From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH] ext4 crypto: handle ENOKEY correctly
Date: Sun, 31 May 2015 11:03:42 -0400
Message-ID: <20150531150342.GB11642@thunk.org>
References: <1432917543-26495-1-git-send-email-dmonakhov@openvz.org>
 <20150529204429.GH18540@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Dmitry Monakhov <dmonakhov@openvz.org>, G@thunk.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:39295 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758259AbbEaPDr (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sun, 31 May 2015 11:03:47 -0400
Content-Disposition: inline
In-Reply-To: <20150529204429.GH18540@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, May 29, 2015 at 04:44:29PM -0400, Theodore Ts'o wrote:
> I don't think that's the right way to go.  We should add checks to
> ext4_file_open, sure.  But the problem is that i_crypt_info can get
> set to NULL after the file is succesfully opened.  So we need to
> handle i_crypt_info being NULL everywhere.  So the BUG_ON() in
> ext4_get_crypto_ctx() needs to be replaced with:
> 
> 	if (ci == NULL)
> 		return ERR_PTR(-ENOKEY);

This is what I had in mind....

				- Ted

commit 3cde0c5d3125697c4b02c32054a378dc71ebfdb5
Author: Theodore Ts'o <tytso@mit.edu>
Date:   Sun May 31 08:12:34 2015 -0400

    ext4 crypto: handle unexpected lack of encryption keys
    
    Fix up attempts by users to try to write to a file when they don't
    have access to the encryption key.
    
    Signed-off-by: Theodore Ts'o <tytso@mit.edu>

diff --git a/fs/ext4/crypto.c b/fs/ext4/crypto.c
index ac2419c..6634478 100644
--- a/fs/ext4/crypto.c
+++ b/fs/ext4/crypto.c
@@ -104,7 +104,8 @@ struct ext4_crypto_ctx *ext4_get_crypto_ctx(struct inode *inode)
 	unsigned long flags;
 	struct ext4_crypt_info *ci = EXT4_I(inode)->i_crypt_info;
 
-	BUG_ON(ci == NULL);
+	if (ci == NULL)
+		return ERR_PTR(-ENOKEY);
 
 	/*
 	 * We first try getting the ctx from a free list because in
diff --git a/fs/ext4/crypto_policy.c b/fs/ext4/crypto_policy.c
index a1d434d..02c4e5d 100644
--- a/fs/ext4/crypto_policy.c
+++ b/fs/ext4/crypto_policy.c
@@ -183,7 +183,8 @@ int ext4_inherit_context(struct inode *parent, struct inode *child)
 	if (res < 0)
 		return res;
 	ci = EXT4_I(parent)->i_crypt_info;
-	BUG_ON(ci == NULL);
+	if (ci == NULL)
+		return -ENOKEY;
 
 	ctx.format = EXT4_ENCRYPTION_CONTEXT_FORMAT_V1;
 	if (DUMMY_ENCRYPTION_ENABLED(EXT4_SB(parent->i_sb))) {
diff --git a/fs/ext4/file.c b/fs/ext4/file.c
index 875ca6b..ac517f1 100644
--- a/fs/ext4/file.c
+++ b/fs/ext4/file.c
@@ -226,6 +226,8 @@ static int ext4_file_mmap(struct file *file, struct vm_area_struct *vma)
 		int err = ext4_get_encryption_info(inode);
 		if (err)
 			return 0;
+		if (ext4_encryption_info(inode) == NULL)
+			return -ENOKEY;
 	}
 	file_accessed(file);
 	if (IS_DAX(file_inode(file))) {
@@ -278,6 +280,13 @@ static int ext4_file_open(struct inode * inode, struct file * filp)
 			ext4_journal_stop(handle);
 		}
 	}
+	if (ext4_encrypted_inode(inode)) {
+		ret = ext4_get_encryption_info(inode);
+		if (ret)
+			return -EACCES;
+		if (ext4_encryption_info(inode) == NULL)
+			return -ENOKEY;
+	}
 	/*
 	 * Set up the jbd2_inode if we are opening the inode for
 	 * writing and the journal is present
@@ -287,13 +296,7 @@ static int ext4_file_open(struct inode * inode, struct file * filp)
 		if (ret < 0)
 			return ret;
 	}
-	ret = dquot_file_open(inode, filp);
-	if (!ret && ext4_encrypted_inode(inode)) {
-		ret = ext4_get_encryption_info(inode);
-		if (ret)
-			ret = -EACCES;
-	}
-	return ret;
+	return dquot_file_open(inode, filp);
 }
 
 /*
