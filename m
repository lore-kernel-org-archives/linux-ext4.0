From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: [PATCH 71/74] tests: check mapping of really high logical block
 offsets
Date: Tue, 10 Dec 2013 17:26:17 -0800
Message-ID: <20131211012617.30655.15412.stgit@birch.djwong.org>
References: <20131211011813.30655.39624.stgit@birch.djwong.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org
To: tytso@mit.edu, darrick.wong@oracle.com
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:44134 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751424Ab3LKB0Y (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 10 Dec 2013 20:26:24 -0500
In-Reply-To: <20131211011813.30655.39624.stgit@birch.djwong.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Create a test to try to map logical blocks at the upper end of where
we can map blocks.  Then check the stat results, and run the whole
thing by e2fsck.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 tests/metadata-checksum-test.sh |   46 +++++++++++++++++++++++++++++++++++++++
 1 file changed, 46 insertions(+)


diff --git a/tests/metadata-checksum-test.sh b/tests/metadata-checksum-test.sh
index 1f0d5bc..4e353e1 100755
--- a/tests/metadata-checksum-test.sh
+++ b/tests/metadata-checksum-test.sh
@@ -3231,6 +3231,52 @@ umount "${MNT}"
 ${fsck_cmd} -f -n "${DEV}"
 }
 
+##########################
+function enormous_extent_file_test {
+msg "enormous_extent_file_test"
+
+# Try to create a file that's too big (with extents)
+$VALGRIND ${E2FSPROGS}/misc/mke2fs -T ext4icsum $MKFS_OPTS -O extent,^bigalloc,^64bit -F "${DEV}"
+test -z "$NO_CSUM" && $VALGRIND ${E2FSPROGS}/misc/tune2fs -O metadata_csum $DEV
+${E2FSPROGS}/misc/dumpe2fs -h $DEV 2> /dev/null | egrep -q "^Filesystem state:[ ]*clean$" || ${fsck_cmd} -fDy $DEV || true
+
+MAX_BLK=$(( (2**32) - 1 ))
+FILE_SIZE="$(( MAX_BLK * BLK_SZ ))"
+${mount_cmd} ${MOUNT_OPTS} "${DEV}" "${MNT}" -t ext4 -o journal_checksum
+dd if=/dev/zero of="${MNT}/bigfile" bs="${BLK_SZ}" count=32 seek=4294967288 conv=notrunc || true
+dd if=/dev/zero of="${MNT}/bigfile2" bs="${BLK_SZ}" count=32 seek=4294967288 || true
+umount "${MNT}"
+${fsck_cmd} -C0 -f -n "${DEV}"
+${E2FSPROGS}/debugfs/debugfs -R 'stat /bigfile' "${DEV}" | cat -
+${E2FSPROGS}/debugfs/debugfs -R 'stat /bigfile' "${DEV}" | grep -c "Size: ${FILE_SIZE}"
+${E2FSPROGS}/debugfs/debugfs -R 'stat /bigfile2' "${DEV}" | grep -c "Size: ${FILE_SIZE}"
+}
+
+##########################
+function enormous_blockmap_file_test {
+msg "enormous_blockmap_file_test"
+
+# Try to create a file that's too big (with block maps)
+$VALGRIND ${E2FSPROGS}/misc/mke2fs -T ext4icsum $MKFS_OPTS -O ^extent,^bigalloc,^64bit -F "${DEV}"
+test -z "$NO_CSUM" && $VALGRIND ${E2FSPROGS}/misc/tune2fs -O metadata_csum $DEV
+${E2FSPROGS}/misc/dumpe2fs -h $DEV 2> /dev/null | egrep -q "^Filesystem state:[ ]*clean$" || ${fsck_cmd} -fDy $DEV || true
+
+ADDR_PER_BLOCK="$((BLK_SZ / 4))"
+MAX_BLK="$(( (ADDR_PER_BLOCK ** 3) + (ADDR_PER_BLOCK ** 2) + (ADDR_PER_BLOCK) + 12))"
+if [ "${MAX_BLK}" -gt "$(( (2**32) - 1 ))" ]; then
+	MAX_BLK="$(( (2**32) - 1 ))"
+fi
+FILE_SIZE="$(( MAX_BLK * BLK_SZ ))"
+${mount_cmd} ${MOUNT_OPTS} "${DEV}" "${MNT}" -t ext4 -o journal_checksum
+dd if=/dev/zero of="${MNT}/bigfile" bs="${BLK_SZ}" count=32 seek="$((MAX_BLK - 8))" conv=notrunc || true
+dd if=/dev/zero of="${MNT}/bigfile2" bs="${BLK_SZ}" count=32 seek="$((MAX_BLK - 8))" || true
+umount "${MNT}"
+${E2FSPROGS}/debugfs/debugfs -R 'stat /bigfile' "${DEV}" | cat -
+${fsck_cmd} -C0 -f -n "${DEV}"
+${E2FSPROGS}/debugfs/debugfs -R 'stat /bigfile' "${DEV}" | grep -c "Size: ${FILE_SIZE}"
+${E2FSPROGS}/debugfs/debugfs -R 'stat /bigfile2' "${DEV}" | grep -c "Size: ${FILE_SIZE}"
+}
+
 # This test should be the last one (before speed tests, anyway)
 
 #### ALL SPEED TESTS GO AT THE END

