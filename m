From: Theodore Ts'o <tytso@mit.edu>
Subject: [PATCH,STABLE 2.6.29 06/18] ext4: Automatically allocate delay allocated blocks on close
Date: Tue,  2 Jun 2009 08:07:47 -0400
Message-ID: <1243944479-20574-6-git-send-email-tytso@mit.edu>
References: <1243944479-20574-1-git-send-email-tytso@mit.edu>
 <1243944479-20574-2-git-send-email-tytso@mit.edu>
 <1243944479-20574-3-git-send-email-tytso@mit.edu>
 <1243944479-20574-4-git-send-email-tytso@mit.edu>
 <1243944479-20574-5-git-send-email-tytso@mit.edu>
Cc: linux-ext4@vger.kernel.org, Theodore Ts'o <tytso@mit.edu>
To: stable@kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from thunk.org ([69.25.196.29]:33526 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751634AbZFBMIK (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 2 Jun 2009 08:08:10 -0400
In-Reply-To: <1243944479-20574-5-git-send-email-tytso@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

When closing a file that had been previously truncated, force any
delay allocated blocks that to be allocated so that if the filesystem
is mounted with data=ordered, the data blocks will be pushed out to
disk along with the journal commit.  Many application programs expect
this, so we do this to avoid zero length files if the system crashes
unexpectedly.

Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
(cherry picked from commit 7d8f9f7d150dded7b68e61ca6403a1f166fb4edf)
---
 fs/ext4/ext4.h  |    1 +
 fs/ext4/file.c  |    4 ++++
 fs/ext4/inode.c |    3 +++
 3 files changed, 8 insertions(+), 0 deletions(-)

diff --git a/fs/ext4/ext4.h b/fs/ext4/ext4.h
index f5552d7..83f685d 100644
--- a/fs/ext4/ext4.h
+++ b/fs/ext4/ext4.h
@@ -279,6 +279,7 @@ static inline __u32 ext4_mask_flags(umode_t mode, __u32 flags)
 #define EXT4_STATE_NEW			0x00000002 /* inode is newly created */
 #define EXT4_STATE_XATTR		0x00000004 /* has in-inode xattrs */
 #define EXT4_STATE_NO_EXPAND		0x00000008 /* No space for expansion */
+#define EXT4_STATE_DA_ALLOC_CLOSE	0x00000010 /* Alloc DA blks on close */
 
 /* Used to pass group descriptor data when online resize is done */
 struct ext4_new_group_input {
diff --git a/fs/ext4/file.c b/fs/ext4/file.c
index f731cb5..06df827 100644
--- a/fs/ext4/file.c
+++ b/fs/ext4/file.c
@@ -33,6 +33,10 @@
  */
 static int ext4_release_file(struct inode *inode, struct file *filp)
 {
+	if (EXT4_I(inode)->i_state & EXT4_STATE_DA_ALLOC_CLOSE) {
+		ext4_alloc_da_blocks(inode);
+		EXT4_I(inode)->i_state &= ~EXT4_STATE_DA_ALLOC_CLOSE;
+	}
 	/* if we are the last writer on the inode, drop the block reservation */
 	if ((filp->f_mode & FMODE_WRITE) &&
 			(atomic_read(&inode->i_writecount) == 1))
diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index 0c93ce0..8c7259a 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -3880,6 +3880,9 @@ void ext4_truncate(struct inode *inode)
 	if (!ext4_can_truncate(inode))
 		return;
 
+	if (inode->i_size == 0)
+		ei->i_state |= EXT4_STATE_DA_ALLOC_CLOSE;
+
 	if (EXT4_I(inode)->i_flags & EXT4_EXTENTS_FL) {
 		ext4_ext_truncate(inode);
 		return;
-- 
1.6.3.1.1.g75fc.dirty

