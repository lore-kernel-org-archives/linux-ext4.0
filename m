From: Jun He <jhe@cs.wisc.edu>
Subject: Re: unexpected sync delays in dpkg for small pre-allocated files on
 ext4
Date: Mon, 30 May 2016 14:04:47 -0500
Message-ID: <20160530190447.GA99050@wifi-808.cs.wisc.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: tytso@mit.edu
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from sabe.cs.wisc.edu ([128.105.6.20]:40913 "EHLO sabe.cs.wisc.edu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161631AbcE3TEy (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 30 May 2016 15:04:54 -0400
Content-Disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

> On Tue, May 24, 2016 at 07:07:41PM +0200, Gernot Hillier wrote:
> > 
> > To me, the problem looks comparable to
> > https://bugzilla.kernel.org/show_bug.cgi?id=56821 (even if we don't see
> > a full hang and there's no RAID involved for us), so a closer look on
> > the SCSI layer or driver might be the next step?
> 
> What I would suggest is to create a small test case which compares the
> time it takes to allocate 1 megabyte of memory, zero it, and then
> write one megabytes of zeros using the write(2) system call.  Then try
> writing one megabytes of zero using the BLKZEROOUT ioctl.
> 
> I'm pretty sure you'll see same issue with BLKZEROOUT ioctl, but at
> this point, we'll be able to send bug reports to the SCSI and block
> layer developers with something that makes this very clear that it has
> nothing to do with ext4.
> 
> This way we can also do some differential diagnosis; given that I'm
> not seeing this complaint from most people, I suspect it will be a
> matter of adding some specific devices to a blacklist (so that even
> though the SCSI device claims to support WRITE SAME, we need to
> disable it because it has a really lousy implementation of the SCSI
> WRITE SAME command).
> 
> Cheers,
> 
> - Ted

I just want to add that I once experienced a similar problem: huge delay
with fallocate() and a SSD. It turns out block layer zeroouts extents by 
discarding them (blkdev_issue_zeroout()), and the Intel SSD is VERY slow
at discarding.

