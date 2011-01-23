From: Ted Ts'o <tytso@mit.edu>
Subject: Re: Severe slowdown caused by jbd2 process
Date: Sun, 23 Jan 2011 00:17:18 -0500
Message-ID: <20110123051718.GA3237@thunk.org>
References: <20110121125922.GB8949@dhcp231-156.rdu.redhat.com>
 <20110121140306.GA11313@dhcp231-156.rdu.redhat.com>
 <1295620109.22802.1.camel@tybalt>
 <20110121143145.GB11313@dhcp231-156.rdu.redhat.com>
 <20110121235641.GM3043@thunk.org>
 <4D3A2EC6.3020700@shiftmail.org>
 <20110122013415.GN3043@thunk.org>
 <4D3B03FA.4040604@shiftmail.org>
 <EF21BE9C-2457-4C17-A667-9839E23C58B8@mit.edu>
 <4D3B66AB.6030102@shiftmail.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Josef Bacik <josef@redhat.com>,
	Jon Leighton <j@jonathanleighton.com>,
	linux-ext4@vger.kernel.org
To: torn5 <torn5@shiftmail.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from thunk.org ([69.25.196.29]:53165 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750699Ab1AWFRZ (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sun, 23 Jan 2011 00:17:25 -0500
Content-Disposition: inline
In-Reply-To: <4D3B66AB.6030102@shiftmail.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sun, Jan 23, 2011 at 12:22:19AM +0100, torn5 wrote:
> 
> Sometimes it's useful, and that's the reason why Postgresql and
> Mysql both have a no-fsync mode.

Yes, and that's why the application is the right place to decide
whether or not to do fsync.

> Sometimes you have to do something for which intermediate state
> doesn't matter. Think at it as a computation: if it fails, you
> restart it from the beginning. In scientific research this is often
> the case. Often to save time you use software already written, which
> might have an excessively conservative behaviour for a "computation"
> , and this slows down your computation. But rewriting such
> application is simply too much, so you end up waiting patiently...

You're using open source software, right?  If so, you can edit the
source and recompile it.  :-)

Oh, you're using proprietary software?  That doesn't have an
fsync-mode?  Now you know one of the serious downsides of buying a car
whose hood is welded shut.

> that's why a fakefsync mount option would be nice to have.

Yes, except the file system developers don't want to take on the moral
liability of system administrators using such a mount option
incorrectly.  Might as well ask why Lawn Mower manufacturers don't
make lawn mowers where you can disable the safety device that prevents
the blade from spinning when the wheels are lifted off the ground.
Just "it could be useful" because you could trim hedges with the lawn
mower isn't going to be sufficient justification....

> Anyway, you said fsyncs in nobarriers mode (only?) generate a
> journal commit and push writes to the HDD.
> Then if I also disable the journal the only thing that remains is
> the push of data to the HDD, right?
> This is near to a no-op I would say because data should have gone to
> the disks earlier or later... Ow... oh no, it's not, because you
> wait for the disk to return a completion and in the meanwhile you
> cannot use the CPU. Right?

We wait for the blocks queued for I/O to be sent to the disk.  That's
not quite the same thing, but yes, it can cause delay if you have a
lot of writes pending to be sent to the disk.

> May I ask how is this "push of data to the disk" implemented: does
> it skip the request queue for the disk (i.e. jumps ahead of the
> queue), or has other kinds of special priority, or it is submitted
> to the tail like normal and the fysnc waits patiently for it to
> reach the disk?

The fsync waits for all data to be sent to disk.  It has to; since we
can't easily, given the current disk protocols, distinguish between
the 5 MB of I/O that pertains to file A which is being fsync'ed, but
not the 20 MB of I/O pertaining to file B which is going on in the
background.  There is a way, for some newer disk drives, to do what's
called a FUA (Force Unit Attention) where a single block write request
bypasses all caches, including the track buffer, and it goes straight
to disk.  (Well, you could, but you'd regret it.)  But since a FUA
write bypasses all HDD optimizations, you can't really use it for bulk
file data.  You could use it if there was a few blocks that needed to
be sent to the disk *now*, bypassing all other I/O requests, but in
practice you need to do a lot more than that when fulfilling a fsync()
request.

Again, the right answer is for the application to be smart.  And if
it's not smart, and it's open source, fix the application.  If it's a
crappy proprietary userspace application, open a bug report; that's
why you pay the manufacturer $$$ for support, right?  And if they
won't fix it, well, then vote with your wallet, and go elsewhere.
Preferably to an properly written open source application.  :-)

						- Ted
