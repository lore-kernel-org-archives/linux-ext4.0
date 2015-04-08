From: Andreas Dilger <adilger@dilger.ca>
Subject: Re: [PATCH 19/22] ext4 crypto: enable filename encryption
Date: Wed, 8 Apr 2015 12:38:57 -0600
Message-ID: <27786CEA-679B-4DF0-946F-8C28D9DB5250@dilger.ca>
References: <1428012659-12709-1-git-send-email-tytso@mit.edu> <1428012659-12709-20-git-send-email-tytso@mit.edu>
Mime-Version: 1.0 (Mac OS X Mail 8.2 \(2070.6\))
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
Cc: Ext4 Developers List <linux-ext4@vger.kernel.org>,
	jaegeuk@kernel.org, mhalcrow@google.com,
	Uday Savagaonkar <savagaon@google.com>,
	Ildar Muslukhov <ildarm@google.com>
To: Theodore Ts'o <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-pa0-f41.google.com ([209.85.220.41]:34252 "EHLO
	mail-pa0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753400AbbDHSi7 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 8 Apr 2015 14:38:59 -0400
Received: by pacyx8 with SMTP id yx8so122486134pac.1
        for <linux-ext4@vger.kernel.org>; Wed, 08 Apr 2015 11:38:59 -0700 (PDT)
In-Reply-To: <1428012659-12709-20-git-send-email-tytso@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Apr 2, 2015, at 4:10 PM, Theodore Ts'o <tytso@mit.edu> wrote:
> 
> From: Michael Halcrow <mhalcrow@google.com>
> 
> Change-Id: I1057e08bf05741b963705f2850710ec5d7d8bd72
> Signed-off-by: Uday Savagaonkar <savagaon@google.com>
> Signed-off-by: Ildar Muslukhov <ildarm@google.com>
> Signed-off-by: Michael Halcrow <mhalcrow@google.com>
> Signed-off-by: Theodore Ts'o <tytso@mit.edu>
> ---
> fs/ext4/dir.c    | 83 ++++++++++++++++++++++++++++++++++++++++++++++++++++----
> fs/ext4/ialloc.c | 21 ++++++++++++--
> 2 files changed, 96 insertions(+), 8 deletions(-)
> 
> diff --git a/fs/ext4/dir.c b/fs/ext4/dir.c
> index f67f955..a77900f 100644
> --- a/fs/ext4/dir.c
> +++ b/fs/ext4/dir.c
> @@ -111,6 +111,11 @@ static int ext4_readdir(struct file *file, struct dir_context *ctx)
> 	struct inode *inode = file_inode(file);
> 	struct super_block *sb = inode->i_sb;
> 	int dir_has_error = 0;
> +#ifdef CONFIG_EXT4_FS_ENCRYPTION
> +	struct ext4_fname_crypto_ctx *enc_ctx = NULL;
> +	struct ext4_str fname_crypto_str = {.name = NULL, .len = 0};
> +#endif
> +	int res;

Having both "res" and "err" in the same function seems prone to mistakes.

