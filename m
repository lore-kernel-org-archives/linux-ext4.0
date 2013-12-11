From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: [PATCH 74/74] tests: test date handling
Date: Tue, 10 Dec 2013 17:26:38 -0800
Message-ID: <20131211012638.30655.70224.stgit@birch.djwong.org>
References: <20131211011813.30655.39624.stgit@birch.djwong.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org
To: tytso@mit.edu, darrick.wong@oracle.com
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:44259 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751646Ab3LKB0p (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 10 Dec 2013 20:26:45 -0500
In-Reply-To: <20131211011813.30655.39624.stgit@birch.djwong.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Test our ability to handle the entire range of valid dates.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 tests/metadata-checksum-test.sh |   62 +++++++++++++++++++++++++++++++++++++++
 1 file changed, 62 insertions(+)


diff --git a/tests/metadata-checksum-test.sh b/tests/metadata-checksum-test.sh
index d34985b..507d355 100755
--- a/tests/metadata-checksum-test.sh
+++ b/tests/metadata-checksum-test.sh
@@ -3301,6 +3301,68 @@ umount "${MNT}"
 test "${LINK_NOW}" = "${LINK_TARGET}"
 }
 
+##########################
+function date_test {
+msg "date_test"
+
+$VALGRIND ${E2FSPROGS}/misc/mke2fs -T ext4icsum $MKFS_OPTS $MKFS_FEATURES -F "${DEV}"
+test -z "$NO_CSUM" && $VALGRIND ${E2FSPROGS}/misc/tune2fs -O metadata_csum $DEV
+${E2FSPROGS}/misc/dumpe2fs -h $DEV 2> /dev/null | egrep -q "^Filesystem state:[ ]*clean$" || ${fsck_cmd} -fDy $DEV || true
+rm -rf /tmp/ls.before /tmp/ls.after /tmp/debugfs.diff
+
+INODE_SIZE="$(${E2FSPROGS}/misc/dumpe2fs -h "${DEV}" | grep 'Inode size:' | awk '{print $3}')"
+if [ "${INODE_SIZE}" -gt 128 ]; then
+	LAST_YEAR=2430
+else
+	LAST_YEAR=2030
+fi
+
+# Write dates
+${mount_cmd} ${MOUNT_OPTS} "${DEV}" "${MNT}" -t ext4 -o journal_checksum
+seq 1910 20 "${LAST_YEAR}" | while read year; do
+	DATE="${year}-01-01 00:00:00.000000000"
+	FNAME="$(echo "${DATE}" | tr '[ \-:.]' '____')"
+	touch -d "${DATE}" "${MNT}/${FNAME}"
+	echo "${FNAME} ${DATE}" >> /tmp/ls.before
+done
+umount "${MNT}"
+${fsck_cmd} -C0 -f -n "${DEV}"
+
+# debugfs
+seq 1910 20 "${LAST_YEAR}" | while read year; do
+	DATE="${year}-01-01 00:00:00.000000000"
+	FNAME="$(echo "${DATE}" | tr '[ \-:.]' '____')"
+	echo "${FNAME}" "$(${E2FSPROGS}/debugfs/debugfs -R "stat ${FNAME}" "${DEV}" | grep 'mtime:')"
+done > /tmp/debugfs.before
+
+# Re-read from kernel
+${mount_cmd} ${MOUNT_OPTS} "${DEV}" "${MNT}" -t ext4 -o journal_checksum
+seq 1910 20 "${LAST_YEAR}" | while read year; do
+	DATE="${year}-01-01 00:00:00.000000000"
+	FNAME="$(echo "${DATE}" | tr '[ \-:.]' '____')"
+	FDATE="$(stat -c '%y' "${MNT}/${FNAME}" | sed -e 's/......$//g')"
+	echo "${FNAME}" "${FDATE}" >> /tmp/ls.after
+done
+umount "${MNT}"
+
+# Did the kernel work?
+diff -u /tmp/ls.before /tmp/ls.after > /tmp/ls.diff || true
+
+# Does debugfs work?
+touch /tmp/debugfs.diff
+cat /tmp/debugfs.before | sed -e 's/^\(....\).*\(....\)$/\1 \2/g' | while read date fdate crap; do
+	if [ "${date}" != "${fdate}" ]; then
+		echo "${date} != ${fdate}" >> /tmp/debugfs.diff
+	fi
+done
+
+if [ "$(cat /tmp/debugfs.diff /tmp/ls.diff | wc -l)" -gt 0 ]; then
+	echo "BROKEN DATE HANDLING"
+	cat /tmp/debugfs.diff /tmp/ls.diff
+	false
+fi
+}
+
 # This test should be the last one (before speed tests, anyway)
 
 #### ALL SPEED TESTS GO AT THE END

