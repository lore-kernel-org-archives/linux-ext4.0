From: Jens Axboe <jens.axboe@oracle.com>
Subject: Re: [GIT PULL] Ext3 latency fixes
Date: Mon, 6 Apr 2009 17:09:44 +0200
Message-ID: <20090406150943.GC5178@kernel.dk>
References: <20090404135719.GA9812@mit.edu> <20090404151649.GE5178@kernel.dk> <alpine.LFD.2.00.0904040854470.3915@localhost.localdomain> <20090404173412.GF5178@kernel.dk> <alpine.LFD.2.00.0904041039230.3915@localhost.localdomain> <20090404180108.GH5178@kernel.dk> <20090404232222.GA7480@mit.edu> <20090404163349.20df1208@infradead.org> <20090406081616.GT5178@kernel.dk> <alpine.LFD.2.00.0904060739570.4023@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Arjan van de Ven <arjan@infradead.org>,
	Theodore Tso <tytso@mit.edu>,
	Linux Kernel Developers List <linux-kernel@vger.kernel.org>,
	Ext4 Developers List <linux-ext4@vger.kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from brick.kernel.dk ([93.163.65.50]:49464 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751739AbZDFPJq (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 6 Apr 2009 11:09:46 -0400
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.00.0904060739570.4023@localhost.localdomain>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Apr 06 2009, Linus Torvalds wrote:
> 
> 
> On Mon, 6 Apr 2009, Jens Axboe wrote:
> > 
> > Well, either you are submitting a single piece of IO (in which case you
> > just want to unplug or directly submit as part of the submit_bio()), or
> > you are submitting several IOS (in which case you just want to unplug at
> > the end of the IO submission, before waiting).
> 
> That's not true.
> 
> The plugging is often across multiple threads. It didn't _use_ to be (we 

It is completely true, you will very rarely see merges between
processes. The plug may be across the entire device and it'll get you
some inter-process sorting as well if you have more than one app busy,
but for merging it's usually effectively per-process.

> always unplugged at wait), but it is now. Nothing else explains why that 
> patch by Ted makes such a big throughput thing, because the code did
> 
>       ret = submit_bh(WRITE_SYNC, bh);
>       wait_on_buffer(bh);

Linus, the implementation is still basically the same. Yes it's true
that you used to do

        submit();
        unplug(;)
        wait();

and you better still be doing that or things will run at the timer
unplug speed - not very fast. The only difference is that we hide the
unplug in the wait_on_bit() callback, but it's definitely still very
much the same thing.

> ie it very much submits a _single_ IO, and waits on it. If plugging made a 
> difference, that means that unplugging was delayed so long that somebody 
> else does IO too - ie it gets delayed past a wait event.
> 
> So according to your own rules, that submit_bh() _should_ use WRITE_SYNC, 
> but something bad happens if it does. I'm not quite seeing _what_, though, 
> unless there are multiple processes trying to dirty the _same_ buffer, and 
> they win if they all can dirty it without doing IO on it in between (and 
> then the write turns into just one write).

sync_dirty_buffer() should use it, I agree, I even did the original
patch for it. And in the series posted today, it's also there and it
performs as expected now. For this particular case, it's not about
plugging. The performance penalty came from the 'sync' modifier, it'll
change how the IO schedulers look at the IO. Both AS and CFQ would have
considerably worse performance with this, as you would be mixing related
IO into both sync and async buckets. So it wasn't merging (as suspected)
or plugging.

-- 
Jens Axboe

