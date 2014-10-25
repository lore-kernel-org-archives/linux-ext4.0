From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: [PATCH 02/39] e2fuzz: exercise fuzzed blocks more aggressively
Date: Sat, 25 Oct 2014 13:56:36 -0700
Message-ID: <20141025205636.532.23454.stgit@birch.djwong.org>
References: <20141025205623.532.12119.stgit@birch.djwong.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org
To: tytso@mit.edu, darrick.wong@oracle.com
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:43622 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752690AbaJYU5K (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sat, 25 Oct 2014 16:57:10 -0400
In-Reply-To: <20141025205623.532.12119.stgit@birch.djwong.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Exercise fuzzed metadata blocks more aggressively by expanding up to
50000 files (instead of just test.1, which might not hit anything).
Fix a typo while we're at it.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 misc/e2fuzz.sh |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)


diff --git a/misc/e2fuzz.sh b/misc/e2fuzz.sh
index a261d5a..4cb7b61 100755
--- a/misc/e2fuzz.sh
+++ b/misc/e2fuzz.sh
@@ -34,7 +34,7 @@ print_help() {
 	echo "-p:	Use system's mke2fs/e2fsck/tune2fs tools."
 	echo "-s:	Create FS images of this size. (${SZ})"
 	echo "-S:	Copy files from this dir. (${SRCDIR})"
-	echo "-x:	Run e2fck at most this many times. (${MAX_FSCK})"
+	echo "-x:	Run e2fsck at most this many times. (${MAX_FSCK})"
 	test "${HAS_FUSE2FS}" -gt 0 && echo "-u:	Use fuse2fs instead of the kernel."
 	exit 0
 }
@@ -192,12 +192,12 @@ seq 1 "${PASSES}" | while read pass; do
 		find "${TESTMNT}/test.1/" -type f -size -1048576k -print0 | xargs -0 cat > /dev/null 2>> "${OPS_LOG}"
 
 		echo "+++ expand"
-		find "${TESTMNT}/test.1/" -type f 2> /dev/null | while read f; do
+		find "${TESTMNT}/" -type f 2> /dev/null | head -n 50000 | while read f; do
 			attr -l "$f" > /dev/null 2>> "${OPS_LOG}"
-			mv "$f" "$f.longer" > /dev/null 2>> "${OPS_LOG}"
 			if [ -f "$f" -a -w "$f" ]; then
 				dd if=/dev/zero bs="${BLK_SZ}" count=1 >> "$f" 2>> "${OPS_LOG}"
 			fi
+			mv "$f" "$f.longer" > /dev/null 2>> "${OPS_LOG}"
 		done
 		sync
 

