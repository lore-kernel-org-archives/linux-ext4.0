Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.127.231.114
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794569624;
	b=l/woeWdQW8CynPKMMKwkAiff/2H5u7ni5A76ECm8wYHLFPapPxy8SrCxCaYhvRDvJ3f/
	 q6yIhEkATXsN0VxYkEkexxihnuQfI93FHAjaCIldQTEOEfnZK3+Bqv8SqMLZwGmb8r0fy
	 RwA7ZXuqSK8PNvNmciY5m+/5Q3p/+Duq4XZmjVI6DO2p6MsodQ3unPXLWvq8y45OYt3ck
	 FNMDicvNzXcUDKNAQME6qkULLT+g1M7pikxEMoZX/LvNmfhrWZBKsCjVtDsaJzOERTQ2g
	 N0nPNwVWfDUxoTYcFh6lZTfWVwV4i9rCbiXBikhdQGDZ0k6LlZ7ohtFHM/UlaIuHmTA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794569624;
	h=DMARC-Filter:DKIM-Signature:Content-Type:From:Date:X-Original-From:
	 Subject:Message-Id:Content-Transfer-Encoding:X-Lms-Return-Path:To:Cc:
	 Mime-Version:X-Mailer;
	bh=9qzXj5+nocOiDZ2q3E95BPDKr5xMDk58YWT+FmqPtTg=;
	b=z3GssLVuCbRFgNaiXVR7zzdCJfMjIotypx/N4aFyIB1QGo49WpLruQAnkQ1/iSftmsXS
	 ilsYAWhINYb/n4cQCXn9s41IL0c+q/deanrxOnhBaWx0YaPkX68cMt1TULOJmoORF2I4T
	 D+V0bbtImvJ2Q3ETkdU/Ur45Fc7HPQlLLP0sIu3nekl+9praYkPcTqddkiEqDkvKCJJaO
	 xhJ0PuiIa8GIFjFI41a9yxC2BsSFUQ0BXnH8XzanC5LheI3RnRVc7WZjxXskyORFqv3EZ
	 JlCKTaS+Cxiw0uLSRuCoOJ4c31FyUHq+zKDofYc1IxRN7MUPO7JDnzk0x7NO4xb2mZQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=bytedance.com;
	spf=pass smtp.mailfrom=bytedance.com;
	dkim=pass header.d=bytedance.com header.i=@bytedance.com header.a=rsa-sha256 header.s=2212171451 header.b=Xc7Z2YWc;
	arc=none smtp.remote-ip=209.127.231.114
Received: from va-2-114.ptr.blmpb.com (va-2-114.ptr.blmpb.com [209.127.231.114])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AD709606A887
	for <linux-ext4@vger.kernel.org>; Fri, 13 Nov 2026 11:33:43 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org AD709606A887
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=bytedance.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=bytedance.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=bytedance.com header.i=@bytedance.com header.a=rsa-sha256 header.s=2212171451 header.b=Xc7Z2YWc
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 s=2212171451; d=bytedance.com; t=1794569614; h=from:subject:
 mime-version:from:date:message-id:subject:to:cc:reply-to:content-type:
 mime-version:in-reply-to:message-id;
 bh=9qzXj5+nocOiDZ2q3E95BPDKr5xMDk58YWT+FmqPtTg=;
 b=Xc7Z2YWcKkNHRLNjA4WS5+Su9gtTugdL1Khs5C+/MIn+Pr1n6iuvfr0J/TOk3KRjNpQkeg
 ZIg9kkyc9VoSKudrq1LrXSH5EI9yXpWs4pShnULPnmjMq/+ODvsyV9jFPjLzvszNHWYqAw
 BmQ1V7nGy51rxZqcs2TByi8WXW01STm5DpTrLnO6NwKgiQL49wpeTbhWVhIspBe9WtpKQ9
 jW7P+7p32rKllPH02J7Gc2CL3hSpGPziyb4hUifBXEi23op/gU1xtnjw3F7LirYaJCt1g6
 ZrxE/fvHycNaDsF4I3Idnd3F4heis0JROlxVXKMKqkx3kv0JSKTWWX1yjmW+ZA==
