From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: Minimal configuration for e2fsprogs
Date: Mon, 25 Jun 2012 22:33:31 -0400
Message-ID: <20120626023331.GC14329@thunk.org>
References: <20120615042421.GA7021@thor.bakeyournoodle.com>
 <20120616000825.GE7363@thunk.org>
 <20120618055836.GA30557@thor.bakeyournoodle.com>
 <20120618171257.GA16017@thunk.org>
 <20120626021046.GA26200@thor.bakeyournoodle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:52696 "EHLO
	imap.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753684Ab2FZCde (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 25 Jun 2012 22:33:34 -0400
Content-Disposition: inline
In-Reply-To: <20120626021046.GA26200@thor.bakeyournoodle.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, Jun 26, 2012 at 12:10:47PM +1000, Tony Breeds wrote:
> 
> I was thinking that this was the very sinmple matter of making
> BMAP_STATS conditional rather that have it always #defined.  Is that
> what you were thinking?
> 
> Also what's the correct way to get BMAP_STATS_OPS defined?

Yeah, I was thinking to simply rename BMAP_STATS and BMAP_STATS_OPS to
ENABLE_BMAP_STATS and ENABLE_BMAP_STATS_OPS, and then handle them via
an AC_ARG_ENABLE much like --enable-compression is handled (with the
first enabled by default, so --disable-bmap-stats to the configure
script would disable it, while the much more heavier weight from a
performance standpoint BMAP_STATS_OPS would be disabled by default, so
the user would have to specify --enable-bmap-stats-ops to the
configure script to enable it.)

Regards,

						- Ted
