From: Dan Carpenter <error27@gmail.com>
Subject: [patch] Null dereference in ext4_ext_migrate()
Date: Tue, 3 Feb 2009 10:49:22 +0300 (EAT)
Message-ID: <alpine.DEB.2.00.0901302346430.12904@bikeee>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; format=flowed; charset=US-ASCII
Cc: linux-ext4@vger.kernel.org, tytso@mit.edu, adilger@sun.com
To: aneesh.kumar@linux.vnet.ibm.com
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from nf-out-0910.google.com ([64.233.182.186]:3814 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750821AbZBCHtv (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 3 Feb 2009 02:49:51 -0500
Received: by nf-out-0910.google.com with SMTP id d3so262547nfc.21
        for <linux-ext4@vger.kernel.org>; Mon, 02 Feb 2009 23:49:49 -0800 (PST)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

There is a potential null dereference of tmp_inode.

The patch also removes an unnecessary check for whether tmp_inode is null.

This was found through a code checker (http://repo.or.cz/w/smatch.git/). 
It looks like you might be able to trigger the error by trying to migrate 
a readonly file system.  I have only compile tested though, sorry.

regards,
dan carpenter

Signed-off-by: Dan Carpenter <error27@gmail.com>

--- orig/fs/ext4/migrate.c	2009-01-30 23:55:33.000000000 +0300
+++ devel/fs/ext4/migrate.c	2009-01-30 23:57:14.000000000 +0300
@@ -481,7 +481,7 @@
  					+ 1);
  	if (IS_ERR(handle)) {
  		retval = PTR_ERR(handle);
-		goto err_out;
+		return retval;
  	}
  	tmp_inode = ext4_new_inode(handle,
  				inode->i_sb->s_root->d_inode,
@@ -489,8 +489,7 @@
  	if (IS_ERR(tmp_inode)) {
  		retval = -ENOMEM;
  		ext4_journal_stop(handle);
-		tmp_inode = NULL;
-		goto err_out;
+		return retval;
  	}
  	i_size_write(tmp_inode, i_size_read(inode));
  	/*
@@ -618,8 +617,7 @@

  	ext4_journal_stop(handle);

-	if (tmp_inode)
-		iput(tmp_inode);
+	iput(tmp_inode);

  	return retval;
  }
