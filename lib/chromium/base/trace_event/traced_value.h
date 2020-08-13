// Copyright 2014 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

#ifndef BASE_TRACE_EVENT_TRACED_VALUE_H_
#define BASE_TRACE_EVENT_TRACED_VALUE_H_

#include <stddef.h>

#include <memory>
#include <sstream>
#include <string>
#include <vector>

#include "base/macros.h"
#include "base/pickle.h"
#include "base/strings/string_piece.h"
#include "base/trace_event/trace_event_impl.h"

namespace base {

class Value;

namespace trace_event {

class BASE_EXPORT TracedValue : public ConvertableToTraceFormat {
 public:
  // TODO(oysteine): |capacity| is not used in any production code. Consider
  // removing it.
  explicit TracedValue(size_t capacity = 0);
  ~TracedValue() override;

  void EndDictionary();
  void EndArray();

  // These methods assume that |name| is a long lived "quoted" string.
  void SetInteger(const char* name, int value);
  void SetDouble(const char* name, double value);
  void SetBoolean(const char* name, bool value);
  void SetString(const char* name, base::StringPiece value);
  void SetValue(const char* name, TracedValue* value);
  void SetPointer(const char* name, void* value);
  void BeginDictionary(const char* name);
  void BeginArray(const char* name);

  // These, instead, can be safely passed a temporary string.
  void SetIntegerWithCopiedName(base::StringPiece name, int value);
  void SetDoubleWithCopiedName(base::StringPiece name, double value);
  void SetBooleanWithCopiedName(base::StringPiece name, bool value);
  void SetStringWithCopiedName(base::StringPiece name, base::StringPiece value);
  void SetValueWithCopiedName(base::StringPiece name, TracedValue* value);
  void SetPointerWithCopiedName(base::StringPiece name, void* value);
  void BeginDictionaryWithCopiedName(base::StringPiece name);
  void BeginArrayWithCopiedName(base::StringPiece name);

  void AppendInteger(int);
  void AppendDouble(double);
  void AppendBoolean(bool);
  void AppendString(base::StringPiece);
  void BeginArray();
  void BeginDictionary();

  // ConvertableToTraceFormat implementation.
  void AppendAsTraceFormat(std::string* out) const override;
  bool AppendToProto(ProtoAppender* appender) override;

  void EstimateTraceMemoryOverhead(TraceEventMemoryOverhead* overhead) override;

  // TracedValue::Build is a friend of TracedValue::DictionaryItem.
  class BASE_EXPORT DictionaryItem;

  // Helper to enable easier initialization of TracedValue. This is intended for
  // quick local debugging as there is overhead of creating
  // std::initializer_list of name-value objects. This method does not support
  // creation of dictionaries or arrays.
  //
  // Example:
  //    auto value = TracedValue::Build({
  //      {"int_var_name", 42},
  //      {"double_var_name", 3.14},
  //      {"string_var_name", "hello world"}
  //    });
  //
  // |name| is assumed to be a long lived "quoted" string.
  static std::unique_ptr<TracedValue> Build(
      std::initializer_list<DictionaryItem> items);

  // DictionaryItem instance represents a single name-value pair.
  class DictionaryItem {
   public:
    // These constructors assume that |name| is a long lived "quoted" string.
    DictionaryItem(const char* name, int value);
    DictionaryItem(const char* name, double value);
    DictionaryItem(const char* name, bool value);
    DictionaryItem(const char* name, void* value);
    // StringPiece's backing storage / const char* pointer needs to remain valid
    // until TracedValue::Build is called.
    DictionaryItem(const char* name, base::StringPiece value);
    // Define an explicit overload for const char* to resolve the ambiguity
    // between the base::StringPiece, void*, and bool constructors for string
    // literals.
    DictionaryItem(const char* name, const char* value);

   private:
    friend std::unique_ptr<TracedValue> TracedValue::Build(
        std::initializer_list<DictionaryItem> items);

    void WriteToValue(TracedValue* value) const;

    union KeptValue {
      int int_value;
      double double_value;
      bool bool_value;
      base::StringPiece string_piece_value;
      void* void_ptr_value;

      // Default constructor is implicitly deleted because union field has a
      // non-trivial default constructor.
      KeptValue() {}
    };

