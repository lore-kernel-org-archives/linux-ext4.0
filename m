From: Ted Ts'o <tytso@mit.edu>
Subject: Re: What am I doing wrong?  submit_bio() suddenly stops working...
Date: Thu, 21 Oct 2010 12:55:25 -0400
Message-ID: <20101021165525.GB3127@thunk.org>
References: <E1P8kSE-0001DW-8C@tytso-glaptop>
 <4CBFE4E2.7050001@kernel.dk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>
To: Jens Axboe <axboe@kernel.dk>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from THUNK.ORG ([69.25.196.29]:37397 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752932Ab0JUQzg (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 21 Oct 2010 12:55:36 -0400
Content-Disposition: inline
In-Reply-To: <4CBFE4E2.7050001@kernel.dk>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, Oct 21, 2010 at 08:59:46AM +0200, Jens Axboe wrote:
> 
> I don't see anything immediately wrong with your approach. I suspect
> we'll need to see sysrq-t traces of the relevant processes to make a
> more educated guess!

I've uploaded a trace output that includes the sysrq-t trace, but I
don't think it shows anything interesting.  We're not hanging on any
kind of loack as near as I can tell.  It looks like
__generic_make_request() is calling q->make_request_fn(), and this is
returning without actually doing anything.

http://userweb.kernel.org/~tytso/ext4-bio-patches/kvm-console-2

In this trace, I added a patch to prove that __generic_make_request()
is calling __make_request (I wasn't sure what q->make_request_fn was
indirecting to, so I added a brute force lookup to make sure I
understood what was going on), but at one point, it just starts
queuing the request, and it enters cfq, but the request never gets
dispatched out.  Maybe this is a failure of the plugging/unplugging
mechanisms?

I guess I can start putting in more brute-force printk's inside
__make_request and inside the cfq scheduler to try to understand what
is going on, but I'm really guessing at this point.

If you have any suggestions about more elegant ways of figuring what
is happening, please do let me know....

						- Ted
