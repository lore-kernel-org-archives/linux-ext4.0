From: Theodore Tso <tytso@mit.edu>
Subject: Re: 5% diskspace used for ext4?
Date: Mon, 14 Jul 2008 07:47:57 -0400
Message-ID: <20080714114757.GA9144@mit.edu>
References: <alpine.DEB.1.10.0807140054000.4469@sheep.housecafe.de> <20080713234541.GA4633@phobos.i.cabal.ca> <620f96feb01d15a6a836a1a11715ee8e.squirrel@housecafe.dyndns.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Kyle McMartin <kyle@mcmartin.ca>, linux-ext4@vger.kernel.org
To: Christian Kujau <lists@nerdbynature.de>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from www.church-of-our-saviour.ORG ([69.25.196.31]:44499 "EHLO
	thunker.thunk.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752999AbYGNLsP (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 14 Jul 2008 07:48:15 -0400
Content-Disposition: inline
In-Reply-To: <620f96feb01d15a6a836a1a11715ee8e.squirrel@housecafe.dyndns.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Jul 14, 2008 at 11:49:42AM +0200, Christian Kujau wrote:
> On Mon, July 14, 2008 01:45, Kyle McMartin wrote:
> > 5% of your space is being reserved for root. You can disable this with
> > the "-m" argument to mkfs.
> 
> Ah, the reserve for root, of course. It did cross my mind that this was
> where the 5% came from and if I had read the mkfs printout more carefully
> I'd have seen it (thanks, Eric!). I shall use -m to specify a different
> value then.
> 
> With filesystems getting bigger and bigger, values like "5% of the
> available diskspace" are actually becoming more and more visible. Although
> they shouldn't, as diskspace gets cheaper and cheaper :-)

There are two reasons for the %5 of available diskspace.  One is
emergency reserve for root, for silly things like /var/log, etc. ---
that's something which a good argument can be made that it should be
adjusted down as disks get bigger.  The other is that as the disk gets
bigger, the fragmentation resistance of a traditional BSD FFS-style
cylinder groups algorithm breaks down, and so the block layout and
resulting performance of the filesystem gets quite bad.

Both of these problems were cited in the "Design and Implementation of
the BSD Fast Filesystm" paper, if I recall correctly, and the BSD FFS
actually reserves 10%; we reduced it down to 5% for ext2.

Can we safely reduce it further for ext4?  With delayed allocation,
ext4 does have much better fragmentation resistance for allocating
blocks for a specific file.  However placement of files in the same
directory will break down as the disk fills up.  That tends to happen
anyway, so it's probably not a big deal.

For people who care much more about available space than the rsulting
performance if the filesystem gets to 100% full, changing the tuning
parameter is definitely a good thing.  In terms of what the default
should be, there probably is a potential OLS/Linux Kongress/LCA paper
here for someone who wants to study the fragmentation resistance of
various filesystms at different levels of filesystem utilization.
(I.e., age a filesystem with a system trace which keeps the filesystem
utilization at a certain average utilization level; repeat at
different levels of utilization, and for different filesystem types,
and graph the "layout score" as defined by [1] for different
filesystem types and different utilization levels).  Would be a pretty
simple undergraduate thesis or graduate student paper....  

The other observation I would make is that I should add a tuning knob
to /etc/mke2fs.conf so system administrators can adjust the default to
their liking much more easily.  That should be pretty straightforward
to add.

							- Ted

[1] K. Smith and M. Seltzer, "A Comparison of FFS Disk Allocation
Alogithms", Proceedings of the USENIX 1996 Annual Technical Conference
(Junary 1996), pp. 15-25
