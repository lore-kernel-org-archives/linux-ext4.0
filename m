From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH] ext4: check for extents that wrap around
Date: Thu, 30 Jun 2016 11:54:52 -0400
Message-ID: <20160630155452.GH2028@thunk.org>
References: <1467239688-2588-1-git-send-email-vegard.nossum@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Phil Turnbull <phil.turnbull@oracle.com>,
	linux-ext4@vger.kernel.org, Eryu Guan <guaneryu@gmail.com>
To: Vegard Nossum <vegard.nossum@oracle.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:40704 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752346AbcF3Pyy (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 30 Jun 2016 11:54:54 -0400
Content-Disposition: inline
In-Reply-To: <1467239688-2588-1-git-send-email-vegard.nossum@oracle.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, Jun 30, 2016 at 12:34:48AM +0200, Vegard Nossum wrote:
> An extent with lblock = 4294967295 and len = 1 will pass the
> ext4_valid_extent() test:
> 
> 	ext4_lblk_t last = lblock + len - 1;
> 
> 	if (len == 0 || lblock > last)
> 		return 0;
> 
> since last = 4294967295 + 1 - 1 = 4294967295. This would later trigger
> the BUG_ON(es->es_lblk + es->es_len < es->es_lblk) in ext4_es_end().
> 
> We can simplify it by removing the - 1 altogether and changing the test
> to use lblock + len <= lblock, since now if len = 0, then lblock + 0 ==
> lblock and it fails, and if len > 0 then lblock + len > lblock in order
> to pass (i.e. it doesn't overflow).
> 
> Fixes: 5946d0893 ("ext4: check for overlapping extents in ext4_valid_extent_entries()")
> Fixes: 2f974865f ("ext4: check for zero length extent explicitly")
> Cc: Eryu Guan <guaneryu@gmail.com>
> Cc: stable@vger.kernel.org
> Signed-off-by: Phil Turnbull <phil.turnbull@oracle.com>
> Signed-off-by: Vegard Nossum <vegard.nossum@oracle.com>

Thanks, applied.

						- Ted
