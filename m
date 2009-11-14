From: Theodore Tso <tytso@mit.edu>
Subject: Re: [PATCH] EXT4: Add missing brelse() in ext4_iget()
Date: Sat, 14 Nov 2009 08:27:45 -0500
Message-ID: <20091114132745.GB4221@mit.edu>
References: <20091107221732.GA16212@basil.fritz.box>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Andi Kleen <andi@firstfloor.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from THUNK.ORG ([69.25.196.29]:54411 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751572AbZKNN1p (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sat, 14 Nov 2009 08:27:45 -0500
Content-Disposition: inline
In-Reply-To: <20091107221732.GA16212@basil.fritz.box>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sat, Nov 07, 2009 at 11:17:32PM +0100, Andi Kleen wrote:
> EXT4: Add missing brelse() in ext4_iget()
> 
> One of the invalid error paths in ext4_iget() forgot to brelse() the inode
> buffer head. Fix that.
> 
> Found during code review.
> 
> Signed-off-by: Andi Kleen <ak@linux.intel.com>

Hi Andi, my apologies for the delay in responding; crazy travel
schedule.  I've committed a slightly better fix which cleans up the
error handling for ext4_iget(), and drops the net number of lines in
fs/ext4/inode.c by 5, and shrinks the compiled object size as well:

  31495       0      12   31507    7b13 /kbuild/ext4/fs/ext4/inode.o
  31459       0      12   31471    7aef /kbuild/ext4/fs/ext4/inode.o

							- Ted

ext4: plug a buffer_head leak in an error path of ext4_iget()

One of the invalid error paths in ext4_iget() forgot to brelse() the
inode buffer head.  Fix it by adding a brelse() in the common error
return path, which also simplifies function.

Thanks to Andi Kleen <ak@linux.intel.com> reporting the problem.

Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
---
 fs/ext4/inode.c |   11 +++--------
 1 files changed, 3 insertions(+), 8 deletions(-)

diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index 2c8caa5..554c679 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -4781,7 +4781,6 @@ struct inode *ext4_iget(struct super_block *sb, unsigned long ino)
 	struct ext4_iloc iloc;
 	struct ext4_inode *raw_inode;
 	struct ext4_inode_info *ei;
-	struct buffer_head *bh;
 	struct inode *inode;
 	long ret;
 	int block;
@@ -4793,11 +4792,11 @@ struct inode *ext4_iget(struct super_block *sb, unsigned long ino)
 		return inode;
 
 	ei = EXT4_I(inode);
+	iloc.bh = 0;
 
 	ret = __ext4_get_inode_loc(inode, &iloc, 0);
 	if (ret < 0)
 		goto bad_inode;
-	bh = iloc.bh;
 	raw_inode = ext4_raw_inode(&iloc);
 	inode->i_mode = le16_to_cpu(raw_inode->i_mode);
 	inode->i_uid = (uid_t)le16_to_cpu(raw_inode->i_uid_low);
@@ -4820,7 +4819,6 @@ struct inode *ext4_iget(struct super_block *sb, unsigned long ino)
 		if (inode->i_mode == 0 ||
 		    !(EXT4_SB(inode->i_sb)->s_mount_state & EXT4_ORPHAN_FS)) {
 			/* this inode is deleted */
-			brelse(bh);
 			ret = -ESTALE;
 			goto bad_inode;
 		}
@@ -4852,7 +4850,6 @@ struct inode *ext4_iget(struct super_block *sb, unsigned long ino)
 		ei->i_extra_isize = le16_to_cpu(raw_inode->i_extra_isize);
 		if (EXT4_GOOD_OLD_INODE_SIZE + ei->i_extra_isize >
 		    EXT4_INODE_SIZE(inode->i_sb)) {
-			brelse(bh);
 			ret = -EIO;
 			goto bad_inode;
 		}
@@ -4905,10 +4902,8 @@ struct inode *ext4_iget(struct super_block *sb, unsigned long ino)
 		/* Validate block references which are part of inode */
 		ret = ext4_check_inode_blockref(inode);
 	}
-	if (ret) {
-		brelse(bh);
+	if (ret)
 		goto bad_inode;
-	}
 
 	if (S_ISREG(inode->i_mode)) {
 		inode->i_op = &ext4_file_inode_operations;
@@ -4936,7 +4931,6 @@ struct inode *ext4_iget(struct super_block *sb, unsigned long ino)
 			init_special_inode(inode, inode->i_mode,
 			   new_decode_dev(le32_to_cpu(raw_inode->i_block[1])));
 	} else {
-		brelse(bh);
 		ret = -EIO;
 		ext4_error(inode->i_sb, __func__,
 			   "bogus i_mode (%o) for inode=%lu",
@@ -4949,6 +4943,7 @@ struct inode *ext4_iget(struct super_block *sb, unsigned long ino)
 	return inode;
 
 bad_inode:
+	brelse(iloc.bh);
 	iget_failed(inode);
 	return ERR_PTR(ret);
 }
