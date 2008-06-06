From: David Brownell <david-b@pacbell.net>
Subject: verifying filesystem images on resume
Date: Fri, 6 Jun 2008 16:26:54 -0700
Message-ID: <200806061626.54950.david-b@pacbell.net>
Mime-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: Linus Torvalds <torvalds@osdl.org>,
	Alan Stern <stern@rowland.harvard.edu>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp115.sbc.mail.sp1.yahoo.com ([69.147.64.88]:21586 "HELO
	smtp115.sbc.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1757858AbYFFXdg (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 6 Jun 2008 19:33:36 -0400
Content-Disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi,

I'm scrubbing out some old email, and this one encapsulates some
thoughts of mine that I hope would still be addressible in the
context of ext4.

Briefly, consider the scenario of a *mounted* filesystem (say, ext4)
on some removable media such as a USB, Firewire, or external SATA
disk (or flash drive) during a suspend/resume cycle.  If that media
isn't removed, no problems should appear.  Ditto when the media can
report it's been removed ... like USB drives when the host stays in
the USB "suspend" state instead of powering off the USB hardware.
(In that case the backing media would just vanish ... which may have
some issues of its own.)

BUT ... when it's removed and then modified on a different system
before being replaced and then resumed, and the hardware doesn't
report the removal, then problems could appear when in-kernel data
structures related to that mounted device (like metadata caches)
become invalid.  Problems like filesystem corruption.

My observation was that at some level on-disk data structures
would need to be validated against in-kernel structures, and
one type of check could involve a simple generation number that's
updated before the suspend.  (Or check the journal, etc.)

Appended is some intial reaction from Linus, which observes that
more than the filesystem layers are affected.

Comments?  Do any Linux filesystems handle these things today?
If they don't ... shouldn't they do so?

- Dave



----------  Forwarded Message  ----------

Subject: Re: CONFIG_USB_PERSIST..
Date: Friday 22 February 2008
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: David Brownell <david-b@pacbell.net>, greg@kroah.com

On Fri, 22 Feb 2008, Alan Stern wrote:
> 
> >  - that image includes a generation number;
> >  - on resume, verify the generation number is what we expected.
> > 
> > If the image is clean, then no data should ever get lost when the
> > media is moved to a different system.  Seeing the right generation
> > number on resume can avoid problems like clobbering data that got
> > written by some other system ... if the number is wrong, cached
> > FS data can/should be invalidated.
> 
> That would help a lot.  But some filesystems probably don't have any 
> space in the on-disk superblock for storing such a generation number.

We could try to do a callback to openers along the lines of "please 
double-check the image", and then filesystems that can do so could try 
their best.

But that would require data structures that we don't yet have (and much 
more complex ones than just a counter). At *least* a pointer to the 
associated "struct block_device"s (and then you can walk those and find 
the super-blocks that have a s_bdev that has a ->container_of that points 
to the top-level block device, and then for each such superblock you can 
do the callback).

So it's possible, but it needs much more than the lock bit, and would 
require the filesystems to be able to double-check too. Most of them 
probably could do at least *some* sanity-checks, so it does sound like a 
good idea..

		Linus

-------------------------------------------------------
