From: Ted Ts'o <tytso@mit.edu>
Subject: Re: [PATCH] mke2fs: Inform user about ongoing discard
Date: Mon, 22 Nov 2010 15:20:02 -0500
Message-ID: <20101122202002.GA2767@thunk.org>
References: <1287670982-32348-1-git-send-email-lczerner@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, sandeen@redhat.com, adilger@dilger.ca
To: Lukas Czerner <lczerner@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from thunk.org ([69.25.196.29]:52318 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753516Ab0KWPSr (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 23 Nov 2010 10:18:47 -0500
Content-Disposition: inline
In-Reply-To: <1287670982-32348-1-git-send-email-lczerner@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, Oct 21, 2010 at 04:23:02PM +0200, Lukas Czerner wrote:
> Since there are some slow SSD's out there and big thinly provisioned
> storages on which it takes quite long to issue discard through whole
> device, it would be nice to provide user the information about what is
> going on and how long it will take (approximately).
> 
> Signed-off-by: Lukas Czerner <lczerner@redhat.com>

Hi Lukas,

I've looked at this patch, and one thing that disturbs me about it ---
you are discarding the first percentage of the disk five percent times
for no good reason just to get the timing, before then executing the
discard for the entire disk.   There are a couple of problems with this:

*) For smart/competently implemented SSD's, discarding the same part
of the disk five times might lead to a misleading timing --- the smart
device could easily determine that the first 1% is already not in use
after the first discard, and the subsequent 4 discards could be
discard as no-ops.

*) Mark Lord has claimed that there exists a large number of
incomptently implemented SSD's out there, that may actually be
executing a flash erase of the discarded region.  If true, executing
an extra flash erase on 1% of the disk for no good reason five times
might not be the best thing to do for the longetivity of the device.

I was tempted to fix this up myself, but since I'm trying to get
better at delegating work to others, may I suggest the following
changes?

1)  Implement block device ioctl's for the kernel that export the
discard_granularity, discard_alignment, and max_discard_sectors.  

2) Change mke2fs so that the discard is done in a separate function.
Said function should attempt to fetch the discard_granularity,
discard_alignment, and max_discard_sectors.

3) This new function in mke2fs should start by discarding
approximately 1% of device at a time, respecting discard_granularity
and discard_alignment.  If the time to discard 1% of the device is
less than a second, then it should double the amount that it discards
at a time.  If the time to discard takes longer than 4 seconds, it
should reduce the amount that it discards by half (again, always
respecting discard_granularity and discard_alignment).  The function
can display the amount of time elapsed and the estimated amount of
time remaining after each chunk of the device that it discards,
assuming it can use ^M to redraw the progress report (which of course
should be suppressed if the -q option is specified on the command
line).


This design doesn't "waste" any discards, which is both faster and
reduces wear on badly designed SSD's.  It also continuously updates
the user with the amount of time it takes to complete the discard
process.  It also will respect the discard_granularity and
discard_alignment restrictions; and of course, it allows the user to
interrupt the discard, without needing a special kernel patch.

Does this make sense to you?

						- Ted
