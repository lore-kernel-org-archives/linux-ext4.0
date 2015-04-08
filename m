From: Andreas Dilger <adilger@dilger.ca>
Subject: Re: [PATCH 20/22] ext4 crypto: Add symlink encryption
Date: Wed, 8 Apr 2015 11:58:02 -0600
Message-ID: <3E172AFE-2288-4115-9D3A-E4A047311D27@dilger.ca>
References: <1428012659-12709-1-git-send-email-tytso@mit.edu> <1428012659-12709-21-git-send-email-tytso@mit.edu>
Mime-Version: 1.0 (Mac OS X Mail 8.2 \(2070.6\))
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
Cc: Ext4 Developers List <linux-ext4@vger.kernel.org>,
	jaegeuk@kernel.org, mhalcrow@google.com,
	Uday Savagaonkar <savagaon@google.com>
To: Theodore Ts'o <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-pd0-f172.google.com ([209.85.192.172]:33659 "EHLO
	mail-pd0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753482AbbDHR6F convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 8 Apr 2015 13:58:05 -0400
Received: by pdbnk13 with SMTP id nk13so123160874pdb.0
        for <linux-ext4@vger.kernel.org>; Wed, 08 Apr 2015 10:58:04 -0700 (PDT)
In-Reply-To: <1428012659-12709-21-git-send-email-tytso@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Apr 2, 2015, at 4:10 PM, Theodore Ts'o <tytso@mit.edu> wrote:
> 
> Change-Id: Ic92ebe4c615721650ccaf16b3175c2f4e931af2d
> Signed-off-by: Uday Savagaonkar <savagaon@google.com>
> Signed-off-by: Theodore Ts'o <tytso@mit.edu>
> ---
> fs/ext4/ext4_crypto.h |  20 ++++++++++
> fs/ext4/namei.c       |  63 +++++++++++++++++++++++++++---
> fs/ext4/symlink.c     | 104 +++++++++++++++++++++++++++++++++++++++++++++++++-
> 3 files changed, 180 insertions(+), 7 deletions(-)
> 
> diff --git a/fs/ext4/ext4_crypto.h b/fs/ext4/ext4_crypto.h
> index 68e95d8..4597530 100644
> --- a/fs/ext4/ext4_crypto.h
> +++ b/fs/ext4/ext4_crypto.h
> @@ -117,4 +117,24 @@ struct ext4_fname_crypto_ctx {
> 	unsigned ctfm_key_is_ready : 1;
> };
> 
> +/**
> + * For encrypted symlinks, the ciphertext length is stored at the beginning
> + * of the string in little-endian format.
> + */
> +struct ext4_encrypted_symlink_data {
> +	__le32 len;
> +	char encrypted_path[1];
> +} __attribute__((__packed__));

We can't have a symlink size larger than a block (or possibly PATH_MAX),
can we?  That would allow using __le16 for the symlink length, and
checkpatch.pl will complain about __attribute__((__packed__)) and
request the use of __packed instead.

