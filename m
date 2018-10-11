Return-Path: <SRS0=dqau=MX=vger.kernel.org=linux-ext4-owner@kernel.org>
Received: from userp2130.oracle.com ([156.151.31.86]:43142 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725840AbeJLF4S (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Fri, 12 Oct 2018 01:56:18 -0400
Date: Thu, 11 Oct 2018 15:26:39 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
To: Gabriel Krisman Bertazi <krisman@collabora.co.uk>
Cc: tytso@mit.edu, linux-ext4@vger.kernel.org
Subject: Re: [PATCH RESEND v2 20/25] ext4: Include encoding information in
 the superblock
Message-ID: <20181011222639.GC24099@magnolia>
References: <20180924215655.3676-1-krisman@collabora.co.uk>
 <20180924215655.3676-21-krisman@collabora.co.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180924215655.3676-21-krisman@collabora.co.uk>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Sep 24, 2018 at 05:56:50PM -0400, Gabriel Krisman Bertazi wrote:
> Support for encoding is considered an incompatible feature, since it has
> potential to create collisions of file names in existing filesystems.
> If the feature flag is not enabled, the entire filesystem will operate
> on opaque byte sequences, respecting the original behavior.
> 
> The charset data is encoded in a new field in the superblock using a
> magic number specific to ext4.  This is the easiest way I found to avoid
> writing the name of the charset in the superblock.  The magic number is
> mapped to the exact NLS table, but the mapping is specific to ext4.
> Since we don't have any commitment to support old encodings, the only
> encodings I am supporting right now is utf8n-10.0.0 and ascii, both
> using the NLS abstraction.
> 
> The current implementation prevents the user from enabling encoding and
> per-directory encryption on the same filesystem at the same time.  The
> incompatibility between these features lies in how we do efficient
> directory searches when we cannot be sure the encryption of the user
> provided fname will match the actual hash stored in the disk without
> decrypting every directory entry, because of normalization cases.  My
> quickest solution is to simply block the concurrent use of these
> features for now, and enable it later, once we have a better solution.
> 
> Changes since v1:
>   - Guard code with CONFIG_NLS.
>   - Use 16 bits for s_ioencoding.
>   - Split mount option from this patch
> 
> Signed-off-by: Gabriel Krisman Bertazi <krisman@collabora.co.uk>
> ---
>  fs/ext4/ext4.h  | 19 ++++++++++++-
>  fs/ext4/super.c | 73 +++++++++++++++++++++++++++++++++++++++++++++++++
>  2 files changed, 91 insertions(+), 1 deletion(-)
> 
> diff --git a/fs/ext4/ext4.h b/fs/ext4/ext4.h
> index ac05bd86643a..6bdaba9c6923 100644
> --- a/fs/ext4/ext4.h
> +++ b/fs/ext4/ext4.h
> @@ -1190,6 +1190,11 @@ extern void ext4_set_bits(void *bm, int cur, int len);
>  /* Metadata checksum algorithm codes */
>  #define EXT4_CRC32C_CHKSUM		1
>  
> +/* Be careful when modifying these flags.  The lower byte must match the
> + * NLS flags. */
> +
> +#define EXT4_ENC_NLS_FL_MASK	0x00FF
> +
>  /*
>   * Structure of the super block
>   */
> @@ -1316,7 +1321,9 @@ struct ext4_super_block {
>  	__u8	s_first_error_time_hi;
>  	__u8	s_last_error_time_hi;
>  	__u8	s_pad[2];
> -	__le32	s_reserved[96];		/* Padding to the end of the block */
> +	__le16  s_ioencoding;		/* charset encoding */
> +	__le16  s_ioencoding_flags;	/* charset encoding flags */
> +	__le32	s_reserved[95];		/* Padding to the end of the block */

Please update Documentation/filesystems/ext4/super.rst with this when it
appears after the merge window.

>  	__le32	s_checksum;		/* crc32c(superblock) */
>  };
>  
> @@ -1341,6 +1348,8 @@ struct ext4_super_block {
>  /* Number of quota types we support */
>  #define EXT4_MAXQUOTAS 3
>  
> +struct ext4_sb_encodings;
> +
>  /*
>   * fourth extended-fs super-block data in memory
>   */
> @@ -1390,6 +1399,11 @@ struct ext4_sb_info {
>  	struct kobject s_kobj;
>  	struct completion s_kobj_unregister;
>  	struct super_block *s_sb;
> +#ifdef CONFIG_NLS
> +	const struct ext4_sb_encodings *encoding_info;
> +	struct nls_table *encoding;
> +	__u16 encoding_flags;
> +#endif
>  
>  	/* Journaling */
>  	struct journal_s *s_journal;
> @@ -1665,6 +1679,7 @@ static inline void ext4_clear_state_flags(struct ext4_inode_info *ei)
>  #define EXT4_FEATURE_INCOMPAT_LARGEDIR		0x4000 /* >2GB or 3-lvl htree */
>  #define EXT4_FEATURE_INCOMPAT_INLINE_DATA	0x8000 /* data in inode */
>  #define EXT4_FEATURE_INCOMPAT_ENCRYPT		0x10000
> +#define EXT4_FEATURE_INCOMPAT_IOENCODING	0x20000

/me wonders how the 'ioencoding' name came about?  We're not encoding
disk IO, just directory entries.

>  
>  #define EXT4_FEATURE_COMPAT_FUNCS(name, flagname) \
>  static inline bool ext4_has_feature_##name(struct super_block *sb) \
> @@ -1753,6 +1768,7 @@ EXT4_FEATURE_INCOMPAT_FUNCS(csum_seed,		CSUM_SEED)
>  EXT4_FEATURE_INCOMPAT_FUNCS(largedir,		LARGEDIR)
>  EXT4_FEATURE_INCOMPAT_FUNCS(inline_data,	INLINE_DATA)
>  EXT4_FEATURE_INCOMPAT_FUNCS(encrypt,		ENCRYPT)
> +EXT4_FEATURE_INCOMPAT_FUNCS(ioencoding,		IOENCODING)
>  
>  #define EXT2_FEATURE_COMPAT_SUPP	EXT4_FEATURE_COMPAT_EXT_ATTR
>  #define EXT2_FEATURE_INCOMPAT_SUPP	(EXT4_FEATURE_INCOMPAT_FILETYPE| \
> @@ -1780,6 +1796,7 @@ EXT4_FEATURE_INCOMPAT_FUNCS(encrypt,		ENCRYPT)
>  					 EXT4_FEATURE_INCOMPAT_MMP | \
>  					 EXT4_FEATURE_INCOMPAT_INLINE_DATA | \
>  					 EXT4_FEATURE_INCOMPAT_ENCRYPT | \
> +					 EXT4_FEATURE_INCOMPAT_IOENCODING | \
>  					 EXT4_FEATURE_INCOMPAT_CSUM_SEED | \
>  					 EXT4_FEATURE_INCOMPAT_LARGEDIR)
>  #define EXT4_FEATURE_RO_COMPAT_SUPP	(EXT4_FEATURE_RO_COMPAT_SPARSE_SUPER| \
> diff --git a/fs/ext4/super.c b/fs/ext4/super.c
> index a430fb3e9720..ccf4742fea3b 100644
> --- a/fs/ext4/super.c
> +++ b/fs/ext4/super.c
> @@ -42,6 +42,7 @@
>  #include <linux/cleancache.h>
>  #include <linux/uaccess.h>
>  #include <linux/iversion.h>
> +#include <linux/nls.h>
>  
>  #include <linux/kthread.h>
>  #include <linux/freezer.h>
> @@ -1010,6 +1011,10 @@ static void ext4_put_super(struct super_block *sb)
>  		crypto_free_shash(sbi->s_chksum_driver);
>  	kfree(sbi->s_blockgroup_lock);
>  	fs_put_dax(sbi->s_daxdev);
> +#ifdef CONFIG_NLS
> +	unload_nls(sbi->encoding);
> +	kfree(sbi->encoding_info);
> +#endif
>  	kfree(sbi);
>  }
>  
> @@ -1703,6 +1708,31 @@ static const struct mount_opts {
>  	{Opt_err, 0, 0}
>  };
>  
> +#ifdef CONFIG_NLS
> +static const struct ext4_sb_encodings {
> +	char *name;
> +	char *version;
> +} ext4_sb_encoding_map[] = {
> +	/* 0x0 */	{"ascii", NULL},
> +	/* 0x1 */	{"utf8", "10.0.0"},
> +};
> +
> +static int
> +ext4_sb_read_encoding(const struct ext4_super_block *es,
> +		      const struct ext4_sb_encodings **encoding, __u16 *flags)
> +{
> +	__u16 magic = le16_to_cpu(es->s_ioencoding);
> +
> +	if (magic >= ARRAY_SIZE(ext4_sb_encoding_map))
> +		return -EINVAL;
> +
> +	*encoding = &ext4_sb_encoding_map[magic];
> +	*flags = le16_to_cpu(es->s_ioencoding_flags);
> +
> +	return 0;
> +}
> +#endif
> +
>  static int handle_mount_opt(struct super_block *sb, char *opt, int token,
>  			    substring_t *args, unsigned long *journal_devnum,
>  			    unsigned int *journal_ioprio, int is_remount)
> @@ -3515,6 +3545,11 @@ static int ext4_fill_super(struct super_block *sb, void *data, int silent)
>  	int err = 0;
>  	unsigned int journal_ioprio = DEFAULT_JOURNAL_IOPRIO;
>  	ext4_group_t first_not_zeroed;
> +#ifdef CONFIG_NLS
> +	struct nls_table *encoding;
> +	const struct ext4_sb_encodings *encoding_info;
> +	__u16 nls_flags;
> +#endif
>  
>  	if ((data && !orig_data) || !sbi)
>  		goto out_free_base;
> @@ -3687,6 +3722,39 @@ static int ext4_fill_super(struct super_block *sb, void *data, int silent)
>  			   &journal_ioprio, 0))
>  		goto failed_mount;
>  
> +#ifdef CONFIG_NLS
> +	if (ext4_has_feature_ioencoding(sb) && !sbi->encoding) {
> +		if (ext4_has_feature_encrypt(sb)) {
> +			ext4_msg(sb, KERN_ERR,
> +				 "Can't mount with both encoding and encryption");
> +			goto failed_mount;
> +		}
> +
> +		if (ext4_sb_read_encoding(es, &encoding_info, &nls_flags)) {
> +			ext4_msg(sb, KERN_ERR,
> +				 "Encoding requested by superblock is unknown");
> +			goto failed_mount;
> +		}
> +
> +		encoding = load_nls_version(encoding_info->name,
> +					    encoding_info->version,
> +					    nls_flags & EXT4_ENC_NLS_FL_MASK);
> +		if (IS_ERR(encoding)) {
> +			ext4_msg(sb, KERN_ERR, "can't mount with superblock charset: "
> +				 "%s-%s not supported by the kernel. flags: 0x%x",
> +				 encoding_info->name, encoding_info->version,
> +				 nls_flags);
> +			goto failed_mount;
> +		}
> +		ext4_msg(sb, KERN_INFO,"Using encoding defined by superblock: "
> +			 "%s-%s with flags 0x%hx", encoding_info->name,
> +			 encoding_info->version?:"\b", nls_flags);
> +
> +		sbi->encoding = encoding;
> +		sbi->encoding_flags = nls_flags;
> +	}
> +#endif
> +
>  	if (test_opt(sb, DATA_FLAGS) == EXT4_MOUNT_JOURNAL_DATA) {
>  		printk_once(KERN_WARNING "EXT4-fs: Warning: mounting "
>  			    "with data=journal disables delayed "
> @@ -4527,6 +4595,11 @@ static int ext4_fill_super(struct super_block *sb, void *data, int silent)
>  failed_mount:
>  	if (sbi->s_chksum_driver)
>  		crypto_free_shash(sbi->s_chksum_driver);
> +
> +#ifdef CONFIG_NLS
> +	unload_nls(sbi->encoding);
> +#endif
> +
>  #ifdef CONFIG_QUOTA
>  	for (i = 0; i < EXT4_MAXQUOTAS; i++)
>  		kfree(sbi->s_qf_names[i]);
> -- 
> 2.19.0
> 
