From: Ted Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 3/3] ext4: update writeback_index based on last page
 scanned
Date: Tue, 26 Oct 2010 14:59:55 -0400
Message-ID: <20101026185955.GA3194@thunk.org>
References: <4CC2023A.7060607@redhat.com>
 <4CC205ED.4090007@redhat.com>
 <20101025213550.GK16981@thunk.org>
 <4CC5F8FE.6000100@redhat.com>
 <20101026141454.GL16981@thunk.org>
 <4CC6EC4A.9070702@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: ext4 development <linux-ext4@vger.kernel.org>
To: Eric Sandeen <sandeen@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from thunk.org ([69.25.196.29]:39845 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753335Ab0JZTAA (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 26 Oct 2010 15:00:00 -0400
Content-Disposition: inline
In-Reply-To: <4CC6EC4A.9070702@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, Oct 26, 2010 at 09:57:14AM -0500, Eric Sandeen wrote:
> Ted Ts'o wrote:
> > On Mon, Oct 25, 2010 at 04:39:10PM -0500, Eric Sandeen wrote:
> >> Not compilebench specifically, but I did do some benchmarking
> >> with out of cache buffered IO; to be honest I didn't see
> >> striking performance differences, but I did see the writeback
> >> behave better in terms of not wandering all over, even if it
> >> might recover well.
> >>
> >> I can try compilebench; do you have specific concerns?
> > 
> > My specific concern is that what happens if __mpage_da_writepage()
> > accumulates 200 pages, but then we were only able to accumulate 50
> > pages, and we only write 50 pages.
> 
> Be patient with me, but how do we accumulate 200 pages but then only
> accumulate 50 pages?

Sorry, I typo'ed the world .  What I meant was, we accumulate 200
pages of contiguously dirty, delay allocated pages in logical block
numberspace, but then we are able to only _allocate_ 50 pages worth of
blocks which are contiguous in physical block numberspace, so we only
end up writing 50 pages worth of blocks.  

But with your patch we end up skipping 200 pages, even though at the
end we only wrote 50 pages.

	      	       	  	     - Ted
