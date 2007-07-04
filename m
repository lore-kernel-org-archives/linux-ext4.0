From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: Re: [EXT4 set 4][PATCH 4/5] i_version:ext4 inode version update
Date: Wed, 04 Jul 2007 10:56:26 +0530
Message-ID: <468B2F82.6000808@linux.vnet.ibm.com>
References: <1183275465.4010.130.camel@localhost.localdomain> <4689F2D2.7020809@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: cmm@us.ibm.com, linux-ext4@vger.kernel.org
To: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from ausmtp05.au.ibm.com ([202.81.18.154]:51928 "EHLO
	ausmtp05.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751959AbXGDF1O (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 4 Jul 2007 01:27:14 -0400
Received: from sd0208e0.au.ibm.com (d23rh904.au.ibm.com [202.81.18.202])
	by ausmtp05.au.ibm.com (8.13.8/8.13.8) with ESMTP id l645S1wH2502838
	for <linux-ext4@vger.kernel.org>; Wed, 4 Jul 2007 15:28:10 +1000
Received: from d23av02.au.ibm.com (d23av02.au.ibm.com [9.190.250.243])
	by sd0208e0.au.ibm.com (8.13.8/8.13.8/NCO v8.3) with ESMTP id l645U6tk230208
	for <linux-ext4@vger.kernel.org>; Wed, 4 Jul 2007 15:30:07 +1000
Received: from d23av02.au.ibm.com (loopback [127.0.0.1])
	by d23av02.au.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id l645QVQi013638
	for <linux-ext4@vger.kernel.org>; Wed, 4 Jul 2007 15:26:32 +1000
In-Reply-To: <4689F2D2.7020809@linux.vnet.ibm.com>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org



Aneesh Kumar K.V wrote:

> 
> If we bump i_version  in ext4_mark_iloc_dity then we should be removing 
> the i_version update
> at other places. A simple grep of ext4 dir shows i_version being updated 
> followed by ext4_mark_inode_dirty.
> 
> 

How about the below patch. I also removed the i_version = 1 from 
ext4_new_inode because we do the same in ext4_alloc_inode. I also added
the From:  line. 

-aneesh

>From ccdfc4a6a8edbdbf5d21d32fd2350f36399a89f8 Mon Sep 17 00:00:00 2001
From: Jean Noel Cordenner <jean-noel.cordenner@bull.net>
Date: Wed, 4 Jul 2007 10:51:50 +0530
Subject: [PATCH] This patch is on top of i_version_update_vfs.
 The i_version field of the inode is set on inode creation and incremented when
 the inode is being modified.

Signed-off-by: Jean Noel Cordenner <jean-noel.cordenner@bull.net>
Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
Signed-off-by: Mingming Cao <cmm@us.ibm.com>
---
 fs/ext4/inode.c |    1 +
 fs/ext4/namei.c |    4 ----
 fs/ext4/super.c |    1 -
 3 files changed, 1 insertions(+), 5 deletions(-)

diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index cb9f1f4..cd3e886 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -3084,6 +3084,7 @@ int ext4_mark_iloc_dirty(handle_t *handle,
 {
 	int err = 0;
 
+	inode->i_version++;
 	/* the do_update_inode consumes one bh->b_count */
 	get_bh(iloc->bh);
 
diff --git a/fs/ext4/namei.c b/fs/ext4/namei.c
index 477b6d2..a1dc5ef 100644
--- a/fs/ext4/namei.c
+++ b/fs/ext4/namei.c
@@ -1287,7 +1287,6 @@ static int add_dirent_to_buf(handle_t *handle, struct dentry *dentry,
 	 */
 	dir->i_mtime = dir->i_ctime = ext4_current_time(dir);
 	ext4_update_dx_flag(dir);
-	dir->i_version++;
 	ext4_mark_inode_dirty(handle, dir);
 	BUFFER_TRACE(bh, "call ext4_journal_dirty_metadata");
 	err = ext4_journal_dirty_metadata(handle, bh);
@@ -1606,7 +1605,6 @@ static int ext4_delete_entry (handle_t *handle,
 						    le16_to_cpu(de->rec_len));
 			else
 				de->inode = 0;
-			dir->i_version++;
 			BUFFER_TRACE(bh, "call ext4_journal_dirty_metadata");
 			ext4_journal_dirty_metadata(handle, bh);
 			return 0;
@@ -2039,7 +2037,6 @@ static int ext4_rmdir (struct inode * dir, struct dentry *dentry)
 		ext4_warning (inode->i_sb, "ext4_rmdir",
 			      "empty directory has nlink!=2 (%d)",
 			      inode->i_nlink);
-	inode->i_version++;
 	clear_nlink(inode);
 	/* There's no need to set i_disksize: the fact that i_nlink is
 	 * zero will ensure that the right thing happens during any
@@ -2284,7 +2281,6 @@ static int ext4_rename (struct inode * old_dir, struct dentry *old_dentry,
 		if (EXT4_HAS_INCOMPAT_FEATURE(new_dir->i_sb,
 					      EXT4_FEATURE_INCOMPAT_FILETYPE))
 			new_de->file_type = old_de->file_type;
-		new_dir->i_version++;
 		BUFFER_TRACE(new_bh, "call ext4_journal_dirty_metadata");
 		ext4_journal_dirty_metadata(handle, new_bh);
 		brelse(new_bh);
diff --git a/fs/ext4/super.c b/fs/ext4/super.c
index 914c273..55b99b3 100644
--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -2846,7 +2846,6 @@ out:
 		i_size_write(inode, off+len-towrite);
 		EXT4_I(inode)->i_disksize = inode->i_size;
 	}
-	inode->i_version++;
 	inode->i_mtime = inode->i_ctime = CURRENT_TIME;
 	ext4_mark_inode_dirty(handle, inode);
 	mutex_unlock(&inode->i_mutex);
-- 
1.5.3.rc0-dirty
