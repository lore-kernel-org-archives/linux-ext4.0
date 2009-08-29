From: Theodore Ts'o <tytso@mit.edu>
Subject: [PATCH] ext4: Limit number of links that can be created by ext4_link()
Date: Fri, 28 Aug 2009 21:53:40 -0400
Message-ID: <1251510820-20528-1-git-send-email-tytso@mit.edu>
Cc: Theodore Ts'o <tytso@mit.edu>
To: Ext4 Developers List <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from thunk.org ([69.25.196.29]:43722 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750799AbZH2Bxj (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 28 Aug 2009 21:53:39 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

In ext4_link we need to check using EXT4_LINK_MAX, and not
EXT4_DIR_LINK_MAX(), since ext4_link() is creating hard links of
regular files, and not directories.

Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
---
 fs/ext4/namei.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/fs/ext4/namei.c b/fs/ext4/namei.c
index 3692ba6..f92cc06 100644
--- a/fs/ext4/namei.c
+++ b/fs/ext4/namei.c
@@ -2318,7 +2318,7 @@ static int ext4_link(struct dentry *old_dentry,
 	struct inode *inode = old_dentry->d_inode;
 	int err, retries = 0;
 
-	if (EXT4_DIR_LINK_MAX(inode))
+	if (inode->i_nlink >= EXT4_LINK_MAX)
 		return -EMLINK;
 
 	/*
-- 
1.6.3.2.1.gb9f7d.dirty