Content-Type: text/plain; charset=UTF-8
From: "Xianjun Zeng" <zengxianjun@bytedance.com>
Date: Fri, 13 Nov 2026 19:33:11 +0800
X-Original-From: Xianjun Zeng <zengxianjun@bytedance.com>
Subject: [PATCH] ext4: test fallback after a failed stripe-aligned scan
Message-Id: <20261113113310.77386-2-zengxianjun@bytedance.com>
Content-Transfer-Encoding: 7bit
X-Lms-Return-Path: <lba+26af6f58c+d5b619+vger.kernel.org+zengxianjun@bytedance.com>
To: <fstests@vger.kernel.org>
Cc: <linux-ext4@vger.kernel.org>, <zlang@kernel.org>, 
	"Xianjun Zeng" <zengxianjun@bytedance.com>
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Post: <mailto:linux-ext4@vger.kernel.org>
List-Help: <mailto:linux-ext4+help@vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-ext4+owner@vger.kernel.org>
Precedence: list
Mime-Version: 1.0
X-Mailer: git-send-email 2.50.1

Add a regression test for repeated scans of the same block group when
a stripe-aligned allocation cannot be satisfied. Check that the allocator
falls back to the complex scan.

The kernel fix is 1f6bc02f1848 ("ext4: fallback to complex scan
if aligned scan doesn't work").

Signed-off-by: Xianjun Zeng <zengxianjun@bytedance.com>
---
 .gitignore                   |   1 +
 src/Makefile                 |   1 +
 src/t_ext4_mb_aligned_scan.c | 193 +++++++++++++++++++++++++++++++++++
 tests/ext4/064               | 145 ++++++++++++++++++++++++++
 tests/ext4/064.out           |   2 +
 5 files changed, 342 insertions(+)
 create mode 100644 src/t_ext4_mb_aligned_scan.c
 create mode 100755 tests/ext4/064
 create mode 100644 tests/ext4/064.out

diff --git a/.gitignore b/.gitignore
index cdcfa06e..43749f4e 100644
--- a/.gitignore
+++ b/.gitignore
@@ -173,6 +173,7 @@ tags
 /src/t_reflink_read_race
 /src/t_rename_overwrite
 /src/t_snapshot_deleted_subvolume
+/src/t_ext4_mb_aligned_scan
 /src/t_stripealign
 /src/t_truncate_cmtime
 /src/test-nextquota
diff --git a/src/Makefile b/src/Makefile
index eaf0621f..41ef94e9 100644
--- a/src/Makefile
+++ b/src/Makefile
@@ -54,6 +54,7 @@ endif
 
 ifeq ($(HAVE_FIEMAP), true)
 LINUX_TARGETS += fiemap-tester t_stripealign
+LINUX_TARGETS += t_ext4_mb_aligned_scan
 endif
 
 ifeq ($(HAVE_OPEN_BY_HANDLE_AT), true)
diff --git a/src/t_ext4_mb_aligned_scan.c b/src/t_ext4_mb_aligned_scan.c
new file mode 100644
index 00000000..214c353a
--- /dev/null
+++ b/src/t_ext4_mb_aligned_scan.c
@@ -0,0 +1,193 @@
+// SPDX-License-Identifier: GPL-2.0+
+/*
+ * Construct an ext4 block group whose free extents cannot satisfy a
+ * stripe-aligned allocation.
+ */
+#include <errno.h>
+#include <fcntl.h>
+#include <inttypes.h>
+#include <limits.h>
+#include <linux/fiemap.h>
+#include <linux/fs.h>
+#include <stdint.h>
+#include <stdio.h>
+#include <stdlib.h>
+#include <string.h>
+#include <sys/ioctl.h>
+#include <sys/types.h>
+#include <unistd.h>
+
+#define FS_BLOCK_SIZE		1024ULL
+#define BLOCKS_PER_GROUP	8192ULL
+#define GROUP_SIZE		(FS_BLOCK_SIZE * BLOCKS_PER_GROUP)
+#define STRIPE_BLOCKS		12ULL
+#define FREE_BLOCKS		13ULL
+#define FRAGMENT_PERIOD		24ULL
+#define FILL_FILE_SIZE		(64ULL * 1024 * 1024)
+#define FIEMAP_EXTENTS		1024
+#define MIN_FRAGMENT_BLOCKS	4096ULL
+
+static void make_path(char *path, size_t size, const char *dir,
+		      const char *name)
+{
+	if ((size_t)snprintf(path, size, "%s/%s", dir, name) >= size) {
+		fprintf(stderr, "path is too long: %s/%s\n", dir, name);
+		exit(1);
+	}
+}
+
+static int allocate_fill_file(const char *path)
+{
+	uint64_t offset;
+	int fd;
+
+	fd = open(path, O_CREAT | O_EXCL | O_RDWR, 0600);
+	if (fd < 0) {
+		perror("open fill file");
+		return -1;
+	}
+	/* Consume small free extents instead of skipping over them. */
+	for (offset = 0; offset < FILL_FILE_SIZE; offset += FS_BLOCK_SIZE) {
+		if (fallocate(fd, 0, offset, FS_BLOCK_SIZE)) {
+			perror("fallocate fill file");
+			close(fd);
+			return -1;
+		}
+	}
+	return fd;
+}
+
+/*
+ * Find a large region in the goal block group and one contiguous extent.
+ * Return its logical file offset, physical device offset and length in blocks.
+ */
+static int find_fragment_region(int fd, uint64_t group, uint64_t *logical,
+				uint64_t *physical, uint64_t *blocks)
+{
+	struct fiemap *fiemap;
+	uint64_t extent_end;
+	uint64_t group_start = (group * BLOCKS_PER_GROUP + 1) * FS_BLOCK_SIZE;
+	uint64_t group_end = group_start + GROUP_SIZE;
+	uint64_t region_start;
+	uint64_t region_end;
+	unsigned int i;
+	int ret = -1;
+
+	fiemap = calloc(1, sizeof(*fiemap) +
+			FIEMAP_EXTENTS * sizeof(struct fiemap_extent));
+	if (!fiemap) {
+		perror("calloc fiemap");
+		return -1;
+	}
+	fiemap->fm_start = 0;
+	fiemap->fm_length = ~0ULL;
+	fiemap->fm_flags = FIEMAP_FLAG_SYNC;
+	fiemap->fm_extent_count = FIEMAP_EXTENTS;
+
+	if (ioctl(fd, FS_IOC_FIEMAP, fiemap)) {
+		perror("FS_IOC_FIEMAP");
+		goto out;
+	}
+
+	for (i = 0; i < fiemap->fm_mapped_extents; i++) {
+		struct fiemap_extent *extent = &fiemap->fm_extents[i];
+
+		extent_end = extent->fe_physical + extent->fe_length;
+		region_start = extent->fe_physical > group_start ?
+			extent->fe_physical : group_start;
+		region_end = extent_end < group_end ? extent_end : group_end;
+		if (region_end <= region_start ||
+		    region_end - region_start < MIN_FRAGMENT_BLOCKS * FS_BLOCK_SIZE)
+			continue;
+
+		*physical = region_start;
+		*blocks = (region_end - region_start) / FS_BLOCK_SIZE;
+		*logical = extent->fe_logical + region_start -
+			   extent->fe_physical;
+		ret = 0;
+		goto out;
+	}
+	fprintf(stderr, "no suitable region in goal group %" PRIu64 "\n", group);
+out:
+	free(fiemap);
+	return ret;
+}
+
+/*
+ * Leave thirteen free blocks every twenty-four blocks.  Every free extent
+ * starts at physical block 1 (mod 12), so none contains twelve blocks
+ * starting at a stripe boundary.  The average free extent is nevertheless
+ * large enough for ext4_mb_good_group() to keep selecting this group for a
+ * twelve-block request.
+ */
+static int fragment_group(int fd, uint64_t logical, uint64_t physical,
+			  uint64_t blocks, unsigned int *holes)
+{
+	uint64_t region_block = physical / FS_BLOCK_SIZE;
+	uint64_t offset;
+	uint64_t first;
+
+	first = (1 + STRIPE_BLOCKS - region_block % STRIPE_BLOCKS) %
+		STRIPE_BLOCKS;
+	*holes = 0;
+	for (offset = first;
+	     offset + FREE_BLOCKS <= blocks;
+	     offset += FRAGMENT_PERIOD) {
+		off_t pos = logical + offset * FS_BLOCK_SIZE;
+
+		if (fallocate(fd, FALLOC_FL_PUNCH_HOLE | FALLOC_FL_KEEP_SIZE,
+			      pos, FREE_BLOCKS * FS_BLOCK_SIZE)) {
+			perror("punch fragmentation pattern");
+			return -1;
+		}
+		(*holes)++;
+	}
+	if (fsync(fd)) {
+		perror("fsync fill file");
+		return -1;
+	}
+	return 0;
+}
+
+int main(int argc, char **argv)
+{
+	char fill_path[PATH_MAX];
+	uint64_t logical;
+	uint64_t physical;
+	uint64_t blocks;
+	uint64_t group;
+	unsigned int holes = 0;
+	char *end;
+	int fd;
+
+	if (argc != 4 || strcmp(argv[1], "setup")) {
+		fprintf(stderr, "usage: %s setup MOUNTPOINT GROUP\n", argv[0]);
+		return 1;
+	}
+	errno = 0;
+	group = strtoull(argv[3], &end, 0);
+	if (errno || *end || !argv[3][0]) {
+		fprintf(stderr, "invalid block group: %s\n", argv[3]);
+		return 1;
+	}
+
+	make_path(fill_path, sizeof(fill_path), argv[2], "fragmentation-fill");
+	/* Cover every other free data extent in the goal block group. */
+	fd = allocate_fill_file(fill_path);
+	if (fd < 0)
+		return 1;
+	if (find_fragment_region(fd, group, &logical, &physical, &blocks) ||
+	    fragment_group(fd, logical, physical, blocks, &holes))
+		goto error;
+	close(fd);
+	printf("fragmented block group %" PRIu64
+	       " at physical block %" PRIu64
+	       " with %u thirteen-block free extents\n",
+	       group, (uint64_t)(physical / FS_BLOCK_SIZE), holes);
+	return 0;
+
+error:
+	close(fd);
+	fprintf(stderr, "failed to fragment goal group %" PRIu64 "\n", group);
+	return 1;
+}
diff --git a/tests/ext4/064 b/tests/ext4/064
new file mode 100755
index 00000000..5671ccda
--- /dev/null
+++ b/tests/ext4/064
@@ -0,0 +1,145 @@
+#! /bin/bash
+# SPDX-License-Identifier: GPL-2.0
+# Copyright (c) 2026, ByteDance Ltd. and/or its affiliates. All rights reserved.
+#
+# FS QA Test No. 064
+#
+# Regression test for ext4 repeatedly choosing the same block group when a
+# stripe-aligned allocation cannot be satisfied.  The allocator must fall back
+# to the complex scan instead of spending time rescanning that block group.
+#
+. ./common/preamble
+. ./common/tracing
+. ./common/filter
+_begin_fstest auto prealloc quick
+
+_cleanup()
+{
+	_ftrace_cleanup
+	cd /
+
+	if [ -n "$loop_mnt" ]; then
+		if [ -n "$(_is_dir_mountpoint "$loop_mnt" ext4)" ] &&
+		   ! _unmount "$loop_mnt" > /dev/null 2>&1; then
+			status=1
+			return
+		fi
+		rmdir "$loop_mnt" 2>/dev/null || true
+	fi
+	if [ -n "$loop_dev" ]; then
+		_destroy_loop_device "$loop_dev" > /dev/null 2>&1
+		loop_dev=
+	fi
+	rm -f "$tmp".* "$fs_img"
+}
+
+_require_test
+_require_loop
+_require_sparse_files
+_require_test_program t_ext4_mb_aligned_scan
+_require_xfs_io_command "falloc"
+_require_xfs_io_command "fiemap"
+_require_command "$TIMEOUT_PROG" timeout
+_require_ftrace
+
+_fixed_by_kernel_commit 1f6bc02f18489b9c9ea39b068d0695fb0e4567e9 \
+	"ext4: fallback to complex scan if aligned scan doesn't work"
+
+loop_mnt=$TEST_DIR/$seq.mnt
+fs_img=$TEST_DIR/$seq.img
+
+# A 1k block size gives us 2560 block groups in this sparse 20G image.  The
+# large group count makes repeated selection of one bad group observable.
+$XFS_IO_PROG -f -c "truncate 20G" $fs_img >> $seqres.full 2>&1
+${MKFS_PROG} -t ext4 -b 1024 -N 32768 -O ^has_journal \
+	-E stride=3,stripe_width=12,lazy_itable_init=1 $fs_img 20G \
+	>> $seqres.full 2>&1 || _fail "mkfs failed"
+
+mkdir -p $loop_mnt
+# The backing filesystem's direct I/O alignment may be 4k, which cannot
+# hold this 1k ext4 filesystem.  Pin the loop logical sector size to 512.
+loop_dev=$(_create_loop_device $fs_img 512)
+_mount -t ext4 -o mb_optimize_scan=1 $loop_dev $loop_mnt \
+	>> $seqres.full 2>&1 || _fail "could not loop mount ext4 filesystem"
+
+# Always use the optimized group selection path, including on rotational loop
+# devices which otherwise perform a bounded linear scan first.
+scan_ctl=/sys/fs/ext4/$(basename $loop_dev)/mb_max_linear_groups
+[ -w $scan_ctl ] || _notrun "ext4 mb_max_linear_groups is unavailable"
+echo 0 > $scan_ctl || _fail "could not disable linear group scanning"
+
+goal_file=$loop_mnt/aligned-allocation
+$XFS_IO_PROG -f -c "falloc 0 1k" $goal_file >> $seqres.full 2>&1 || \
+	_fail "could not initialize goal file"
+goal_sector=$(_get_file_extent_sector $goal_file 0)
+[ "$goal_sector" != "hole" ] || _fail "goal file has no mapped extent"
+[ "$goal_sector" -gt 0 ] || _fail "invalid goal sector $goal_sector"
+# _get_file_extent_sector returns 512-byte sectors.  Convert to a 1k ext4
+# block number and account for s_first_data_block == 1 on this filesystem.
+fragment_group=$(( (goal_sector / 2 - 1) / 8192 ))
+goal_inode=$(stat -c '%i' $goal_file)
+
+$here/src/t_ext4_mb_aligned_scan setup $loop_mnt $fragment_group \
+	>> $seqres.full 2>&1 || _fail "could not construct fragmented block group"
+
+_ftrace_setup
+event_dir=$FTRACE_DIR/events/ext4/ext4_mballoc_alloc
+[ -d $event_dir ] || _notrun "ext4_mballoc_alloc tracepoint is unavailable"
+major=$(stat -c '%t' $loop_dev)
+minor=$(stat -c '%T' $loop_dev)
+trace_dev=$((0x$major * 1048576 + 0x$minor))
+printf '%s' "orig_len == 12 && dev == $trace_dev && ino == $goal_inode" > \
+	$event_dir/filter || _fail "could not set ext4 allocation trace filter"
+_ftrace_record_events ext4_mballoc_alloc
+
+# The timeout is only a watchdog for a genuinely stuck kernel.  Determine
+# whether this regressed from the number of groups scanned, not elapsed time.
+rc=0
+$TIMEOUT_PROG -k 5s 120s $XFS_IO_PROG -c "falloc 1k 12k" $goal_file \
+	>> $seqres.full 2>&1 || rc=$?
+case $rc in
+0)
+	;;
+124|137)
+	_fail "stripe-aligned allocation watchdog expired"
+	;;
+*)
+	_fail "xfs_io fallocate exited with status $rc"
+	;;
+esac
+rm -f $goal_file || _fail "could not remove goal file"
+_ftrace_ignore_events
+trace=$(_ftrace_dump)
+echo "$trace" >> $seqres.full
+trace_line=$(echo "$trace" | grep ': ext4_mballoc_alloc:')
+trace_count=$(echo "$trace" | grep -c ': ext4_mballoc_alloc:')
+[ "$trace_count" -eq 1 ] || \
+	_fail "expected one target allocation tracepoint, got $trace_count"
+groups=$(echo "$trace_line" | \
+	sed -n 's/.* blks [0-9][0-9]* grps \([0-9][0-9]*\) .*/\1/p')
+result=$(echo "$trace_line" | \
+	sed -n 's/.* result \([0-9][0-9]*\)\/\([0-9][0-9]*\)\/\([0-9][0-9]*\)@.*/\1 \2 \3/p')
+[ -n "$groups" ] || _fail "no ext4 allocation tracepoint recorded"
+[ -n "$result" ] || _fail "could not parse allocation result"
+result_group=${result%% *}
+result_rest=${result#* }
+result_start=${result_rest%% *}
+result_len=${result_rest##* }
+[ "$result_len" -eq 12 ] || _fail "allocation returned $result_len blocks, expected 12"
+[ "$result_group" = "$fragment_group" ] || \
+	_fail "allocation used group $result_group instead of $fragment_group"
+
+# With a 1k block size ext4_group_first_block_no() adds one block.  A
+# non-aligned result proves that the complex scan supplied the allocation.
+physical_block=$((result_group * 8192 + result_start + 1))
+[ $((physical_block % 12)) -ne 0 ] || \
+	_fail "aligned scan unexpectedly succeeded at block $physical_block"
+
+# The fixed allocator normally scans one group.  Allow a small margin for
+# allocator implementation changes; the regression scans all 2560 groups.
+[ "$groups" -le 16 ] || \
+	_fail "allocator scanned $groups groups without falling back to complex scan"
+
+echo "Silence is golden"
+status=0
+exit
diff --git a/tests/ext4/064.out b/tests/ext4/064.out
new file mode 100644
index 00000000..d9076546
--- /dev/null
+++ b/tests/ext4/064.out
@@ -0,0 +1,2 @@
+QA output created by 064
+Silence is golden
-- 
2.50.1 (Apple Git-155)
