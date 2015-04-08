From: Andreas Dilger <adilger@dilger.ca>
Subject: Re: [PATCH 17/22] ext4 crypto: partial update to namei.c for fname crypto
Date: Wed, 8 Apr 2015 11:44:05 -0600
Message-ID: <799E1747-6588-4AA2-9A2C-97FEB11CDA5A@dilger.ca>
References: <1428012659-12709-1-git-send-email-tytso@mit.edu> <1428012659-12709-18-git-send-email-tytso@mit.edu>
Mime-Version: 1.0 (Mac OS X Mail 8.2 \(2070.6\))
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
Cc: Ext4 Developers List <linux-ext4@vger.kernel.org>,
	jaegeuk@kernel.org, mhalcrow@google.com,
	Uday Savagaonkar <savagaon@google.com>,
	Ildar Muslukhov <ildarm@google.com>
To: Theodore Ts'o <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-pd0-f182.google.com ([209.85.192.182]:35739 "EHLO
	mail-pd0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753994AbbDHRoJ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 8 Apr 2015 13:44:09 -0400
Received: by pddn5 with SMTP id n5so122651512pdd.2
        for <linux-ext4@vger.kernel.org>; Wed, 08 Apr 2015 10:44:08 -0700 (PDT)
In-Reply-To: <1428012659-12709-18-git-send-email-tytso@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Apr 2, 2015, at 4:10 PM, Theodore Ts'o <tytso@mit.edu> wrote:
> 
> From: Michael Halcrow <mhalcrow@google.com>
> 
> Modifies dx_show_leaf and dx_probe to support fname encryption.
> Filename encryption not yet enabled.
> 
> Change-Id: I2058ea5cf6c3920a05c75e42acb2baab631fa1e8
> Signed-off-by: Uday Savagaonkar <savagaon@google.com>
> Signed-off-by: Ildar Muslukhov <ildarm@google.com>
> Signed-off-by: Michael Halcrow <mhalcrow@google.com>
> Signed-off-by: Theodore Ts'o <tytso@mit.edu>
> ---
> fs/ext4/namei.c | 161 ++++++++++++++++++++++++++++++++++++++++++--------------
> 1 file changed, 122 insertions(+), 39 deletions(-)
> 
> diff --git a/fs/ext4/namei.c b/fs/ext4/namei.c
> index cbedeb0..4fccb76 100644
> --- a/fs/ext4/namei.c
> +++ b/fs/ext4/namei.c
> @@ -588,8 +588,10 @@ struct stats
> 	unsigned bcount;
> };
> 
> -static struct stats dx_show_leaf(struct dx_hash_info *hinfo, struct ext4_dir_entry_2 *de,
> -				 int size, int show_names)
> +static struct stats dx_show_leaf(struct inode *dir,
> +				struct dx_hash_info *hinfo,
> +				struct ext4_dir_entry_2 *de,
> +				int size, int show_names)
> {
> 	unsigned names = 0, space = 0;
> 	char *base = (char *) de;
> @@ -602,12 +604,85 @@ static struct stats dx_show_leaf(struct dx_hash_info *hinfo, struct ext4_dir_ent
> 		{
> 			if (show_names)
> 			{
> +#ifdef CONFIG_EXT4_FS_ENCRYPTION
> +				int len;
> +				char *name;
> +				struct ext4_str fname_crypto_str
> +					= {.name = NULL, .len = 0};
> +				struct ext4_fname_crypto_ctx *ctx = NULL;
> +				int res;
> +
> +				name  = de->name;
> +				len = de->name_len;
> +				ctx = ext4_get_fname_crypto_ctx(dir,
> +								EXT4_NAME_LEN);
> +				if (IS_ERR(ctx)) {
> +					printk(KERN_WARNING "Error acquiring"
> +					" crypto ctxt--skipping crypto\n");
> +					ctx = NULL;
> +				}
> +				if (ctx == NULL) {
> +					/* Directory is not encrypted */
> +					while (len--)
> +						printk("%c", *name++);

This is a bit strange, why not use "printk("%*.s", len, name)"?

> +					ext4fs_dirhash(de->name,
> +						de->name_len, &h);
> +					printk(":(U)%x.%u ", h.hash,
> +						(unsigned) ((char *) de
> +							- base));

These two printk's could be combined into a single one.

> +				} else {
> +					/* Directory is encrypted */
> +					res = ext4_fname_crypto_alloc_buffer(
> +						ctx, &fname_crypto_str.name,
> +						&fname_crypto_str.len,
> +						de->name_len);
> +					if (res < 0) {
> +						printk(KERN_WARNING "Error "
> +							"allocating crypto "
> +							"buffer--skipping "
> +							"crypto\n");
> +						ext4_put_fname_crypto_ctx(&ctx);
> +						ctx = NULL;
> +					}
> +					res = ext4_fname_disk_to_usr(ctx, de,
> +							&fname_crypto_str);
> +					if (res < 0) {
> +						printk(KERN_WARNING "Error "
> +							"converting filename "
> +							"from disk to usr"
> +							"\n");
> +						name = "??";
> +						len = 2;
> +					} else {
> +						name = fname_crypto_str.name;
> +						len = fname_crypto_str.len;
> +					}
> +					while (len--)
> +						printk("%c", *name++);
> +					res = ext4_fname_disk_to_hash(ctx, de,
> +								      &h);
> +					if (res < 0) {
> +						printk(KERN_WARNING "Error "
> +							"converting filename "
> +							"from disk to htree"
> +							"\n");
> +						h.hash = 0xDEADBEEF;
> +					}
> +					printk(":(E)%x.%u ", h.hash,
> +						(unsigned) ((char *) de
> +						- base));
> +					ext4_put_fname_crypto_ctx(&ctx);
> +					ext4_fname_crypto_free_buffer(
> +						(void **)&fname_crypto_str.name);
> +				}
> +#else
> 				int len = de->name_len;
> 				char *name = de->name;
> 				while (len--) printk("%c", *name++);
> 				ext4fs_dirhash(de->name, de->name_len, &h);
> 				printk(":%x.%u ", h.hash,
> 				       (unsigned) ((char *) de - base));

I guess this could be fixed similarly, or possibly restructured so that
the code is not duplicated?

> +#endif
> 			}
> 			space += EXT4_DIR_REC_LEN(de->name_len);
> 			names++;
> @@ -639,7 +714,8 @@ struct stats dx_show_entries(struct dx_hash_info *hinfo, struct inode *dir,
> 			continue;
> 		stats = levels?
> 		   dx_show_entries(hinfo, dir, ((struct dx_node *) bh->b_data)->entries, levels - 1):
> -		   dx_show_leaf(hinfo, (struct ext4_dir_entry_2 *) bh->b_data, blocksize, 0);
> +		   dx_show_leaf(dir, hinfo, (struct ext4_dir_entry_2 *)
> +			bh->b_data, blocksize, 0);
> 		names += stats.names;
> 		space += stats.space;
> 		bcount += stats.bcount;
> @@ -672,6 +748,10 @@ dx_probe(const struct qstr *d_name, struct inode *dir,
> 	struct dx_frame *frame = frame_in;
> 	struct dx_frame *ret_err = ERR_PTR(ERR_BAD_DX_DIR);
> 	u32 hash;
> +#ifdef CONFIG_EXT4_FS_ENCRYPTION
> +	struct ext4_fname_crypto_ctx *ctx = NULL;
> +	int res;
> +#endif
> 
> 	frame->bh = ext4_read_dirblock(dir, 0, INDEX);
> 	if (IS_ERR(frame->bh))
> @@ -689,8 +769,25 @@ dx_probe(const struct qstr *d_name, struct inode *dir,
> 	if (hinfo->hash_version <= DX_HASH_TEA)
> 		hinfo->hash_version += EXT4_SB(dir->i_sb)->s_hash_unsigned;
> 	hinfo->seed = EXT4_SB(dir->i_sb)->s_hash_seed;
> +#ifdef CONFIG_EXT4_FS_ENCRYPTION
> +	if (d_name) {
> +		/* Check if the directory is encrypted */
> +		ctx = ext4_get_fname_crypto_ctx(dir, EXT4_NAME_LEN);
> +		if (IS_ERR(ctx)) {
> +			ret_err = ERR_PTR(PTR_ERR(ctx));
> +			goto fail;
> +		}
> +		res = ext4_fname_usr_to_hash(ctx, d_name, hinfo);
> +		if (res < 0) {
> +			ret_err = ERR_PTR(res);
> +			goto fail;
> +		}
> +	}
> +#else
> 	if (d_name)
> 		ext4fs_dirhash(d_name->name, d_name->len, hinfo);
> +#endif
> +
> 	hash = hinfo->hash;
> 
> 	if (root->info.unused_flags & 1) {
> @@ -775,6 +872,11 @@ fail:
> 		brelse(frame->bh);
> 		frame--;
> 	}
> +#ifdef CONFIG_EXT4_FS_ENCRYPTION
> +	/* Free up the memory allocated for EXT4 crypto */
> +	ext4_put_fname_crypto_ctx(&ctx);
> +#endif
> +
> 	if (ret_err == ERR_PTR(ERR_BAD_DX_DIR))
> 		ext4_warning(dir->i_sb,
> 			     "Corrupt dir inode %lu, running e2fsck is "
> @@ -1602,8 +1704,10 @@ static struct ext4_dir_entry_2 *do_split(handle_t *handle, struct inode *dir,
> 		initialize_dirent_tail(t, blocksize);
> 	}
> 
> -	dxtrace(dx_show_leaf (hinfo, (struct ext4_dir_entry_2 *) data1, blocksize, 1));
> -	dxtrace(dx_show_leaf (hinfo, (struct ext4_dir_entry_2 *) data2, blocksize, 1));
> +	dxtrace(dx_show_leaf(dir, hinfo, (struct ext4_dir_entry_2 *) data1,
> +			blocksize, 1));
> +	dxtrace(dx_show_leaf(dir, hinfo, (struct ext4_dir_entry_2 *) data2,
> +			blocksize, 1));
> 
> 	/* Which block gets the new entry? */
> 	if (hinfo->hash >= hash2) {
> @@ -1796,8 +1900,13 @@ static int make_indexed_dir(handle_t *handle, struct dentry *dentry,
> 			    struct inode *inode, struct buffer_head *bh)
> {
> 	struct inode	*dir = dentry->d_parent->d_inode;
> +#ifdef CONFIG_EXT4_FS_ENCRYPTION
> +	struct ext4_fname_crypto_ctx *ctx = NULL;
> +	int res;
> +#else
> 	const char	*name = dentry->d_name.name;
> 	int		namelen = dentry->d_name.len;
> +#endif
> 	struct buffer_head *bh2;
> 	struct dx_root	*root;
> 	struct dx_frame	frames[2], *frame;
> @@ -1812,24 +1921,11 @@ static int make_indexed_dir(handle_t *handle, struct dentry *dentry,
> 	ext4_lblk_t  block;
> 	struct fake_dirent *fde;
> 	int csum_size = 0;
> -#ifdef CONFIG_EXT4_FS_ENCRYPTION
> -	struct ext4_fname_crypto_ctx *ctx = NULL;
> -	struct ext4_str fname_crypto_str = {.name = NULL, .len = 0};
> -	int res;
> 
> +#ifdef CONFIG_EXT4_FS_ENCRYPTION
> 	ctx = ext4_get_fname_crypto_ctx(dir, EXT4_NAME_LEN);
> 	if (IS_ERR(ctx))
> -		return -1;
> -	if (ctx != NULL) {
> -		/* Allocate buffer to hold maximum name length */
> -		res = ext4_fname_crypto_alloc_buffer(ctx,
> -			&fname_crypto_str.name, &fname_crypto_str.len,
> -			EXT4_NAME_LEN);
> -		if (res < 0) {
> -			ext4_put_fname_crypto_ctx(&ctx);
> -			return -1;
> -		}
> -	}
> +		return PTR_ERR(ctx);
> #endif
> 
> 	if (ext4_has_metadata_csum(inode->i_sb))
> @@ -1898,27 +1994,14 @@ static int make_indexed_dir(handle_t *handle, struct dentry *dentry,
> 		hinfo.hash_version += EXT4_SB(dir->i_sb)->s_hash_unsigned;
> 	hinfo.seed = EXT4_SB(dir->i_sb)->s_hash_seed;
> #ifdef CONFIG_EXT4_FS_ENCRYPTION
> -	if (ctx == NULL) {
> -		/* Directory is not encrypted */
> -		ext4fs_dirhash(name, namelen, &hinfo);
> -	} else {
> -		/* Directory is encrypted */
> -		res = ext4_fname_usr_to_htree(ctx, &dentry->d_name,
> -					      &fname_crypto_str);
> -		if (res < 0) {
> -			ext4_put_fname_crypto_ctx(&ctx);
> -			ext4_fname_crypto_free_buffer(
> -			    (void **)&fname_crypto_str.name);
> -			ext4_mark_inode_dirty(handle, dir);
> -			brelse(bh);
> -			return res;
> -		}
> -		ext4fs_dirhash(fname_crypto_str.name,
> -			       fname_crypto_str.len,
> -			       &hinfo);
> +	res = ext4_fname_usr_to_hash(ctx, &dentry->d_name, &hinfo);
> +	if (res < 0) {
> 		ext4_put_fname_crypto_ctx(&ctx);
> -		ext4_fname_crypto_free_buffer((void **)&fname_crypto_str.name);
> +		ext4_mark_inode_dirty(handle, dir);
> +		brelse(bh);
> +		return res;
> 	}
> +	ext4_put_fname_crypto_ctx(&ctx);
> #else
> 	ext4fs_dirhash(name, namelen, &hinfo);
> #endif
> -- 
> 2.3.0
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


Cheers, Andreas





