From: Ted Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 1/6 v5] ext4: Add new ext4_discard_partial_page_buffers
 routines
Date: Sun, 21 Aug 2011 22:38:10 -0400
Message-ID: <20110822023810.GA3671@thunk.org>
References: <1313893787-25460-1-git-send-email-achender@linux.vnet.ibm.com>
 <1313893787-25460-2-git-send-email-achender@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Allison Henderson <achender@linux.vnet.ibm.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:34114 "EHLO
	test.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751972Ab1HVCiQ (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sun, 21 Aug 2011 22:38:16 -0400
Content-Disposition: inline
In-Reply-To: <1313893787-25460-2-git-send-email-achender@linux.vnet.ibm.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sat, Aug 20, 2011 at 07:29:42PM -0700, Allison Henderson wrote:
> +		/* If the range is block aligned, unmap */
> +		if (range_to_discard == blocksize) {
> +			clear_buffer_dirty(bh);
> +			bh->b_bdev = NULL;
> +			clear_buffer_mapped(bh);
> +			clear_buffer_req(bh);
> +			clear_buffer_new(bh);
> +			clear_buffer_delay(bh);
> +			clear_buffer_unwritten(bh);
> +			clear_buffer_uptodate(bh);
> +			ClearPageUptodate(page);

Is this ClearPageUptodate() necessary?  If the page is uptodate, and
we've zero'ed out the relevant space, why do we need to force the page
to read in from disk again?  (In fact, if we want to avoid forcing the
whole punched region to be written to disk, we'll need to get rid of
the ClearPageUptodate() sooner or later --- and I'm not sure I see why
it's needed now.  Am I missing something?)

					- Ted
