Received: from dggsgout12.his.huawei.com (dggsgout12.his.huawei.com [45.249.212.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 453834A23;
	Wed, 22 Apr 2026 01:59:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.56
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776823152; cv=none; b=h7Xm6IolN3FGqE5ZpRlgFwcFwpUy2c3OOKBzBgWohgh8TwvuBxblvWSGFb2dZfnK37xi/mO5FAriEJq7Im2uyU6lLMVX9I94exsykgLlLiIbOF4OZlUNTeazX3Uh3QRQO6J6NtvxRkPmRr12W7ZTXcPVwBrS2aI5+AijZehit6w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776823152; c=relaxed/simple;
	bh=/dYcp8HiUqYhyRhwQpJDUJJRfiSSBDRerwnbELrnQ44=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=uzNcSwZ99FRupt7nX48yqrGGUs5RuRIZxkrTus6fgC8iIZxd57wetkJaRo168gC/bxZkT9waHqEwgWtt/J4TGtIyvaZHErcRTTCzLORRAPVrL5ppaLwe4mFSLe0zIoXEzsYezN9vuo7O5dCAeRzHHvGs+Hkb4WAtYrXtH4W22zQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=none smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.163.170])
	by dggsgout12.his.huawei.com (SkyGuard) with ESMTPS id 4g0j7T0YzVzKHLt9;
	Wed, 22 Apr 2026 09:58:45 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.252])
	by mail.maildlp.com (Postfix) with ESMTP id 1B1A1405D2;
	Wed, 22 Apr 2026 09:59:05 +0800 (CST)
Received: from huaweicloud.com (unknown [10.50.85.155])
	by APP3 (Coremail) with SMTP id _Ch0CgC3ZL5bK+hpYcQSBQ--.2895S4;
	Wed, 22 Apr 2026 09:59:02 +0800 (CST)
From: Zhang Yi <yi.zhang@huaweicloud.com>
To: fstests@vger.kernel.org,
	zlang@kernel.org
Cc: linux-ext4@vger.kernel.org,
	linux-fsdevel@vger.kernel.org,
	jack@suse.cz,
	yi.zhang@huawei.com,
	yi.zhang@huaweicloud.com,
	yizhang089@gmail.com,
	yangerkun@huawei.com
Subject: [PATCH] generic/790: test post-EOF gap zeroing persistence
Date: Wed, 22 Apr 2026 09:52:46 +0800
Message-ID: <20260422015246.4132376-1-yi.zhang@huaweicloud.com>
X-Mailer: git-send-email 2.52.0
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:_Ch0CgC3ZL5bK+hpYcQSBQ--.2895S4
X-Coremail-Antispam: 1UD129KBjvJXoW3Xw17Cr48CryDCryUtry3twb_yoWxuFy3pF
	ZYgF1Ykr1xKa17X397GF1qqr1ruwn5Zr4j9392grZ0vry8GF1xXa9Fgr1jq3y7Jr1fuw4F
	va1kKa4xWw17AFJanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUkG14x267AKxVW8JVW5JwAFc2x0x2IEx4CE42xK8VAvwI8IcIk0
	rVWrJVCq3wAFIxvE14AKwVWUJVWUGwA2ocxC64kIII0Yj41l84x0c7CEw4AK67xGY2AK02
	1l84ACjcxK6xIIjxv20xvE14v26F1j6w1UM28EF7xvwVC0I7IYx2IY6xkF7I0E14v26r4U
	JVWxJr1l84ACjcxK6I8E87Iv67AKxVW0oVCq3wA2z4x0Y4vEx4A2jsIEc7CjxVAFwI0_Gc
	CE3s1le2I262IYc4CY6c8Ij28IcVAaY2xG8wAqx4xG64xvF2IEw4CE5I8CrVC2j2WlYx0E
	2Ix0cI8IcVAFwI0_JrI_JrylYx0Ex4A2jsIE14v26r1j6r4UMcvjeVCFs4IE7xkEbVWUJV
	W8JwACjcxG0xvY0x0EwIxGrwACjI8F5VA0II8E6IAqYI8I648v4I1lc7CjxVAaw2AFwI0_
	Jw0_GFyl42xK82IYc2Ij64vIr41l4I8I3I0E4IkC6x0Yz7v_Jr0_Gr1lx2IqxVAqx4xG67
	AKxVWUJVWUGwC20s026x8GjcxK67AKxVWUGVWUWwC2zVAF1VAY17CE14v26r1q6r43MIIY
	rxkI7VAKI48JMIIF0xvE2Ix0cI8IcVAFwI0_Jr0_JF4lIxAIcVC0I7IYx2IY6xkF7I0E14
	v26r1j6r4UMIIF0xvE42xK8VAvwI8IcIk0rVWUJVWUCwCI42IY6I8E87Iv67AKxVWUJVW8
	JwCI42IY6I8E87Iv6xkF7I0E14v26r1j6r4UYxBIdaVFxhVjvjDU0xZFpf9x0JUZYFZUUU
	UU=
