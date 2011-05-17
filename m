From: Lukas Czerner <lczerner@redhat.com>
Subject: Re: [PATCH] ext4: do not normalize block requests from fallocate.
Date: Tue, 17 May 2011 08:47:00 +0200 (CEST)
Message-ID: <alpine.LFD.2.00.1105170837260.3449@dhcp-27-109.brq.redhat.com>
References: <1305321545-17214-1-git-send-email-haldar@google.com> <alpine.LFD.2.00.1105161135260.3670@dhcp-27-109.brq.redhat.com> <BANLkTikWG_+aeVZUpBcfbqVoKvjRq4tbgQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="8323328-1657751038-1305614823=:3449"
Cc: Lukas Czerner <lczerner@redhat.com>,
	"Theodore Ts'o" <tytso@mit.edu>,
	Andreas Dilger <adilger.kernel@dilger.ca>,
	linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org
To: Vivek Haldar <haldar@google.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:39408 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751944Ab1EQGrI (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 17 May 2011 02:47:08 -0400
In-Reply-To: <BANLkTikWG_+aeVZUpBcfbqVoKvjRq4tbgQ@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--8323328-1657751038-1305614823=:3449
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT

On Mon, 16 May 2011, Vivek Haldar wrote:

> EXT4_GET_BLOCKS_* and EXT4_MB_HINT_* are different flag spaces and
> should not be mixed. ext4_ext_map_blocks should not be using
> EXT4_MB_HINT_*, it only uses EXT4_GET_BLOCKS_*.

Agh, yes you're right of course, somehow I just missed that
ext4_map_blocks() take separate flag argument and EXT4_GET_* flag might
use the same bit as EXT4_MB_HINT_NOPREALLOC. Sorry.

Thanks!
-Lukas

> 
> On Mon, May 16, 2011 at 2:39 AM, Lukas Czerner <lczerner@redhat.com> wrote:
> > On Fri, 13 May 2011, Vivek Haldar wrote:
> >
> >> Currently, an fallocate request of size slightly larger than a power of
> >> 2 is turned into two block requests, each a power of 2, with the extra
> >> blocks pre-allocated for future use. When an application calls
> >> fallocate, it already has an idea about how large the file may grow so
> >> there is usually little benefit to reserve extra blocks on the
> >> preallocation list. This reduces disk fragmentation.
> >>
> >> Tested: fsstress. Also verified manually that fallocat'ed files are
> >> contiguously laid out with this change (whereas without it they begin at
> >> power-of-2 boundaries, leaving blocks in between). CPU usage of
> >> fallocate is not appreciably higher. In a tight fallocate loop, CPU
> >> usage hovers between 5%-8% with this change, and 5%-7% without it.
> >
> > Hi Vivek,
> >
> > the patch looks good, but I do not understand why you are introducing
> > new #define when you can simply use EXT4_MB_HINT_NOPREALLOC and then in
> > the ext4_ext_map_blocks() just do :
> >
> > ar.flags |= (flags & EXT4_MB_HINT_NOPREALLOC)
> >
> > and you do not need to introduce new condition. Am I missing something ?
> >
> > Thanks!
> > -Lukas
> >
> >>
> >> Signed-off-by: Vivek Haldar <haldar@google.com>
> >> ---
> >>  fs/ext4/ext4.h    |    2 ++
> >>  fs/ext4/extents.c |    5 ++++-
> >>  2 files changed, 6 insertions(+), 1 deletions(-)
> >>
> >> diff --git a/fs/ext4/ext4.h b/fs/ext4/ext4.h
> >> index 076c5d2..e606d34 100644
> >> --- a/fs/ext4/ext4.h
> >> +++ b/fs/ext4/ext4.h
> >> @@ -512,6 +512,8 @@ struct ext4_new_group_data {
> >>       /* Convert extent to initialized after IO complete */
> >>  #define EXT4_GET_BLOCKS_IO_CONVERT_EXT               (EXT4_GET_BLOCKS_CONVERT|\
> >>                                        EXT4_GET_BLOCKS_CREATE_UNINIT_EXT)
> >> +     /* Don't normalize when fallocat'ing */
> >> +#define EXT4_GET_BLOCKS_NO_NORMALIZE         0x0020
> >>
> >>  /*
> >>   * Flags used by ext4_free_blocks
> >> diff --git a/fs/ext4/extents.c b/fs/ext4/extents.c
> >> index e363f21..f02dd52 100644
> >> --- a/fs/ext4/extents.c
> >> +++ b/fs/ext4/extents.c
> >> @@ -3304,6 +3304,8 @@ int ext4_ext_map_blocks(handle_t *handle, struct inode *inode,
> >>       else
> >>               /* disable in-core preallocation for non-regular files */
> >>               ar.flags = 0;
> >> +     if (flags & EXT4_GET_BLOCKS_NO_NORMALIZE)
> >> +             ar.flags |= EXT4_MB_HINT_NOPREALLOC;
> >>       newblock = ext4_mb_new_blocks(handle, &ar, &err);
> >>       if (!newblock)
> >>               goto out2;
> >> @@ -3549,7 +3551,8 @@ retry:
> >>                       break;
> >>               }
> >>               ret = ext4_map_blocks(handle, inode, &map,
> >> -                                   EXT4_GET_BLOCKS_CREATE_UNINIT_EXT);
> >> +                                   EXT4_GET_BLOCKS_CREATE_UNINIT_EXT |
> >> +                                   EXT4_GET_BLOCKS_NO_NORMALIZE);
> >>               if (ret <= 0) {
> >>  #ifdef EXT4FS_DEBUG
> >>                       WARN_ON(ret <= 0);
> >>
> >
> > --
> >
> 
> 
> 
> 

-- 
--8323328-1657751038-1305614823=:3449--
