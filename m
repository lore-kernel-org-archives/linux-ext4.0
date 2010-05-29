From: tytso@mit.edu
Subject: Re: [PATCH 2.6.27.y 1/3] ext4: Use our own write_cache_pages()
Date: Fri, 28 May 2010 20:49:13 -0400
Message-ID: <20100529004913.GL26177@thunk.org>
References: <4C001888.8020006@jaysonking.com>
 <4C0018E1.5060007@jaysonking.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Stable team <stable@kernel.org>,
	LKML <linux-kernel@vger.kernel.org>,
	Greg Kroah-Hartman <gregkh@suse.de>,
	"Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>,
	Dave Chinner <david@fromorbit.com>,
	Ext4 Developers List <linux-ext4@vger.kernel.org>,
	Kay Diederichs <Kay.Diederichs@uni-konstanz.de>
To: "Jayson R. King" <dev@jaysonking.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from thunk.org ([69.25.196.29]:43669 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751442Ab0E2Atl (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 28 May 2010 20:49:41 -0400
Content-Disposition: inline
In-Reply-To: <4C0018E1.5060007@jaysonking.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, May 28, 2010 at 02:26:25PM -0500, Jayson R. King wrote:
> From: Theodore Ts'o <tytso@mit.edu>
> Date: Sun May 16 18:00:00 2010 -0400
> Subject: ext4: Use our own write_cache_pages()
> 
> commit 8e48dcfbd7c0892b4cfd064d682cc4c95a29df32 upstream.
> 
> Make a copy of write_cache_pages() for the benefit of
> ext4_da_writepages().  This allows us to simplify the code some, and
> will allow us to further customize the code in future patches.
> 
> There are some nasty hacks in write_cache_pages(), which Linus has
> (correctly) characterized as vile.  I've just copied it into
> write_cache_pages_da(), without trying to clean those bits up lest I
> break something in the ext4's delalloc implementation, which is a bit
> fragile right now.  This will allow Dave Chinner to clean up
> write_cache_pages() in mm/page-writeback.c, without worrying about
> breaking ext4.  Eventually write_cache_pages_da() will go away when I
> rewrite ext4's delayed allocation and create a general
> ext4_writepages() which is used for all of ext4's writeback.  Until
> now this is the lowest risk way to clean up the core
> write_cache_pages() function.
> 
> Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>

This doesn't fix a bug; it's to make it easy for Dave Chinner to make
some changes to fix XFS's performance and to undo some ext4-specific
changes to write_cache_pages().  I'm not sure there's a good reason to
backport this to 2.6.27.y....

					- Ted
