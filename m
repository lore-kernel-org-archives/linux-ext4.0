From: Ted Ts'o <tytso@mit.edu>
Subject: Re: [PATCH] ext4: use vmtruncate() instead of ext4_truncate() in
 ext4_setattr()
Date: Sun, 22 May 2011 19:56:26 -0400
Message-ID: <20110522235625.GC10009@thunk.org>
References: <20110517225926.8B4A94225B@ruihe.smo.corp.google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Jiaying Zhang <jiayingz@google.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:50356 "EHLO
	test.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754491Ab1EVX43 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sun, 22 May 2011 19:56:29 -0400
Content-Disposition: inline
In-Reply-To: <20110517225926.8B4A94225B@ruihe.smo.corp.google.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Here's a cleaner way of fixing the problem.  vmtruncate() is now
deprecated, so I'm using truncate_setsize() instead; in addition, I
avoid calling ext4_truncate() twice in the case where EOFBLOCKS_FL.
Since ext4_truncate() is a very heavyweight function, which requires
manipulating the orphan list and taking i_data_sem, avoiding a double
call of ext4_truncate() is a big win.

						- Ted

commit bb5eabd2de1e9dfdeeac822174fba17f2d2a7f2b
Author: Theodore Ts'o <tytso@mit.edu>
Date:   Sun May 22 19:45:01 2011 -0400

    ext4: use truncate_setsize() unconditionally
    
    In commit c8d46e41 (ext4: Add flag to files with blocks intentionally
    past EOF), if the EOFBLOCKS_FL flag is set, we call ext4_truncate()
    before calling vmtruncate().  This caused any allocated but unwritten
    blocks created by calling fallocate() with the FALLOC_FL_KEEP_SIZE
    flag to be dropped.  This was done to make to make sure that
    EOFBLOCKS_FL would not be cleared while still leaving blocks past
    i_size allocated.  This was not necessary, since ext4_truncate()
    guarantees that blocks past i_size will be dropped, even in the case
    where truncate() has increased i_size before calling ext4_truncate().
    
    So fix this by removing the EOFBLOCKS_FL special case treatment in
    ext4_setattr().  In addition, use truncate_setsize() followed by a
    call to ext4_truncate() instead of using vmtruncate().  This is more
    efficient since it skips the call to inode_newsize_ok(), which has
    been checked already by inode_change_ok().  This is also in a win in
    the case where EOFBLOCKS_FL is set since it avoids calling
    ext4_truncate() twice.
    
    Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>

diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index df3fb20..4ca8411 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -5363,8 +5363,7 @@ int ext4_setattr(struct dentry *dentry, struct iattr *attr)
 
 	if (S_ISREG(inode->i_mode) &&
 	    attr->ia_valid & ATTR_SIZE &&
-	    (attr->ia_size < inode->i_size ||
-	     (ext4_test_inode_flag(inode, EXT4_INODE_EOFBLOCKS)))) {
+	    (attr->ia_size < inode->i_size)) {
 		handle_t *handle;
 
 		handle = ext4_journal_start(inode, 3);
@@ -5398,14 +5397,13 @@ int ext4_setattr(struct dentry *dentry, struct iattr *attr)
 				goto err_out;
 			}
 		}
-		/* ext4_truncate will clear the flag */
-		if ((ext4_test_inode_flag(inode, EXT4_INODE_EOFBLOCKS)))
-			ext4_truncate(inode);
 	}
 
 	if ((attr->ia_valid & ATTR_SIZE) &&
-	    attr->ia_size != i_size_read(inode))
-		rc = vmtruncate(inode, attr->ia_size);
+	    attr->ia_size != i_size_read(inode)) {
+		truncate_setsize(inode, attr->ia_size);
+		ext4_truncate(inode);
+	}
 
 	if (!rc) {
 		setattr_copy(inode, attr);
