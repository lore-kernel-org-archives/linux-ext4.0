From: Carlos Maiolino <cmaiolino@redhat.com>
Subject: Re: ext4_wait_block_bitmap() and ext4_read_block_bitmap_nowait()
 handle bitmap verification differently
Date: Fri, 4 Oct 2013 11:04:08 -0300
Message-ID: <20131004140407.GA1348@orion.maiolino.org>
References: <CAGW2f1HsP1s+Avuiietg1BqqNeEJJ8g1MOgxHnx-8hqK57QG7Q@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: "linux-ext4@vger.kernel.org List" <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:2713 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754319Ab3JDOEN (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 4 Oct 2013 10:04:13 -0400
Received: from int-mx02.intmail.prod.int.phx2.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id r94E4C9L002898
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-ext4@vger.kernel.org>; Fri, 4 Oct 2013 10:04:13 -0400
Received: from orion.maiolino.org (ovpn-113-147.phx2.redhat.com [10.3.113.147])
	by int-mx02.intmail.prod.int.phx2.redhat.com (8.13.8/8.13.8) with ESMTP id r94E490h019278
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES128-SHA bits=128 verify=NO)
	for <linux-ext4@vger.kernel.org>; Fri, 4 Oct 2013 10:04:11 -0400
Content-Disposition: inline
In-Reply-To: <CAGW2f1HsP1s+Avuiietg1BqqNeEJJ8g1MOgxHnx-8hqK57QG7Q@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi,

looks like that, with this patch, ext4_read_block_bitmap_nowait() might sleep in
wait_on_buffer() called from ext4_wait_block_bitmap(), which is not really the
intention of ext4_read_block_bitmap_nowait().

Am I wrong here or this might really happen?


On Thu, Oct 03, 2013 at 10:45:06PM -0400, jon ernst wrote:
> Hi,
> 
> I found that ext4_wait_block_bitmap() and
> ext4_read_block_bitmap_nowait() handle bitmap verification
> differently.
> wait_block_bitmap() calls ext4_validate_block_bitmap() all the time.
> But  read_block_bitmap_nowait() checks EXT4_BG_BLOCK_UNINIT, if it
> meets, it will skip ext4_validate_block_bitmap()
> 
> In my opinion, they'd better do same thing.
> In that way, we can also return "fail" in ext4_valid_block_bitmap()
> method when we meet FLEX_BG.
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

-- 
Carlos
