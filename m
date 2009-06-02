From: Theodore Ts'o <tytso@mit.edu>
Subject: [PATCH,STABLE 2.6.27 13/24] ext4: Fix discard of inode prealloc space with delayed allocation.
Date: Tue,  2 Jun 2009 08:09:25 -0400
Message-ID: <1243944576-20915-13-git-send-email-tytso@mit.edu>
References: <1243944576-20915-1-git-send-email-tytso@mit.edu>
 <1243944576-20915-2-git-send-email-tytso@mit.edu>
 <1243944576-20915-3-git-send-email-tytso@mit.edu>
 <1243944576-20915-4-git-send-email-tytso@mit.edu>
 <1243944576-20915-5-git-send-email-tytso@mit.edu>
 <1243944576-20915-6-git-send-email-tytso@mit.edu>
 <1243944576-20915-7-git-send-email-tytso@mit.edu>
 <1243944576-20915-8-git-send-email-tytso@mit.edu>
 <1243944576-20915-9-git-send-email-tytso@mit.edu>
 <1243944576-20915-10-git-send-email-tytso@mit.edu>
 <1243944576-20915-11-git-send-email-tytso@mit.edu>
 <1243944576-20915-12-git-send-email-tytso@mit.edu>
Cc: linux-ext4@vger.kernel.org,
	"Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>,
	"Theodore Ts'o" <tytso@mit.edu>
To: stable@kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from thunk.org ([69.25.196.29]:59270 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752044AbZFBMJq (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 2 Jun 2009 08:09:46 -0400
In-Reply-To: <1243944576-20915-12-git-send-email-tytso@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

From: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>

With delayed allocation we should not/cannot discard inode prealloc
space during file close. We would still have dirty pages for which we
haven't allocated blocks yet. With this fix after each get_blocks
request we check whether we have zero reserved blocks and if yes and
we don't have any writers on the file we discard inode prealloc space.

Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
(cherry picked from commit d6014301b5599fba395c42a1e96a7fe86f7d0b2d)
---
 fs/ext4/file.c  |    3 ++-
 fs/ext4/inode.c |    8 ++++++++
 2 files changed, 10 insertions(+), 1 deletions(-)

diff --git a/fs/ext4/file.c b/fs/ext4/file.c
index b080072..c0d02f8 100644
--- a/fs/ext4/file.c
+++ b/fs/ext4/file.c
@@ -39,7 +39,8 @@ static int ext4_release_file (struct inode * inode, struct file * filp)
 	}
 	/* if we are the last writer on the inode, drop the block reservation */
 	if ((filp->f_mode & FMODE_WRITE) &&
-			(atomic_read(&inode->i_writecount) == 1))
+			(atomic_read(&inode->i_writecount) == 1) &&
+		        !EXT4_I(inode)->i_reserved_data_blocks)
 	{
 		down_write(&EXT4_I(inode)->i_data_sem);
 		ext4_discard_reservation(inode);
diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index a2586b0..1c79655 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -1046,6 +1046,14 @@ static void ext4_da_update_reserve_space(struct inode *inode, int used)
 	EXT4_I(inode)->i_reserved_meta_blocks = mdb;
 	EXT4_I(inode)->i_allocated_meta_blocks = 0;
 	spin_unlock(&EXT4_I(inode)->i_block_reservation_lock);
+
+	/*
+	 * If we have done all the pending block allocations and if
+	 * there aren't any writers on the inode, we can discard the
+	 * inode's preallocations.
+	 */
+	if (!total && (atomic_read(&inode->i_writecount) == 0))
+		ext4_discard_reservation(inode);
 }
 
 /*
-- 
1.6.3.1.1.g75fc.dirty

