From: Tobias Klauser <tklauser@distanz.ch>
Subject: [PATCH] ext4: Remove redundant unlikely()
Date: Thu,  9 Dec 2010 15:40:38 +0100
Message-ID: <1291905638-32410-1-git-send-email-tklauser@distanz.ch>
Cc: kernel-janitors@vger.kernel.org
To: "Theodore Ts'o" <tytso@mit.edu>,
	Andreas Dilger <adilger.kernel@dilger.ca>,
	linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.zhaw.ch ([160.85.104.50]:62602 "EHLO mx1.zhaw.ch"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755188Ab0LIOsV (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 9 Dec 2010 09:48:21 -0500
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

IS_ERR() already implies unlikely(), so it can be omitted here.

Signed-off-by: Tobias Klauser <tklauser@distanz.ch>
---
 fs/ext4/namei.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/fs/ext4/namei.c b/fs/ext4/namei.c
index 92203b8..cec88ce 100644
--- a/fs/ext4/namei.c
+++ b/fs/ext4/namei.c
@@ -1036,7 +1036,7 @@ static struct dentry *ext4_lookup(struct inode *dir, struct dentry *dentry, stru
 			return ERR_PTR(-EIO);
 		}
 		inode = ext4_iget(dir->i_sb, ino);
-		if (unlikely(IS_ERR(inode))) {
+		if (IS_ERR(inode)) {
 			if (PTR_ERR(inode) == -ESTALE) {
 				EXT4_ERROR_INODE(dir,
 						 "deleted inode referenced: %u",
-- 
1.7.0.4

