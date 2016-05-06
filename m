From: Jaegeuk Kim <jaegeuk@kernel.org>
Subject: Re: [PATCH] ext4 crypto: migrate into vfs's crypto engine
Date: Thu, 5 May 2016 17:25:10 -0700
Message-ID: <20160506002510.GA82180@jaegeuk.gateway>
References: <1461629736-16523-1-git-send-email-jaegeuk@kernel.org>
 <20160505032022.GC10776@thunk.org>
 <20160505042248.GB73673@jaegeuk.gateway>
 <20160505124412.GE10776@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: Theodore Ts'o <tytso@mit.edu>, linux-kernel@vger.kernel.org,
	linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20160505124412.GE10776@thunk.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Thu, May 05, 2016 at 08:44:12AM -0400, Theodore Ts'o wrote:
> On Wed, May 04, 2016 at 09:22:48PM -0700, Jaegeuk Kim wrote:
> > 
> > Got it. Let me add (*key_prefix(inode)) in fscrypt_operations so that filesystem
> > can give a specific prefix additionally.
> > Once fscrypto supports both of prefixes, does e4crypto have to set "fscrypto"?
> > The "ext4" should work all the time tho.
> 
> Well, the question is what userspace tool should be used for the
> non-Android case?
> 
> The other thing to consider is the cost of doing lookups in two
> keyrings all of the time.  I'm not sure how much overhead there is,
> but if it's significant, it might be time to hang a keyring off the
> superblock, and to start migrating to a model where keys are globally
> available to the file system once they get their (either implicitly
> because they are on a user's keyring, or explicitly via a new ioctl),
> and when they are removed (either implicitly because a key has been
> invalidated, or explicitly via a new ioctl), when a key gets added or
> removed from the file system global keyring, we bump a sequence
> counter so we can invalidate negative or positve dcache entries as
> appropriate.

The below patch implements allowing one more prefix given by fs.

Regarding to the overhead, I measured elapsed time of each function in
get_crypt_info() under x86 server.
And, I could see mostly negligible latencies including double check one.

Especially, the result shows just zero latencies except some cold misses
made by get_context(), derive_key_aes(), and crypto_alloc_skcipher(); those
are to read xattrs or load kernel crypto modules, I think.
After cold misses, I couldn't see any delay from get_crypt_info() actually.

Moreover, when considering prefix check is done by request_key() in early stage,
IMHO, calling it twice would not be a big deal.

Thought?

Thanks,

>From 08eb7ef36243728e00d9ffc6c56fa7d088d3d27c Mon Sep 17 00:00:00 2001
From: Jaegeuk Kim <jaegeuk@kernel.org>
Date: Wed, 4 May 2016 22:05:01 -0700
Subject: [PATCH] fscrypto/f2fs: allow fs-specific key prefix for fs encryption

This patch allows fscrypto to handle a second key prefix given by filesystem.
The main reason is to provide backward compatibility, since previously f2fs
used "f2fs:" as a crypto prefix instead of "fscrypt:".
Later, ext4 should also provide key_prefix() to give "ext4:".

One concern decribed by Ted would be kinda double check overhead of prefixes.
In x86, for example, validate_user_key consumes 8 ms after boot-up, which turns
out derive_key_aes() consumed most of the time to load specific crypto module.
After such the cold miss, it shows almost zero latencies, which treats as a
negligible overhead.
Note that request_key() detects wrong prefix in prior to derive_key_aes() even.

Cc: Ted Tso <tytso@mit.edu>
Signed-off-by: Jaegeuk Kim <jaegeuk@kernel.org>
---
 fs/crypto/keyinfo.c      | 120 ++++++++++++++++++++++++++++++-----------------
 fs/f2fs/f2fs.h           |   8 ++++
 fs/f2fs/super.c          |  13 +++++
 include/linux/fscrypto.h |   1 +
 4 files changed, 98 insertions(+), 44 deletions(-)

diff --git a/fs/crypto/keyinfo.c b/fs/crypto/keyinfo.c
index 06f5aa4..1ac263e 100644
--- a/fs/crypto/keyinfo.c
+++ b/fs/crypto/keyinfo.c
@@ -78,6 +78,67 @@ out:
 	return res;
 }
 
