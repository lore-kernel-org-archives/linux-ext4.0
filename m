From: Ted Ts'o <tytso@mit.edu>
Subject: Re: [PATCH] don't use ext4_allocation_contexts for tracing
Date: Sat, 9 Oct 2010 19:04:58 -0400
Message-ID: <20101009230457.GD11237@thunk.org>
References: <4C6EDCCF.1000104@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: ext4 development <linux-ext4@vger.kernel.org>
To: Eric Sandeen <sandeen@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from thunk.org ([69.25.196.29]:35102 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756661Ab0JIXE6 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sat, 9 Oct 2010 19:04:58 -0400
Content-Disposition: inline
In-Reply-To: <4C6EDCCF.1000104@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, Aug 20, 2010 at 02:51:43PM -0500, Eric Sandeen wrote:
> Many tracepoints were populating an ext4_allocation_context
> to pass in, but this requires a slab allocation even when
> tracepoints are off.  In fact, 4 of 5 of these allocations
> were only for tracing.  In addition, we were only using a
> small fraction of the 144 bytes of this structure for this
> purpose.
> 
> We can do away with all these alloc/frees of the ac and
> simply pass in the bits we care about, instead.
> 
> I tested this by turning on tracing and running through
> xfstests on x86_64.  I did not actually do anything with
> the trace output, however.
> 
> Signed-off-by: Eric Sandeen <sandeen@redhat.com>

Added to the patch tree, thanks!

I made a slight change to drop passing in the logical parameter to
trace_ext4_mballoc_discard() and trace_ext4_mballoc_free(), since
passing in 0 all the time doesn't really buy us much.  :-)

	     	     	  	  	 - Ted
