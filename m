From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH] fscrypt / ext4: make test_dummy_encryption require a
 keyring key
Date: Mon, 2 Jan 2017 15:43:43 -0500
Message-ID: <20170102204342.vib5ayse4kthruma@thunk.org>
References: <1481611930-65173-1-git-send-email-ebiggers3@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, Jaegeuk Kim <jaegeuk@kernel.org>,
        Andreas Dilger <adilger.kernel@dilger.ca>,
        linux-fsdevel@vger.kernel.org, Eric Biggers <ebiggers@google.com>
To: Eric Biggers <ebiggers3@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:60488 "EHLO imap.thunk.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751940AbdABUns (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Mon, 2 Jan 2017 15:43:48 -0500
Content-Disposition: inline
In-Reply-To: <1481611930-65173-1-git-send-email-ebiggers3@gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

The following patch is smaller (and causes a net reduction in code).
It also uses allows us to properly test the context inheritance code,
by completely removing any test_dummy_encryption specific hacks from
fscrypt_inherit_context().

The suggested userspace shell script fragment works on big-endian
systems, and uses fixed key instead of a random one.  The latter is
useful for test sequences where it is useful to validate a file system
that had been previously created using an older kernel.

>  fs/crypto/keyinfo.c | 19 ++++---------------
>  fs/crypto/policy.c  | 40 ++++++++++++++++++++++------------------
>  fs/ext4/ialloc.c    | 12 +++++++-----
>  fs/ext4/namei.c     | 12 +++++++-----
>  4 files changed, 40 insertions(+), 43 deletions(-)

Compare the old diff stat with the changes needed with my version of
the patch:

 fs/crypto/keyinfo.c | 15 ++++++---------
 fs/crypto/policy.c  | 22 +++++++---------------
 2 files changed, 13 insertions(+), 24 deletions(-)

						- Ted

commit 5bbdcbbb396196f1c94110ad7a041e90de95c4c2
Author: Theodore Ts'o <tytso@mit.edu>
Date:   Mon Jan 2 15:12:17 2017 -0500

    fscrypt: make test_dummy_encryption require a keyring key
    
    Currently, the test_dummy_encryption ext4 mount option, which exists
    only to test encrypted I/O paths with xfstests, overrides all
    per-inode encryption keys with a fixed key.
    
    This change minimizes test_dummy_encryption-specific code path changes
    by supplying a fake context for directories which are not encrypted
    for use when creating new directories, files, or symlinks.  This
    allows us to properly exercise the keyring lookup, derivation, and
    context inheritance code paths.
    
    Before mounting a file system using test_dummy_encryption, userspace
    must execute the following shell commands:
    
        mode='\x00\x00\x00\x00'
        raw="$(printf ""\\\\x%02x"" $(seq 0 63))"
        if lscpu | grep "Byte Order" | grep -q Little ; then
            size='\x40\x00\x00\x00'
        else
            size='\x00\x00\x00\x40'
        fi
        key="${mode}${raw}${size}"
        keyctl new_session
        echo -n -e "${key}" | keyctl padd logon fscrypt:4242424242424242 @s
    
    Signed-off-by: Theodore Ts'o <tytso@mit.edu>

diff --git a/fs/crypto/keyinfo.c b/fs/crypto/keyinfo.c
index 95cd4c3b06c3..80f145c8d550 100644
--- a/fs/crypto/keyinfo.c
+++ b/fs/crypto/keyinfo.c
@@ -206,12 +206,16 @@ int fscrypt_get_crypt_info(struct inode *inode)
 
 	res = inode->i_sb->s_cop->get_context(inode, &ctx, sizeof(ctx));
 	if (res < 0) {
-		if (!fscrypt_dummy_context_enabled(inode))
+		if (!fscrypt_dummy_context_enabled(inode) ||
+		    inode->i_sb->s_cop->is_encrypted(inode))
 			return res;
+		/* Fake up a context for an unencrypted directory */
+		memset(&ctx, 0, sizeof(ctx));
 		ctx.format = FS_ENCRYPTION_CONTEXT_FORMAT_V1;
 		ctx.contents_encryption_mode = FS_ENCRYPTION_MODE_AES_256_XTS;
 		ctx.filenames_encryption_mode = FS_ENCRYPTION_MODE_AES_256_CTS;
-		ctx.flags = 0;
+		memset(ctx.master_key_descriptor, 0x42, FS_KEY_DESCRIPTOR_SIZE);
+		res = sizeof(ctx);
 	} else if (res != sizeof(ctx)) {
 		return -EINVAL;
 	}
