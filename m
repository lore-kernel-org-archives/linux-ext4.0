From: Ted Ts'o <tytso@mit.edu>
Subject: Re: [RFC PATCH] ext4: fix 50% disk write performance regression
Date: Mon, 30 Aug 2010 13:40:00 -0400
Message-ID: <20100830174000.GA6647@thunk.org>
References: <20100829231126.8d8b2086.billfink@mindspring.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: adilger@sun.com, linux-ext4@vger.kernel.org, bill.fink@nasa.gov
To: Bill Fink <billfink@mindspring.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from THUNK.ORG ([69.25.196.29]:56764 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756134Ab0H3RkE (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 30 Aug 2010 13:40:04 -0400
Content-Disposition: inline
In-Reply-To: <20100829231126.8d8b2086.billfink@mindspring.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sun, Aug 29, 2010 at 11:11:26PM -0400, Bill Fink wrote:
> A 50% ext4 disk write performance regression was introduced
> in 2.6.32 and still exists in 2.6.35, although somewhat improved
> from 2.6.32.  Read performance was not affected).

Thanks for reporting it.  I'm going to have to take a closer look at
why this makes a difference.  I'm going to guess though that what's
going on is that we're posting writes in such a way that they're no
longer aligned or ending at the end of a RAID5 stripe, causing a
read-modify-write pass.  That would easily explain the write
performance regression.

The interesting thing is that we don't actually do anything in
ext4_da_writepages() to assure that we are making our writes are
appropriate aligned and sized.  We do pay attention to make sure they
are alligned correctly in the allocator, but _not_ in the writepages
code.  So the fact that apparently things were well aligned in 2.6.32
seems to be luck... (or maybe the writes are perfectly aligned in
2.6.32; they're just much worse with 2.6.35, and with explicit
attention paid to the RAID stripe size, we could do even better :-)

If you could run blktraces on 2.6.32, 2.6.35 stock, and 2.6.35 with
your patch, that would be really helpful to confirm my hypothesis.  Is
that something that wouldn't be too much trouble?

Thanks, regards,

						- Ted
