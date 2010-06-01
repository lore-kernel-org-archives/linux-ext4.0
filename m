From: tytso@mit.edu
Subject: Re: [PATCH 2.6.27.y 1/3] ext4: Use our own write_cache_pages()
Date: Tue, 1 Jun 2010 18:12:32 -0400
Message-ID: <20100601221232.GH4426@thunk.org>
References: <4C001888.8020006@jaysonking.com>
 <4C0018E1.5060007@jaysonking.com>
 <20100529004913.GL26177@thunk.org>
 <4C0070D8.8060500@jaysonking.com>
 <20100530212502.GQ26177@thunk.org>
 <4C0358B1.1050605@uni-konstanz.de>
 <AANLkTin3rfw04Shsmmd2O0URjWqbUhf-HOw4r2dXaprH@mail.gmail.com>
 <070DAF41-4DD5-4F20-B9F1-3B472147C499@mit.edu>
 <4C05684D.5050204@jaysonking.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Greg Freemyer <greg.freemyer@gmail.com>,
	Kay Diederichs <kay.diederichs@uni-konstanz.de>,
	Stable team <stable@kernel.org>,
	LKML <linux-kernel@vger.kernel.org>,
	Greg Kroah-Hartman <gregkh@suse.de>,
	"Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>,
	Dave Chinner <david@fromorbit.com>,
	Ext4 Developers List <linux-ext4@vger.kernel.org>
To: "Jayson R. King" <dev@jaysonking.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from thunk.org ([69.25.196.29]:49167 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751364Ab0FAWMp (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 1 Jun 2010 18:12:45 -0400
Content-Disposition: inline
In-Reply-To: <4C05684D.5050204@jaysonking.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, Jun 01, 2010 at 03:06:37PM -0500, Jayson R. King wrote:
> Like Kay Diederichs mentioned, .27 has received ext4 updates in the
> past, even as recently as April this year ("ext4: Avoid null pointer
> dereference..."). Though this of course does not imply that .27
> should receive ext4 fixes (or other fixes) forever, but it is nice
> to fix the most serious, show-stopping problems if it is feasable.

Some people have, but I had stopped doing wholesale attempts of
backports about 6-9 months ago, due to lack of time and because 2.6.27
was just getting too hard to backport to.  So what has been getting
backported has been a little bit of a scattershot.  In retrospect, if
I had known people would have wanted to keep it going for this long, I
would have been more aggressive about backporting patches which might
not (strictly speaking) meet the "critical bugfix" category, but which
enables backporting of future important bugs without having to do some
pretty extreme efforts to make the backport work.  

(And past a certain point, we end up needing to manually regen each
patch, and because of quota and i_blocks updates are so closely tied
together, and quota received a bunch of "clean up patches", we either
need to merge in all of the quota "clean ups", or we need to regen the
patch pretty much from scratch as part of the stable backport.)

> (maybe OT?: When I made an attempt to switch to kernel .31 or .32
> earlier, the kernel would not boot for me. Surely, I can do some
> investigating and get it to boot some day, but I wasn't motivated to
> solve it at the time and stuck with .27 instead.)

You might want to try the latest 2.6.32 stable kernel and see if it
works any better for you.  Since all of the major enterprise distro's
are using 2.6.32 as a base, it's likely that a lot of problem that may
have been in the original 2.6.32 kernel has been fixed.

And, to sweeten the pot, I've done all of the backporting of the ext4
patches to 2.6.32 already, and will probably keep it up for a while,
just because the enterprise distros that are focusing on 2.6.32.

						- Ted