@@ -247,12 +251,6 @@ int fscrypt_get_crypt_info(struct inode *inode)
 	if (!raw_key)
 		goto out;
 
-	if (fscrypt_dummy_context_enabled(inode)) {
-		memset(raw_key, 0x42, keysize/2);
-		memset(raw_key+keysize/2, 0x24, keysize - (keysize/2));
-		goto got_key;
-	}
-
 	res = validate_user_key(crypt_info, &ctx, raw_key,
 			FS_KEY_DESC_PREFIX, FS_KEY_DESC_PREFIX_SIZE);
 	if (res && inode->i_sb->s_cop->key_prefix) {
@@ -270,7 +268,6 @@ int fscrypt_get_crypt_info(struct inode *inode)
 	} else if (res) {
 		goto out;
 	}
-got_key:
 	ctfm = crypto_alloc_skcipher(cipher_str, 0, 0);
 	if (!ctfm || IS_ERR(ctfm)) {
 		res = ctfm ? PTR_ERR(ctfm) : -ENOMEM;
diff --git a/fs/crypto/policy.c b/fs/crypto/policy.c
index 4c99972899c7..14b76da71269 100644
--- a/fs/crypto/policy.c
+++ b/fs/crypto/policy.c
@@ -198,9 +198,9 @@ EXPORT_SYMBOL(fscrypt_has_permitted_context);
  * @parent: Parent inode from which the context is inherited.
  * @child:  Child inode that inherits the context from @parent.
  * @fs_data:  private data given by FS.
- * @preload:  preload child i_crypt_info
+ * @preload:  preload child i_crypt_info if true
  *
- * Return: Zero on success, non-zero otherwise
+ * Return: 0 on success, -errno on failure
  */
 int fscrypt_inherit_context(struct inode *parent, struct inode *child,
 						void *fs_data, bool preload)
@@ -221,19 +221,11 @@ int fscrypt_inherit_context(struct inode *parent, struct inode *child,
 		return -ENOKEY;
 
 	ctx.format = FS_ENCRYPTION_CONTEXT_FORMAT_V1;
-	if (fscrypt_dummy_context_enabled(parent)) {
-		ctx.contents_encryption_mode = FS_ENCRYPTION_MODE_AES_256_XTS;
-		ctx.filenames_encryption_mode = FS_ENCRYPTION_MODE_AES_256_CTS;
-		ctx.flags = 0;
-		memset(ctx.master_key_descriptor, 0x42, FS_KEY_DESCRIPTOR_SIZE);
-		res = 0;
-	} else {
-		ctx.contents_encryption_mode = ci->ci_data_mode;
-		ctx.filenames_encryption_mode = ci->ci_filename_mode;
-		ctx.flags = ci->ci_flags;
-		memcpy(ctx.master_key_descriptor, ci->ci_master_key,
-				FS_KEY_DESCRIPTOR_SIZE);
-	}
+	ctx.contents_encryption_mode = ci->ci_data_mode;
+	ctx.filenames_encryption_mode = ci->ci_filename_mode;
+	ctx.flags = ci->ci_flags;
+	memcpy(ctx.master_key_descriptor, ci->ci_master_key,
+	       FS_KEY_DESCRIPTOR_SIZE);
 	get_random_bytes(ctx.nonce, FS_KEY_DERIVATION_NONCE_SIZE);
 	res = parent->i_sb->s_cop->set_context(child, &ctx,
 						sizeof(ctx), fs_data);
