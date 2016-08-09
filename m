From: Andreas Dilger <adilger@dilger.ca>
Subject: [PATCH] debugfs: use labs() for absolute value of a long
Date: Tue,  9 Aug 2016 14:44:11 -0600
Message-ID: <1470775451-69146-1-git-send-email-adilger@dilger.ca>
Cc: linux-ext4@vger.kernel.org, Andreas Dilger <adilger@dilger.ca>
To: tytso@mit.edu
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp-out-so.shaw.ca ([64.59.136.137]:36749 "EHLO
	smtp-out-so.shaw.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932324AbcHIUwV (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 9 Aug 2016 16:52:21 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Use labs() instead of abs() for calculated value of a long int
to quiet warning from LLVM.

Signed-off-by: Andreas Dilger <adilger@dilger.ca>
---
 debugfs/lsdel.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/debugfs/lsdel.c b/debugfs/lsdel.c
index e5b2d20..0d74590 100644
--- a/debugfs/lsdel.c
+++ b/debugfs/lsdel.c
@@ -133,7 +133,7 @@ void do_lsdel(int argc, char **argv)
 
 	while (ino) {
 		if ((inode.i_dtime == 0) ||
-		    (secs && ((unsigned) abs(now - secs) > inode.i_dtime)))
+		    (secs && ((unsigned)labs(now - secs) > inode.i_dtime)))
 			goto next;
 
 		lsd.inode = ino;
-- 
1.8.0

