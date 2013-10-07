From: =?ISO-8859-15?Q?Luk=E1=A8_Czerner?= <lczerner@redhat.com>
Subject: Re: ext4_wait_block_bitmap() and ext4_read_block_bitmap_nowait()
 handle bitmap verification differently
Date: Mon, 7 Oct 2013 14:45:49 +0200 (CEST)
Message-ID: <alpine.LFD.2.00.1310071358400.1975@localhost.localdomain>
References: <CAGW2f1HsP1s+Avuiietg1BqqNeEJJ8g1MOgxHnx-8hqK57QG7Q@mail.gmail.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: "linux-ext4@vger.kernel.org List" <linux-ext4@vger.kernel.org>
To: jon ernst <jonernst07@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:5622 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751520Ab3JGMp5 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 7 Oct 2013 08:45:57 -0400
In-Reply-To: <CAGW2f1HsP1s+Avuiietg1BqqNeEJJ8g1MOgxHnx-8hqK57QG7Q@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, 3 Oct 2013, jon ernst wrote:

> Date: Thu, 3 Oct 2013 22:45:06 -0400
> From: jon ernst <jonernst07@gmail.com>
> To: "linux-ext4@vger.kernel.org List" <linux-ext4@vger.kernel.org>
> Subject: ext4_wait_block_bitmap() and ext4_read_block_bitmap_nowait() handle
>     bitmap verification differently
> 
> Hi,

Hi Jon,

Btw the patch has some issues and it seems to be badly formatted, or
even corrupted. You're also missing some Signed-off-by line and the
subject is not good either. Please see
Documentation/SubmittingPatches, use git to create patches and use
email client which does not automatically wrap your lines.

> 
> I found that ext4_wait_block_bitmap() and
> ext4_read_block_bitmap_nowait() handle bitmap verification
> differently.
> wait_block_bitmap() calls ext4_validate_block_bitmap() all the time.
> But  read_block_bitmap_nowait() checks EXT4_BG_BLOCK_UNINIT, if it
> meets, it will skip ext4_validate_block_bitmap()
> 
> In my opinion, they'd better do same thing.

Why ?

> In that way, we can also return "fail" in ext4_valid_block_bitmap()
> method when we meet FLEX_BG.

This does not make sense at all. Why do you suggest that we should
"fail" in the case that we have FLEG_BG feature enabled (which is
default btw) ?

> 
> 
> 
> diff --git a/fs/ext4/balloc.c b/fs/ext4/balloc.c
> index dc5d572..366807a 100644
> --- a/fs/ext4/balloc.c
> +++ b/fs/ext4/balloc.c
> @@ -319,7 +319,7 @@ static ext4_fsblk_t ext4_valid_block_bitmap(struct
> super_block *sb,
>                  * or it has to also read the block group where the bitmaps
>                  * are located to verify they are set.
>                  */
> -               return 0;
> +               return 1;
>         }
>         group_first_block = ext4_group_first_block_no(sb, block_group);
> 
> @@ -472,8 +472,12 @@ int ext4_wait_block_bitmap(struct super_block
> *sb, ext4_group_t block_group,
>                 return 1;
>         }
>         clear_buffer_new(bh);
> -       /* Panic or remount fs read-only if block bitmap is invalid */
> -       ext4_validate_block_bitmap(sb, desc, block_group, bh);
> +
> +       if (desc->bg_flags & cpu_to_le16(EXT4_BG_BLOCK_UNINIT)) {
> +        return 0;

This is wrong from multiple reasons. First of all you're not holding
group lock so what is preventing others to actually initialize the
bitmap before you return 0 ?

Secondly, uninit group will never get that far, because it'll be
initialized in ext4_read_block_bitmap_nowait() and we will not
actually need to wait for the buffer.

Thanks!
-Lukas

> +        }
> +       /* Panic or remount fs read-only if block bitmap is invalid */
> +       ext4_validate_block_bitmap(sb, desc, block_group, bh);
>         /* ...but check for error just in case errors=continue. */
>         return !buffer_verified(bh);
>  }
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
