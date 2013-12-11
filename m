From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: [PATCH 67/74] tests: check correct handling of reading and writing
 uninit extents
Date: Tue, 10 Dec 2013 17:25:46 -0800
Message-ID: <20131211012546.30655.86099.stgit@birch.djwong.org>
References: <20131211011813.30655.39624.stgit@birch.djwong.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org
To: tytso@mit.edu, darrick.wong@oracle.com
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:43979 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751393Ab3LKBZw (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 10 Dec 2013 20:25:52 -0500
In-Reply-To: <20131211011813.30655.39624.stgit@birch.djwong.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Check that fallocate actually creates uninitialized extents, that
reads from uninit regions don't return garbage data, and that
subsequent writes to an uninitalized extent actually get recorded.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 tests/metadata-checksum-test.sh |   62 ++++++++++++++++++++++++++++++++++++++-
 1 file changed, 61 insertions(+), 1 deletion(-)


diff --git a/tests/metadata-checksum-test.sh b/tests/metadata-checksum-test.sh
index 987e653..1c73e58 100755
--- a/tests/metadata-checksum-test.sh
+++ b/tests/metadata-checksum-test.sh
@@ -21,6 +21,7 @@ DIR="$(readlink -f "$(dirname "$0")")"
 E2FSPROGS="${DIR}/../"
 export LD_LIBRARY_PATH="${E2FSPROGS}/lib/:${LD_LIBRARY_PATH}"
 BLK_SZ=4096
+MAX_BLK_SZ=65536
 #MOUNT_OPTS="errors=remount-ro"
 HUGE_DEV_NAME="HUGE"
 FUZZ_DEV=0
@@ -132,7 +133,7 @@ function msg {
 	fi
 }
 
-for prog in attr /usr/bin/time truncate fallocate gcc; do
+for prog in od attr /usr/bin/time truncate fallocate gcc; do
 	type "${prog}" 2> /dev/null || msg "WARNING: ${prog} not found!"
 done
 
@@ -3095,6 +3096,65 @@ MKE2FS_CONFIG=/tmp/mke2fs.conf
 export MKE2FS_CONFIG
 }
 
+##########################
+function fallocate_dirty_test {
+msg "fallocate_dirty_test"
+$VALGRIND ${E2FSPROGS}/misc/mke2fs -T ext4icsum $MKFS_OPTS $MKFS_FEATURES -F "${DEV}"
+test -z "$NO_CSUM" && $VALGRIND ${E2FSPROGS}/misc/tune2fs -O metadata_csum $DEV
+${E2FSPROGS}/misc/dumpe2fs -h $DEV 2> /dev/null | egrep -q "^Filesystem state:[ ]*clean$" || ${fsck_cmd} -fDy $DEV || true
+
+${mount_cmd} ${MOUNT_OPTS} "${DEV}" "${MNT}" -t ext4 -o journal_checksum
+echo "moo" > "${MNT}/a"
+fallocate -l "$((6 * MAX_BLK_SZ))" "${MNT}/a"
+umount "${MNT}"
+${fsck_cmd} -f -n "${DEV}"
+
+str="$(${E2FSPROGS}/debugfs/debugfs -R 'ex /a' "${DEV}")"
+echo "${str}"
+echo "${str}" | grep -i uninit
+
+zap="$(${E2FSPROGS}/debugfs/debugfs -R 'bmap /a 1' "${DEV}")"
+${E2FSPROGS}/debugfs/debugfs -w -R "zap -p 0x55 ${zap}" "${DEV}"
+
+${mount_cmd} ${MOUNT_OPTS} "${DEV}" "${MNT}" -t ext4 -o journal_checksum
+od -tx1 -Ad -c "${MNT}/a" > /tmp/a
+cat > /tmp/b << ENDL
+0000000  6d  6f  6f  0a  00  00  00  00  00  00  00  00  00  00  00  00
+          m   o   o  \n  \0  \0  \0  \0  \0  \0  \0  \0  \0  \0  \0  \0
+0000016  00  00  00  00  00  00  00  00  00  00  00  00  00  00  00  00
+         \0  \0  \0  \0  \0  \0  \0  \0  \0  \0  \0  \0  \0  \0  \0  \0
+*
+0393216
+ENDL
+diff -u /tmp/a /tmp/b
+echo "cow" | dd of="${MNT}/a" bs="${BLK_SZ}" count=1 seek=3 conv=notrunc
+umount "${MNT}"
+${fsck_cmd} -f -n "${DEV}"
+
+${E2FSPROGS}/debugfs/debugfs -R 'ex /a' "${DEV}" | cat -
+
+${mount_cmd} ${MOUNT_OPTS} "${DEV}" "${MNT}" -t ext4 -o journal_checksum
+od -tx1 -Ad -c "${MNT}/a" > /tmp/a
+OFF1="$(printf '%07d\n' "$((3 * BLK_SZ))")"
+OFF2="$(printf '%07d\n' "$(((3 * BLK_SZ) + 16))")"
+cat > /tmp/b << ENDL
+0000000  6d  6f  6f  0a  00  00  00  00  00  00  00  00  00  00  00  00
+          m   o   o  \n  \0  \0  \0  \0  \0  \0  \0  \0  \0  \0  \0  \0
+0000016  00  00  00  00  00  00  00  00  00  00  00  00  00  00  00  00
+         \0  \0  \0  \0  \0  \0  \0  \0  \0  \0  \0  \0  \0  \0  \0  \0
+*
+${OFF1}  63  6f  77  0a  00  00  00  00  00  00  00  00  00  00  00  00
+          c   o   w  \n  \0  \0  \0  \0  \0  \0  \0  \0  \0  \0  \0  \0
+${OFF2}  00  00  00  00  00  00  00  00  00  00  00  00  00  00  00  00
+         \0  \0  \0  \0  \0  \0  \0  \0  \0  \0  \0  \0  \0  \0  \0  \0
+*
+0393216
+ENDL
+diff -u /tmp/a /tmp/b
+umount "${MNT}"
+${fsck_cmd} -f -n "${DEV}"
+}
+
 # This test should be the last one (before speed tests, anyway)
 
 #### ALL SPEED TESTS GO AT THE END

