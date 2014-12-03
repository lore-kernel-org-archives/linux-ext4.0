From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 48/47] misc: fix infinite loop when finding the start of
 the hugefile start range
Date: Tue, 2 Dec 2014 22:06:50 -0500
Message-ID: <20141203030650.GN13618@thunk.org>
References: <20141107215042.883.49888.stgit@birch.djwong.org>
 <20141112224329.GI10043@birch.djwong.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:36011 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750864AbaLCDGx (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 2 Dec 2014 22:06:53 -0500
Content-Disposition: inline
In-Reply-To: <20141112224329.GI10043@birch.djwong.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, Nov 12, 2014 at 02:43:29PM -0800, Darrick J. Wong wrote:
> When looking for the start of the hugefile range, the 'next' variable
> is incorrectly decremented.  If we happened to find a single free
> block, the effect of this decrement is that blk == next, which means
> that we never modify the loop control variable, so get_start_block
> never returns.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>

Applied, thanks.

					- Ted
