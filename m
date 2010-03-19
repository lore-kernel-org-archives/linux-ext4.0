From: Theodore Ts'o <tytso@mit.edu>
Subject: [PATCH, RFC 1/3] ext4: Convert calls of ext4_error() to EXT4_ERROR_INODE()
Date: Thu, 18 Mar 2010 20:50:40 -0400
Message-ID: <1268959842-4697-1-git-send-email-tytso@mit.edu>
Cc: Theodore Ts'o <tytso@mit.edu>
To: Ext4 Developers List <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from thunk.org ([69.25.196.29]:34404 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751808Ab0CSAvH (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 18 Mar 2010 20:51:07 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

EXT4_ERROR_INODE() tends to provide better error information and in a
more consistent format.

Addresses-Google-Bug: #2507977

Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
---

Yes, there are more calls to ext4_error that we probably want to convert
to use ext4_error_inode; this is just for illustrative purposes, and
because it's the one which is most obnoxious if there is a bad entry in
a particular inode which is referenced over and over again (see patch 3
in this series).

 fs/ext4/namei.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/fs/ext4/namei.c b/fs/ext4/namei.c
index 0c070fa..0c0cba4 100644
--- a/fs/ext4/namei.c
+++ b/fs/ext4/namei.c
@@ -1072,9 +1072,9 @@ static struct dentry *ext4_lookup(struct inode *dir, struct dentry *dentry, stru
 		inode = ext4_iget(dir->i_sb, ino);
 		if (unlikely(IS_ERR(inode))) {
 			if (PTR_ERR(inode) == -ESTALE) {
-				ext4_error(dir->i_sb,
-						"deleted inode referenced: %u",
-						ino);
+				EXT4_ERROR_INODE(dir,
+						 "deleted inode referenced: %u",
+						 ino);
 				return ERR_PTR(-EIO);
 			} else {
 				return ERR_CAST(inode);
-- 
1.6.6.1.1.g974db.dirty

