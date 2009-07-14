From: Curt Wohlgemuth <curtw@google.com>
Subject: [PATCH] ext4: More buffer head reference leaks
Date: Tue, 14 Jul 2009 13:58:29 -0700
Message-ID: <6601abe90907141358w3b16cdb0rb429f8d67d65dc9a@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
To: ext4 development <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp-out.google.com ([216.239.45.13]:38674 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753609AbZGNU6c (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 14 Jul 2009 16:58:32 -0400
Received: from zps77.corp.google.com (zps77.corp.google.com [172.25.146.77])
	by smtp-out.google.com with ESMTP id n6EKwWco020136
	for <linux-ext4@vger.kernel.org>; Tue, 14 Jul 2009 13:58:32 -0700
Received: from pzk9 (pzk9.prod.google.com [10.243.19.137])
	by zps77.corp.google.com with ESMTP id n6EKw25q029195
	for <linux-ext4@vger.kernel.org>; Tue, 14 Jul 2009 13:58:30 -0700
Received: by pzk9 with SMTP id 9so2666129pzk.21
        for <linux-ext4@vger.kernel.org>; Tue, 14 Jul 2009 13:58:29 -0700 (PDT)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

After the patch I posted last week regarding buffer head ref leaks in
no-journal mode, I looked at all the code that uses buffer heads and
searched for more potential leaks.

The patch below fixes the issues I found; these can occur even when a
journal is present.

The change to inode.c fixes a double release if
ext4_journal_get_create_access() fails.

The changes to namei.c are more complicated.  add_dirent_to_buf() will
release the input buffer head EXCEPT when it returns -ENOSPC.  There are
some callers of this routine that don't always do the brelse() in the event
that -ENOSPC is returned.  Unfortunately, to put this fix into ext4_add_entry()
required capturing the return value of make_indexed_dir() and
add_dirent_to_buf().

I'd appreciate comments on these changes, in particular if I'm just missing
something obvious here.

       Signed-off-by: Curt Wohlgemuth <curtw@google.com>

---
diff -Naur orig/fs/ext4/inode.c new/fs/ext4/inode.c
--- orig/fs/ext4/inode.c	2009-07-14 11:19:01.000000000 -0700
+++ new/fs/ext4/inode.c	2009-07-14 11:51:42.000000000 -0700
@@ -758,8 +758,9 @@
 		BUFFER_TRACE(bh, "call get_create_access");
 		err = ext4_journal_get_create_access(handle, bh);
 		if (err) {
+			/* Don't brelse(bh) here; it's done in journal_forget()
+			 * below */
 			unlock_buffer(bh);
-			brelse(bh);
 			goto failed;
 		}

diff -Naur orig/fs/ext4/namei.c new/fs/ext4/namei.c
--- orig/fs/ext4/namei.c	2009-07-14 11:19:46.000000000 -0700
+++ new/fs/ext4/namei.c	2009-07-14 11:19:28.000000000 -0700
@@ -1498,12 +1498,14 @@

 	sb = dir->i_sb;
 	blocksize = sb->s_blocksize;
-	if (!dentry->d_name.len)
-		return -EINVAL;
+	if (!dentry->d_name.len) {
+		retval = -EINVAL;
+		goto out;
+	}
 	if (is_dx(dir)) {
 		retval = ext4_dx_add_entry(handle, dentry, inode);
 		if (!retval || (retval != ERR_BAD_DX_DIR))
-			return retval;
+			goto out;
 		EXT4_I(dir)->i_flags &= ~EXT4_INDEX_FL;
 		dx_fallback++;
 		ext4_mark_inode_dirty(handle, dir);
@@ -1512,23 +1514,31 @@
 	for (block = 0; block < blocks; block++) {
 		bh = ext4_bread(handle, dir, block, 0, &retval);
 		if(!bh)
-			return retval;
+			goto out;
 		retval = add_dirent_to_buf(handle, dentry, inode, NULL, bh);
 		if (retval != -ENOSPC)
-			return retval;
+			goto out;

 		if (blocks == 1 && !dx_fallback &&
-		    EXT4_HAS_COMPAT_FEATURE(sb, EXT4_FEATURE_COMPAT_DIR_INDEX))
-			return make_indexed_dir(handle, dentry, inode, bh);
+		    EXT4_HAS_COMPAT_FEATURE(sb, EXT4_FEATURE_COMPAT_DIR_INDEX)) {
+			retval = make_indexed_dir(handle, dentry, inode, bh);
+			if (retval == -ENOSPC)
+				brelse(bh);
+			goto out;
+		}
 		brelse(bh);
 	}
 	bh = ext4_append(handle, dir, &block, &retval);
 	if (!bh)
-		return retval;
+		goto out;
 	de = (struct ext4_dir_entry_2 *) bh->b_data;
 	de->inode = 0;
 	de->rec_len = ext4_rec_len_to_disk(blocksize, blocksize);
-	return add_dirent_to_buf(handle, dentry, inode, de, bh);
+	retval = add_dirent_to_buf(handle, dentry, inode, de, bh);
+	if (retval == -ENOSPC)
+		brelse(bh);
+out:
+	return retval;
 }

 /*
@@ -1657,7 +1667,8 @@
 	if (!de)
 		goto cleanup;
 	err = add_dirent_to_buf(handle, dentry, inode, de, bh);
-	bh = NULL;
+	if (err != -ENOSPC)
+		bh = NULL;
 	goto cleanup;

 journal_error:
