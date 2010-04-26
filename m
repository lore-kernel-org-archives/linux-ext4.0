From: Lukas Czerner <lczerner@redhat.com>
Subject: Re: [PATCH 2/2] Add batched discard support for ext4.
Date: Mon, 26 Apr 2010 17:51:28 +0200 (CEST)
Message-ID: <alpine.LFD.2.00.1004261746430.2797@localhost>
References: <1271674527-2977-1-git-send-email-lczerner@redhat.com>  <4BD2F69D.7070508@redhat.com>  <o2y87f94c371004240730x389391dfka42a1e8abc498e1a@mail.gmail.com>  <4BD30393.4050800@redhat.com>  <h2n87f94c371004240803obefca41cg1ca8a727c1726827@mail.gmail.com>
  <4BD324B5.4030808@redhat.com>  <p2i87f94c371004241130ya1642597g42bd77c3e3c351f1@mail.gmail.com>  <4BD33B61.2080807@redhat.com> <4BD59C84.4040200@teksavvy.com>  <yq18w8ae0mq.fsf@sermon.lab.mkp.net>
 <x2s87f94c371004260827gf5f978f4l48548add85094e22@mail.gmail.com>
Mime-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="8323328-1816101403-1272297092=:2797"
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>,
	Mark Lord <kernel@teksavvy.com>,
	Ric Wheeler <rwheeler@redhat.com>,
	Eric Sandeen <sandeen@redhat.com>,
	Lukas Czerner <lczerner@redhat.com>,
	Jeff Moyer <jmoyer@redhat.com>, linux-ext4@vger.kernel.org,
	Edward Shishkin <eshishki@redhat.com>,
	Eric Sandeen <esandeen@redhat.com>,
	Christoph Hellwig <hch@infradead.org>
To: Greg Freemyer <greg.freemyer@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:36027 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751362Ab0DZPve (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 26 Apr 2010 11:51:34 -0400
In-Reply-To: <x2s87f94c371004260827gf5f978f4l48548add85094e22@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--8323328-1816101403-1272297092=:2797
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT

On Mon, 26 Apr 2010, Greg Freemyer wrote:

> On Mon, Apr 26, 2010 at 10:42 AM, Martin K. Petersen
> <martin.petersen@oracle.com> wrote:
> >>>>>> "Mark" == Mark Lord <kernel@teksavvy.com> writes:
> >
> > Mark> So.. again.. in an ideal kernel, I'd like to see use of larger
> > Mark> ranges (and _multiple_ ranges) per TRIM command.  And options for
> > Mark> the kernel to do it automatically (-o discard), as well as an
> > Mark> ioctl() interface for userspace to "scrub" (or "wipe") all free
> > Mark> ranges in a gradual fashion.
> >
> > Again: Discard splitting, merging, and coalescing is coming.  I'm
> > working on it.  It's not exactly trivial.
> >
> > My objection was purely wrt. nuking realtime discard in favor of
> > scrubbing.  We absolutely need both approaches.
> >
> > But I'm not going to let crappy SSD firmware implementations set the
> > direction for what I'm working on.  It is much more interesting to
> > ensure that we work well for the devices that'll be shipping 6-12 months
> > from now (at the time where this stuff will realistically end up in
> > distro kernels).
> >
> > --
> > Martin K. Petersen      Oracle Linux Engineering
> >
> 
> Is this an agreed summary as relates to ext4:
> 
> 1) Current "-o discard" causes real-time calls to discard.  Although
> not optimized for current generation hardware, both block-layer
> optimizations and new hardware are coming, so it needs to be kept.
> 
> 2) Kernel based discard scrubbing - Doesn't currently exist in 2.6.34,
> all agree that for the LVM, mdraid, btrfs cases it is needed and there
> is no linux tool (kernel or userspace) at present.  The Lukas proposed
> patch is userspace invoked so a mount option is not needed.

It is userspace invoked indeed, but once you set the nodiscard mount
option it will not do anything. It seems only logical to me to NOT
discard anything, when "nodiscard" option is set.

> 
> 3) Userspace discard is available today and works well with ext4 on a
> single JBOD SSD which will be the typical laptop use as one example.

It (wiper) do not work on devices which does not support vectored trim
ranges.

> 
> Mark, or anyone, do you think it would be a bad idea for me to push
> for Opensuse 11.3 (2.6.34 based) to use wiper.sh as a standard ext4
> discard tool?  hdparm and wiper.sh are already in the distro, it just
> needs a cron entry and maybe some basic management infrastructure.
> They're at feature freeze for 11.3, so I don't know if I can get it in
> or not.
> 
> If and when the suse team want to move to the kernel based scrubber,
> they can.  ie. a year from now when the next release after 11.3 comes
> out.
> 
> Greg
> 

-Lukas
--8323328-1816101403-1272297092=:2797--
