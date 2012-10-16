From: Adil Mujeeb <mujeeb.adil@gmail.com>
Subject: [PATCH 05/10] ext4: file: Fixed coding style issue
Date: Wed, 17 Oct 2012 00:43:00 +0530
Message-ID: <1350414785-7848-5-git-send-email-mujeeb.adil@gmail.com>
References: <1350414785-7848-1-git-send-email-mujeeb.adil@gmail.com>
Cc: Adil Mujeeb <mujeeb.adil@gmail.com>
To: tytso@mit.edu, adilger.kernel@dilger.ca,
	linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1350414785-7848-1-git-send-email-mujeeb.adil@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Removed errors reported by checkpatch.pl

Signed-off-by: Adil Mujeeb <mujeeb.adil@gmail.com>
---
 linux-3.7-rc1/fs/ext4/file.c |    5 ++---
 1 files changed, 2 insertions(+), 3 deletions(-)

diff --git a/linux-3.7-rc1/fs/ext4/file.c b/linux-3.7-rc1/fs/ext4/file.c
index bf3966b..17068a7 100644
--- a/linux-3.7-rc1/fs/ext4/file.c
+++ b/linux-3.7-rc1/fs/ext4/file.c
@@ -43,8 +43,7 @@ static int ext4_release_file(struct inode *inode, struct file *filp)
 	/* if we are the last writer on the inode, drop the block reservation */
 	if ((filp->f_mode & FMODE_WRITE) &&
 			(atomic_read(&inode->i_writecount) == 1) &&
-		        !EXT4_I(inode)->i_reserved_data_blocks)
-	{
+			!EXT4_I(inode)->i_reserved_data_blocks) {
 		down_write(&EXT4_I(inode)->i_data_sem);
 		ext4_discard_preallocations(inode);
 		up_write(&EXT4_I(inode)->i_data_sem);
@@ -221,7 +220,7 @@ static int ext4_file_mmap(struct file *file, struct vm_area_struct *vma)
 	return 0;
 }
 
-static int ext4_file_open(struct inode * inode, struct file * filp)
+static int ext4_file_open(struct inode *inode, struct file *filp)
 {
 	struct super_block *sb = inode->i_sb;
 	struct ext4_sb_info *sbi = EXT4_SB(inode->i_sb);
-- 
1.7.7.3
