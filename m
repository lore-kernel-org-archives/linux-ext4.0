From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: [PATCH 16/24] e2fsck: don't crash during rehash
Date: Fri, 18 Jul 2014 15:54:15 -0700
Message-ID: <20140718225415.31374.89196.stgit@birch.djwong.org>
References: <20140718225200.31374.85411.stgit@birch.djwong.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org
To: tytso@mit.edu, darrick.wong@oracle.com
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:33309 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1946059AbaGRWyV (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 18 Jul 2014 18:54:21 -0400
In-Reply-To: <20140718225200.31374.85411.stgit@birch.djwong.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

If a user crafts a carefully constructed filesystem containing a
single directory entry block with an invalid checksum and fewer than
two entries, and then runs e2fsck to fix the filesystem, fsck will
crash when it tries to "compress" the short dir and passes a negative
dirent array length to qsort.  Therefore, don't allow directory
"compression" in this situation.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 e2fsck/rehash.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)


diff --git a/e2fsck/rehash.c b/e2fsck/rehash.c
index f75479a..5913ae7 100644
--- a/e2fsck/rehash.c
+++ b/e2fsck/rehash.c
@@ -848,7 +848,7 @@ retry_nohash:
 
 	/* Sort the list */
 resort:
-	if (fd.compress)
+	if (fd.compress && fd.num_array > 1)
 		qsort(fd.harray+2, fd.num_array-2, sizeof(struct hash_entry),
 		      hash_cmp);
 	else
@@ -867,7 +867,7 @@ resort:
 	}
 
 	/* Sort non-hashed directories by inode number */
-	if (fd.compress)
+	if (fd.compress && fd.num_array > 1)
 		qsort(fd.harray+2, fd.num_array-2,
 		      sizeof(struct hash_entry), ino_cmp);
 

