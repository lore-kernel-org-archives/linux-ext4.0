From: Andreas Dilger <adilger@dilger.ca>
Subject: Re: [PATCH] ext4: Fix missing iput for root inode in case of all failed mount paths.
Date: Sun, 16 Jan 2011 09:20:39 -0700
Message-ID: <032DF412-6B37-4EB7-A687-8216CB1E2BAB@dilger.ca>
References: <AANLkTik8jweuA_kDfzY7H=wP-ikSSwdf-FF1NX09DDCT@mail.gmail.com>
Mime-Version: 1.0 (iPhone Mail 8C148a)
Content-Type: text/plain;
	charset=us-ascii
Content-Transfer-Encoding: 8BIT
Cc: Theodore Ts'o <tytso@mit.edu>, ext4 <linux-ext4@vger.kernel.org>,
	"mkatiyar@gmail.com" <mkatiyar@gmail.com>
To: Manish Katiyar <mkatiyar@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from idcmail-mo1so.shaw.ca ([24.71.223.10]:11383 "EHLO
	idcmail-mo1so.shaw.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753190Ab1APQUK convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sun, 16 Jan 2011 11:20:10 -0500
In-Reply-To: <AANLkTik8jweuA_kDfzY7H=wP-ikSSwdf-FF1NX09DDCT@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Why not just put the iput() at failed_mount4() instead of spread around the code?

Cheers, Andreas

On 2011-01-16, at 0:30, Manish Katiyar <mkatiyar@gmail.com> wrote:

> Fix missing iput for root inode in case of all failed mount paths.
> Fixes bug#26752
> 
> Signed-off-by: Manish Katiyar <mkatiyar@gmail.com>
> 
> ---
> fs/ext4/super.c |    8 +++++++-
> 1 files changed, 7 insertions(+), 1 deletions(-)
> 
> diff --git a/fs/ext4/super.c b/fs/ext4/super.c
> index cb10a06..9570fcc 100644
> --- a/fs/ext4/super.c
> +++ b/fs/ext4/super.c
> @@ -3587,6 +3587,7 @@ no_journal:
>        if (err) {
>                ext4_msg(sb, KERN_ERR, "failed to initialize system "
>                         "zone (%d)", err);
> +               iput(root);
>                goto failed_mount4;
>        }
> 
> @@ -3595,12 +3596,15 @@ no_journal:
>        if (err) {
>                ext4_msg(sb, KERN_ERR, "failed to initialize mballoc (%d)",
>                         err);
> +               iput(root);
>                goto failed_mount4;
>        }
> 
>        err = ext4_register_li_request(sb, first_not_zeroed);
> -       if (err)
> +       if (err) {
> +               iput(root);
>                goto failed_mount4;
> +       }
> 
>        sbi->s_kobj.kset = ext4_kset;
>        init_completion(&sbi->s_kobj_unregister);
> @@ -3609,6 +3613,7 @@ no_journal:
>        if (err) {
>                ext4_mb_release(sb);
>                ext4_ext_release(sb);
> +               iput(root);
>                goto failed_mount4;
>        };
> 
> @@ -3648,6 +3653,7 @@ cantfind_ext4:
>        goto failed_mount;
> 
> failed_mount4:
> +       sb->s_root = NULL;
>        ext4_msg(sb, KERN_ERR, "mount failed");
>        destroy_workqueue(EXT4_SB(sb)->dio_unwritten_wq);
> failed_mount_wq:
> -- 
> 1.7.1
> 
> 
> -- 
> Thanks -
> Manish
> ==================================
> [$\*.^ -- I miss being one of them
> ==================================
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
