From: Tobias Klauser <tklauser@distanz.ch>
Subject: [PATCH] ext2: Remove redundant unlikely()
Date: Thu,  9 Dec 2010 15:39:00 +0100
Message-ID: <1291905540-32296-1-git-send-email-tklauser@distanz.ch>
Cc: kernel-janitors@vger.kernel.org
To: Jan Kara <jack@suse.cz>, linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.zhaw.ch ([160.85.104.50]:62603 "EHLO mx1.zhaw.ch"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754444Ab0LIOsV (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 9 Dec 2010 09:48:21 -0500
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

IS_ERR() already implies unlikely(), so it can be omitted here.

Signed-off-by: Tobias Klauser <tklauser@distanz.ch>
---
 fs/ext2/namei.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/fs/ext2/namei.c b/fs/ext2/namei.c
index f8aecd2..2e1d834 100644
--- a/fs/ext2/namei.c
+++ b/fs/ext2/namei.c
@@ -67,7 +67,7 @@ static struct dentry *ext2_lookup(struct inode * dir, struct dentry *dentry, str
 	inode = NULL;
 	if (ino) {
 		inode = ext2_iget(dir->i_sb, ino);
-		if (unlikely(IS_ERR(inode))) {
+		if (IS_ERR(inode)) {
 			if (PTR_ERR(inode) == -ESTALE) {
 				ext2_error(dir->i_sb, __func__,
 						"deleted inode referenced: %lu",
-- 
1.7.0.4

