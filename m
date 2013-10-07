From: =?ISO-8859-15?Q?Luk=E1=A8_Czerner?= <lczerner@redhat.com>
Subject: Re: ext4_wait_block_bitmap() and ext4_read_block_bitmap_nowait()
 handle bitmap verification differently
Date: Mon, 7 Oct 2013 16:11:47 +0200 (CEST)
Message-ID: <alpine.LFD.2.00.1310071605020.1975@localhost.localdomain>
References: <CAGW2f1HsP1s+Avuiietg1BqqNeEJJ8g1MOgxHnx-8hqK57QG7Q@mail.gmail.com> <alpine.LFD.2.00.1310071358400.1975@localhost.localdomain> <CAGW2f1G1=LE4B-BtT5oZidfW0SUO9rgN0dsKY4tLD2nLNFsYUQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="8323328-642098078-1381155110=:1975"
Cc: "linux-ext4@vger.kernel.org List" <linux-ext4@vger.kernel.org>
To: jon ernst <jonernst07@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:61935 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754532Ab3JGOLv (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 7 Oct 2013 10:11:51 -0400
In-Reply-To: <CAGW2f1G1=LE4B-BtT5oZidfW0SUO9rgN0dsKY4tLD2nLNFsYUQ@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--8323328-642098078-1381155110=:1975
Content-Type: TEXT/PLAIN; charset=UTF-8
Content-Transfer-Encoding: 8BIT

On Mon, 7 Oct 2013, jon ernst wrote:

> Date: Mon, 7 Oct 2013 10:03:55 -0400
> From: jon ernst <jonernst07@gmail.com>
> To: Lukáš Czerner <lczerner@redhat.com>
> Cc: "linux-ext4@vger.kernel.org List" <linux-ext4@vger.kernel.org>
> Subject: Re: ext4_wait_block_bitmap() and ext4_read_block_bitmap_nowait()
>     handle bitmap verification differently
> 
> On Mon, Oct 7, 2013 at 8:45 AM, Lukáš Czerner <lczerner@redhat.com> wrote:
> > On Thu, 3 Oct 2013, jon ernst wrote:
> >
> >> Date: Thu, 3 Oct 2013 22:45:06 -0400
> >> From: jon ernst <jonernst07@gmail.com>
> >> To: "linux-ext4@vger.kernel.org List" <linux-ext4@vger.kernel.org>
> >> Subject: ext4_wait_block_bitmap() and ext4_read_block_bitmap_nowait() handle
> >>     bitmap verification differently
> >>
> >> Hi,
> >
> > Hi Jon,
> >
> > Btw the patch has some issues and it seems to be badly formatted, or
> > even corrupted. You're also missing some Signed-off-by line and the
> > subject is not good either. Please see
> > Documentation/SubmittingPatches, use git to create patches and use
> > email client which does not automatically wrap your lines.
> 
> Thanks for your instruction. I will pay attention.
> >
> >>
> >> I found that ext4_wait_block_bitmap() and
> >> ext4_read_block_bitmap_nowait() handle bitmap verification
> >> differently.
> >> wait_block_bitmap() calls ext4_validate_block_bitmap() all the time.
> >> But  read_block_bitmap_nowait() checks EXT4_BG_BLOCK_UNINIT, if it
> >> meets, it will skip ext4_validate_block_bitmap()
> >>
> >> In my opinion, they'd better do same thing.
> >
> > Why ?
> >
> >> In that way, we can also return "fail" in ext4_valid_block_bitmap()
> >> method when we meet FLEX_BG.
> >
> > This does not make sense at all. Why do you suggest that we should
> > "fail" in the case that we have FLEG_BG feature enabled (which is
> > default btw) ?
> >
> 
> I was thinking when we have FLEG_BG feature enabled, we actually don't
> have valid bitmap in that block. So semantically , we don't have valid
> block bitmap there.

Well, yes. We do not have a valid bitmap simply because the bitmap
may not be there in the first place. And if there is no bitmap it
can not be invalid. So in the case there may be no bitmap we just
skip this one. I think that the comment in the code explains quite
well why we return 0, so I do not think there is a problem which
needs fixing.

Also this patch looks entirely untested. You can always use xfstests
on the ext4 file system with your changes to make sure that it does
not break anything.

Thanks!
-Lukas

> 
> >>
> >>
> >>
> >> diff --git a/fs/ext4/balloc.c b/fs/ext4/balloc.c
> >> index dc5d572..366807a 100644
> >> --- a/fs/ext4/balloc.c
> >> +++ b/fs/ext4/balloc.c
> >> @@ -319,7 +319,7 @@ static ext4_fsblk_t ext4_valid_block_bitmap(struct
> >> super_block *sb,
> >>                  * or it has to also read the block group where the bitmaps
> >>                  * are located to verify they are set.
> >>                  */
> >> -               return 0;
> >> +               return 1;
> >>         }
> >>         group_first_block = ext4_group_first_block_no(sb, block_group);
> >>
> >> @@ -472,8 +472,12 @@ int ext4_wait_block_bitmap(struct super_block
> >> *sb, ext4_group_t block_group,
> >>                 return 1;
> >>         }
> >>         clear_buffer_new(bh);
> >> -       /* Panic or remount fs read-only if block bitmap is invalid */
> >> -       ext4_validate_block_bitmap(sb, desc, block_group, bh);
> >> +
> >> +       if (desc->bg_flags & cpu_to_le16(EXT4_BG_BLOCK_UNINIT)) {
> >> +        return 0;
> >
> > This is wrong from multiple reasons. First of all you're not holding
> > group lock so what is preventing others to actually initialize the
> > bitmap before you return 0 ?
> >
> Got it.
> 
> > Secondly, uninit group will never get that far, because it'll be
> > initialized in ext4_read_block_bitmap_nowait() and we will not
> > actually need to wait for the buffer.
> >
> 
> Thank you! Very helpful information.
> 
> Best,
> Jon
> 
> > Thanks!
> > -Lukas
> >
> >> +        }
> >> +       /* Panic or remount fs read-only if block bitmap is invalid */
> >> +       ext4_validate_block_bitmap(sb, desc, block_group, bh);
> >>         /* ...but check for error just in case errors=continue. */
> >>         return !buffer_verified(bh);
> >>  }
> >> --
> >> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> >> the body of a message to majordomo@vger.kernel.org
> >> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> >>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
--8323328-642098078-1381155110=:1975--
