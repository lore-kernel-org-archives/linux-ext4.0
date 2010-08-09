From: "Darrick J. Wong" <djwong@us.ibm.com>
Subject: Re: [RFC v2] ext4: Don't send extra barrier during fsync if there
	are no dirty pages.
Date: Mon, 9 Aug 2010 12:36:09 -0700
Message-ID: <20100809193609.GF2109@tux1.beaverton.ibm.com>
References: <20100429235102.GC15607@tux1.beaverton.ibm.com> <1272934667.2544.3.camel@mingming-laptop> <4BE02C45.6010608@redhat.com> <1273002566.3755.10.camel@mingming-laptop> <20100629205102.GM15515@tux1.beaverton.ibm.com> <20100805164008.GH2901@thunk.org> <20100806071356.GE2109@tux1.beaverton.ibm.com> <20100806180454.GA24583@thunk.org>
Reply-To: djwong@us.ibm.com
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: "Ted Ts'o" <tytso@mit.edu>, Mingming Cao <cmm@us.ibm.com>,
	Ric Wheeler <rwheeler@redhat.com>,
	linux-ext4 <linux-ext4@vger.kernel.org>,
	linux-kernel <linux-kernel@vger.kernel.org>,
	Ke
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e37.co.us.ibm.com ([32.97.110.158]:37481 "EHLO
	e37.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753381Ab0HITgj (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 9 Aug 2010 15:36:39 -0400
Content-Disposition: inline
In-Reply-To: <20100806180454.GA24583@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, Aug 06, 2010 at 02:04:54PM -0400, Ted Ts'o wrote:
> On Fri, Aug 06, 2010 at 12:13:56AM -0700, Darrick J. Wong wrote:
> > Yes, it's a proxy for something else.  One of our larger products would like to
> > use fsync() to flush dirty data out to disk (right now it looks like they use
> > O_SYNC), but they're concerned that the many threads they use can create an
> > fsync() storm.  So, they wanted to know how to mitigate the effects of those
> > storms.  Not calling fsync() except when they really need to guarantee a disk
> > write is a good start, but I'd like to get ahead of them to pick off more low
> > hanging fruit like the barrier coordination and not sending barriers when
> > there's no dirty data ... before they run into it. :)
> 
> Do they need a barrier operation, or do they just want to initiate the
> I/O?  One of the reasons I found it hard to believe you would have
> multiple threads all fsync()'ing the same file is that keeping the the
> file consistent is very hard to do in such a scenario.  Maintaining
> ACID-level consistency without a single thread which coordinates when
> commit records gets written is I'm sure theoretically possible, but in
> practice, I wasn't sure any applications would actually be _written_
> that way.

> If the goal is just to make sure I/O is getting initiated, without
> necessarily waiting for assurance that a specific file write has hit
> the disk platters, it may be that the Linux-specific
> sync_file_range(2) system call might be a far more efficient way of
> achieving those ends.  Without more details about what this product is
> doing, it's hard to say, of course.

I don't know for sure, though given what I've seen of the app behavior I
suspect they simply want the disk cache flushed, and don't need the full
ordering semantics.  That said, I do think they want to make sure that data
actually hits the disk platters.

--D
