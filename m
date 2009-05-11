From: Theodore Tso <tytso@mit.edu>
Subject: Re: Is TRIM/DISCARD going to be a performance problem?
Date: Mon, 11 May 2009 10:27:40 -0400
Message-ID: <20090511142740.GC6277@mit.edu>
References: <E1M2ts6-0005jr-Cg@closure.thunk.org> <20090510165259.GA31850@logfs.org> <20090511083754.GA29082@mit.edu> <20090511100624.GB6585@logfs.org> <20090511112729.GD29082@mit.edu> <20090511120936.GB6277@mit.edu> <87f94c370905110610j2f5ea7fcua4e596b2b5e82a5f@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: =?iso-8859-1?Q?J=F6rn?= Engel <joern@logfs.org>,
	Matthew Wilcox <willy@linux.intel.com>,
	Jens Axboe <jens.axboe@oracle.com>,
	Ric Wheeler <rwheeler@redhat.com>,
	linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org,
	Linux RAID <linux-raid@vger.kernel.org>
To: Greg Freemyer <greg.freemyer@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from thunk.org ([69.25.196.29]:57131 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756173AbZEKO16 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 11 May 2009 10:27:58 -0400
Content-Disposition: inline
In-Reply-To: <87f94c370905110610j2f5ea7fcua4e596b2b5e82a5f@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, May 11, 2009 at 09:10:15AM -0400, Greg Freemyer wrote:
> 
> That implies that the SSD folks are not treating erase blocks as a
> contiguous group of sectors.  

Correct. 

> For some reason, I thought their was
> only one mapping per erase block and within the erase block the
> sectors were contiguous..

No, if you try to treat erase blocks as a contiguous group of
sectors, you'll have terrible write amplification problems (leading to
premature death of the SSD) and terrible small random write
performance.  Flash devices optimized for digital cameras might have
done that, but for SSD's, this will result in catastrophically bad
performance, and very limited lifespan.  As I said, I expect these
SSD's to be weeded out of the market very shortly.

For any sane implementation of an SSD, the mapping will be on a per
LBA basis, not on a per-erase block basis.

> More realistic is to figure out a way to make it deterministic at
> least for the short term (by writing data to all the trimmed blocks?),
> then reshaping, then having a tool to scan the filesystem and re-issue
> all the trim commands.

Writing data to all of the trimmed block?  Um, no.  That would be a
diaster, since it accelerates the wear and tear of the SSD.  The whole
*point* of the TRIM command is to avoid needing to do that.

The whole worry about determinism is highly overrated.  If the
filesystem doesn't need a block, then it doesn't need it.  What you
read after you send a TRIM command, whether it is the old data because
the device applied some kind of rounding, or random data, or all
zero's, won't matter to the filesystem.  Why should the filesystem
care?  I know I certainly don't....

					- Ted
