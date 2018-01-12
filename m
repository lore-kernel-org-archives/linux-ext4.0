From: "Weber, Olaf (HPC Data Management & Storage)" <olaf.weber@hpe.com>
Subject: RE: [PATCH RFC 13/13] ext4: Implement ext4 dcache hooks for custom
 charsets
Date: Fri, 12 Jan 2018 10:52:57 +0000
Message-ID: <DF4PR8401MB0812FF0D5F50D89C14015C0485170@DF4PR8401MB0812.NAMPRD84.PROD.OUTLOOK.COM>
References: <20180112071234.29470-1-krisman@collabora.co.uk>
 <20180112071234.29470-14-krisman@collabora.co.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Cc: "linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>,
        "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
        "kernel@lists.collabora.co.uk" <kernel@lists.collabora.co.uk>,
        "alvaro.soliverez@collabora.co.uk" <alvaro.soliverez@collabora.co.uk>
To: Gabriel Krisman Bertazi <krisman@collabora.co.uk>,
        "tytso@mit.edu" <tytso@mit.edu>,
        "david@fromorbit.com" <david@fromorbit.com>,
        "bpm@sgi.com" <bpm@sgi.com>, "olaf@sgi.com" <olaf@sgi.com>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <20180112071234.29470-14-krisman@collabora.co.uk>
Content-Language: en-US
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Hi Gabriel,

Short summary: you're calling functions that can return an error, but do not check for that.

Olaf

> -----Original Message-----
> From: Gabriel Krisman Bertazi [mailto:krisman@collabora.co.uk]
> Sent: Friday, January 12, 2018 08:13
> To: tytso@mit.edu; david@fromorbit.com; bpm@sgi.com; olaf@sgi.com
> Cc: linux-ext4@vger.kernel.org; linux-fsdevel@vger.kernel.org;
> kernel@lists.collabora.co.uk; alvaro.soliverez@collabora.co.uk; Gabriel
> Krisman Bertazi <krisman@collabora.co.uk>
> Subject: [PATCH RFC 13/13] ext4: Implement ext4 dcache hooks for custom
> charsets
> 
> Signed-off-by: Gabriel Krisman Bertazi <krisman@collabora.co.uk>
> ---
>  fs/ext4/dir.c   | 63
> +++++++++++++++++++++++++++++++++++++++++++++++++++++++++
>  fs/ext4/ext4.h  |  2 ++
>  fs/ext4/super.c |  5 +++++
>  3 files changed, 70 insertions(+)
> 
> diff --git a/fs/ext4/dir.c b/fs/ext4/dir.c
> index d5babc9f222b..8b73a68930d2 100644
> --- a/fs/ext4/dir.c
> +++ b/fs/ext4/dir.c
> @@ -25,6 +25,7 @@
>  #include <linux/fs.h>
>  #include <linux/buffer_head.h>
>  #include <linux/slab.h>
> +#include <linux/charsets.h>
>  #include "ext4.h"
>  #include "xattr.h"
> 
> @@ -661,3 +662,65 @@ const struct file_operations ext4_dir_operations = {
>  	.open		= ext4_dir_open,
>  	.release	= ext4_release_dir,
>  };
> +
> +static int ext4_d_hash(const struct dentry *dentry, struct qstr *q)
> +{
> +	unsigned long hash;
> +	int i, len;
> +	char *str;
> +	const struct charset *charset = EXT4_SB(dentry->d_sb)->encoding;
> +
> +	len = charset_normalize(charset, q->name, q->len, &str);

What if charset_normalize() returns an error?


> +
> +	hash = init_name_hash(dentry);
> +	for (i = 0; i < len; i++)
> +		hash = partial_name_hash(str[i], hash);
> +	q->hash = end_name_hash(hash);
> +
> +	kfree(str);
> +	return 0;
> +}
> +
> +static int ext4_d_compare(const struct dentry *dentry, unsigned int len,
> +			  const char *str, const struct qstr *name)
> +{
> +	const struct charset *charset = EXT4_SB(dentry->d_sb)->encoding;
> +
> +	return charset_strncmp(charset, str, name->name, len);
> +}
> +
> +const struct dentry_operations ext4_dentry_ops = {
> +	.d_hash = ext4_d_hash,
> +	.d_compare = ext4_d_compare,
> +};
> +
> +static int ext4_d_ci_hash(const struct dentry *dentry, struct qstr *q)
> +{
> +	unsigned long hash;
> +	int i, len;
> +	char *str;
> +	const struct charset *charset = EXT4_SB(dentry->d_sb)->encoding;
> +
> +	len = charset_casefold(charset, q->name, q->len, &str);

What if charset_casefold() returns an error?


> +
> +	hash = init_name_hash(dentry);
> +	for (i = 0; i < len; i++)
> +		hash = partial_name_hash(str[i], hash);
> +	q->hash = end_name_hash(hash);
> +
> +	kfree(str);
> +	return 0;
> +}
> +
> +static int ext4_d_ci_compare(const struct dentry *dentry, unsigned int len,
> +			     const char *str, const struct qstr *name)
> +{
> +	const struct charset *charset = EXT4_SB(dentry->d_sb)->encoding;
> +
> +	return charset_strncasecmp(charset, str, name->name, len);
> +}
> +
> +const struct dentry_operations ext4_ci_dentry_ops = {
> +	.d_hash = ext4_d_ci_hash,
> +	.d_compare = ext4_d_ci_compare,
> +};
> diff --git a/fs/ext4/ext4.h b/fs/ext4/ext4.h
> index 6c8aaf2dd322..980968aeb1cf 100644
> --- a/fs/ext4/ext4.h
> +++ b/fs/ext4/ext4.h
> @@ -2943,6 +2943,8 @@ static inline void ext4_unlock_group(struct
> super_block *sb,
> 
>  /* dir.c */
>  extern const struct file_operations ext4_dir_operations;
> +extern const struct dentry_operations ext4_dentry_ops;
> +extern const struct dentry_operations ext4_ci_dentry_ops;
> 
>  /* file.c */
>  extern const struct inode_operations ext4_file_inode_operations;
> diff --git a/fs/ext4/super.c b/fs/ext4/super.c
> index 022bf5f274b2..877acb938453 100644
> --- a/fs/ext4/super.c
> +++ b/fs/ext4/super.c
> @@ -4358,6 +4358,11 @@ static int ext4_fill_super(struct super_block *sb,
> void *data, int silent)
>  	if (es->s_error_count)
>  		mod_timer(&sbi->s_err_report, jiffies + 300*HZ); /* 5
> minutes */
> 
> +	if (test_opt2(sb, CASE_INSENSITIVE))
> +		sb->s_d_op = &ext4_ci_dentry_ops;
> +	else
> +		sb->s_d_op = &ext4_dentry_ops;
> +
>  	/* Enable message ratelimiting. Default is 10 messages per 5 secs. */
>  	ratelimit_state_init(&sbi->s_err_ratelimit_state, 5 * HZ, 10);
>  	ratelimit_state_init(&sbi->s_warning_ratelimit_state, 5 * HZ, 10);
> --
> 2.15.1
