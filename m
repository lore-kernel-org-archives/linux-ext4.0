From: Andreas Dilger <adilger@whamcloud.com>
Subject: [PATCH] ext4: avoid setting directory i_nlink to zero
Date: Tue, 25 Oct 2011 09:33:05 -0600
Message-ID: <1319556785-34754-1-git-send-email-adilger@whamcloud.com>
Cc: linux-ext4@vger.kernel.org, Andreas Dilger <adilger@whamcloud.com>
To: tytso@mit.edu
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from idcmail-mo2no.shaw.ca ([64.59.134.9]:27880 "EHLO
	idcmail-mo2no.shaw.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752130Ab1JYPdt (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 25 Oct 2011 11:33:49 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

If a directory with more than EXT4_LINK_MAX subdirectories, the nlink
count is set to 1.  Subsequently, if any subdirectories are deleted,
ext4_dec_count() decrements the i_nlink count, which may go to 0
temporarily before being incremented back to 1.

While this is done under i_mutex, which prevents races for directory
and inode operations that check i_nlink, the temporary i_nlink == 0
case is exposed to userspace via stat() and similar calls that do not
hold i_mutex.

Instead, change the code to not decrement i_nlink count for any
directories that do not already have i_nlink larger than 2.

Reported-by: Cliff White <cliffw@whamcloud.com>
Reviewed-by: Johann Lombardi <johann@whamcloud.com>
Signed-off-by: Andreas Dilger <adilger@whamcloud.com>
---
 fs/ext4/namei.c |    5 ++---
 1 files changed, 2 insertions(+), 3 deletions(-)

diff --git a/fs/ext4/namei.c b/fs/ext4/namei.c
index 1c924fa..b13cd39 100644
--- a/fs/ext4/namei.c
+++ b/fs/ext4/namei.c
@@ -1707,9 +1707,8 @@ static void ext4_inc_count(handle_t *handle, struct inode *inode)
  */
 static void ext4_dec_count(handle_t *handle, struct inode *inode)
 {
-	drop_nlink(inode);
-	if (S_ISDIR(inode->i_mode) && inode->i_nlink == 0)
-		inc_nlink(inode);
+	if (!S_ISDIR(inode->i_mode) || inode->i_nlink > 2)
+		drop_nlink(inode);
 }
 
 
-- 
1.7.3.4

