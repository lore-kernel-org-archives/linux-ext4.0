Received: from dggsgout11.his.huawei.com (dggsgout11.his.huawei.com [45.249.212.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 74EFD37E2E5;
	Tue, 28 Apr 2026 09:04:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777367080; cv=none; b=UuW2FkB7wGCTNYmDyNRL3qjOXvuNgfzo9NgLDj6BQ7oiBNxvc96zEI0L98SYZ6H/OMOTZbTmkM1Mphi5KOFBadvG6xULq0EHn6T4BAS1zizyLRdPR7gt+O22IIq2Y/VKQxoXvQTR2/Zhk6xVFQGJ6XD+KFxXSAiFM1VZW6RrHzI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777367080; c=relaxed/simple;
	bh=+bCGhT/K6ChurygkZg9dxv0FarllXRmKWAVPqfhtEbI=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=p3Ha2YiJX2ZymXykaLWyE8KUzDDOgJlcE0pwk5UVHEqzmikWtHfs6MbxW44llzSyhM8hOllEOpEpm9jVedCKPXMB0b+0quGP5gdk2XOFiNXINWRtLkz7RGlOID6IFQhRfooCOSTyxF/p6/TZ4GE0Q8IutNuKq+YDEE7/0Z1Hh1A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=pass smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.163.177])
	by dggsgout11.his.huawei.com (SkyGuard) with ESMTPS id 4g4ZHk2c37zYQtxh;
	Tue, 28 Apr 2026 17:04:18 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.128])
	by mail.maildlp.com (Postfix) with ESMTP id 0586540592;
	Tue, 28 Apr 2026 17:04:25 +0800 (CST)
Received: from huaweicloud.com (unknown [10.50.85.155])
	by APP4 (Coremail) with SMTP id gCh0CgBHD1sQePBp2ZtgAQ--.9895S4;
	Tue, 28 Apr 2026 17:04:24 +0800 (CST)
From: Zhang Yi <yi.zhang@huaweicloud.com>
To: fstests@vger.kernel.org,
	zlang@kernel.org
Cc: linux-ext4@vger.kernel.org,
	linux-fsdevel@vger.kernel.org,
	bfoster@redhat.com,
	jack@suse.cz,
	yi.zhang@huawei.com,
	yi.zhang@huaweicloud.com,
	yizhang089@gmail.com,
	yangerkun@huawei.com
Subject: [PATCH v3] generic/790: test post-EOF gap zeroing persistence
Date: Tue, 28 Apr 2026 16:57:50 +0800
Message-ID: <20260428085750.1072612-1-yi.zhang@huaweicloud.com>
X-Mailer: git-send-email 2.52.0
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:gCh0CgBHD1sQePBp2ZtgAQ--.9895S4
X-Coremail-Antispam: 1UD129KBjvJXoW3Xw17Cr48CryDCryUtFWDJwb_yoW3tF1kpF
	Z5WF1Ykr1IgF47G3s2kF1qq34ruws5Ar4Uu392grZ09ryUGr1xXa9Fqry2qay7Jrn3uw40
	va1kKa4Igw17ZaDanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUU9j14x267AKxVW8JVW5JwAFc2x0x2IEx4CE42xK8VAvwI8IcIk0
	rVWrJVCq3wAFIxvE14AKwVWUJVWUGwA2ocxC64kIII0Yj41l84x0c7CEw4AK67xGY2AK02
	1l84ACjcxK6xIIjxv20xvE14v26w1j6s0DM28EF7xvwVC0I7IYx2IY6xkF7I0E14v26rxl
	6s0DM28EF7xvwVC2z280aVAFwI0_GcCE3s1l84ACjcxK6I8E87Iv6xkF7I0E14v26rxl6s
	0DM2AIxVAIcxkEcVAq07x20xvEncxIr21l5I8CrVACY4xI64kE6c02F40Ex7xfMcIj6xII
	jxv20xvE14v26r1j6r18McIj6I8E87Iv67AKxVWUJVW8JwAm72CE4IkC6x0Yz7v_Jr0_Gr
	1lF7xvr2IYc2Ij64vIr41lF7I21c0EjII2zVCS5cI20VAGYxC7M4IIrI8v6xkF7I0E8cxa
	n2IY04v7MxkF7I0En4kS14v26r1q6r43MxAIw28IcxkI7VAKI48JMxC20s026xCaFVCjc4
	AY6r1j6r4UMI8I3I0E5I8CrVAFwI0_Jr0_Jr4lx2IqxVCjr7xvwVAFwI0_JrI_JrWlx4CE
	17CEb7AF67AKxVWUtVW8ZwCIc40Y0x0EwIxGrwCI42IY6xIIjxv20xvE14v26r1j6r1xMI
	IF0xvE2Ix0cI8IcVCY1x0267AKxVW8JVWxJwCI42IY6xAIw20EY4v20xvaj40_Jr0_JF4l
	IxAIcVC2z280aVAFwI0_Jr0_Gr1lIxAIcVC2z280aVCY1x0267AKxVW8JVW8JrUvcSsGvf
	C2KfnxnUUI43ZEXa7VUbGQ6JUUUUU==