X-CM-SenderInfo: d1lo6xhdqjqx5xdzvxpfor3voofrz/

From: Zhang Yi <yi.zhang@huawei.com>

Test that extending a file past a non-block-aligned EOF correctly
zero-fills the gap [old_EOF, block_boundary), and that this zeroing
persists through a filesystem shutdown+remount cycle.

Stale data beyond EOF can persist on disk when append write data blocks
are flushed before the i_size metadata update, or when concurrent append
writeback and mmap writes persist non-zero data past EOF. Subsequent
post-EOF operations (append write, fallocate, truncate up) must
zero-fill and persist the gap to prevent exposing stale data.

The test pollutes the file's last physical block (via FIEMAP + raw
device write) with a sentinel pattern beyond i_size, then performs each
extend operation and verifies the gap is zeroed both in memory and on
disk.

Signed-off-by: Zhang Yi <yi.zhang@huawei.com>
---
This is the case Jan Kara pointed out during my work on the ext4
buffered I/O to iomap conversion. This case is similar to generic/363,
but generic/363 doesn't provide persistent testing. For details:

 https://lore.kernel.org/linux-ext4/jgotl7vzzuzm6dvz5zfgk6haodxvunb4hq556pzh4hqqwvnhxq@lr3jiedhqh7c/

 tests/generic/790     | 155 ++++++++++++++++++++++++++++++++++++++++++
 tests/generic/790.out |   4 ++
 2 files changed, 159 insertions(+)
 create mode 100755 tests/generic/790
 create mode 100644 tests/generic/790.out

diff --git a/tests/generic/790 b/tests/generic/790
new file mode 100755
index 00000000..5d8f61f9
--- /dev/null
+++ b/tests/generic/790
@@ -0,0 +1,155 @@
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
+# 1) append write data blocks are flushed before the i_size metadata update,
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
+_require_scratch_shutdown
+_require_metadata_journaling $SCRATCH_DEV
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
+	data=$(od -A n -t x1 -j $offset -N $nbytes "$file" 2>/dev/null)
+
+	# Remove whitespace and check if any byte is non-zero
+	stripped=$(echo "$data" | tr -d ' \n\t')
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
+	_scratch_mount >> $seqres.full 2>&1
+
+	# Verify file size is still eof_offset after remount
+	local sz
+	sz=$(stat -c %s "$file")
+	if [ "$sz" -ne "$eof_offset" ]; then
+		_fail "$test_name: file size wrong after remount: $sz != $eof_offset"
+	fi
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
+			"$file" >> $seqres.full 2>&1
+	fi
+	_scratch_shutdown -f
+
+	# Step 8: Remount and verify gap is still zeroed
+	_scratch_cycle_mount
+	_check_gap_zero "$file" $eof_offset $gap_bytes "after shutdown+remount" || return 1
+}
+
+_scratch_mkfs >> $seqres.full 2>&1
+_scratch_mount
+
+blksz=$(_get_block_size $SCRATCH_MNT)
+
+# Test three variants of EOF-extending operations
+_test_eof_zeroing "append_write" "pwrite -S 0x42 $blksz $blksz"
+_test_eof_zeroing "truncate_up" "truncate $((blksz * 2))"
+_test_eof_zeroing "fallocate" "falloc $blksz $blksz"
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

