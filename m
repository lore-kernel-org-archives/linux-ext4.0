From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: help with 'discard' mount option on ext4
Date: Fri, 11 Oct 2013 09:53:37 -0400
Message-ID: <20131011135337.GA18621@thunk.org>
References: <loom.20131010T102704-458@post.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Prasanna NAVARATNA <prasanna.navaratna@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:44901 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751932Ab3JKNxm (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 11 Oct 2013 09:53:42 -0400
Content-Disposition: inline
In-Reply-To: <loom.20131010T102704-458@post.gmane.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, Oct 10, 2013 at 08:28:20AM +0000, Prasanna NAVARATNA wrote:
> 
> I'm using Hynix eMMC4.41 with Linux kernel 3.4.5.
> 
> After mounting ext4 partition /userdata with 'discard' mount option enabled,
> fs triggers TRIM commands to eMMC after every file deletion. With this
> setup, for a continuous reboot test (5s awake and issue reboot and repeat)
> with 10 or 20 iterations, i see data corruption in eMMC consistently.
> 
> mount options are :- noatime,nosuid,nodev,noauto_da_alloc,discard
> encryptable="path"
> 
> What am i missing here? if 'discard' mount option is removed, then no data
> corruption in eMMC for more than 200 iterations. Does TRIM needs some extra
> care? BKOPS is not enabled in eMMC (is bkops mandatory if using TRIM?)
> Are there any latest patches which address these corruption issues during
> reboot with discard option enabled?

Unfortunately, there is a lot of what professionals in the field call
"crappy flash" out there.  This is especially true of low-cost flash
devices, such as eMMC or SD cards.  (Heck, there are cards marketing
as containing 16GB of data that only contains 8GB of space, and rely
on the fact that many people never completely fill their SD cards,
because when you write over 8GB, data starts getting lost or
corrupted.)

If using the TRIM command on the eMMC device results in corruption,
then the card is broken by definition.  It may be that using using
fstrim instead of the discard mount option will work better for you;
with fstrim, which is either run manually or periodically by the user,
the Kernel will issue trim commands for all of the unused regions of
the disk when the fstrim program is run, instead of after every
delete.  The fstrim approach often results in better performance
(especially on low-end flash) than issuing a discard after every file
deletion, which is why I recommend it.

However, if the hardware is so broken as to result in file corruption
with the discard option, there is no guarantee that it might not also
result in file corruption when using the fstrim approach --- it might
just not be as obvious, so you don't catch it in testing, but only
catch it production.

Unfortunately, many product managers (especially for low-end
embedded/consumer devices) are more concerned with saving a penny or
two on the Bill of Materials cost of their embedded devices than they
are about the safety of their users' data.  And so the eMMC
manufacturers have responded to this market demand by cutting corners
and making craptastic flash devices.  Isn't the free market system
wonderful?

You may also find that some of these devices have very atrocious 4k
random write speeds, and in fact if you try to use them as part of a
general Linux system, as opposed to storing digital images on a FAT
file system, that simple heavy use will result in horrible
performance, or worse, data corruption.

Hopefully with the higher end mobile handset / consumer devices, the
manufacturer, who will be buying eMMC devices in lots of several
million units at a time, will be carrying out their own quality
control and testing.  But if you are buying just a few units at a time
aas an individual hobbyist/consumer, life is very tough....

Regards,

						- Ted
