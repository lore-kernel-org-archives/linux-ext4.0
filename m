From: Jim Meyering <jim@meyering.net>
Subject: avoid leak upon failed realloc
Date: Sat, 16 Jun 2007 19:31:01 +0200
Message-ID: <87ejkbbycq.fsf@rho.meyering.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp3-g19.free.fr ([212.27.42.29]:59686 "EHLO smtp3-g19.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751088AbXFPRbD (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sat, 16 Jun 2007 13:31:03 -0400
Received: from mx.meyering.net (mx.meyering.net [82.230.74.64])
	by smtp3-g19.free.fr (Postfix) with ESMTP id 36E1A5A210
	for <linux-ext4@vger.kernel.org>; Sat, 16 Jun 2007 19:31:02 +0200 (CEST)
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Here's a tiny fix to avoid a leak when realloc fails:

2007-06-16  Jim Meyering  <jim@meyering.net>

	* tdb.c (tdb_append): Don't leak a buffer when realloc fails.

diff -r 777972a573b3 lib/ext2fs/tdb.c
--- a/lib/ext2fs/tdb.c	Fri Jun 15 18:05:09 2007 +0200
+++ b/lib/ext2fs/tdb.c	Sat Jun 16 19:28:50 2007 +0200
@@ -3460,8 +3460,15 @@ int tdb_append(struct tdb_context *tdb,
 	if (dbuf.dptr == NULL) {
 		dbuf.dptr = (unsigned char *)malloc(new_dbuf.dsize);
 	} else {
-		dbuf.dptr = (unsigned char *)realloc(dbuf.dptr,
-						     dbuf.dsize + new_dbuf.dsize);
+		unsigned char *new_dptr
+		  = (unsigned char *)realloc(dbuf.dptr,
+					     dbuf.dsize + new_dbuf.dsize);
+		if (new_dptr == NULL) {
+			free(dbuf.dptr);
+			dbuf.dptr = NULL;
+		} else {
+			dbuf.dptr = new_dptr;
+		}
 	}

 	if (dbuf.dptr == NULL) {

Signed-off-by: Jim Meyering <jim@meyering.net>