X-CM-SenderInfo: d1lo6xhdqjqx5xdzvxpfor3voofrz/

From: Zhang Yi <yi.zhang@huawei.com>

Test that extending a file past a non-block-aligned EOF correctly
zero-fills the gap [old_EOF, block_boundary), and that this zeroing
persists through a filesystem shutdown+remount cycle.

Stale data beyond EOF can persist on disk when append write data blocks
are flushed before the on-disk file size update, or when concurrent
append writeback and mmap writes persist non-zero data past EOF.
Subsequent post-EOF operations (append write, fallocate, truncate up)
must zero-fill and persist the gap to prevent exposing stale data.

The test pollutes the file's last physical block (via FIEMAP + raw
device write) with a sentinel pattern beyond i_size, then performs each
extend operation and verifies the gap is zeroed both in memory and on
disk.

Signed-off-by: Zhang Yi <yi.zhang@huawei.com>
---
v2->v3:
 - Add error check for the raw device pwrite, a failed pwrite would
   silently leave the test continuing with an unpolluted block,
   producing false-positive passes.
 - Add sync_range -a to wait until the extending I/O completes and to
   ensure file size update is persisted before shutdown, preventing
   unexpected file size errors.
v1->v2:
 - Add _require_no_realtime to prevent testing on XFS realtime devices,
   where file data may reside on $SCRATCH_RTDEV.
 - Add _exclude_fs btrfs since FIEMAP returns logical addresses, not
   physical device offsets, writing to these offsets on $SCRATCH_DEV
   would corrupt the filesystem in multi-device setups. Besides, since
   btrfs doesn't support shutdown right now, we can support it later.
 - Add -v flag to od in _check_gap_zero() to prevent line folding of
   identical consecutive lines.
 - Add expected_new_sz parameter to _test_eof_zeroing(), verify file
   size was not rolled back after shutdown+remount cycle, and also drop
   the unnecessary file size check before the shutdown as well.
 - Clarify the comment regarding when stale data beyond EOF can persist.

 tests/generic/790     | 168 ++++++++++++++++++++++++++++++++++++++++++
 tests/generic/790.out |   4 +
 2 files changed, 172 insertions(+)
 create mode 100755 tests/generic/790
 create mode 100644 tests/generic/790.out

