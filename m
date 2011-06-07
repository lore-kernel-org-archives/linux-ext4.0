From: Lukas Czerner <lczerner@redhat.com>
Subject: Re: [PATCH RFC 00/30] Ext4 snapshots - core patches
Date: Tue, 7 Jun 2011 12:09:30 +0200 (CEST)
Message-ID: <alpine.LFD.2.00.1106071205530.4754@dhcp-27-109.brq.redhat.com>
References: <1304959308-11122-1-git-send-email-amir73il@users.sourceforge.net> <alpine.LFD.2.00.1106061501460.3934@dhcp-27-109.brq.redhat.com> <BANLkTimjxkOnX6hvLvU+Xth20ie5FaXq1A@mail.gmail.com> <4DECF2D5.7050408@redhat.com> <20110606205512.GE20818@thunk.org>
 <BD378E74-754D-45FF-9F65-EFAF8436BBFD@dilger.ca> <BANLkTin5WLnvaZtpym9896wWwscUetQy0Q@mail.gmail.com>
Mime-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="8323328-1491547279-1307441373=:4754"
Cc: Andreas Dilger <adilger@dilger.ca>, "Ted Ts'o" <tytso@mit.edu>,
	Eric Sandeen <sandeen@redhat.com>,
	Lukas Czerner <lczerner@redhat.com>, linux-ext4@vger.kernel.org
To: "Amir G." <amir73il@users.sourceforge.net>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:59184 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752848Ab1FGKJn (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 7 Jun 2011 06:09:43 -0400
In-Reply-To: <BANLkTin5WLnvaZtpym9896wWwscUetQy0Q@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--8323328-1491547279-1307441373=:4754
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT

On Tue, 7 Jun 2011, Amir G. wrote:

> On Tue, Jun 7, 2011 at 8:17 AM, Andreas Dilger <adilger@dilger.ca> wrote:
> > On 2011-06-06, at 2:55 PM, Ted Ts'o wrote:
> >> On Mon, Jun 06, 2011 at 10:31:33AM -0500, Eric Sandeen wrote:
> >>>> For one reason, a snapshot file format is currently an indirect file
> >>>> and big_alloc doesn't support indirect mapped files.
> >>>> I am not saying it cannot be done, but if it does, there would be
> >>>> several obstacles to cross.
> >>>
> >>> I know I'm kind of just throwing a bomb out here, but I am very concerned
> >>> about the ever-growing feature (in)compatibility matrix in ext4.
> >>
> >> bigalloc doesn't support indirect blocks mainly because it was faster
> >> to get things working if I didn't have to worry about indirect blocks.
> >> It wouldn't be _that_ hard to make bigalloc work on indirect blocks.
> >> I'll get around to it at some point.
> >
> > My main concern isn't about whether bigalloc grows support for indirect-
> > mapped files, but rather the opposite - that snapshots gain support for
> > extent-mapped files.  In fact, since extent-mapped files can be 16TB in
> > size, it might make sense that the snapshots are _always_ extent-mapped
> > files, and we don't need to deal with the new block-mapped files with
> > 4-triple-indirect blocks layout at all?  Since snapshots are only going
> > into ext4, and ext4 + e2fsprogs already support extents, there wouldn't
> > be any issue about compatibility?
> >
> > The only concern might be that mapping fragmented files into extents is
> > more effort, which makes me wonder about whether we should introduce the
> > "block-mapped extents" that I proposed in the past, to allow efficient
> > mapping of files (or parts thereof) that are highly fragmented, but still
> > keeping the benefits of extents (internal redundancy, 48-bit physical
> > block numbers, and while we are adding a new extent format it could be
> > designed to add 48-bit logical block numbers.
> >
> 
> You are right about snapshot file being a highly fragmented file by design,
> so single block mapping is an advantage. The down side is that deleting
> an extent mapped file, requires mapping all blocks one-by-one to snapshot
> file, which is not efficient and makes deletes slow.
> So having a format optimized for both single and multi block mapping would be
> best.
> 
> The reason I DO NOT want to change the snapshot file format at this moment
> is that it will make us lose all the stabilization that snapshot feature gained
> during 1 year in production as next3.
> You see, ext4_free_blocks() cares not if blocks are deleted from indirect or
> extent mapped files and from there on, the code that maps those blocks to
> the special snapshot file is the same in next3 and ext4.
> 

But the problem is, that you will not be able to change it in the future
or at least not without adding more incompatibility flags, which is
exactly the point of this thread. I just wonder if it would not be
better to do it now, because now is the right time. Although I do not
know how much work will that require.

Thanks!
-Lukas
--8323328-1491547279-1307441373=:4754--
