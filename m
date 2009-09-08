From: Theodore Ts'o <tytso@mit.edu>
Subject: [PATCH] ext4: print more sysadmin-friendly message in check_block_validity()
Date: Tue,  8 Sep 2009 08:22:42 -0400
Message-ID: <1252412562-738-1-git-send-email-tytso@mit.edu>
References: <4AA645F0.8050903@linux.vnet.ibm.com>
Cc: Nageswara R Sastry <rnsastry@linux.vnet.ibm.com>,
	Theodore Ts'o <tytso@mit.edu>
To: Ext4 Developers List <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from THUNK.ORG ([69.25.196.29]:46884 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751050AbZIHMWo (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 8 Sep 2009 08:22:44 -0400
In-Reply-To: <4AA645F0.8050903@linux.vnet.ibm.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Drop the WARN_ON(1), as he stack trace is not appropriate, since it is
triggered by file system corruption, and it misleads users into
thinking there is a kernel bug.  In addition, change the message
displayed by ext4_error() to make it clear that this is a file system
corruption problem.

Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
---
 fs/ext4/inode.c |   16 ++++++++--------
 1 files changed, 8 insertions(+), 8 deletions(-)

diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index 3400961..4d3fd0e 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -1121,16 +1121,15 @@ static void ext4_da_update_reserve_space(struct inode *inode, int used)
 		ext4_discard_preallocations(inode);
 }
 
-static int check_block_validity(struct inode *inode, sector_t logical,
-				sector_t phys, int len)
+static int check_block_validity(struct inode *inode, const char *msg,
+				sector_t logical, sector_t phys, int len)
 {
 	if (!ext4_data_block_valid(EXT4_SB(inode->i_sb), phys, len)) {
-		ext4_error(inode->i_sb, "check_block_validity",
+		ext4_error(inode->i_sb, msg,
 			   "inode #%lu logical block %llu mapped to %llu "
 			   "(size %d)", inode->i_ino,
 			   (unsigned long long) logical,
 			   (unsigned long long) phys, len);
-		WARN_ON(1);
 		return -EIO;
 	}
 	return 0;
@@ -1182,8 +1181,8 @@ int ext4_get_blocks(handle_t *handle, struct inode *inode, sector_t block,
 	up_read((&EXT4_I(inode)->i_data_sem));
 
 	if (retval > 0 && buffer_mapped(bh)) {
-		int ret = check_block_validity(inode, block,
-					       bh->b_blocknr, retval);
+		int ret = check_block_validity(inode, "file system corruption",
+					       block, bh->b_blocknr, retval);
 		if (ret != 0)
 			return ret;
 	}
@@ -1264,8 +1263,9 @@ int ext4_get_blocks(handle_t *handle, struct inode *inode, sector_t block,
 
 	up_write((&EXT4_I(inode)->i_data_sem));
 	if (retval > 0 && buffer_mapped(bh)) {
-		int ret = check_block_validity(inode, block,
-					       bh->b_blocknr, retval);
+		int ret = check_block_validity(inode, "file system "
+					       "corruption after allocation",
+					       block, bh->b_blocknr, retval);
 		if (ret != 0)
 			return ret;
 	}
-- 
1.6.3.2.1.gb9f7d.dirty

