From: Andreas Dilger <adilger@dilger.ca>
Subject: [PATCH] debugfs: allow do_write() to handle files over 4GB
Date: Thu, 24 Jul 2014 17:49:19 -0600
Message-ID: <1406245759-1617-1-git-send-email-adilger@dilger.ca>
Cc: linux-ext4@vger.kernel.org, Andreas Dilger <adilger@dilger.ca>
To: tytso@mit.edu
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from idcmail-mo2no.shaw.ca ([64.59.134.9]:52068 "EHLO
	idcmail-mo2no.shaw.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934850AbaGXXtV (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 24 Jul 2014 19:49:21 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Fix debugfs do_write() to correctly set i_size_high if the source
file is larger than 4GB.  Otherwise, only the low 32 bits of the
size is stored in i_size.

Signed-off-by: Andreas Dilger <adilger@dilger.ca>
---
 debugfs/debugfs.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/debugfs/debugfs.c b/debugfs/debugfs.c
index 1703aba..1184596 100644
--- a/debugfs/debugfs.c
+++ b/debugfs/debugfs.c
@@ -1719,6 +1719,8 @@ void do_write(int argc, char *argv[])
 		current_fs->now ? current_fs->now : time(0);
 	inode.i_links_count = 1;
 	inode.i_size = statbuf.st_size;
+	/* cast to (long long) to avoid shift warning if st_size is 32 bits */
+	inode.i_size_high = (long long)statbuf.st_size >> 32;
 	if (current_fs->super->s_feature_incompat &
 	    EXT3_FEATURE_INCOMPAT_EXTENTS) {
 		int i;
-- 
1.7.3.4

