From: Tadao Uchiyama <Tadao.Uchiyama@uniadex.co.jp>
Subject: Re: EXT3 file system with unsupported revision level can be mounted
 in R/W mode
Date: Mon, 18 Aug 2008 18:40:44 +0900
Message-ID: <48A9439C.4010007@uniadex.co.jp>
References: <4885AFBF.2010409@uniadex.co.jp> <48A90371.6070700@uniadex.co.jp>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-2022-JP"
Content-Transfer-Encoding: 7bit
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from igw03.unisys.co.jp ([202.233.47.13]:55474 "EHLO
	igw03.unisys.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751514AbYHRJ1v (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 18 Aug 2008 05:27:51 -0400
In-Reply-To: <48A90371.6070700@uniadex.co.jp>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

> ----------
> diff -up linux-2.6.26.2/fs/ext3/super.c.orig linux-2.6.26.2/fs/ext3/super.c
> --- linux-2.6.26.2/fs/ext3/super.c.orig 2008-08-18 11:01:02.000000000 +0900
> +++ linux-2.6.26.2/fs/ext3/super.c 2008-08-18 11:06:29.000000000 +0900
> @@ -1898,7 +1898,8 @@ static int ext3_fill_super (struct super
> goto failed_mount4;
> }
> 
> - ext3_setup_super (sb, es, sb->s_flags & MS_RDONLY);
> + if (ext3_setup_super (sb, es, sb->s_flags & MS_RDONLY))
> + sb->s_flags |= MS_RDONLY;
> /*
> * akpm: core read_super() calls in here with the superblock locked.
> * That deadlocks, because orphan cleanup needs to lock the superblock
> @@ -2506,8 +2507,8 @@ static int ext3_remount (struct super_bl
> sbi->s_mount_state = le16_to_cpu(es->s_state);
> if ((err = ext3_group_extend(sb, es, n_blocks_count)))
> goto restore_opts;
> - if (!ext3_setup_super (sb, es, 0))
> - sb->s_flags &= ~MS_RDONLY;
> + if (ext3_setup_super (sb, es, 0))
> + *flags &= ~MS_RDONLY;
> }
> }
> #ifdef CONFIG_QUOTA
> ----------
> 

Since the patch described in my previous response was formatted inappropriately with no indents, let
me please send it here again.

Thanks.
Signed-off-by :Tadao Uchiyama <Tadao.Uchiyama@uniadex.co.jp>

----------
diff -up linux-2.6.26.2/fs/ext3/super.c.orig linux-2.6.26.2/fs/ext3/super.c
--- linux-2.6.26.2/fs/ext3/super.c.orig 2008-08-18 11:01:02.000000000 +0900
+++ linux-2.6.26.2/fs/ext3/super.c      2008-08-18 11:06:29.000000000 +0900
@@ -1898,7 +1898,8 @@ static int ext3_fill_super (struct super
                goto failed_mount4;
        }

-       ext3_setup_super (sb, es, sb->s_flags & MS_RDONLY);
+       if (ext3_setup_super (sb, es, sb->s_flags & MS_RDONLY))
+                sb->s_flags |= MS_RDONLY;
        /*
         * akpm: core read_super() calls in here with the superblock locked.
         * That deadlocks, because orphan cleanup needs to lock the superblock
@@ -2506,8 +2507,8 @@ static int ext3_remount (struct super_bl
                        sbi->s_mount_state = le16_to_cpu(es->s_state);
                        if ((err = ext3_group_extend(sb, es, n_blocks_count)))
                                goto restore_opts;
-                       if (!ext3_setup_super (sb, es, 0))
-                               sb->s_flags &= ~MS_RDONLY;
+                       if (ext3_setup_super (sb, es, 0))
+                               *flags &= ~MS_RDONLY;
                }
        }
 #ifdef CONFIG_QUOTA
----------
