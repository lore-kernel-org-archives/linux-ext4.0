From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 1/2] ext4: Fix stripe-unaligned allocations
Date: Fri, 10 Feb 2017 00:53:35 -0500
Message-ID: <20170210055335.dnujxjtv4ew3sprb@thunk.org>
References: <20170209153050.15317-1-jack@suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org,
        Ross Zwisler <ross.zwisler@linux.intel.com>
To: Jan Kara <jack@suse.cz>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:54082 "EHLO imap.thunk.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750940AbdBJFzJ (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Fri, 10 Feb 2017 00:55:09 -0500
Content-Disposition: inline
In-Reply-To: <20170209153050.15317-1-jack@suse.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, Feb 09, 2017 at 04:30:49PM +0100, Jan Kara wrote:
> When a filesystem is created using:
> 
> mkfs.ext4 -b 4096 -E stride=512 <dev>
> 
> and we try to allocate 64MB extent, we will end up directly in
> ext4_mb_complex_scan_group(). This is because the request is detected as
> power-of-two allocation (so we start in ext4_mb_regular_allocator()
> with ac_criteria == 0) however the check before
> ext4_mb_simple_scan_group() refuses the direct buddy scan because the
> allocation request is too large. Since cr == 0, the check whether we
> should use ext4_mb_scan_aligned() fails as well and we fall back to
> ext4_mb_complex_scan_group().
> 
> Fix the problem by checking for upper limit on power-of-two requests
> directly when detecting them.
> 
> Reported-by: Ross Zwisler <ross.zwisler@linux.intel.com>
> Signed-off-by: Jan Kara <jack@suse.cz>

Thanks, applied.

						- Ted
