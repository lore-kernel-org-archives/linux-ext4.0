From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: [PATCH] ext4: Check dioread_nolock on remount
Date: Mon, 17 Dec 2012 09:43:12 -0600
Message-ID: <50CF3D90.60408@redhat.com>
References: <1355434842-13478-1-git-send-email-jack@suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: Ted Tso <tytso@mit.edu>, linux-ext4@vger.kernel.org
To: Jan Kara <jack@suse.cz>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:58964 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752179Ab2LQPn5 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 17 Dec 2012 10:43:57 -0500
In-Reply-To: <1355434842-13478-1-git-send-email-jack@suse.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 12/13/12 3:40 PM, Jan Kara wrote:
> Currently we allow enabling dioread_nolock mount option on remount for
> filesystems where blocksize < PAGE_CACHE_SIZE. This isn't really supported so
> fix the bug by moving the check for blocksize != PAGE_CACHE_SIZE into
> parse_options(). Change the original PAGE_SIZE to PAGE_CACHE_SIZE along the way
> because that's what we are really interested in.
> 
> Signed-off-by: Jan Kara <jack@suse.cz>

Looks good to me,

Reviewed-by: Eric Sandeen <sandeen@redhat.com>

> ---
>  fs/ext4/super.c |   22 +++++++++++-----------
>  1 files changed, 11 insertions(+), 11 deletions(-)
> 
> diff --git a/fs/ext4/super.c b/fs/ext4/super.c
> index 80928f7..9753ed2 100644
> --- a/fs/ext4/super.c
> +++ b/fs/ext4/super.c
> @@ -1650,9 +1650,7 @@ static int parse_options(char *options, struct super_block *sb,
>  			 unsigned int *journal_ioprio,
>  			 int is_remount)
>  {
> -#ifdef CONFIG_QUOTA
>  	struct ext4_sb_info *sbi = EXT4_SB(sb);
> -#endif
>  	char *p;
>  	substring_t args[MAX_OPT_ARGS];
>  	int token;
> @@ -1701,6 +1699,16 @@ static int parse_options(char *options, struct super_block *sb,
>  		}
>  	}
>  #endif
> +	if (test_opt(sb, DIOREAD_NOLOCK)) {
> +		int blocksize =
> +			BLOCK_SIZE << le32_to_cpu(sbi->s_es->s_log_block_size);
> +
> +		if (blocksize < PAGE_CACHE_SIZE) {
> +			ext4_msg(sb, KERN_ERR, "can't mount with "
> +				 "dioread_nolock if block size != PAGE_SIZE");
> +			return 0;
> +		}
> +	}
>  	return 1;
>  }
>  
> @@ -3446,15 +3454,6 @@ static int ext4_fill_super(struct super_block *sb, void *data, int silent)
>  			clear_opt(sb, DELALLOC);
>  	}
>  
> -	blocksize = BLOCK_SIZE << le32_to_cpu(es->s_log_block_size);
> -	if (test_opt(sb, DIOREAD_NOLOCK)) {
> -		if (blocksize < PAGE_SIZE) {
> -			ext4_msg(sb, KERN_ERR, "can't mount with "
> -				 "dioread_nolock if block size != PAGE_SIZE");
> -			goto failed_mount;
> -		}
> -	}
> -
>  	sb->s_flags = (sb->s_flags & ~MS_POSIXACL) |
>  		(test_opt(sb, POSIX_ACL) ? MS_POSIXACL : 0);
>  
> @@ -3496,6 +3495,7 @@ static int ext4_fill_super(struct super_block *sb, void *data, int silent)
>  	if (!ext4_feature_set_ok(sb, (sb->s_flags & MS_RDONLY)))
>  		goto failed_mount;
>  
> +	blocksize = BLOCK_SIZE << le32_to_cpu(es->s_log_block_size);
>  	if (blocksize < EXT4_MIN_BLOCK_SIZE ||
>  	    blocksize > EXT4_MAX_BLOCK_SIZE) {
>  		ext4_msg(sb, KERN_ERR,
> 