> 
> 	if (is_dx_dir(inode)) {
> 		err = ext4_dx_readdir(file, ctx);
> @@ -127,11 +132,27 @@ static int ext4_readdir(struct file *file, struct dir_context *ctx)
> 
> 	if (ext4_has_inline_data(inode)) {
> 		int has_inline_data = 1;
> -		int ret = ext4_read_inline_dir(file, ctx,
> +		res = ext4_read_inline_dir(file, ctx,
> 					   &has_inline_data);
> 		if (has_inline_data)
> -			return ret;
> +			return res;

Is there any reason this can't use "err"?  Or for that matter, "ret" (or
more commonly "rc") could stay local to this scope since it isn't actually
used elsewhere.

> +	}
> +
> +#ifdef CONFIG_EXT4_FS_ENCRYPTION
> +	enc_ctx = ext4_get_fname_crypto_ctx(inode, EXT4_NAME_LEN);
> +	if (IS_ERR(enc_ctx))
> +		return PTR_ERR(enc_ctx);
> +	if (enc_ctx) {
> +		res = ext4_fname_crypto_alloc_buffer(enc_ctx,
> +						     &fname_crypto_str.name,
> +						     &fname_crypto_str.len,
> +						     EXT4_NAME_LEN);
> +		if (res < 0) {
> +			ext4_put_fname_crypto_ctx(&enc_ctx);
> +			return res;
> +		}

Likewise here, "res" isn't used outside the scope of this if {} block
and could be declared locally.  That shouldn't increase stack usage, and
makes it more clear to the reader that this value isn't used elsewhere.

> 	}
> +#endif
> 
> 	offset = ctx->pos & (sb->s_blocksize - 1);
> 
> @@ -226,13 +247,53 @@ static int ext4_readdir(struct file *file, struct dir_context *ctx)
> 			offset += ext4_rec_len_from_disk(de->rec_len,
> 					sb->s_blocksize);
> 			if (le32_to_cpu(de->inode)) {
> +#ifdef CONFIG_EXT4_FS_ENCRYPTION
> +				if (enc_ctx == NULL) {
> +					/* Directory is not encrypted */
> +					if (!dir_emit(ctx, de->name,
> +					    de->name_len,
> +					    le32_to_cpu(de->inode),
> +					    get_dtype(sb, de->file_type))) {
> +						ext4_put_fname_crypto_ctx(
> +							&enc_ctx);
> +						ext4_fname_crypto_free_buffer(
> +							(void **)&fname_crypto_str.name);
> +						brelse(bh);
> +						return 0;
> +					}

This #ifdef and code should be restructured to avoid duplicating the
unencrypted case.  Otherwise it is prone to bugs in one copy or the other.

> +				} else {
> +					/* Directory is encrypted */
> +					err = ext4_fname_disk_to_usr(enc_ctx,
> +							de, &fname_crypto_str);
> +					if (err < 0) {
> +						ext4_put_fname_crypto_ctx(
> +							&enc_ctx);
> +						ext4_fname_crypto_free_buffer(
> +							(void **)&fname_crypto_str.name);
> +						brelse(bh);
> +						return err;
> +					}

"err" isn't used outside the scope of this while {} block and could be
declared inside, preferably keeping the same name as the other local
temporary variables above.

> +					if (!dir_emit(ctx,
> +					    fname_crypto_str.name, err,
> +					    le32_to_cpu(de->inode),
> +					    get_dtype(sb, de->file_type))) {
> +						ext4_put_fname_crypto_ctx(
> +							&enc_ctx);
> +						ext4_fname_crypto_free_buffer(
> +							(void **)&fname_crypto_str.name);
> +						brelse(bh);
> +						return 0;
> +					}
> +				}
> +#else
> 				if (!dir_emit(ctx, de->name,
> -						de->name_len,
> -						le32_to_cpu(de->inode),
> -						get_dtype(sb, de->file_type))) {
> +					      de->name_len,
> +					      le32_to_cpu(de->inode),
> +					      get_dtype(sb, de->file_type))) {
> 					brelse(bh);
> 					return 0;
> 				}
> +#endif
> 			}
> 			ctx->pos += ext4_rec_len_from_disk(de->rec_len,
> 						sb->s_blocksize);
> @@ -240,10 +301,20 @@ static int ext4_readdir(struct file *file, struct dir_context *ctx)
> 		offset = 0;
> 		brelse(bh);
> 		if (ctx->pos < inode->i_size) {
> -			if (!dir_relax(inode))
> +			if (!dir_relax(inode)) {
> +#ifdef CONFIG_EXT4_FS_ENCRYPTION
> +				ext4_put_fname_crypto_ctx(&enc_ctx);
> +				ext4_fname_crypto_free_buffer(
> +						(void **)&fname_crypto_str.name);
> +#endif

Could ext4_put_fname_crypto_ctx() and ext4_fname_crypto_free_buffer()
be made no-ops in the !CONFIG_EXT4_FS_ENCRYPTION case?  That would avoid
the #ifdefs here.

In general, there are a LOT of #ifdefs being being added by this patch
series, and it would be good to avoid it as much as possible.

> 				return 0;
> +			}
> 		}
> 	}
> +#ifdef CONFIG_EXT4_FS_ENCRYPTION
> +	ext4_put_fname_crypto_ctx(&enc_ctx);
> +	ext4_fname_crypto_free_buffer((void **)&fname_crypto_str.name);
> +#endif
> 	return 0;
> }
> 
> diff --git a/fs/ext4/ialloc.c b/fs/ext4/ialloc.c
> index e554ca3..8f37c9e 100644
> --- a/fs/ext4/ialloc.c
> +++ b/fs/ext4/ialloc.c
> @@ -1034,11 +1034,28 @@ got:
> 	ext4_set_inode_state(inode, EXT4_STATE_NEW);
> 
> 	ei->i_extra_isize = EXT4_SB(sb)->s_want_extra_isize;
> -
> +#ifdef CONFIG_EXT4_FS_ENCRYPTION
> +	if ((sbi->s_file_encryption_mode == EXT4_ENCRYPTION_MODE_INVALID) &&
> +	    (sbi->s_dir_encryption_mode == EXT4_ENCRYPTION_MODE_INVALID)) {
> +		ei->i_inline_off = 0;
> +		if (EXT4_HAS_INCOMPAT_FEATURE(sb,
> +			EXT4_FEATURE_INCOMPAT_INLINE_DATA))

This should be indented more, so it is more clear what is being continued.

> +			ext4_set_inode_state(inode,
> +			EXT4_STATE_MAY_INLINE_DATA);

Align after '(' so it is more clear what is being continued.

> +	} else {
> +		/* Inline data and encryption are incompatible
> +		 * We turn off inline data since encryption is enabled */
> +		ei->i_inline_off = 1;
> +		if (EXT4_HAS_INCOMPAT_FEATURE(sb,
> +			EXT4_FEATURE_INCOMPAT_INLINE_DATA))
> +			ext4_clear_inode_state(inode,
> +			EXT4_STATE_MAY_INLINE_DATA);

Same.

> +	}
> +#else
> 	ei->i_inline_off = 0;
> 	if (EXT4_HAS_INCOMPAT_FEATURE(sb, EXT4_FEATURE_INCOMPAT_INLINE_DATA))
> 		ext4_set_inode_state(inode, EXT4_STATE_MAY_INLINE_DATA);

It looks like the logic could be reversed here so that the non-encrypted
case doesn't need to be duplicated:

#ifdef CONFIG_EXT4_FS_ENCRYPTION
	if (file_mode != INVALID || dir_mode != INVALID) {
		/* Inline data and encryption are incompatible ... */
	} else
#endif
	{
		ei->i_inline_off = 0;
		if (EXT4_HAS_INCOMPAT_FEATURE(sb, ...)
			ext4_set_inode_state(inode, MAY_INLINE_DATA);
	}


Cheers, Andreas





