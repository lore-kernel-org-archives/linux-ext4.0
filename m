From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: [PATCH 01/35] e2fuzz: fuzz harder
Date: Wed, 01 Apr 2015 19:34:06 -0700
Message-ID: <20150402023406.25243.9589.stgit@birch.djwong.org>
References: <20150402023359.25243.79782.stgit@birch.djwong.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org
To: tytso@mit.edu, darrick.wong@oracle.com
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:48069 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752364AbbDBCeM (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 1 Apr 2015 22:34:12 -0400
In-Reply-To: <20150402023359.25243.79782.stgit@birch.djwong.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Once we've "fixed" the filesystem, try mounting and modifying it to see
if we can break the kernel.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 misc/e2fuzz.sh |   60 +++++++++++++++++++++++++++++++++++++++++++++++++++++++-
 1 file changed, 59 insertions(+), 1 deletion(-)


diff --git a/misc/e2fuzz.sh b/misc/e2fuzz.sh
index d8d9a82..389f2ca 100755
--- a/misc/e2fuzz.sh
+++ b/misc/e2fuzz.sh
@@ -139,7 +139,7 @@ if [ $? -ne 0 ]; then
 fi
 SRC_SZ="$(du -ks "${SRCDIR}" | awk '{print $1}')"
 FS_SZ="$(( $(stat -f "${TESTMNT}" -c '%a * %S') / 1024 ))"
-NR="$(( (FS_SZ * 6 / 10) / SRC_SZ ))"
+NR="$(( (FS_SZ * 4 / 10) / SRC_SZ ))"
 if [ "${NR}" -lt 1 ]; then
 	NR=1
 fi
@@ -263,6 +263,64 @@ seq 1 "${PASSES}" | while read pass; do
 			break;
 		fi
 	fi
+
+	echo "+++ check fs for round 2"
+	FSCK_LOG="${TESTDIR}/e2fuzz-${pass}-round2.log"
+	e2fsck -fn "${FSCK_IMG}" ${EXTENDED_FSCK_OPTS} >> "${FSCK_LOG}" 2>&1
+	res=$?
+	if [ "${res}" -ne 0 ]; then
+		echo "++++ fsck failed."
+		exit 1
+	fi
+
+	echo "++ mount image (2)"
+	mount "${FSCK_IMG}" "${TESTMNT}" -o loop
+	res=$?
+
+	if [ "${res}" -eq 0 ]; then
+		echo "+++ ls -laR (2)"
+		ls -laR "${TESTMNT}/test.1/" > /dev/null 2> "${OPS_LOG}"
+
+		echo "+++ cat files (2)"
+		find "${TESTMNT}/test.1/" -type f -size -1048576k -print0 | xargs -0 cat > /dev/null 2>> "${OPS_LOG}"
+
+		echo "+++ expand (2)"
+		find "${TESTMNT}/" -type f 2> /dev/null | head -n 50000 | while read f; do
+			attr -l "$f" > /dev/null 2>> "${OPS_LOG}"
+			if [ -f "$f" -a -w "$f" ]; then
+				dd if=/dev/zero bs="${BLK_SZ}" count=1 >> "$f" 2>> "${OPS_LOG}"
+			fi
+			mv "$f" "$f.longer" > /dev/null 2>> "${OPS_LOG}"
+		done
+		sync
+
+		echo "+++ create files (2)"
+		cp -pRdu "${SRCDIR}" "${TESTMNT}/test.moo" 2>> "${OPS_LOG}"
+		sync
+
+		echo "+++ remove files (2)"
+		rm -rf "${TESTMNT}/test.moo" 2>> "${OPS_LOG}"
+
+		umount "${TESTMNT}"
+		res=$?
+		if [ "${res}" -ne 0 ]; then
+			ret=1
+			break
+		fi
+		sync
+		test "${USE_FUSE2FS}" -gt 0 && sleep 2
+
+		echo "+++ check fs (2)"
+		e2fsck -fn "${FSCK_IMG}" >> "${FSCK_LOG}" 2>&1
+		res=$?
+		if [ "${res}" -ne 0 ]; then
+			echo "++ fsck failed."
+			exit 1
+		fi
+	else
+		echo "++ mount(2) failed with ${res}"
+		exit 1
+	fi
 	rm -rf "${FSCK_IMG}" "${PASS_IMG}" "${FUZZ_LOG}" "${TESTDIR}"/e2fuzz*.log
 done
 

