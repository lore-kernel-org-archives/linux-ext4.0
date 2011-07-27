From: Ted Ts'o <tytso@mit.edu>
Subject: Re: flashing large eMMC partitions with ext4
Date: Tue, 26 Jul 2011 21:21:39 -0400
Message-ID: <20110727012139.GB19851@thunk.org>
References: <20110725181043.GK3469@thunk.org>
 <20110726173822.24068.qmail@web4211.mail.ogk.yahoo.co.jp>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Round Robinjp <roundrobinjp@yahoo.co.jp>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:48579 "EHLO
	test.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752356Ab1G0BVl (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 26 Jul 2011 21:21:41 -0400
Content-Disposition: inline
In-Reply-To: <20110726173822.24068.qmail@web4211.mail.ogk.yahoo.co.jp>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, Jul 27, 2011 at 02:38:19AM +0900, Round Robinjp wrote:
> 
> I see.
> The flash will then contain _random_ data in the non-used blocks.
> That is not a problem, right?

Nope.  So long as the previously written (random) data on the card
doesn't contain anything security sensitive.

So for example, if someone used a microSD card to transfer credit card
numbers from their e-commerce website to their credit card processor,
and then afterwards, deciding they didn't need the card any more, and
dropped it into a bin at the production line where it got flashed and
put into a cell phone that was then shipped to Best Buy, then the
non-used blocks wouldn't get written and credit card numbers might get
exposed.  But that's probably only something that folks who designed
the security systems at Sony would do, so there's nothing to worry
about.  :-)

> One more thing.
> Although I have very small amount of files in my 4G image,
> I see that the image has almost no zero-filled blocks.
> Is that normal for ext4?

It depends on how you created the image.

> Can zerofree.c recognize them as non-used blocks?

Yes, it uses the block allocation bitmaps to understand what is used
and non-used.

						- Ted
