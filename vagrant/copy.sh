#!/bin/bash
#shellcheck disable=SC2116

set -e
set -u

HOST=quic-pg-vagrant

CHROMIUM_REMOTE_DIR=/home/vagrant/chromium/src
CHROMIUM_LOCAL_DIR=lib/chromium

scp "$HOST:$CHROMIUM_REMOTE_DIR/LICENSE" lib/chromium
scp "$HOST:$CHROMIUM_REMOTE_DIR/LICENSE.chromium_os" lib/chromium

readonly FILES=(
  base/atomic_ref_count.h
  base/atomicops.h
  base/atomicops_internals_portable.h
  base/base_export.h
  base/bind.h
  base/bind_internal.h
  base/callback.h
  base/callback_forward.h
  base/callback_internal.cc
  base/callback_internal.h
  base/check.cc
  base/check.h
  base/check_op.cc
  base/check_op.h
  base/compiler_specific.h
  base/containers/checked_iterators.h
  base/containers/checked_range.h
  base/containers/circular_deque.h
  base/containers/flat_map.h
  base/containers/flat_tree.h
  base/containers/linked_list.h
  base/containers/queue.h
  base/containers/span.h
  base/containers/stack.h
  base/containers/util.h
  base/containers/vector_buffer.h
  base/dcheck_is_on.h
  base/files/file_path.cc
  base/files/file_path.h
  base/gtest_prod_util.h
  base/hash/hash.cc
  base/hash/hash.h
  base/immediate_crash.h
  base/location.cc
  base/location.h
  base/logging.cc
  base/logging.h
  base/macros.h
  base/memory/raw_scoped_refptr_mismatch_checker.h
  base/memory/ref_counted.cc
  base/memory/ref_counted.h
  base/memory/scoped_refptr.h
  base/memory/weak_ptr.cc
  base/memory/weak_ptr.h
  base/no_destructor.h
  base/notreached.cc
  base/notreached.h
  base/numerics/checked_math.h
  base/numerics/checked_math_impl.h
  base/numerics/clamped_math.h
  base/numerics/clamped_math_impl.h
  base/numerics/safe_conversions.h
  base/numerics/safe_conversions_impl.h
  base/numerics/safe_math.h
  base/numerics/safe_math_clang_gcc_impl.h
  base/numerics/safe_math_shared_impl.h
  base/observer_list.h
  base/observer_list_internal.cc
  base/observer_list_internal.h
  base/observer_list_types.cc
  base/observer_list_types.h
  base/optional.h
  base/pending_task.cc
  base/pending_task.h
  base/pickle.cc
  base/pickle.h
  base/post_task_and_reply_with_result_internal.h
  base/process/process_handle.cc
  base/process/process_handle.h
  base/scoped_clear_last_error.h
  base/sequence_checker.h
  base/sequence_checker_impl.cc
  base/sequence_checker_impl.h
  base/sequence_token.cc
  base/sequence_token.h
  base/sequenced_task_runner.cc
  base/sequenced_task_runner.h
  base/sequenced_task_runner_helpers.h
  base/single_thread_task_runner.h
  base/stl_util.h
  base/strings/char_traits.h
  base/strings/string16.cc
  base/strings/string16.h
  base/strings/string_piece.cc
  base/strings/string_piece.h
  base/strings/string_piece_forward.h
  base/strings/string_util.h
  base/strings/stringprintf.cc
  base/strings/stringprintf.h
  base/strings/utf_string_conversions.cc
  base/strings/utf_string_conversions.h
  base/synchronization/atomic_flag.cc
  base/synchronization/atomic_flag.h
  base/synchronization/condition_variable.h
  base/synchronization/lock.cc
  base/synchronization/lock.h
  base/synchronization/lock_impl.h
  base/task/common/task_annotator.cc
  base/task/common/task_annotator.h
  base/task_runner.cc
  base/task_runner.h
  base/template_util.h
  base/third_party/nspr/prtime.cc
  base/third_party/nspr/prtime.h
  base/thread_annotations.h
  base/threading/platform_thread.cc
  base/threading/platform_thread.h
  base/threading/thread_checker.h
  base/threading/thread_checker_impl.cc
  base/threading/thread_checker_impl.h
  base/threading/thread_collision_warner.cc
  base/threading/thread_collision_warner.h
  base/threading/thread_local.h
  base/threading/thread_local_internal.h
  base/threading/thread_local_storage.cc
  base/threading/thread_local_storage.h
  base/time/time.cc
  base/time/time.h
  base/time/time_override.cc
  base/time/time_override.h
  base/trace_event/base_tracing.h
  base/trace_event/blame_context.cc
  base/trace_event/blame_context.h
  base/trace_event/builtin_categories.cc
  base/trace_event/builtin_categories.h
  base/trace_event/category_registry.cc
  base/trace_event/category_registry.h
  base/trace_event/common/trace_event_common.h
  base/trace_event/heap_profiler.h
  base/trace_event/heap_profiler_allocation_context.cc
  base/trace_event/heap_profiler_allocation_context.h
  base/trace_event/heap_profiler_allocation_context_tracker.cc
  base/trace_event/heap_profiler_allocation_context_tracker.h
  base/trace_event/log_message.cc
  base/trace_event/log_message.h
  base/trace_event/memory_allocator_dump_guid.cc
  base/trace_event/memory_allocator_dump_guid.h
  base/trace_event/memory_dump_provider.h
  base/trace_event/memory_dump_request_args.cc
  base/trace_event/memory_dump_request_args.h
  base/trace_event/thread_instruction_count.cc
  base/trace_event/thread_instruction_count.h
  base/trace_event/trace_arguments.cc
  base/trace_event/trace_arguments.h
  base/trace_event/trace_category.h
  base/trace_event/trace_config.cc
  base/trace_event/trace_config.h
  base/trace_event/trace_config_category_filter.cc
  base/trace_event/trace_config_category_filter.h
  base/trace_event/trace_event.h
  base/trace_event/trace_event_impl.cc
  base/trace_event/trace_event_impl.h
  base/trace_event/trace_event_memory_overhead.cc
  base/trace_event/trace_event_memory_overhead.h
  base/trace_event/trace_event_stub.cc
  base/trace_event/trace_event_stub.h
  base/trace_event/trace_log.cc
  base/trace_event/trace_log.h
  base/trace_event/traced_value.cc
  base/trace_event/traced_value.h
  base/trace_event/typed_macros.h
  base/trace_event/typed_macros_embedder_support.h
  base/trace_event/typed_macros_internal.cc
  base/trace_event/typed_macros_internal.h
  base/value_iterators.cc
  base/value_iterators.h
  base/values.cc
  base/values.h
  build/build_config.h
  build/buildflag.h
  out/Debug/gen/base/debug/debugging_buildflags.h
  out/Debug/gen/base/logging_buildflags.h
  out/Debug/gen/base/tracing_buildflags.h
  out/Debug/gen/third_party/perfetto/protos/perfetto/common/builtin_clock.pbzero.h
  out/Debug/gen/third_party/perfetto/protos/perfetto/trace/interned_data/interned_data.pbzero.h
  out/Debug/gen/third_party/perfetto/protos/perfetto/trace/trace_packet.pbzero.h
  out/Debug/gen/third_party/perfetto/protos/perfetto/trace/track_event/debug_annotation.pbzero.h
  out/Debug/gen/third_party/perfetto/protos/perfetto/trace/track_event/track_descriptor.gen.h
  out/Debug/gen/third_party/perfetto/protos/perfetto/trace/track_event/track_descriptor.pbzero.h
  out/Debug/gen/third_party/perfetto/protos/perfetto/trace/track_event/track_event.pbzero.h
  testing/gtest/include/gtest/gtest_prod.h
  third_party/googletest/src/googletest/include/gtest/gtest_prod.h
  third_party/perfetto/include/perfetto/base/build_config.h
  third_party/perfetto/include/perfetto/base/compiler.h
  third_party/perfetto/include/perfetto/base/export.h
  third_party/perfetto/include/perfetto/base/flat_set.h
  third_party/perfetto/include/perfetto/base/logging.h
  third_party/perfetto/include/perfetto/base/proc_utils.h
  third_party/perfetto/include/perfetto/base/thread_utils.h
  third_party/perfetto/include/perfetto/protozero/contiguous_memory_range.h
  third_party/perfetto/include/perfetto/protozero/copyable_ptr.h
  third_party/perfetto/include/perfetto/protozero/cpp_message_obj.h
  third_party/perfetto/include/perfetto/protozero/field.h
  third_party/perfetto/include/perfetto/protozero/message.h
  third_party/perfetto/include/perfetto/protozero/message_handle.h
  third_party/perfetto/include/perfetto/protozero/packed_repeated_fields.h
  third_party/perfetto/include/perfetto/protozero/proto_decoder.h
  third_party/perfetto/include/perfetto/protozero/proto_utils.h
  third_party/perfetto/include/perfetto/protozero/scattered_heap_buffer.h
  third_party/perfetto/include/perfetto/protozero/scattered_stream_writer.h
  third_party/perfetto/include/perfetto/tracing/core/forward_decls.h
  third_party/perfetto/include/perfetto/tracing/debug_annotation.h
  third_party/perfetto/include/perfetto/tracing/event_context.h
  third_party/perfetto/include/perfetto/tracing/internal/track_event_internal.h
  third_party/perfetto/include/perfetto/tracing/trace_writer_base.h
  third_party/perfetto/include/perfetto/tracing/track.h
  third_party/perfetto/src/base/logging.cc
  third_party/perfetto/src/base/thread_checker.cc
  third_party/perfetto/src/base/time.cc
  third_party/perfetto/src/protozero/message.cc
  third_party/perfetto/src/protozero/message_handle.cc
  third_party/perfetto/src/protozero/packed_repeated_fields.cc
  third_party/perfetto/src/protozero/proto_decoder.cc
  third_party/perfetto/src/protozero/scattered_heap_buffer.cc
  third_party/perfetto/src/protozero/scattered_stream_writer.cc
  third_party/perfetto/src/tracing/debug_annotation.cc
  third_party/perfetto/src/tracing/event_context.cc
  third_party/perfetto/src/tracing/internal/track_event_internal.cc
  third_party/perfetto/src/tracing/trace_writer_base.cc
  third_party/perfetto/src/tracing/track.cc
)

for file in "${FILES[@]}"; do
  dir=$(dirname "$file")
  dir="$CHROMIUM_LOCAL_DIR/$(echo "${dir#*out/Debug/gen/}")"
  mkdir -p "$dir"
  scp "$HOST:$CHROMIUM_REMOTE_DIR/$file" "$dir"
done

scp $HOST:$CHROMIUM_REMOTE_DIR/out/Debug/gen/third_party/perfetto/build_config/perfetto_build_flags.h \
    $CHROMIUM_LOCAL_DIR/third_party/perfetto/include/perfetto/base

PERFETTO_SYMLINK=$CHROMIUM_LOCAL_DIR/perfetto
if [ ! -e "$PERFETTO_SYMLINK" ]; then
  ln -s "$(pwd)/$CHROMIUM_LOCAL_DIR/third_party/perfetto/include/perfetto" $PERFETTO_SYMLINK
fi

PERFETTO_PROTO_SYMLINK=$CHROMIUM_LOCAL_DIR/protos
if [ ! -e "$PERFETTO_PROTO_SYMLINK" ]; then
  ln -s "$(pwd)/$CHROMIUM_LOCAL_DIR/third_party/perfetto/protos" $PERFETTO_PROTO_SYMLINK
fi