From: Andreas Dilger <adilger@sun.com>
Subject: Re: [PATCH] Errors reported by Coverity in ext3
Date: Tue, 21 Apr 2009 05:59:00 -0600
Message-ID: <20090421115900.GQ3209@webber.adilger.int>
References: <18730dc50904120458m1649aaf7tab395436d159105a@mail.gmail.com>
 <20090413220240.GT17302@webber.adilger.int>
 <18730dc50904160230ue3cbdccqd223e0a6f2edf06e@mail.gmail.com>
 <20090420221441.GI3209@webber.adilger.int>
 <18730dc50904210201h454e9790y434e35c364dbb9d1@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7BIT
Cc: linux-ext4@vger.kernel.org
To: Amir Goldor <amir73il@users.sourceforge.net>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from sca-es-mail-1.Sun.COM ([192.18.43.132]:44049 "EHLO
	sca-es-mail-1.sun.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753158AbZDUL7P (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 21 Apr 2009 07:59:15 -0400
Received: from fe-sfbay-10.sun.com ([192.18.43.129])
	by sca-es-mail-1.sun.com (8.13.7+Sun/8.12.9) with ESMTP id n3LBxClJ022903
	for <linux-ext4@vger.kernel.org>; Tue, 21 Apr 2009 04:59:13 -0700 (PDT)
Content-disposition: inline
Received: from conversion-daemon.fe-sfbay-10.sun.com by fe-sfbay-10.sun.com
 (Sun Java(tm) System Messaging Server 7.0-5.01 64bit (built Feb 19 2009))
 id <0KIG0000092OFP00@fe-sfbay-10.sun.com> for linux-ext4@vger.kernel.org; Tue,
 21 Apr 2009 04:59:12 -0700 (PDT)
In-reply-to: <18730dc50904210201h454e9790y434e35c364dbb9d1@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Apr 21, 2009  12:01 +0300, Amir Goldor wrote:
> Attached is a new patch against kernel 2.6.29.1.
> I applied most of your corrections, see my comments inline.

Patch looks good.  Full patch included below, because it was attached
as "application/octet-stream" and might have been missed by patchworks.

Acked-by: Andreas Dilger <adilger@sun.com>

---------------------------------------------------------------------------
diff -up linux-2.6.29.1.orig/fs/ext3/namei.c linux-2.6.29.1/fs/ext3/namei.c
--- linux-2.6.29.1.orig/fs/ext3/namei.c	2009-04-21 10:44:01.000000000 +0300
+++ linux-2.6.29.1/fs/ext3/namei.c	2009-04-21 11:35:12.000000000 +0300
@@ -1627,7 +1627,7 @@ static int ext3_delete_entry (handle_t *
 			      struct buffer_head * bh)
 {
 	struct ext3_dir_entry_2 * de, * pde;
-	int i;
+	int i, err;
 
 	i = 0;
 	pde = NULL;
@@ -1637,7 +1637,9 @@ static int ext3_delete_entry (handle_t *
 			return -EIO;
 		if (de == de_del)  {
 			BUFFER_TRACE(bh, "get_write_access");
-			ext3_journal_get_write_access(handle, bh);
+			err = ext3_journal_get_write_access(handle, bh);
+			if (err)
+				return err;
 			if (pde)
 				pde->rec_len = ext3_rec_len_to_disk(
 					ext3_rec_len_from_disk(pde->rec_len) +
@@ -1784,7 +1786,15 @@ retry:
 		goto out_stop;
 	}
 	BUFFER_TRACE(dir_block, "get_write_access");
-	ext3_journal_get_write_access(handle, dir_block);
+	err = ext3_journal_get_write_access(handle, dir_block);
+	if (err) {
+		drop_nlink(inode); /* is this nlink == 0? */
+		unlock_new_inode(inode);
+		ext3_mark_inode_dirty(handle, inode);
+		iput (inode);
+		brelse (dir_block);
+		goto out_stop;
+	}
 	de = (struct ext3_dir_entry_2 *) dir_block->b_data;
 	de->inode = cpu_to_le32(inode->i_ino);
 	de->name_len = 1;
@@ -2318,6 +2328,10 @@ static int ext3_rename (struct inode * o
 		if (!new_inode && new_dir!=old_dir &&
 				new_dir->i_nlink >= EXT3_LINK_MAX)
 			goto end_rename;
+		BUFFER_TRACE(dir_bh, "get_write_access");
+		retval = ext3_journal_get_write_access(handle, dir_bh);
+		if (retval)
+			goto end_rename;
 	}
 	if (!new_bh) {
 		retval = ext3_add_entry (handle, new_dentry, old_inode);
@@ -2325,7 +2339,9 @@ static int ext3_rename (struct inode * o
 			goto end_rename;
 	} else {
 		BUFFER_TRACE(new_bh, "get write access");
-		ext3_journal_get_write_access(handle, new_bh);
+		retval = ext3_journal_get_write_access(handle, new_bh);
+		if (retval)
+			goto end_rename;
 		new_de->inode = cpu_to_le32(old_inode->i_ino);
 		if (EXT3_HAS_INCOMPAT_FEATURE(new_dir->i_sb,
 					      EXT3_FEATURE_INCOMPAT_FILETYPE))
@@ -2382,8 +2398,6 @@ static int ext3_rename (struct inode * o
 	old_dir->i_ctime = old_dir->i_mtime = CURRENT_TIME_SEC;
 	ext3_update_dx_flag(old_dir);
 	if (dir_bh) {
-		BUFFER_TRACE(dir_bh, "get_write_access");
-		ext3_journal_get_write_access(handle, dir_bh);
 		PARENT_INO(dir_bh->b_data) = cpu_to_le32(new_dir->i_ino);
 		BUFFER_TRACE(dir_bh, "call ext3_journal_dirty_metadata");
 		ext3_journal_dirty_metadata(handle, dir_bh);


Cheers, Andreas
--
Andreas Dilger
Sr. Staff Engineer, Lustre Group
Sun Microsystems of Canada, Inc.

