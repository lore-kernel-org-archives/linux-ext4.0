From: Lukas Czerner <lczerner@redhat.com>
Subject: Re: [PATCH] e2fsck: Discard free data and inode blocks.
Date: Fri, 22 Oct 2010 16:32:52 +0200 (CEST)
Message-ID: <alpine.LFD.2.00.1010221620490.3390@dhcp-lab-213.englab.brq.redhat.com>
References: <1287670556-23460-1-git-send-email-lczerner@redhat.com> <6388FD2D-50A8-42B9-A955-3824451ACBF4@dilger.ca> <alpine.LFD.2.00.1010221059490.3007@dhcp-lab-213.englab.brq.redhat.com> <4CC175E6.5000700@gmail.com> <alpine.LFD.2.00.1010221335080.3390@dhcp-lab-213.englab.brq.redhat.com>
 <4CC19BC2.9010503@gmail.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Lukas Czerner <lczerner@redhat.com>,
	Andreas Dilger <adilger.kernel@dilger.ca>,
	linux-ext4@vger.kernel.org, tytso@mit.edu, sandeen@redhat.com
To: Ric Wheeler <ricwheeler@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:22906 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755136Ab0JVOc7 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 22 Oct 2010 10:32:59 -0400
In-Reply-To: <4CC19BC2.9010503@gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, 22 Oct 2010, Ric Wheeler wrote:

>  On 10/22/2010 07:43 AM, Lukas Czerner wrote:
> > On Fri, 22 Oct 2010, Ric Wheeler wrote:
> > 
> > >   On 10/22/2010 05:12 AM, Lukas Czerner wrote:
> > > > On Thu, 21 Oct 2010, Andreas Dilger wrote:
> > > > 
> > > > > On 2010-10-21, at 08:15, Lukas Czerner wrote:
> > > > > > In Pass 5 when we are checking block and inode bitmaps we have great
> > > > > > opportunity to discard free space and unused inodes on the device,
> > > > > > because bitmaps has just been verified as valid. This commit takes
> > > > > > advantage of this opportunity and discards both, all free space and
> > > > > > unused inodes.
> > > > > > 
> > > > > > I have added new option '-K' which when set, disables discard. Also
> > > > > > when
> > > > > > the underlying device does not support discard, or BLKDISCARD ioctl
> > > > > > returns any kind of error, or when some errors occurred in bitmaps,
> > > > > > the
> > > > > > discard is disabled.
> > > > > I'm always a bit nervous with patches like this, that will prevent
> > > > > data
> > > > > recovery after an e2fsck run (which seems like the opposite of what we
> > > > > want from e2fsck).
> > > > > 
> > > > > Two suggestions:
> > > > > - it probably makes sense to disable this by default, and allow it to
> > > > > be
> > > > >     specified on the command-line and e2fsck.conf
> > > > > - should we really have a short option, or a "-E discard" and "-E
> > > > > nodiscard"
> > > > >     options, which allow us to change the default easily at some later
> > > > > time
> > > > >     (which we can't do with a single -K flag)
> > > > Right, I agree it would be probably better to disable this by default.
> > > > 
> > > > 
> > > If we do disable it by default, I think that we might also want to be
> > > consistent and disable the discard support in mkfs by default as well?
> > > 
> > > thanks!
> > > 
> > > Ric
> > > 
> > I think that this will not be necessary. There is a concern that it might
> > prevent data recovery after fsck because it might be already discarded
> > (some weird fs corruption?) in pass 5. However in my opinion this is a
> > very small window (if there even is any), because we have already passed
> > check 1-4 and we have just confirmed that group descriptors should be ok.
> > But when there is an even slight chance this might happen I would suggest
> > that we really disable it by default (at least for a while - we will see
> > then).
> > 
> > On the other hand there is nothing to be afraid of in the case of mkfs,
> > because we can not possibly lose any relevant data, because discard is
> > done before the filesystem gets created.
> > 
> > -Lukas
> 
> My concern with mkfs is that we have seen several devices which don't handle
> this well.
> 
> We will be using this TRIM (or UNMAP, etc) on lots of old, creaky hardware
> with old firmware, so having it try on all devices is almost certainly going
> to cause breakages, hangs, etc in the field....
> 
> Ric
> 

Well, so far the only breakages I have seen was with lots of small TRIMs
(or UNMAPs, etc) issued in random pattern, never in case of mkfs which
is quite a opposite - big sequential ranges.

Hangs should be covered by those two patches:

http://marc.info/?l=linux-ext4&m=128774558623608&w=2
http://marc.info/?l=linux-ext4&m=128767099123375&w=2

if, of course, they get upstream. Also there is a big win, when discard
also zeroes data, because in that case we can just skip inode table
initialization (zeroing) without any need of in-kernel lazyinit code
enabled. And we get all this for free. It was introduced with Sandeens
patch:

http://marc.info/?l=linux-ext4&m=128234048208327&w=2

So, I would rather leave it on by default.

-Lukas
