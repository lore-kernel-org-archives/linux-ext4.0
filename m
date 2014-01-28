From: Benjamin LaHaise <bcrl@kvack.org>
Subject: Re: high write latency bug in ext3 / jbd in 3.4
Date: Tue, 28 Jan 2014 11:06:26 -0500
Message-ID: <20140128160626.GM19273@kvack.org>
References: <20140113201320.GD1214@kvack.org> <20140127235518.GB7020@quack.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Jan Kara <jack@suse.cz>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from kanga.kvack.org ([205.233.56.17]:32957 "EHLO kanga.kvack.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755260AbaA1QG2 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 28 Jan 2014 11:06:28 -0500
Content-Disposition: inline
In-Reply-To: <20140127235518.GB7020@quack.suse.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi Jan,

On Tue, Jan 28, 2014 at 12:55:18AM +0100, Jan Kara wrote:
>   Hello,
> 
> On Mon 13-01-14 15:13:20, Benjamin LaHaise wrote:
...
>   I'm not sure if you haven't switched to ext4 as others have suggested in
> this thread. If not:
>   1) Since the stall is so long, can you run
>      'echo w >/proc/sysrq-trigger'
>      when the stall happens and send the stack traces from kernel log?

Unfortunately, I didn't capture that output while testing.  I ended up 
migrating to using the ext4 codebase for our ext3 filesystems.  With a 
couple of tweaks to the inode allocator, I was able to resolve the 
regression moving to ext4 had caused.  If there is actually some desire 
to fix this bug, I can certainly go back and reproduce it.

>   2) Are you running with 'barrier' option?

I didn't change the barrier setting from the default.

> > Does anyone have any ideas on where to look in ext3 or jbd for something 
> > that might be causing this behaviour?  If I use ext4 to mount the ext3 
> > filesystem being tested, the problem goes away.  Testing on newer kernels 
> > is not very easy to do (the system has other dependencyies on the 3.4 
> > kernel).  Thoughts?
>   My suspicion is we are hanging on writing the 'commit' block of a
> transaction. That issues a cache flush to the storage and that can take
> quite a bit of time if we are unlucky.

I actually control both ends of the SAN (the two systems are connected via 
fibre channel), and while the hang occurs, no I/O shows up as being queued 
on the head end.  It is as if the system is waiting on a write that hasn't 
been submitted yet.

		-ben

> 								Honza
> -- 
> Jan Kara <jack@suse.cz>
> SUSE Labs, CR

-- 
"Thought is the essence of where you are now."
