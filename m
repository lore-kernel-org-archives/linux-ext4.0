From: Lukas Czerner <lczerner@redhat.com>
Subject: Re: [BUG] copy file result with zero
Date: Mon, 3 Oct 2011 15:11:30 +0200 (CEST)
Message-ID: <alpine.LFD.2.00.1110031500430.4447@dhcp-27-109.brq.redhat.com>
References: <CABqxG0feuZCmx=RfxU-50uFK9-P2vNbAMqJUdWM5RhuJifD5Ow@mail.gmail.com> <20111001143900.GH28234@thunk.org> <CABqxG0eiRiCSirXi5rBB0bJ2AJSQjF2dje2BcjbVYEYWgf-zpw@mail.gmail.com> <A2FF8835-2386-47F9-AFF8-4E09BEC4F80E@oracle.com>
 <89E75765-AC24-4EF4-9547-6EE7A1A38B5A@dilger.ca> <CAGBYx2ZwCQDis-M0-qbdpBgbq34BR-OStMrcCK_+4u20CemXzg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="8323328-1348833973-1317647494=:4447"
Cc: Andreas Dilger <aedilger@gmail.com>,
	Lukas Czerner <lczerner@redhat.com>,
	Jeff liu <jeff.liu@oracle.com>,
	Dave Young <hidave.darkstar@gmail.com>,
	"Ted Ts'o" <tytso@mit.edu>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	linux-ext4@vger.kernel.org
To: Yongqiang Yang <xiaoqiangnk@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:3752 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754411Ab1JCNLl (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 3 Oct 2011 09:11:41 -0400
In-Reply-To: <CAGBYx2ZwCQDis-M0-qbdpBgbq34BR-OStMrcCK_+4u20CemXzg@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--8323328-1348833973-1317647494=:4447
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT

On Mon, 3 Oct 2011, Yongqiang Yang wrote:

> On Sun, Oct 2, 2011 at 3:59 PM, Andreas Dilger <aedilger@gmail.com> wrote:
> > On 2011-10-01, at 11:41 PM, Jeff liu wrote:
> >>> On Sat, Oct 1, 2011 at 10:39 PM, Ted Ts'o <tytso@mit.edu> wrote:
> >>>> On Sat, Oct 01, 2011 at 10:01:35PM +0800, Dave Young wrote:
> >>>>> Hi,
> >>>>>
> >>>>> Weird problem, when I build app from source,
> >>>>> make; make install
> >>>>> run the command, but got "cannot execute binary file"
> >>>>>
> >>>>> hexdump shows the installed binary is full of zero
> >>>>>
> >>>>> Is it related to ext4 fiemap problem described below?
> >>>>> http://lwn.net/Articles/429349/
> >>>>
> >>>> There is general agreement that /bin/cp should not have been relying
> >>>> on FIEMAP, and I believe the more recent versions of /bin/cp have
> >>>> removed that code by default pending implementation of
> >>>> SEEK_HOLE/SEEK_DATA.  That being said, ext4 had a workaround to its
> >>>> FIEMAP implementation that landed in 2.6.39, and you're using
> >>>> 3.1.0-rc6.
> >>
> >> Actually, upstream cp(1) using FIEMAP only if the source file is sparse,  or else, it will do normal copy, i.e, block based.
> >
> > My understanding is that cp uses the blocks count to determine whether the file is sparse or not.  In the case of delayed allocation (where blocks are not yet allocated, if they are not reflected in the i_blocks count) it might mistakenly think that the file is sparse.
> >
> > Given the danger of this bug, it is important to ensure ext4 returns DELALLOC extents for pages in the page cache.  I think Yongqiang Yang just submitted a patch series to do this for ext4, so it would be important to verify it fixes this problem.
> It seemed the patch[ ext4: in fiemap use FIEMAP_EXTENT_LAST flag for
> last extent] (http://www.spinics.net/lists/linux-ext4/msg25698.html)
> Lukas submitted on FIEMAP which ignores delayed extents beyond the
> last allocated block.  e.g.  AAAHHHHDDDD
> A - allocated, H - hole, D - delayed alloc, then the ending delayed
> extent is ignored.

Oops, you're right. I think that the best solution would be to revert
the commit

c03f8aa9abdd517477c2021ea1251939b4da49e6
ext4: use FIEMAP_EXTENT_LAST flag for last extent in fiemap

and then fix the original problem with your delayed extent tree
solution, where we can easily check not only for next allocated extent,
but also for next delayed extent to see if the current one is last or
not.

Currently, the problem is that at the point we are filling the fiemap
extent with fiemap_fill_next_extent() we do not have enough information
to say whether the extent is really the last or is not. And currently
there is not easy way to check for next delayed extent (which will be
fixed with your delayed extent tree).

I do not know how "ready" are your patches..Is it possible to wait for
them to be ready and fix it in your patch set ? That means, revert the
mentioned commit and reimplement fiemap with delayed extent tree.

Thanks!
-Lukas

> 
> Yongqiang.
> >
> >>> Do you means It should work in 3.1.0-rc6 even with cp which depends fiemap?
> >>>
> >>>>
> >>>>> I finally managed to find the way to reproduce this:
> >>>>> just cp a elf binary A  to file B, then cp B to file C,  then you will get:
> >>>>> A == B != C
> >>>>>
> >>>>> ie.
> >>>>> cp /bin/ls ls1
> >>>>> cp ls1 ls2
> >>>>>
> >>>>> ls2 will be filled with zero
> >>>>
> >>>> If you add a "sync" between the two copies, does that work around the
> >>>> problem?  I bet it will...
> >>>
> >>> Yes, it works
> >>>
> >>>>
> >>>> My suggestion is to upgrade to a newer version of coreutils that
> >>>> doesn't try to use FIEMAP.
> >>>
> >>> Thanks, will try
> >>>
> >>>>
> >>>>                                       - Ted
> >>>>
> >>>
> >>>
> >>>
> >>> --
> >>> Regards
> >>> Dave
> >>> --
> >>> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> >>> the body of a message to majordomo@vger.kernel.org
> >>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> >>
> >> --
> >> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> >> the body of a message to majordomo@vger.kernel.org
> >> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> >
> >
> > Cheers, Andreas
> >
> >
> >
> >
> >
> >
> 
> 
> 
> 

-- 
--8323328-1348833973-1317647494=:4447--
