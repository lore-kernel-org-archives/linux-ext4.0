From: Marcus Huewe <suse-tux@gmx.de>
Subject: [PATCH 1/2] tests: test "mke2fs -E offset=N" filesystem size
 calculation
Date: Thu, 12 May 2016 18:22:12 +0200
Message-ID: <20160512162212.GA4627@linux>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: tytso@mit.edu
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.17.20]:58677 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751628AbcELQWd (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 12 May 2016 12:22:33 -0400
Content-Disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

If "mke2fs -E offset=N ..." is called without a specified filesystem size,
the offset should be subtracted from the default filesystem size (see
commit 87d9b2fb). If "mke2fs -E offset=N ..." is called with an
explicitly specified filesystem size, the specified filesystem size
should be used.

Also, call dd with the "iflag=fullblock" option, if it is going to read
from a pipe.

Signed-off-by: Marcus Huewe <suse-tux@gmx.de>
---
 tests/t_mke2fs_offset/script | 28 +++++++++++++++++++++-------
 1 file changed, 21 insertions(+), 7 deletions(-)

diff --git a/tests/t_mke2fs_offset/script b/tests/t_mke2fs_offset/script
index 97b9bd1..e4bc3c4 100755
--- a/tests/t_mke2fs_offset/script
+++ b/tests/t_mke2fs_offset/script
@@ -1,20 +1,34 @@
 test_description="mke2fs with offset option (-E offset=N)"
 OUT="$test_name.log"
 
-echo "testing mke2fs with -E offset=524288 option" > "$OUT"
-yes a | dd of="$TMPFILE" bs=1k count=2048 2>/dev/null
+echo "testing mke2fs with -E offset=524288 option (no fssize)" > "$OUT"
+yes a | dd of="$TMPFILE" bs=1k count=2048 iflag=fullblock 2>>"$OUT"
+$MKE2FS -F -b 1024 -E offset=524288 "$TMPFILE" >> "$OUT" 2>&1
+# compute crc of the first 512 1k blocks
+crc_first1=`dd if="$TMPFILE" bs=1k count=512 2>/dev/null | $CRCSUM`
+
+echo "testing mke2fs with -E offset=524288 option (explicit fssize)" >> "$OUT"
+yes a | dd of="$TMPFILE" bs=1k count=2048 iflag=fullblock 2>>"$OUT"
 $MKE2FS -F -b 1024 -E offset=524288 "$TMPFILE" 1024 >> "$OUT" 2>&1
 # compute crc of the first and last 512 1k blocks
-crc_first=`dd if="$TMPFILE" bs=1k count=512 2>/dev/null | $CRCSUM`
-crc_last=`dd if="$TMPFILE" bs=1k count=512 skip=1536 2>/dev/null | $CRCSUM`
+crc_first2=`dd if="$TMPFILE" bs=1k count=512 2>/dev/null | $CRCSUM`
+crc_last2=`dd if="$TMPFILE" bs=1k count=512 skip=1536 2>/dev/null | $CRCSUM`
 crc_exp=`yes a | dd bs=1k count=512 2>/dev/null | $CRCSUM`
+# a warning should be only emitted by the first mke2fs call
+warning=`grep -c "offset specified without an explicit file system size." \
+	"$OUT"`
 
-if [ "$crc_first" = "$crc_last" -a "$crc_first" = "$crc_exp" ]; then
+if [ "$warning" -eq 1 -a \
+	 "$crc_first1" = "$crc_first2" -a \
+	 "$crc_first2" = "$crc_last2" -a \
+	 "$crc_first2" = "$crc_exp" ]; then
 	echo "$test_name: $test_description: ok"
 	touch "$test_name.ok"
 else
 	echo "$test_name: $test_description: failed"
-	echo "crc_first: $crc_first" > "$test_name.failed"
-	echo "crc_last: $crc_last" >> "$test_name.failed"
+	echo "warning: $warning" > "$test_name.failed"
+	echo "crc_first1: $crc_first1" >> "$test_name.failed"
+	echo "crc_first2: $crc_first2" >> "$test_name.failed"
+	echo "crc_last2: $crc_last2" >> "$test_name.failed"
 	echo "crc_exp: $crc_exp" >> "$test_name.failed"
 fi
-- 
2.6.3

