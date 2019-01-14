Return-Path: <SRS0=NmFT=PW=vger.kernel.org=linux-ext4-owner@kernel.org>
Received: from mail-vs1-f66.google.com ([209.85.217.66]:36178 "EHLO
        mail-vs1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726187AbfANKZT (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Mon, 14 Jan 2019 05:25:19 -0500
Received: by mail-vs1-f66.google.com with SMTP id v205so13283490vsc.3
        for <linux-ext4@vger.kernel.org>; Mon, 14 Jan 2019 02:25:18 -0800 (PST)
MIME-Version: 1.0
References: <CAMuHMdULrGHfgF+RRGf5gXAc=V3KaB4549NezxEc3CvfsKWOyA@mail.gmail.com>
 <1547339800-50257-1-git-send-email-adilger@dilger.ca>
In-Reply-To: <1547339800-50257-1-git-send-email-adilger@dilger.ca>
From: Geert Uytterhoeven <geert@linux-m68k.org>
Date: Mon, 14 Jan 2019 11:25:06 +0100
Message-ID: <CAMuHMdX+vHL5ZTq-PJFLSy+wW6y5fgtJR30Tdy6BtabeMMVyjg@mail.gmail.com>
Subject: Re: [PATCH] ext4: don't update s_rev_level if not required
To: Andreas Dilger <adilger@dilger.ca>
Cc: Theodore Tso <tytso@mit.edu>, linux-ext4@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi Andreas,

On Sun, Jan 13, 2019 at 1:36 AM Andreas Dilger <adilger@dilger.ca> wrote:
> Don't update the superblock s_rev_level during mount if it isn't
> actually necessary, only if superblock features are being set by
> the kernel.  This was originally added for ext3 since it always
> set the INCOMPAT_RECOVER and HAS_JOURNAL features during mount,
> but this is not needed since no journal mode was added to ext4.
>
> That will allow Geert to mount his 20-year-old ext2 rev 0.0 m68k
> filesystem, as a testament of the backward compatibility of ext4.
>
> Fixes: 0390131ba84f ("ext4: Allow ext4 to run without a journal")
> Signed-off-by: Andreas Dilger <adilger@dilger.ca>

Thanks for your patch!

> --- a/fs/ext4/ext4.h
> +++ b/fs/ext4/ext4.h
> @@ -1670,6 +1670,7 @@ static inline void ext4_clear_state_flags(struct ext4_inode_info *ei)
>  } \
>  static inline void ext4_set_feature_##name(struct super_block *sb) \
>  { \
> +       ext4_update_dynamic_rev(sb); \

This doesn't compile, as ext4_update_dynamic_rev() is used before its
declaration:

In file included from fs/ext4/bitmap.c:12:0:
fs/ext4/ext4.h: In function ‘ext4_set_feature_dir_prealloc’:
fs/ext4/ext4.h:1673:2: error: implicit declaration of function
‘ext4_update_dynamic_rev’ [-Werror=implicit-function-declaration]
  ext4_update_dynamic_rev(sb); \
  ^
fs/ext4/ext4.h:1719:1: note: in expansion of macro ‘EXT4_FEATURE_COMPAT_FUNCS’
 EXT4_FEATURE_COMPAT_FUNCS(dir_prealloc,  DIR_PREALLOC)
 ^~~~~~~~~~~~~~~~~~~~~~~~~
fs/ext4/ext4.h: At top level:
fs/ext4/ext4.h:2678:13: warning: conflicting types for ‘ext4_update_dynamic_rev’
 extern void ext4_update_dynamic_rev(struct super_block *sb);
             ^~~~~~~~~~~~~~~~~~~~~~~
fs/ext4/ext4.h:1673:2: note: previous implicit declaration of
‘ext4_update_dynamic_rev’ was here
  ext4_update_dynamic_rev(sb); \
  ^
fs/ext4/ext4.h:1719:1: note: in expansion of macro ‘EXT4_FEATURE_COMPAT_FUNCS’
 EXT4_FEATURE_COMPAT_FUNCS(dir_prealloc,  DIR_PREALLOC)
 ^~~~~~~~~~~~~~~~~~~~~~~~~

Moving the declaration up fixes that.

Hence with that fixed:
Tested-by: Geert Uytterhoeven <geert@linux-m68k.org>

Thanks!

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
