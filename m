From: Curt Wohlgemuth <curtw@google.com>
Subject: Re: [PATCH] ext4: More buffer head reference leaks
Date: Wed, 15 Jul 2009 08:53:12 -0700
Message-ID: <6601abe90907150853m73654d6dlfbdb47eb26e7d498@mail.gmail.com>
References: <6601abe90907141358w3b16cdb0rb429f8d67d65dc9a@mail.gmail.com>
	 <20090715055227.GA17310@skywalker>
	 <6601abe90907150800m4924e35fi13dd4eea6fe7f327@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: ext4 development <linux-ext4@vger.kernel.org>
To: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp-out.google.com ([216.239.45.13]:45020 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754893AbZGOPxQ (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 15 Jul 2009 11:53:16 -0400
Received: from spaceape24.eur.corp.google.com (spaceape24.eur.corp.google.com [172.28.16.76])
	by smtp-out.google.com with ESMTP id n6FFrF4r004349
	for <linux-ext4@vger.kernel.org>; Wed, 15 Jul 2009 08:53:16 -0700
Received: from wf-out-1314.google.com (wfc28.prod.google.com [10.142.3.28])
	by spaceape24.eur.corp.google.com with ESMTP id n6FFrCwa003034
	for <linux-ext4@vger.kernel.org>; Wed, 15 Jul 2009 08:53:13 -0700
Received: by wf-out-1314.google.com with SMTP id 28so1348315wfc.28
        for <linux-ext4@vger.kernel.org>; Wed, 15 Jul 2009 08:53:12 -0700 (PDT)
In-Reply-To: <6601abe90907150800m4924e35fi13dd4eea6fe7f327@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

I've cleaned up the patch to
   - fix the comment in ext4_alloc_branch()
   - change ext4_add_entry() to remove the gotos and label


       Signed-off-by: Curt Wohlgemuth <curtw@google.com>

---
diff -Naur orig/fs/ext4/inode.c new/fs/ext4/inode.c
--- orig/fs/ext4/inode.c	2009-07-14 11:19:01.000000000 -0700
+++ new/fs/ext4/inode.c	2009-07-15 08:12:15.000000000 -0700
@@ -758,8 +758,9 @@
 		BUFFER_TRACE(bh, "call get_create_access");
 		err = ext4_journal_get_create_access(handle, bh);
 		if (err) {
+			/* Don't brelse(bh) here; it's done in
+			 * ext4_journal_forget() below */
 			unlock_buffer(bh);
-			brelse(bh);
 			goto failed;
 		}

diff -Naur orig/fs/ext4/namei.c new/fs/ext4/namei.c
--- orig/fs/ext4/namei.c	2009-07-14 11:19:46.000000000 -0700
+++ new/fs/ext4/namei.c	2009-07-15 08:12:09.000000000 -0700
@@ -1518,8 +1518,12 @@
 			return retval;

 		if (blocks == 1 && !dx_fallback &&
-		    EXT4_HAS_COMPAT_FEATURE(sb, EXT4_FEATURE_COMPAT_DIR_INDEX))
-			return make_indexed_dir(handle, dentry, inode, bh);
+		    EXT4_HAS_COMPAT_FEATURE(sb, EXT4_FEATURE_COMPAT_DIR_INDEX)) {
+			retval = make_indexed_dir(handle, dentry, inode, bh);
+			if (retval == -ENOSPC)
+				brelse(bh);
+			return retval;
+		}
 		brelse(bh);
 	}
 	bh = ext4_append(handle, dir, &block, &retval);
@@ -1528,7 +1532,10 @@
 	de = (struct ext4_dir_entry_2 *) bh->b_data;
 	de->inode = 0;
 	de->rec_len = ext4_rec_len_to_disk(blocksize, blocksize);
-	return add_dirent_to_buf(handle, dentry, inode, de, bh);
+	retval = add_dirent_to_buf(handle, dentry, inode, de, bh);
+	if (retval == -ENOSPC)
+		brelse(bh);
+	return retval;
 }

 /*
@@ -1657,7 +1664,8 @@
 	if (!de)
 		goto cleanup;
 	err = add_dirent_to_buf(handle, dentry, inode, de, bh);
-	bh = NULL;
+	if (err != -ENOSPC)
+		bh = NULL;
 	goto cleanup;

 journal_error:
