From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: [PATCH 01/54] misc: fix minor testcase problems
Date: Mon, 26 Jan 2015 23:35:40 -0800
Message-ID: <20150127073540.13308.30168.stgit@birch.djwong.org>
References: <20150127073533.13308.44994.stgit@birch.djwong.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org
To: tytso@mit.edu, darrick.wong@oracle.com
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:45003 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751116AbbA0Hfq (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 27 Jan 2015 02:35:46 -0500
In-Reply-To: <20150127073533.13308.44994.stgit@birch.djwong.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Don't write debugfs headers to stdout...

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 tests/f_badcluster/script |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)


diff --git a/tests/f_badcluster/script b/tests/f_badcluster/script
index 56b4b7f..ea9e488 100644
--- a/tests/f_badcluster/script
+++ b/tests/f_badcluster/script
@@ -8,7 +8,7 @@ if test -x $DEBUGFS_EXE; then
 	$FSCK -fy $TMPFILE 2>&1 | sed -f $cmd_dir/filter.sed >> $OUT
 	for i in a b c d e f g; do echo "stat /$i"; done > $TMPFILE.tmp
 	echo "quit" >> $TMPFILE.tmp
-	$DEBUGFS_EXE -f $TMPFILE.tmp $TMPFILE >> $OUT
+	$DEBUGFS_EXE -f $TMPFILE.tmp $TMPFILE 2>&1 | sed -f $cmd_dir/filter.sed >> $OUT
 	rm -f $TMPFILE.tmp
 
 	cmp -s $OUT $EXP

