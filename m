From: Ted Ts'o <tytso@mit.edu>
Subject: Re: What am I doing wrong?  submit_bio() suddenly stops working...
Date: Sat, 23 Oct 2010 10:48:36 -0400
Message-ID: <20101023144836.GA24650@thunk.org>
References: <E1P8kSE-0001DW-8C@tytso-glaptop>
 <4CBFE4E2.7050001@kernel.dk>
 <20101021165525.GB3127@thunk.org>
 <4CC07C67.9010502@kernel.dk>
 <20101022033424.GO3127@thunk.org>
 <4CC13B09.6030104@kernel.dk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>
To: Jens Axboe <axboe@kernel.dk>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from thunk.org ([69.25.196.29]:53889 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756896Ab0JWOsl (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sat, 23 Oct 2010 10:48:41 -0400
Content-Disposition: inline
In-Reply-To: <4CC13B09.6030104@kernel.dk>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, Oct 22, 2010 at 09:19:37AM +0200, Jens Axboe wrote:
> 
> In my experience, use-after-free bugs are best caught using the
> allocator poisoning along with lock checking. I guess that didn't
> trigger for you?

No, I tried adding slab_debug=FP, but the structure got reused too
quickly.  And I've always had lock checking enabled.

> Out of curiousity, what was the exact bug?

To be honest, I don't know why it was causing the problem.  I had a 

       if (test_bit(BIO_UPTODATE, &bio->bi_flags))
               error = 0;

After the bio_put, which was clearly wrong, so I fixed it.  But
test_bit is a read-only instruction, and if error should have been
zero since I'm testing using kvm and there haven't been any errors.
(I need to test to make sure my error handling paths work correctly;
later).

But it's now working, and at this point, given that I have something
that works, although I'm curious what was causing the mysterious
failures, I may be willing to just let it be a mystery...

	    	   	      	   - Ted
