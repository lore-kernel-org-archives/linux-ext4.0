From: Ted Ts'o <tytso@mit.edu>
Subject: Re: What am I doing wrong?  submit_bio() suddenly stops working...
Date: Thu, 21 Oct 2010 23:34:24 -0400
Message-ID: <20101022033424.GO3127@thunk.org>
References: <E1P8kSE-0001DW-8C@tytso-glaptop>
 <4CBFE4E2.7050001@kernel.dk>
 <20101021165525.GB3127@thunk.org>
 <4CC07C67.9010502@kernel.dk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>
To: Jens Axboe <axboe@kernel.dk>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from THUNK.ORG ([69.25.196.29]:53328 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751320Ab0JVDea (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 21 Oct 2010 23:34:30 -0400
Content-Disposition: inline
In-Reply-To: <4CC07C67.9010502@kernel.dk>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, Oct 21, 2010 at 07:46:15PM +0200, Jens Axboe wrote:
> By the sound of things, if I were you I'd turn on the mem and slab
> debugging to catch use-before-init and use-after-free. Mysterious hangs
> in the IO sub system are usually caused by such bugs. And the regular
> debugging aids, just to see if that produces anything of interest.

It looks like it was a use-after-free bug in my code.  I'm running a
full set of set of tests now, but so far, it's gotten a lot further
than it went before, so I think I've figured it out.

I'm not sure why it caused the weird behaviour that it did (I got as
far as figuring out that somehow we lost the unplug timer, so after
the queue got plugged it never got unplugged), but I'm not going to
ask too many questions.  :-)

Maybe later on I'll try to figure out if there's any way to add some
kind of sanity checking so that screw ups in in the bio code's caller
cause a clearer failure (such as a BUG_ON), but that'll have to wait
for when I have some free time.

	    					- Ted