+static int validate_user_key(struct fscrypt_info *crypt_info,
+			struct fscrypt_context *ctx, u8 *raw_key,
+			u8 *prefix, int prefix_size)
+{
+	u8 *full_key_descriptor;
+	struct key *keyring_key;
+	struct fscrypt_key *master_key;
+	const struct user_key_payload *ukp;
+	int full_key_len = prefix_size + (FS_KEY_DESCRIPTOR_SIZE * 2) + 1;
+	int res;
+
+	full_key_descriptor = kmalloc(full_key_len, GFP_NOFS);
+	if (!full_key_descriptor)
+		return -ENOMEM;
+
+	memcpy(full_key_descriptor, prefix, prefix_size);
+	sprintf(full_key_descriptor + prefix_size,
+			"%*phN", FS_KEY_DESCRIPTOR_SIZE,
+			ctx->master_key_descriptor);
+	full_key_descriptor[full_key_len - 1] = '\0';
+	keyring_key = request_key(&key_type_logon, full_key_descriptor, NULL);
+	kfree(full_key_descriptor);
+	if (IS_ERR(keyring_key))
+		return PTR_ERR(keyring_key);
+
+	if (keyring_key->type != &key_type_logon) {
+		printk_once(KERN_WARNING
+				"%s: key type must be logon\n", __func__);
+		res = -ENOKEY;
+		goto out;
+	}
+	down_read(&keyring_key->sem);
+	ukp = user_key_payload(keyring_key);
+	if (ukp->datalen != sizeof(struct fscrypt_key)) {
+		res = -EINVAL;
+		up_read(&keyring_key->sem);
+		goto out;
+	}
+	master_key = (struct fscrypt_key *)ukp->data;
+	BUILD_BUG_ON(FS_AES_128_ECB_KEY_SIZE != FS_KEY_DERIVATION_NONCE_SIZE);
+
+	if (master_key->size != FS_AES_256_XTS_KEY_SIZE) {
+		printk_once(KERN_WARNING
+				"%s: key size incorrect: %d\n",
+				__func__, master_key->size);
+		res = -ENOKEY;
+		up_read(&keyring_key->sem);
+		goto out;
+	}
+	res = derive_key_aes(ctx->nonce, master_key->raw, raw_key);
+	up_read(&keyring_key->sem);
+	if (res)
+		goto out;
+
+	crypt_info->ci_keyring_key = keyring_key;
+	return 0;
+out:
+	key_put(keyring_key);
+	return res;
+}
+
 static void put_crypt_info(struct fscrypt_info *ci)
 {
 	if (!ci)
@@ -91,12 +152,7 @@ static void put_crypt_info(struct fscrypt_info *ci)
 int get_crypt_info(struct inode *inode)
 {
 	struct fscrypt_info *crypt_info;
-	u8 full_key_descriptor[FS_KEY_DESC_PREFIX_SIZE +
-				(FS_KEY_DESCRIPTOR_SIZE * 2) + 1];
-	struct key *keyring_key = NULL;
-	struct fscrypt_key *master_key;
 	struct fscrypt_context ctx;
-	const struct user_key_payload *ukp;
 	struct crypto_skcipher *ctfm;
 	const char *cipher_str;
 	u8 raw_key[FS_MAX_KEY_SIZE];
@@ -167,48 +223,24 @@ retry:
 		memset(raw_key, 0x42, FS_AES_256_XTS_KEY_SIZE);
 		goto got_key;
 	}
-	memcpy(full_key_descriptor, FS_KEY_DESC_PREFIX,
-					FS_KEY_DESC_PREFIX_SIZE);
-	sprintf(full_key_descriptor + FS_KEY_DESC_PREFIX_SIZE,
-					"%*phN", FS_KEY_DESCRIPTOR_SIZE,
-					ctx.master_key_descriptor);
-	full_key_descriptor[FS_KEY_DESC_PREFIX_SIZE +
-					(2 * FS_KEY_DESCRIPTOR_SIZE)] = '\0';
-	keyring_key = request_key(&key_type_logon, full_key_descriptor, NULL);
-	if (IS_ERR(keyring_key)) {
-		res = PTR_ERR(keyring_key);
-		keyring_key = NULL;
-		goto out;
-	}
-	crypt_info->ci_keyring_key = keyring_key;
-	if (keyring_key->type != &key_type_logon) {
-		printk_once(KERN_WARNING
-				"%s: key type must be logon\n", __func__);
-		res = -ENOKEY;
-		goto out;
-	}
-	down_read(&keyring_key->sem);
-	ukp = user_key_payload(keyring_key);
-	if (ukp->datalen != sizeof(struct fscrypt_key)) {
-		res = -EINVAL;
-		up_read(&keyring_key->sem);
-		goto out;
-	}
-	master_key = (struct fscrypt_key *)ukp->data;
-	BUILD_BUG_ON(FS_AES_128_ECB_KEY_SIZE != FS_KEY_DERIVATION_NONCE_SIZE);
 
-	if (master_key->size != FS_AES_256_XTS_KEY_SIZE) {
-		printk_once(KERN_WARNING
-				"%s: key size incorrect: %d\n",
-				__func__, master_key->size);
-		res = -ENOKEY;
-		up_read(&keyring_key->sem);
+	res = validate_user_key(crypt_info, &ctx, raw_key,
+			FS_KEY_DESC_PREFIX, FS_KEY_DESC_PREFIX_SIZE);
+	if (res && inode->i_sb->s_cop->key_prefix) {
+		u8 *prefix = NULL;
+		int prefix_size, res2;
+
+		prefix_size = inode->i_sb->s_cop->key_prefix(inode, &prefix);
+		res2 = validate_user_key(crypt_info, &ctx, raw_key,
+							prefix, prefix_size);
+		if (res2) {
+			if (res2 == -ENOKEY)
+				res = -ENOKEY;
+			goto out;
+		}
+	} else if (res) {
 		goto out;
 	}
-	res = derive_key_aes(ctx.nonce, master_key->raw, raw_key);
-	up_read(&keyring_key->sem);
-	if (res)
-		goto out;
 got_key:
 	ctfm = crypto_alloc_skcipher(cipher_str, 0, 0);
 	if (!ctfm || IS_ERR(ctfm)) {
diff --git a/fs/f2fs/f2fs.h b/fs/f2fs/f2fs.h
index fd1b4a5..052f5a8 100644
--- a/fs/f2fs/f2fs.h
+++ b/fs/f2fs/f2fs.h
@@ -711,6 +711,10 @@ enum {
 	MAX_TIME,
 };
 
+#ifdef CONFIG_F2FS_FS_ENCRYPTION
+#define F2FS_KEY_DESC_PREFIX "f2fs:"
+#define F2FS_KEY_DESC_PREFIX_SIZE 5
+#endif
 struct f2fs_sb_info {
 	struct super_block *sb;			/* pointer to VFS super block */
 	struct proc_dir_entry *s_proc;		/* proc entry */
@@ -718,6 +722,10 @@ struct f2fs_sb_info {
 	int valid_super_block;			/* valid super block no */
 	int s_flag;				/* flags for sbi */
 
+#ifdef CONFIG_F2FS_FS_ENCRYPTION
+	u8 key_prefix[F2FS_KEY_DESC_PREFIX_SIZE];
+	u8 key_prefix_size;
+#endif
 	/* for node-related operations */
 	struct f2fs_nm_info *nm_info;		/* node manager */
 	struct inode *node_inode;		/* cache node blocks */
diff --git a/fs/f2fs/super.c b/fs/f2fs/super.c
index 8a28f79..28c8992 100644
--- a/fs/f2fs/super.c
+++ b/fs/f2fs/super.c
@@ -964,6 +964,12 @@ static int f2fs_get_context(struct inode *inode, void *ctx, size_t len)
 				ctx, len, NULL);
 }
 
+static int f2fs_key_prefix(struct inode *inode, u8 **key)
+{
+	*key = F2FS_I_SB(inode)->key_prefix;
+	return F2FS_I_SB(inode)->key_prefix_size;
+}
+
 static int f2fs_set_context(struct inode *inode, const void *ctx, size_t len,
 							void *fs_data)
 {
@@ -980,6 +986,7 @@ static unsigned f2fs_max_namelen(struct inode *inode)
 
 static struct fscrypt_operations f2fs_cryptops = {
 	.get_context	= f2fs_get_context,
+	.key_prefix	= f2fs_key_prefix,
 	.set_context	= f2fs_set_context,
 	.is_encrypted	= f2fs_encrypted_inode,
 	.empty_dir	= f2fs_empty_dir,
@@ -1305,6 +1312,12 @@ static void init_sb_info(struct f2fs_sb_info *sbi)
 
 	INIT_LIST_HEAD(&sbi->s_list);
 	mutex_init(&sbi->umount_mutex);
+
+#ifdef CONFIG_F2FS_FS_ENCRYPTION
+	memcpy(sbi->key_prefix, F2FS_KEY_DESC_PREFIX,
+				F2FS_KEY_DESC_PREFIX_SIZE);
+	sbi->key_prefix_size = F2FS_KEY_DESC_PREFIX_SIZE;
+#endif
 }
 
 /*
diff --git a/include/linux/fscrypto.h b/include/linux/fscrypto.h
index 6027f6b..cfa6cde 100644
--- a/include/linux/fscrypto.h
+++ b/include/linux/fscrypto.h
@@ -175,6 +175,7 @@ struct fscrypt_name {
  */
 struct fscrypt_operations {
 	int (*get_context)(struct inode *, void *, size_t);
+	int (*key_prefix)(struct inode *, u8 **);
 	int (*prepare_context)(struct inode *);
 	int (*set_context)(struct inode *, const void *, size_t, void *);
 	int (*dummy_context)(struct inode *);
-- 
2.6.3