diff --git a/tests/generic/790 b/tests/generic/790
new file mode 100755
index 00000000..6daf3793
--- /dev/null
+++ b/tests/generic/790
@@ -0,0 +1,168 @@
+#! /bin/bash
+# SPDX-License-Identifier: GPL-2.0
+# Copyright (c) 2026 Huawei.  All Rights Reserved.
+#
+# FS QA Test No. 790
+#
+# Test that extending a file past a non-block-aligned EOF correctly zero-fills
+# the gap [old_EOF, block_boundary), and that this zeroing persists through a
+# filesystem shutdown+remount cycle.
+#
+# Stale data beyond EOF can persist on disk when:
+# 1) append write data blocks are flushed before the on-disk file size update,
+#    and the system crashes in this window.
+# 2) concurrent append writeback and mmap writes persist non-zero data past EOF.
+#
+# Subsequent post-EOF operations (append write, fallocate, truncate up) must
+# zero-fill and persist the gap to prevent exposing stale data.
+#
+# The test pollutes the file's last physical block (via FIEMAP + raw device
+# write) with a sentinel pattern beyond i_size, then performs each extend
+# operation and verifies the gap is zeroed both in memory and on disk.
+#
+. ./common/preamble
+_begin_fstest auto quick rw shutdown
+
+. ./common/filter
+
+_require_scratch
+_require_block_device $SCRATCH_DEV
+_require_no_realtime
+_require_scratch_shutdown
+_require_metadata_journaling $SCRATCH_DEV
+
+# FIEMAP on Btrfs returns logical addresses within the filesystem's address
+# space, not physical device offsets. Writing to these offsets on $SCRATCH_DEV
+# would corrupt the filesystem in multi-device setups.
+_exclude_fs btrfs
+
+_require_xfs_io_command "fiemap"
+_require_xfs_io_command "falloc"
+_require_xfs_io_command "pwrite"
+_require_xfs_io_command "truncate"
+_require_xfs_io_command "sync_range"
+
+# Check that gap region [offset, offset+nbytes) is entirely zero
+_check_gap_zero()
+{
+	local file="$1"
+	local offset="$2"
+	local nbytes="$3"
+	local label="$4"
+	local data
+	local stripped
+
+	data=$(od -A n -t x1 -v -j $offset -N $nbytes "$file" 2>/dev/null)
+
+	# Remove whitespace and check if any byte is non-zero
+	stripped=$(printf '%s' "$data" | tr -d ' \n\t')
+	if [ -n "$stripped" ] && ! echo "$stripped" | grep -qE "^0+$"; then
+		echo "FAIL: non-zero data in gap [$offset,$((offset + nbytes))) $label"
+		_hexdump -N $((offset + nbytes)) "$file"
+		return 1
+	fi
+	return 0
+}
+
+# Get the physical block offset (in bytes) of the file's first block on device
+_get_phys_offset()
+{
+	local file="$1"
+	local fiemap_output
+	local phys_blk
+
+	fiemap_output=$($XFS_IO_PROG -r -c "fiemap -v" "$file" 2>/dev/null)
+	phys_blk=$(echo "$fiemap_output" | _filter_xfs_io_fiemap | head -1 | awk '{print $3}')
+	if [ -z "$phys_blk" ]; then
+		echo ""
+		return
+	fi
+	# Convert 512-byte blocks to bytes
+	echo $((phys_blk * 512))
+}
+
+_test_eof_zeroing()
+{
+	local test_name="$1"
+	local extend_cmd="$2"
+	local expected_new_sz="$3"
+	local file=$SCRATCH_MNT/testfile_${test_name}
+
+	echo "$test_name" | tee -a $seqres.full
+
+	# Compute non-block-aligned EOF offset
+	local gap_bytes=16
+	local eof_offset=$((blksz - gap_bytes))
+
+	# Step 1: Write one full block to ensure the filesystem allocates a
+	#         physical block for the file instead of using inline data.
+	$XFS_IO_PROG -f -c "pwrite -S 0x5a 0 $blksz" -c fsync \
+		"$file" >> $seqres.full 2>&1
+
+	# Step 2: Get physical block offset on device via FIEMAP
+	local phys_offset
+	phys_offset=$(_get_phys_offset "$file")
+	if [ -z "$phys_offset" ]; then
+		_fail "$test_name: failed to get physical block offset via fiemap"
+	fi
+
+	# Step 3: Truncate file to non-block-aligned size and fsync.
+	#         The on-disk region [eof_offset, blksz) may or may not be
+	#         zeroed by the filesystem at this point.
+	$XFS_IO_PROG -c "truncate $eof_offset" -c fsync \
+		"$file" >> $seqres.full 2>&1
+
+	# Step 4: Unmount and restore the physical block to all-0x5a on disk.
+	#         This bypasses the kernel's pagecache EOF-zeroing to ensure
+	#         the stale pattern is present on disk. Then remount.
+	_scratch_unmount
+	$XFS_IO_PROG -d -c "pwrite -S 0x5a $phys_offset $blksz" \
+		$SCRATCH_DEV >> $seqres.full 2>&1
+	if [ $? -ne 0 ]; then
+		_fail "$test_name: failed to inject stale data on disk"
+	fi
+	_scratch_mount >> $seqres.full 2>&1
+
+	# Step 5: Execute the extend operation.
+	$XFS_IO_PROG -c "$extend_cmd" "$file" >> $seqres.full 2>&1
+
+	# Step 6: Verify gap [eof_offset, blksz) is zeroed BEFORE shutdown
+	_check_gap_zero "$file" $eof_offset $gap_bytes "before shutdown" || return 1
+
+	# Step 7: Sync the extended range and shutdown the filesystem with
+	#         journal flush. This persists the file size extending, and
+	#         the filesystem should persist the zeroed data in the gap
+	#         range as well.
+	if [ "$extend_cmd" != "${extend_cmd#pwrite}" ]; then
+		$XFS_IO_PROG -c "sync_range -w $blksz $blksz" \
+			-c "sync_range -a $blksz $blksz" \
+			"$file" >> $seqres.full 2>&1
+	fi
+	_scratch_shutdown -f
+
+	# Step 8: Remount and verify gap is still zeroed
+	_scratch_cycle_mount
+
+	# Verify file size was not rolled back after shutdown+remount
+	local sz
+	sz=$(stat -c %s "$file")
+	if [ "$sz" -ne "$expected_new_sz" ]; then
+		_fail "$test_name: file size rolled back after shutdown+remount: $sz != $expected_new_sz"
+	fi
+
+	_check_gap_zero "$file" $eof_offset $gap_bytes "after shutdown+remount" || return 1
+}
+
+_scratch_mkfs >> $seqres.full 2>&1
+_scratch_mount
+
+blksz=$(_get_block_size $SCRATCH_MNT)
+
+# Test three variants of EOF-extending operations
+_test_eof_zeroing "append_write" "pwrite -S 0x42 $blksz $blksz" $((blksz * 2))
+_test_eof_zeroing "truncate_up" "truncate $((blksz * 2))" $((blksz * 2))
+_test_eof_zeroing "fallocate" "falloc $blksz $blksz" $((blksz * 2))
+
+# success, all done
+status=0
+exit
diff --git a/tests/generic/790.out b/tests/generic/790.out
new file mode 100644
index 00000000..e5e2cc09
--- /dev/null
+++ b/tests/generic/790.out
@@ -0,0 +1,4 @@
+QA output created by 790
+append_write
+truncate_up
+fallocate
-- 
2.52.0

