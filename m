From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: NULL pointer dereference in ext4_ext_remove_space on 3.5.1
Date: Fri, 17 Aug 2012 19:11:44 -0400
Message-ID: <20120817231144.GC573@thunk.org>
References: <CABRT9RAOhaxcYdCxMn5neJ9WT85r=h=7WgZ2dmLaOs-MMqDW9A@mail.gmail.com>
 <20120816024654.GB3781@thunk.org>
 <20120816111051.GA16036@localhost>
 <20120816152513.GA31346@thunk.org>
 <20120817060110.GA28786@localhost>
 <20120817131558.GA11439@thunk.org>
 <20120817174841.GA4519@infradead.org>
 <20120817203438.GA573@thunk.org>
 <20120817210527.GA22716@infradead.org>
 <20120817225524.GA19235@dastard>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Christoph Hellwig <hch@infradead.org>, xfs@oss.sgi.com,
	ext4 hackers <linux-ext4@vger.kernel.org>
To: Dave Chinner <david@fromorbit.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:45378 "EHLO
	imap.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756814Ab2HQXLt (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 17 Aug 2012 19:11:49 -0400
Content-Disposition: inline
In-Reply-To: <20120817225524.GA19235@dastard>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sat, Aug 18, 2012 at 08:55:24AM +1000, Dave Chinner wrote:
> 
> No.  The whole point of moving to multiple directories is to allow
> easy extension for domain specific tests without having to hack up
> the check script or play other games with test naming. Duplicate
> names in different test subdirectories are most certainly allowed.

Oh, I agree, using separate directories is *way* better than the hack
we're using internally.  The main benefit of what we did was the
patches were minimally intrusive....

> > Can you take a look at Dave's series if that helps you?  I haven't
> > really reviewed it much myself yet, but I'll try to get to it ASAP.
> 
> Well, I'd apprepciate it if somebody looked at it. It's been almost
> a month since I posted it and all I've heard is crickets so far...

I definitely want to look at it, but realistically, I probably won't
have time until after San Diego....  I've been crazy busy lately.

Cheers,

						- Ted
