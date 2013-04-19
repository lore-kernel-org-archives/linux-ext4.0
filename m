From: Zheng Liu <gnehzuil.liu@gmail.com>
Subject: Re: [PATCH] ext4: unregister extents status shrinker if mount failed
Date: Sat, 20 Apr 2013 06:26:53 +0800
Message-ID: <5171C4AD.2070905@gmail.com>
References: <1366409133-27567-1-git-send-email-khoroshilov@ispras.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: Theodore Ts'o <tytso@mit.edu>,
	Andreas Dilger <adilger.kernel@dilger.ca>,
	linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org,
	spruce-project@linuxtesting.org
To: Alexey Khoroshilov <khoroshilov@ispras.ru>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1366409133-27567-1-git-send-email-khoroshilov@ispras.ru>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On 04/20/2013 06:05 AM, Alexey Khoroshilov wrote:
> If ext4_fill_super() failed after extents status shrinker
> has been registered, the shrinker is left in a global list
> while the memory, it sits in, is already freed.
> Oops is not so bad scenario after that.
> 
> Found by Linux File System Verification project (linuxtesting.org).
> 
> Signed-off-by: Alexey Khoroshilov <khoroshilov@ispras.ru>

Thanks for your patch.  This problem has been fixed in dev branch of
ext4 tree, but has not push into mainline kernel yet.  Here is the
commit id (a75ae78f087f933ab3432e98bb4dbbf2196cf6d5).

Thanks,
						- Zheng

> ---
>  fs/ext4/super.c |    6 ++++--
>  1 file changed, 4 insertions(+), 2 deletions(-)
> 
> diff --git a/fs/ext4/super.c b/fs/ext4/super.c
> index 5d6d5357..5f9cb30 100644
> --- a/fs/ext4/super.c
> +++ b/fs/ext4/super.c
> @@ -3757,7 +3757,7 @@ static int ext4_fill_super(struct super_block *sb, void *data, int silent)
>  	if (EXT4_HAS_INCOMPAT_FEATURE(sb, EXT4_FEATURE_INCOMPAT_MMP) &&
>  	    !(sb->s_flags & MS_RDONLY))
>  		if (ext4_multi_mount_protect(sb, le64_to_cpu(es->s_mmp_block)))
> -			goto failed_mount3;
> +			goto failed_mount_shr;
>  
>  	/*
>  	 * The first inode we look at is the journal inode.  Don't try
> @@ -3766,7 +3766,7 @@ static int ext4_fill_super(struct super_block *sb, void *data, int silent)
>  	if (!test_opt(sb, NOLOAD) &&
>  	    EXT4_HAS_COMPAT_FEATURE(sb, EXT4_FEATURE_COMPAT_HAS_JOURNAL)) {
>  		if (ext4_load_journal(sb, es, journal_devnum))
> -			goto failed_mount3;
> +			goto failed_mount_shr;
>  	} else if (test_opt(sb, NOLOAD) && !(sb->s_flags & MS_RDONLY) &&
>  	      EXT4_HAS_INCOMPAT_FEATURE(sb, EXT4_FEATURE_INCOMPAT_RECOVER)) {
>  		ext4_msg(sb, KERN_ERR, "required journal recovery "
> @@ -4009,6 +4009,8 @@ failed_mount_wq:
>  		jbd2_journal_destroy(sbi->s_journal);
>  		sbi->s_journal = NULL;
>  	}
> +failed_mount_shr:
> +	ext4_es_unregister_shrinker(sb);
>  failed_mount3:
>  	del_timer(&sbi->s_err_report);
>  	if (sbi->s_flex_groups)
> 
