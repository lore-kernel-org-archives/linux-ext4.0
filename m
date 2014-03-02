From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: [PATCH 32/32] tests: test date handling
Date: Sat, 01 Mar 2014 23:20:05 -0800
Message-ID: <20140302072005.28217.57465.stgit@birch.djwong.org>
References: <20140302071639.28217.57302.stgit@birch.djwong.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org
To: tytso@mit.edu, darrick.wong@oracle.com
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:44506 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751741AbaCBHUJ (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sun, 2 Mar 2014 02:20:09 -0500
In-Reply-To: <20140302071639.28217.57302.stgit@birch.djwong.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Test our ability to handle the entire range of valid dates.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 tests/metadata-checksum-test.sh |   59 +++++++++++++++++++++++++++++++++++++++
 1 file changed, 59 insertions(+)


diff --git a/tests/metadata-checksum-test.sh b/tests/metadata-checksum-test.sh
index 05b88bc..7887d1a 100755
--- a/tests/metadata-checksum-test.sh
+++ b/tests/metadata-checksum-test.sh
@@ -3746,6 +3746,65 @@ ${fsck_cmd} -C0 -f -n "${DEV}"
 ${E2FSPROGS}/debugfs/debugfs -R 'ex /fragfile' "${DEV}" | tail -n 15
 }
 
+#####################################
+function date_test {
+msg "date_test"
+
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

