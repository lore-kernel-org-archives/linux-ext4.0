From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: [PATCH 69/74] Subject: [PATCH] tests: test what happens if we run out
 of space
Date: Tue, 10 Dec 2013 17:26:04 -0800
Message-ID: <20131211012604.30655.42400.stgit@birch.djwong.org>
References: <20131211011813.30655.39624.stgit@birch.djwong.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org
To: tytso@mit.edu, darrick.wong@oracle.com
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:27664 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752103Ab3LKB0J (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 10 Dec 2013 20:26:09 -0500
In-Reply-To: <20131211011813.30655.39624.stgit@birch.djwong.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Make sure we test behavior when running out of space.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 tests/metadata-checksum-test.sh |   20 ++++++++++++++++++++
 1 file changed, 20 insertions(+)


diff --git a/tests/metadata-checksum-test.sh b/tests/metadata-checksum-test.sh
index 0703501..75b92a0 100755
--- a/tests/metadata-checksum-test.sh
+++ b/tests/metadata-checksum-test.sh
@@ -3164,6 +3164,26 @@ umount "${MNT}"
 ${fsck_cmd} -f -n "${DEV}"
 }
 
+##########################
+function enospc_test {
+msg "enospc_test"
+$VALGRIND ${E2FSPROGS}/misc/mke2fs -T ext4icsum $MKFS_OPTS $MKFS_FEATURES -F "${DEV}" 12800
+test -z "$NO_CSUM" && $VALGRIND ${E2FSPROGS}/misc/tune2fs -O metadata_csum $DEV
+${E2FSPROGS}/misc/dumpe2fs -h $DEV 2> /dev/null | egrep -q "^Filesystem state:[ ]*clean$" || ${fsck_cmd} -fDy $DEV || true
+
+${mount_cmd} ${MOUNT_OPTS} "${DEV}" "${MNT}" -t ext4 -o journal_checksum
+dd if=/dev/zero of="${MNT}/a" || true
+dd if=/dev/zero of="${MNT}/b" || true
+ls -la "${MNT}/"
+for i in 1 2 3; do
+	XYZ="$(dd if=/dev/zero of="${MNT}/b" 2>&1 || true)"
+	echo "${XYZ}" | grep -c "No space left"
+	ls -la "${MNT}/"
+done
+umount "${MNT}"
+${fsck_cmd} -f -n "${DEV}"
+}
+
 # This test should be the last one (before speed tests, anyway)
 
 #### ALL SPEED TESTS GO AT THE END

