From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH] ext4: Allocate entire range in zero range
Date: Fri, 3 Apr 2015 00:11:00 -0400
Message-ID: <20150403041100.GI10991@thunk.org>
References: <1424278168-13711-1-git-send-email-lczerner@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Lukas Czerner <lczerner@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:48560 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751214AbbDCELD (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 3 Apr 2015 00:11:03 -0400
Content-Disposition: inline
In-Reply-To: <1424278168-13711-1-git-send-email-lczerner@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, Feb 18, 2015 at 05:49:28PM +0100, Lukas Czerner wrote:
> Currently there is a bug in zero range code which causes zero range
> calls to only allocate block aligned portion of the range, while
> ignoring the rest in some cases.
> 
> In some cases, namely if the end of the range is past isize, we do
> attempt to preallocate the last nonaligned block. However this might
> cause kernel to BUG() in some carefully designed zero range requests on
> setups where page size > block size.
> 
> Fix this problem by first preallocating the entire range, including the
> nonaligned edges and converting the written extents to unwritten in the
> next step. This approach will also give us the advantage of having the
> range to be as linearly contiguous as possible.
> 
> Signed-off-by: Lukas Czerner <lczerner@redhat.com>

Thanks, applied.  Apologies for the delay.

						- Ted
