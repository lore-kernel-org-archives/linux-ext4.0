From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: [PATCH 70/74] tests: add stale data after truncate test
Date: Tue, 10 Dec 2013 17:26:10 -0800
Message-ID: <20131211012610.30655.42358.stgit@birch.djwong.org>
References: <20131211011813.30655.39624.stgit@birch.djwong.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org
To: tytso@mit.edu, darrick.wong@oracle.com
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:27724 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751424Ab3LKB0R (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 10 Dec 2013 20:26:17 -0500
In-Reply-To: <20131211011813.30655.39624.stgit@birch.djwong.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Add a test to look for stale data after a file truncation.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 tests/metadata-checksum-test.sh |   47 +++++++++++++++++++++++++++++++++++++++
 1 file changed, 47 insertions(+)


diff --git a/tests/metadata-checksum-test.sh b/tests/metadata-checksum-test.sh
index 75b92a0..1f0d5bc 100755
--- a/tests/metadata-checksum-test.sh
+++ b/tests/metadata-checksum-test.sh
@@ -3184,6 +3184,53 @@ umount "${MNT}"
 ${fsck_cmd} -f -n "${DEV}"
 }
 
+##########################
+function truncate_stale_test {
+msg "truncate_stale_test"
+$VALGRIND ${E2FSPROGS}/misc/mke2fs -T ext4icsum $MKFS_OPTS $MKFS_FEATURES -F "${DEV}" 12800
+test -z "$NO_CSUM" && $VALGRIND ${E2FSPROGS}/misc/tune2fs -O metadata_csum $DEV
+${E2FSPROGS}/misc/dumpe2fs -h $DEV 2> /dev/null | egrep -q "^Filesystem state:[ ]*clean$" || ${fsck_cmd} -fDy $DEV || true
+
+# a: truncate, fallocate
+# b: truncate, truncate
+${mount_cmd} ${MOUNT_OPTS} "${DEV}" "${MNT}" -t ext4 -o journal_checksum
+echo "${FUZZ}" > "${MNT}/original"
+echo "${FUZZ}" >> "${MNT}/original"
+echo "${FUZZ}" >> "${MNT}/original"
+
+cp "${MNT}/original" "${MNT}/a"
+cp "${MNT}/original" "${MNT}/b"
+
+dd if=/dev/zero of="${MNT}/correct" bs=20480 count=1
+echo -n "${FUZZ}" | dd of="${MNT}/correct" conv=notrunc
+
+umount "${MNT}"
+${fsck_cmd} -f -n "${DEV}"
+
+${mount_cmd} ${MOUNT_OPTS} "${DEV}" "${MNT}" -t ext4 -o journal_checksum
+FUZZ_LEN="${#FUZZ}"
+truncate -s "${FUZZ_LEN}" "${MNT}/a"
+truncate -s "${FUZZ_LEN}" "${MNT}/b"
+umount "${MNT}"
+${fsck_cmd} -f -n "${DEV}"
+
+${mount_cmd} ${MOUNT_OPTS} "${DEV}" "${MNT}" -t ext4 -o journal_checksum
+fallocate -l 20k "${MNT}/a"
+truncate -s 20k "${MNT}/b"
+umount "${MNT}"
+${fsck_cmd} -f -n "${DEV}"
+
+${mount_cmd} ${MOUNT_OPTS} "${DEV}" "${MNT}" -t ext4 -o journal_checksum
+for i in a b correct original; do
+	od -tx1 -Ad -c "${MNT}/${i}" > "${MNT}/${i}.txt"
+done
+diff -u "${MNT}/original.txt" "${MNT}/correct.txt" || true
+diff -u "${MNT}/a.txt" "${MNT}/correct.txt"
+diff -u "${MNT}/b.txt" "${MNT}/correct.txt"
+umount "${MNT}"
+${fsck_cmd} -f -n "${DEV}"
+}
+
 # This test should be the last one (before speed tests, anyway)
 
 #### ALL SPEED TESTS GO AT THE END