> +
> +/**
> + * This function is used to calculate the disk space required to
> + * store a filename of length l in encrypted symlink format.
> + */
> +static inline u32 encrypted_symlink_data_len(u32 l)
> +{
> +	return ((l + EXT4_CRYPTO_BLOCK_SIZE - 1) / EXT4_CRYPTO_BLOCK_SIZE)
> +		* EXT4_CRYPTO_BLOCK_SIZE
> +		+ sizeof(struct ext4_encrypted_symlink_data) - 1;

Coding style has operators at the end of the line instead of the start.

> +}
> +
> #endif	/* _EXT4_CRYPTO_H */
> diff --git a/fs/ext4/namei.c b/fs/ext4/namei.c
> index 80a3979..57db793 100644
> --- a/fs/ext4/namei.c
> +++ b/fs/ext4/namei.c
> @@ -3198,14 +3198,31 @@ static int ext4_symlink(struct inode *dir,
> 	struct inode *inode;
> 	int l, err, retries = 0;
> 	int credits;
> +	bool encryption_required = false;
> +#ifdef CONFIG_EXT4_FS_ENCRYPTION
> +	int l2;
> +	struct ext4_fname_crypto_ctx *ctx = NULL;
> +	struct qstr istr;
> +	struct ext4_str ostr;
> +	struct ext4_encrypted_symlink_data *sd = NULL;
> +	struct ext4_sb_info *sbi = EXT4_SB(dir->i_sb);
> +#endif
> 
> -	l = strlen(symname)+1;
> +	l = strlen(symname) + 1;
> +#ifdef CONFIG_EXT4_FS_ENCRYPTION
> +	l2 = encrypted_symlink_data_len(l - 1);
> +	encryption_required = (ext4_encrypted_inode(dir) ||
> +			       unlikely(sbi->s_mount_flags &
> +					EXT4_MF_TEST_DUMMY_ENCRYPTION));
> +	if (encryption_required && l2 > dir->i_sb->s_blocksize)
> +#else
> 	if (l > dir->i_sb->s_blocksize)
> +#endif
> 		return -ENAMETOOLONG;
> 
> 	dquot_initialize(dir);
> 
> -	if (l > EXT4_N_BLOCKS * 4) {
> +	if ((l > EXT4_N_BLOCKS * 4) || encryption_required) {
> 		/*
> 		 * For non-fast symlinks, we just allocate inode and put it on
> 		 * orphan list in the first transaction => we need bitmap,
> @@ -3233,7 +3250,7 @@ retry:
> 	if (IS_ERR(inode))
> 		goto out_stop;
> 
> -	if (l > EXT4_N_BLOCKS * 4) {
> +	if ((l > EXT4_N_BLOCKS * 4) || encryption_required) {
> 		inode->i_op = &ext4_symlink_inode_operations;
> 		ext4_set_aops(inode);
> 		/*
> @@ -3251,9 +3268,40 @@ retry:
> 		ext4_journal_stop(handle);
> 		if (err)
> 			goto err_drop_inode;
> -		err = __page_symlink(inode, symname, l, 1);
> -		if (err)
> -			goto err_drop_inode;
> +		if (!encryption_required) {
> +			err = __page_symlink(inode, symname, l, 1);
> +			if (err)
> +				goto err_drop_inode;
> +		}
> +#ifdef CONFIG_EXT4_FS_ENCRYPTION
> +		else {
> +			sd = kmalloc(l2 + 1, GFP_NOFS);
> +			if (!sd) {
> +				err = -ENOMEM;
> +				goto err_drop_inode;
> +			}
> +			sd->encrypted_path[l2] = '\0';
> +			err = ext4_inherit_context(dir, inode);
> +			ctx = ext4_get_fname_crypto_ctx(
> +				inode, inode->i_sb->s_blocksize);
> +			if (IS_ERR_OR_NULL(ctx)) {
> +				/* We just set the policy, so ctx should
> +				   not be NULL */
> +				err = (ctx == NULL) ? -EIO : PTR_ERR(ctx);
> +				goto err_drop_inode;
> +			}
> +			istr.name = (const unsigned char *) symname;
> +			istr.len = l - 1;
> +			ostr.name = sd->encrypted_path;
> +			err = ext4_fname_usr_to_disk(ctx, &istr, &ostr);
> +			ext4_put_fname_crypto_ctx(&ctx);
> +			if (err < 0)
> +				goto err_drop_inode;
> +			sd->len = cpu_to_le32(ostr.len);
> +			err = __page_symlink(inode, (char *)sd, l2 + 1, 1);
> +

No blank line at the end of this scope.

Can "sd" moved inside this scope?  It doesn't appear to be used outside.

> +		}
> +#endif
> 		/*
> 		 * Now inode is being linked into dir (EXT4_DATA_TRANS_BLOCKS
> 		 * + EXT4_INDEX_EXTRA_TRANS_BLOCKS), inode is also modified
> @@ -3293,6 +3341,9 @@ out_stop:
> err_drop_inode:
> 	unlock_new_inode(inode);
> 	iput(inode);
> +#ifdef CONFIG_EXT4_FS_ENCRYPTION
> +	kfree(sd);
> +#endif
> 	return err;
> }
> 
> diff --git a/fs/ext4/symlink.c b/fs/ext4/symlink.c
> index ff37119..d788891 100644
> --- a/fs/ext4/symlink.c
> +++ b/fs/ext4/symlink.c
> @@ -22,9 +22,106 @@
> #include <linux/namei.h>
> #include "ext4.h"
> #include "xattr.h"
> +#include "ext4_crypto.h"
> 
> +#ifdef CONFIG_EXT4_FS_ENCRYPTION
> static void *ext4_follow_link(struct dentry *dentry, struct nameidata *nd)
> {
> +	struct page *cpage = NULL;
> +	char *caddr, *paddr;
> +	struct ext4_str cstr, pstr;
> +	struct inode *inode = dentry->d_inode;
> +	struct ext4_fname_crypto_ctx *ctx = NULL;
> +	struct ext4_encrypted_symlink_data *sd;
> +	loff_t size = min(inode->i_size, (loff_t) PAGE_SIZE-1);

No space after typecast.  Should this use min_t() instead?

> +	int res;
> +	u32 plen, plen2;
> +
> +	ctx = ext4_get_fname_crypto_ctx(inode, inode->i_sb->s_blocksize);
> +	if (IS_ERR(ctx))
> +		return ctx;
> +
> +	cpage = read_mapping_page(inode->i_mapping, 0, NULL);
> +	if (IS_ERR(cpage)) {
> +		ext4_put_fname_crypto_ctx(&ctx);
> +		return cpage;
> +	}
> +	caddr = kmap(cpage);
> +	caddr[size] = 0;
> +
> +	if (!ctx) {
> +		/* Symlink is unencrypted */
> +		plen = strnlen((char *)caddr, inode->i_sb->s_blocksize);
> +		plen2 = (plen < inode->i_sb->s_blocksize) ? plen + 1 : plen;
> +		paddr = kmalloc(plen2, GFP_NOFS);
> +		if (!paddr) {
> +			ext4_put_fname_crypto_ctx(&ctx);
> +			kunmap(cpage);
> +			page_cache_release(cpage);
> +			return ERR_PTR(-ENOMEM);
> +		}
> +		memcpy(paddr, caddr, plen);
> +		if (plen < inode->i_sb->s_blocksize)
> +			paddr[plen] = '\0';
> +	} else {
> +		/* Symlink is encrypted */
> +		sd = (struct ext4_encrypted_symlink_data *)caddr;
> +		cstr.name = sd->encrypted_path;
> +		cstr.len  = le32_to_cpu(sd->len);
> +		if ((cstr.len + sizeof(struct ext4_encrypted_symlink_data) - 1)
> +			> inode->i_sb->s_blocksize) {

Operator at the end of the previous line.
Continued line should align after '(' from previous line.

> +			/* Symlink data on the disk is corrupted */
> +			kunmap(cpage);
> +			page_cache_release(cpage);
> +			return ERR_PTR(-EIO);
> +		}
> +		plen = (cstr.len < EXT4_FNAME_CRYPTO_DIGEST_SIZE*2)
> +			? EXT4_FNAME_CRYPTO_DIGEST_SIZE*2
> +			: cstr.len;

Operators at the end of the previous line.

> +		paddr = kmalloc(plen + 1, GFP_NOFS);
> +		if (!paddr) {
> +			ext4_put_fname_crypto_ctx(&ctx);
> +			kunmap(cpage);
> +			page_cache_release(cpage);
> +			return ERR_PTR(-ENOMEM);
> +		}
> +		pstr.name = paddr;
> +		res = _ext4_fname_disk_to_usr(ctx, &cstr, &pstr);
> +		if (res < 0) {
> +			ext4_put_fname_crypto_ctx(&ctx);
> +			kunmap(cpage);
> +			page_cache_release(cpage);
> +			kfree(paddr);
> +			return ERR_PTR(res);
> +		}
> +		/* Null-terminate the name */
> +		if (res <= plen)
> +			paddr[res] = '\0';
> +	}
> +	nd_set_link(nd, paddr);
> +	ext4_put_fname_crypto_ctx(&ctx);
> +	return cpage;
> +}
> +
> +static void ext4_put_link(struct dentry *dentry, struct nameidata *nd,
> +			  void *cookie)
> +{
> +	struct page *page = cookie;
> +	char *buf = nd_get_link(nd);
> +
> +	if (page) {
> +		kunmap(page);
> +		page_cache_release(page);
> +	}
> +	if (buf) {
> +		nd_set_link(nd, NULL);
> +		kfree(buf);
> +	}
> +}
> +#endif
> +
> +static void *ext4_follow_fast_link(struct dentry *dentry, struct nameidata *nd)
> +{
> 	struct ext4_inode_info *ei = EXT4_I(dentry->d_inode);
> 	nd_set_link(nd, (char *) ei->i_data);
> 	return NULL;
> @@ -32,8 +129,13 @@ static void *ext4_follow_link(struct dentry *dentry, struct nameidata *nd)
> 
> const struct inode_operations ext4_symlink_inode_operations = {
> 	.readlink	= generic_readlink,
> +#ifdef CONFIG_EXT4_FS_ENCRYPTION
> +	.follow_link    = ext4_follow_link,
> +	.put_link       = ext4_put_link,
> +#else

What about instantiating a different inode_operations struct for
encrypted symlinks?  That avoids the need to handle unencrypted
symlinks inline in ext4_follow_link(), and avoids overhead in the
more common unencrypted symlink case.  In that case, the name of
the new function should be ext4_follow_crypto_link() or similar.

> 	.follow_link	= page_follow_link_light,
> 	.put_link	= page_put_link,
> +#endif
> 	.setattr	= ext4_setattr,
> 	.setxattr	= generic_setxattr,
> 	.getxattr	= generic_getxattr,
> @@ -43,7 +145,7 @@ const struct inode_operations ext4_symlink_inode_operations = {
> 
> const struct inode_operations ext4_fast_symlink_inode_operations = {
> 	.readlink	= generic_readlink,
> -	.follow_link	= ext4_follow_link,
> +	.follow_link    = ext4_follow_fast_link,
> 	.setattr	= ext4_setattr,
> 	.setxattr	= generic_setxattr,
> 	.getxattr	= generic_getxattr,
> -- 
> 2.3.0
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


Cheers, Andreas





