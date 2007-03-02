From: Andreas Dilger <adilger@clusterfs.com>
Subject: Re: [PATCH][RFC] ext3: Handle ext[34]_journal_stop() failure
Date: Fri, 2 Mar 2007 17:06:16 +0800
Message-ID: <20070302090616.GO6573@schatzie.adilger.int>
References: <871wka2pt4.fsf@sw.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Dmitriy Monakhov <dmonakhov@sw.ru>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.clusterfs.com ([206.168.112.78]:46269 "EHLO
	mail.clusterfs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933104AbXCBJGZ (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 2 Mar 2007 04:06:25 -0500
Content-Disposition: inline
In-Reply-To: <871wka2pt4.fsf@sw.ru>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Feb 28, 2007  19:46 +0300, Dmitriy Monakhov wrote:
> Where are many places where xxxx_journal_stop() return code wasn't
> checked. Off cause xxxx_journal_stop() failed very rarely (and usually
> with fatal consequences), but this does'n meen it should not be checked.

I fully agree with this.  Otherwise an application will believe that the
operation has succeeded when in fact the filesystem has failed.  It would
notice this on the next filesystem operation, but that might be too late
for e.g. an MTA that just confirmed acceptance of an email.

There are also several places in the code where we don't check error
returns from ext3_journal_get_write_access().  I have a patch that I
was starting to work on but never managed to finish/test.  I'd be
happy if you had time to finish it off.

================= ext3-check-jbd-errors-2.6.20.patch =================
--- ./fs/ext3/namei.c.orig	2007-02-08 08:10:20.000000000 +0800
+++ ./fs/ext3/namei.c	2007-02-17 07:56:16.000000000 +0800
@@ -59,9 +59,14 @@ static struct buffer_head *ext3_append(h
 	*block = inode->i_size >> inode->i_sb->s_blocksize_bits;
 
 	if ((bh = ext3_bread(handle, inode, *block, 1, err))) {
-		inode->i_size += inode->i_sb->s_blocksize;
-		EXT3_I(inode)->i_disksize = inode->i_size;
-		ext3_journal_get_write_access(handle,bh);
+		*err = ext3_journal_get_write_access(handle,bh);
+		if (err) {
+			brelse(bh);
+			bh = NULL;
+		} else {
+			inode->i_size += inode->i_sb->s_blocksize;
+			EXT3_I(inode)->i_disksize = inode->i_size;
+		}
 	}
 	return bh;
 }
@@ -1597,8 +1602,12 @@ static int ext3_delete_entry (handle_t *
 		if (!ext3_check_dir_entry("ext3_delete_entry", dir, de, bh, i))
 			return -EIO;
 		if (de == de_del)  {
+			int err;
+
 			BUFFER_TRACE(bh, "get_write_access");
-			ext3_journal_get_write_access(handle, bh);
+			err = ext3_journal_get_write_access(handle, bh);
+			if (err)
+				return err;
 			if (pde)
 				pde->rec_len =
 					cpu_to_le16(le16_to_cpu(pde->rec_len) +
@@ -1758,7 +1767,13 @@ retry:
 		goto out_stop;
 	}
 	BUFFER_TRACE(dir_block, "get_write_access");
-	ext3_journal_get_write_access(handle, dir_block);
+	err = ext3_journal_get_write_access(handle, dir_block);
+	if (err) {
+		drop_nlink(inode); /* is this nlink == 0? */
+		ext3_mark_inode_dirty(handle, inode);
+		iput (inode);
+		goto out_stop;
+	}
 	de = (struct ext3_dir_entry_2 *) dir_block->b_data;
 	de->inode = cpu_to_le32(inode->i_ino);
 	de->name_len = 1;
@@ -2262,6 +2277,11 @@ static int ext3_rename (struct inode * o
 		if (!new_inode) {
 			brelse (new_bh);
 			new_bh = NULL;
+		} else {
+			BUFFER_TRACE(new_bh, "get write access");
+			retval = ext3_journal_get_write_access(handle, new_bh);
+			if (retval)
+				goto end_rename;
 		}
 	}
 	if (S_ISDIR(old_inode->i_mode)) {
@@ -2280,14 +2300,16 @@ static int ext3_rename (struct inode * o
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
 		if (retval)
 			goto end_rename;
 	} else {
-		BUFFER_TRACE(new_bh, "get write access");
-		ext3_journal_get_write_access(handle, new_bh);
 		new_de->inode = cpu_to_le32(old_inode->i_ino);
 		if (EXT3_HAS_INCOMPAT_FEATURE(new_dir->i_sb,
 					      EXT3_FEATURE_INCOMPAT_FILETYPE))
@@ -2341,8 +2363,6 @@ static int ext3_rename (struct inode * o
 	old_dir->i_ctime = old_dir->i_mtime = CURRENT_TIME_SEC;
 	ext3_update_dx_flag(old_dir);
 	if (dir_bh) {
-		BUFFER_TRACE(dir_bh, "get_write_access");
-		ext3_journal_get_write_access(handle, dir_bh);
 		PARENT_INO(dir_bh->b_data) = cpu_to_le32(new_dir->i_ino);
 		BUFFER_TRACE(dir_bh, "call ext3_journal_dirty_metadata");
 		ext3_journal_dirty_metadata(handle, dir_bh);
==============================================================================

Cheers, Andreas
--
Andreas Dilger
Principal Software Engineer
Cluster File Systems, Inc.
