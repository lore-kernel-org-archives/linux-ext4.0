From: "Peng tao" <bergwolf@gmail.com>
Subject: Re: [PATCH] do not set extents feature from the kernel
Date: Tue, 8 Jul 2008 10:23:28 +0800
Message-ID: <6149e97b0807071923t62379bf0qc682c6cbc15e1380@mail.gmail.com>
References: <48727954.1080406@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Cc: "ext4 development" <linux-ext4@vger.kernel.org>
To: "Eric Sandeen" <sandeen@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from wa-out-1112.google.com ([209.85.146.180]:58986 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755408AbYGHCXf (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 7 Jul 2008 22:23:35 -0400
Received: by wa-out-1112.google.com with SMTP id j37so1505056waf.23
        for <linux-ext4@vger.kernel.org>; Mon, 07 Jul 2008 19:23:28 -0700 (PDT)
In-Reply-To: <48727954.1080406@redhat.com>
Content-Disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi, Eric

On Tue, Jul 8, 2008 at 4:15 AM, Eric Sandeen <sandeen@redhat.com> wrote:
> We've talked for a while about getting rid of any feature-
> setting from the kernel; this gets rid of the code which would
> set the INCOMPAT_EXTENTS flag on the first file write when mounted
> as ext4[dev].
>
> With this patch, if the extents feature is not already set on disk,
> then mounting as ext4 will fall back to noextents with a warning,
> and if -o extents is explicitly requested, the mount will fail,
> also with warning.
Does this mean no more migration from ext3 to ext4?
>
> Does this seem like a decent approach?
>
> Signed-off-by: Eric Sandeen <sandeen@redhat.com>
> ---
>
> Index: linux-2.6/fs/ext4/ialloc.c
> ===================================================================
> --- linux-2.6.orig/fs/ext4/ialloc.c     2008-07-07 10:22:00.000000000 -0500
> +++ linux-2.6/fs/ext4/ialloc.c  2008-07-07 12:07:02.133292077 -0500
> @@ -740,14 +740,10 @@ got:
>                goto fail_free_drop;
>
>        if (test_opt(sb, EXTENTS)) {
> -               /* set extent flag only for diretory, file and normal symlink*/
> +               /* set extent flag only for directory, file and normal symlink*/
>                if (S_ISDIR(mode) || S_ISREG(mode) || S_ISLNK(mode)) {
>                        EXT4_I(inode)->i_flags |= EXT4_EXTENTS_FL;
>                        ext4_ext_tree_init(handle, inode);
> -                       err = ext4_update_incompat_feature(handle, sb,
> -                                       EXT4_FEATURE_INCOMPAT_EXTENTS);
> -                       if (err)
> -                               goto fail_free_drop;
>                }
>        }
>
> Index: linux-2.6/fs/ext4/super.c
> ===================================================================
> --- linux-2.6.orig/fs/ext4/super.c      2008-07-07 10:22:19.000000000 -0500
> +++ linux-2.6/fs/ext4/super.c   2008-07-07 14:08:43.684291817 -0500
> @@ -1309,6 +1309,13 @@ set_qf_format:
>                        clear_opt(sbi->s_mount_opt, NOBH);
>                        break;
>                case Opt_extents:
> +                       if (!EXT4_HAS_INCOMPAT_FEATURE(sb,
> +                                       EXT4_FEATURE_INCOMPAT_EXTENTS)) {
> +                               ext4_warning(sb, __func__,
> +                                       "extents feature not enabled "
> +                                       "on this filesystem, use tune2fs\n");
> +                               return 0;
> +                       }
>                        set_opt (sbi->s_mount_opt, EXTENTS);
>                        break;
>                case Opt_noextents:
> @@ -1919,12 +1926,18 @@ static int ext4_fill_super (struct super
>
>        /*
>         * turn on extents feature by default in ext4 filesystem
> -        * User -o noextents to turn it off
> +        * only if feature flag already set by mkfs or tune2fs.
> +        * Use -o noextents to turn it off
>         */
> -       set_opt(sbi->s_mount_opt, EXTENTS);
> +       if (EXT4_HAS_INCOMPAT_FEATURE(sb, EXT4_FEATURE_INCOMPAT_EXTENTS))
> +               set_opt(sbi->s_mount_opt, EXTENTS);
> +       else
> +               ext4_warning(sb, __func__,
> +                       "extents feature not enabled on this filesystem, "
> +                       "use tune2fs.\n");
>        /*
> -        * turn on mballoc feature by default in ext4 filesystem
> -        * User -o nomballoc to turn it off
> +        * turn on mballoc code by default in ext4 filesystem
> +        * Use -o nomballoc to turn it off
>         */
>        set_opt(sbi->s_mount_opt, MBALLOC);
>
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>



-- 
RGDS

Bergwolf

................
Here lieth one whose name was writ on water.
