From: Ted Ts'o <tytso@mit.edu>
Subject: Re: Ext4 and xfs problems in dm-thin on allocation and discard
Date: Tue, 19 Jun 2012 16:21:30 -0400
Message-ID: <20120619202130.GF22805@thunk.org>
References: <20120619015745.GJ25389@dastard>
 <20120619031241.GA3884@redhat.com>
 <alpine.LFD.2.00.1206190816440.2241@dhcp-1-248.brq.redhat.com>
 <20120619131649.GA6811@redhat.com>
 <alpine.LFD.2.00.1206191519320.21961@dhcp-1-248.brq.redhat.com>
 <20120619133041.GB6811@redhat.com>
 <4FE0840F.2050704@shiftmail.org>
 <20120619144413.GA7225@redhat.com>
 <20120619184858.GA8841@redhat.com>
 <20120619200631.GL25389@dastard>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Mike Snitzer <snitzer@redhat.com>, Spelic <spelic@shiftmail.org>,
	=?utf-8?B?THVrw6HFoQ==?= Czerner <lczerner@redhat.com>,
	device-mapper development <dm-devel@redhat.com>,
	linux-ext4@vger.kernel.org, xfs@oss.sgi.com
To: Dave Chinner <david@fromorbit.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:51389 "EHLO
	imap.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753397Ab2FSUVi (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 19 Jun 2012 16:21:38 -0400
Content-Disposition: inline
In-Reply-To: <20120619200631.GL25389@dastard>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, Jun 20, 2012 at 06:06:31AM +1000, Dave Chinner wrote:
> > But in general xfs is issuing discards with much smaller extents than
> > ext4 does, e.g.:
> 
> THat's normal when you use -o discard - XFS sends extremely
> fine-grained discards as the have to be issued during the checkpoint
> commit that frees the extent. Hence they can't be aggregated like is
> done in ext4.

Actually, ext4 is also sending the discards during (well, actually,
after) the commit which frees the extent/inode.  We do aggregate them
while the commit is open, but once the transaction is committed, we
send out the discards.  I suspect the difference is in the granularity
of the transactions between ext4 and xfs.

> As it is, no-one really should be using -o discard - it is extremely
> inefficient compared to a background fstrim run given that discards
> are unqueued, blocking IOs. It's just a bad idea until the lower
> layers get fixed to allow asynchronous, vectored discards and SATA
> supports queued discards...

What Dave said.  :-) This is true for both ext4 and xfs.

As a result, I can very easily see there being a distinction made
between when we *do* want to pass the discards all the way down to the
device, and when we only want the thinp layer to process them ---
because for current devices, sending discards down to the physical
device is very heavyweight.

I'm not sure how we could do this without a nasty layering violation,
but some way in which we could label fstrim discards versus "we've
committed the unlink/truncate and so thinp can feel free to reuse
these blocks" discards would be interesting to consider.

     	  	     	     	      - Ted
