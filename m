From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH] ext4: fix reading new encrypted symlinks on no-journal
 filesystems
Date: Thu, 1 Dec 2016 14:27:05 -0500
Message-ID: <20161201192705.nys7rs2py5q342ju@thunk.org>
References: <1479318627-143193-1-git-send-email-ebiggers@google.com>
 <2FD4E662-B708-4C34-B1FC-8D42083322A2@dilger.ca>
 <20161118184704.GA73496@google.com>
 <75C88E0E-FF89-4D20-B11C-8F705E249BDD@dilger.ca>
 <20161121231924.GG30672@google.com>
 <4CB8CE8B-8AFE-4266-9983-4B2555702EF3@dilger.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Eric Biggers <ebiggers@google.com>,
        linux-ext4 <linux-ext4@vger.kernel.org>
To: Andreas Dilger <adilger@dilger.ca>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:54252 "EHLO imap.thunk.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1758685AbcLAT1H (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Thu, 1 Dec 2016 14:27:07 -0500
Content-Disposition: inline
In-Reply-To: <4CB8CE8B-8AFE-4266-9983-4B2555702EF3@dilger.ca>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

So in the long term I think we can move to using i_size to determine
fast symlinks, but I think there's a bigger issue hiding here, which
is that we shouldn't be using delayed allocation for symlinks in the
first place.  In the first place, symlinks will never be more than a
block, so there's no advantage in using delalloc.  In the second
place, it means that on a crash the symlink could invalid (zero
length) --- and on a commit the symlink should be commited to disk.

Eric, do you have a test case which verifies this?  Normally I would
think this rarely happens because the dentry cache should hide this
particular issue.  I think a simpler fix up, which also avoids the
"symlink could be lost on a crash" problem, is this:


diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index b48ca0392b9c..4ffb680780e5 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -2902,7 +2902,8 @@ static int ext4_da_write_begin(struct file *file, struct address_space *mapping,
 
 	index = pos >> PAGE_SHIFT;
 
-	if (ext4_nonda_switch(inode->i_sb)) {
+	if (ext4_nonda_switch(inode->i_sb) ||
+	    S_ISLNK(inode->i_mode)) {
 		*fsdata = (void *)FALL_BACK_TO_NONDELALLOC;
 		return ext4_write_begin(file, mapping, pos,
 					len, flags, pagep, fsdata);


					     	    - Ted

