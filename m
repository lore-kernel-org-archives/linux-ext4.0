From: =?ISO-8859-15?Q?Luk=E1=A8_Czerner?= <lczerner@redhat.com>
Subject: Re: Unwritten extent zeroing beyond i_size
Date: Thu, 14 Mar 2013 13:29:48 +0100 (CET)
Message-ID: <alpine.LFD.2.00.1303141312260.18319@dhcp-1-104.brq.redhat.com>
References: <20130313095640.GC29730@quack.suse.cz> <alpine.LFD.2.00.1303140850460.18319@dhcp-1-104.brq.redhat.com> <20130314105629.GA12789@quack.suse.cz> <alpine.LFD.2.00.1303141205330.18319@dhcp-1-104.brq.redhat.com> <20130314120527.GB12789@quack.suse.cz>
Mime-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="8323328-2117690068-1363264191=:18319"
Cc: =?ISO-8859-15?Q?Luk=E1=A8_Czerner?= <lczerner@redhat.com>,
	Dmitry Monakhov <dmonakhov@openvz.org>,
	linux-ext4@vger.kernel.org, Ted Tso <tytso@mit.edu>
To: Jan Kara <jack@suse.cz>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:8885 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755911Ab3CNMah (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 14 Mar 2013 08:30:37 -0400
In-Reply-To: <20130314120527.GB12789@quack.suse.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--8323328-2117690068-1363264191=:18319
Content-Type: TEXT/PLAIN; charset=utf-8
Content-Transfer-Encoding: 8BIT

On Thu, 14 Mar 2013, Jan Kara wrote:

> Date: Thu, 14 Mar 2013 13:05:27 +0100
> From: Jan Kara <jack@suse.cz>
> To: Lukáš Czerner <lczerner@redhat.com>
> Cc: Jan Kara <jack@suse.cz>, Dmitry Monakhov <dmonakhov@openvz.org>,
>     linux-ext4@vger.kernel.org, Ted Tso <tytso@mit.edu>
> Subject: Re: Unwritten extent zeroing beyond i_size
> 
> On Thu 14-03-13 12:11:28, Lukáš Czerner wrote:
> > On Thu, 14 Mar 2013, Jan Kara wrote:
> > 
> > > Date: Thu, 14 Mar 2013 11:56:29 +0100
> > > From: Jan Kara <jack@suse.cz>
> > > To: Lukáš Czerner <lczerner@redhat.com>
> > > Cc: Jan Kara <jack@suse.cz>, Dmitry Monakhov <dmonakhov@openvz.org>,
> > >     linux-ext4@vger.kernel.org, Ted Tso <tytso@mit.edu>
> > > Subject: Re: Unwritten extent zeroing beyond i_size
> > > 
> > > On Thu 14-03-13 08:56:55, Lukáš Czerner wrote:
> > > > On Wed, 13 Mar 2013, Jan Kara wrote:
> > > > 
> > > > > Date: Wed, 13 Mar 2013 10:56:40 +0100
> > > > > From: Jan Kara <jack@suse.cz>
> > > > > To: Dmitry Monakhov <dmonakhov@openvz.org>
> > > > > Cc: linux-ext4@vger.kernel.org, Ted Tso <tytso@mit.edu>
> > > > > Subject: Unwritten extent zeroing beyond i_size
> > > > > 
> > > > >   Hello Dmitry,
> > > > > 
> > > > >   I'm tracking down failure in xfstests test 274 (fallocate + ENOSPC
> > > > > testing). The problem I found (and that's really unrelated to the question
> > > > > I want to ask) is that if write beyond i_size fails, we truncate the file
> > > > > to i_size to remove any blocks that may have been allocated under the page
> > > > > by the write before it failed (think of blocksize < pagesize config).
> > > > > 
> > > > > Now in this test the write fails because it needs to split unwritten extent
> > > > > and there's no space for that and zeroing out is impossible because we are
> > > > > beyond i_size. And here comes my question: You disallowed zeroing of
> > > > > extents beyond i_size because fsck complains about those. Won't it be
> > > > > better to just add inode flag saying "this inode has blocks preallocated
> > > > > beyond i_size" and make fsck not complain about such blocks? IMHO that
> > > > > would catch 99% of corruptions as well and would let us solve the problem
> > > > > with ENOSPC on writes to preallocated space (plus it would simplify the
> > > > > kernel code).
> > > > > 
> > > > > 								Honza
> > > > 
> > > > Unfortunately this will not solve the real issue that writing into
> > > > preallocated space should _not_ fail at all, because it is
> > > > preallocated.
> > > > 
> > > > The problem right now is that we simply do not have block to
> > > > allocate metadata, and there is no way for us to reserve metadata
> > > > blocks in advance as we might try to do in delalloc.
> > >   But if you don't need to split the extent (you will change the whole
> > > extent from unwritten to written state) you don't need any aditional
> > > metadata blocks. So write cannot fail...
> > 
> > Right, but that's not always the case, also this is not the
> > problematic case, or am I missing something ?
>   It's always the case when writing to preallocated data - you can just
> overwrite the whole extent with zeros, convert it to initialized and then
> write the data you have to the part you are interested in. Even for punch
> hole if you get ENOSPC, you can just overwrite the punched region with
> zeros instead of removing blocks. So it all works just results in more IO
> in ENOSPC cases.

ok, I misunderstood you point about not needing to split the extent.
We're going to zeroout if we can not split the extent - but it's better to
avoid that if we can. Though in some cases it might not be possible
so I am for having the possibility to zeroout extents past i_size as
well if it is possible..

> 
> > > > I've proposed the solution for this in the recent email with subject
> > > > "Metadata reservation for unwritten extent conversion". Basically
> > > > the idea is to have reserved pool of blocks which could be used for
> > > > exactly this (and other) cases. Note that xfs actually have the same
> > > > thing for exactly the same reasons.
> > >   Yeah, I've read your proposal. I don't really object to this solution as
> > > it has advantages over "don't split extent if we are out of space" - namely
> > > it's going to be faster than writing extent full of zeros. But OTOH writing
> > > zeros is so much simpler than implementing some reservation of blocks for
> > > emergency cases that it looks as a compelling solution to me.
> > 
> > The reservation is not really all that complicated. Here is what I
> > have so far. Note that the code is not ready yet, nor is it properly
> > tested.
>   I just briefly scanned the code - what I'm missing is that IMHO we should
> automatically refill reserved blocks during freeing of blocks.

Yes, and there are some more things to finish as well.

> 
> > But you're right that zeroing the extent should be simpler. We might
> > want to have both solutions as in extreme cases we might run out of
> > the reserved space as well - it really depends on the default
> > setting. In that case a warning would be appropriate.
> 
> 								Honza
> 
--8323328-2117690068-1363264191=:18319--
