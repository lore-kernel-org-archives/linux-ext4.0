From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: EXT3 file system with unsupported revision level can be mounted
 in R/W mode
Date: Wed, 27 Aug 2008 15:02:04 -0500
Message-ID: <48B5B2BC.4050303@redhat.com>
References: <4885AFBF.2010409@uniadex.co.jp> <48A90371.6070700@uniadex.co.jp> <48A9439C.4010007@uniadex.co.jp>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org
To: Tadao Uchiyama <Tadao.Uchiyama@uniadex.co.jp>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx2.redhat.com ([66.187.237.31]:56617 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750784AbYH0UDc (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 27 Aug 2008 16:03:32 -0400
In-Reply-To: <48A9439C.4010007@uniadex.co.jp>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


> Since the patch described in my previous response was formatted inappropriately with no indents, let
> me please send it here again.
> 
> Thanks.
> Signed-off-by :Tadao Uchiyama <Tadao.Uchiyama@uniadex.co.jp>
> 
> ----------
> diff -up linux-2.6.26.2/fs/ext3/super.c.orig linux-2.6.26.2/fs/ext3/super.c

For what it's worth, ext2 and ext4 have the same problems...

> --- linux-2.6.26.2/fs/ext3/super.c.orig 2008-08-18 11:01:02.000000000 +0900
> +++ linux-2.6.26.2/fs/ext3/super.c      2008-08-18 11:06:29.000000000 +0900
> @@ -1898,7 +1898,8 @@ static int ext3_fill_super (struct super
>                 goto failed_mount4;
>         }
> 
> -       ext3_setup_super (sb, es, sb->s_flags & MS_RDONLY);
> +       if (ext3_setup_super (sb, es, sb->s_flags & MS_RDONLY))
> +                sb->s_flags |= MS_RDONLY;
>         /*
>          * akpm: core read_super() calls in here with the superblock locked.
>          * That deadlocks, because orphan cleanup needs to lock the superblock
> @@ -2506,8 +2507,8 @@ static int ext3_remount (struct super_bl
>                         sbi->s_mount_state = le16_to_cpu(es->s_state);
>                         if ((err = ext3_group_extend(sb, es, n_blocks_count)))

One other thing I worry about; we are doing group_extend before we check
the revision.  Is that safe?  We also still do things like replay the
journal and process orphan inodes before checking the revision.

Should we even worry about this, or is the revision level never going to
change again, and we can almost just ignore it now?  (or assume that for
recent kernels, a too-high rev level indicates corruption and fail the
mount?)

-Eric

>                                 goto restore_opts;
> -                       if (!ext3_setup_super (sb, es, 0))
> -                               sb->s_flags &= ~MS_RDONLY;
> +                       if (ext3_setup_super (sb, es, 0))
> +                               *flags &= ~MS_RDONLY;
>                 }
>         }
>  #ifdef CONFIG_QUOTA
> ----------
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