    // Reimplementing a subset of C++17 std::variant.
    enum class KeptValueType {
      kIntType,
      kDoubleType,
      kBoolType,
      kStringPieceType,
      kVoidPtrType,
    };

    KeptValue kept_value_;
    const char* name_;
    KeptValueType kept_value_type_;
  };

  // A custom serialization class can be supplied by implementing the
  // Writer interface and supplying a factory class to SetWriterFactoryCallback.
  // Primarily used by Perfetto to write TracedValues directly into its proto
  // format, which lets us do a direct memcpy() in AppendToProto() rather than
  // a JSON serialization step in AppendAsTraceFormat.
  class BASE_EXPORT Writer {
   public:
    virtual ~Writer() = default;

    virtual void BeginArray() = 0;
    virtual void BeginDictionary() = 0;
    virtual void EndDictionary() = 0;
    virtual void EndArray() = 0;

    // These methods assume that |name| is a long lived "quoted" string.
    virtual void SetInteger(const char* name, int value) = 0;
    virtual void SetDouble(const char* name, double value) = 0;
    virtual void SetBoolean(const char* name, bool value) = 0;
    virtual void SetString(const char* name, base::StringPiece value) = 0;
    virtual void SetValue(const char* name, Writer* value) = 0;
    virtual void BeginDictionary(const char* name) = 0;
    virtual void BeginArray(const char* name) = 0;

    // These, instead, can be safely passed a temporary string.
    virtual void SetIntegerWithCopiedName(base::StringPiece name,
                                          int value) = 0;
    virtual void SetDoubleWithCopiedName(base::StringPiece name,
                                         double value) = 0;
    virtual void SetBooleanWithCopiedName(base::StringPiece name,
                                          bool value) = 0;
    virtual void SetStringWithCopiedName(base::StringPiece name,
                                         base::StringPiece value) = 0;
    virtual void SetValueWithCopiedName(base::StringPiece name,
                                        Writer* value) = 0;
    virtual void BeginDictionaryWithCopiedName(base::StringPiece name) = 0;
    virtual void BeginArrayWithCopiedName(base::StringPiece name) = 0;

    virtual void AppendInteger(int) = 0;
    virtual void AppendDouble(double) = 0;
    virtual void AppendBoolean(bool) = 0;
    virtual void AppendString(base::StringPiece) = 0;

    virtual void AppendAsTraceFormat(std::string* out) const = 0;

    virtual bool AppendToProto(ProtoAppender* appender);

    virtual void EstimateTraceMemoryOverhead(
        TraceEventMemoryOverhead* overhead) = 0;

    virtual bool IsPickleWriter() const = 0;
    virtual bool IsProtoWriter() const = 0;
  };

  typedef std::unique_ptr<Writer> (*WriterFactoryCallback)(size_t capacity);
  static void SetWriterFactoryCallback(WriterFactoryCallback callback);

 protected:
  TracedValue(size_t capacity, bool forced_json);

  std::unique_ptr<base::Value> ToBaseValue() const;

 private:
  std::unique_ptr<Writer> writer_;

#ifndef NDEBUG
  // In debug builds checks the pairings of {Start,End}{Dictionary,Array}
  std::vector<bool> nesting_stack_;
#endif

  DISALLOW_COPY_AND_ASSIGN(TracedValue);
};

// TracedValue that is convertable to JSON format. This has lower performance
// than the default TracedValue in production code, and should be used only for
// testing and debugging. Should be avoided in tracing. It's for
// testing/debugging code calling value dumping function designed for tracing,
// like the following:
//
//   TracedValueJSON value;
//   AsValueInto(&value);  // which is designed for tracing.
//   return value.ToJSON();
//
// If the code is merely for testing/debugging, base::Value should be used
// instead.
class BASE_EXPORT TracedValueJSON : public TracedValue {
 public:
  explicit TracedValueJSON(size_t capacity = 0)
      : TracedValue(capacity, /*forced_josn*/ true) {}

  using TracedValue::ToBaseValue;

  // Converts the value into a JSON string without formatting. Suitable for
  // printing a simple value or printing a value in a single line context.
  std::string ToJSON() const;

  // Converts the value into a formatted JSON string, with indentation, spaces
  // and new lines for better human readability of complex values.
  std::string ToFormattedJSON() const;
};

}  // namespace trace_event
}  // namespace base

#endif  // BASE_TRACE_EVENT_TRACED_VALUE_H_
