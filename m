From: Theodore Tso <tytso@mit.edu>
Subject: Re: ext2/3: document conditions when reliable operation is possible
Date: Mon, 16 Mar 2009 15:03:08 -0400
Message-ID: <20090316190308.GE6357@mit.edu>
References: <20090312092114.GC6949@elf.ucw.cz> <200903121413.04434.rob@landley.net> <20090316123051.GJ2405@elf.ucw.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Rob Landley <rob@landley.net>,
	kernel list <linux-kernel@vger.kernel.org>,
	Andrew Morton <akpm@osdl.org>, mtk.manpages@gmail.com,
	rdunlap@xenotime.net, linux-doc@vger.kernel.org,
	linux-ext4@vger.kernel.org
To: Pavel Machek <pavel@ucw.cz>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from thunk.org ([69.25.196.29]:57648 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751918AbZCPTEG (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 16 Mar 2009 15:04:06 -0400
Content-Disposition: inline
In-Reply-To: <20090316123051.GJ2405@elf.ucw.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Mar 16, 2009 at 01:30:51PM +0100, Pavel Machek wrote:
> Updated version here.
> 
> On Thu 2009-03-12 14:13:03, Rob Landley wrote:
> > On Thursday 12 March 2009 04:21:14 Pavel Machek wrote:
> > > Not all block devices are suitable for all filesystems. In fact, some
> > > block devices are so broken that reliable operation is pretty much
> > > impossible. Document stuff ext2/ext3 needs for reliable operation.

Some of what is here are bugs, and some are legitimate long-term
interfaces (for example, the question of losing I/O errors when two
processes are writing to the same file, or to a directory entry, and
errors aren't or in some cases, can't, be reflected back to userspace).

I'm a little concerned that some of this reads a bit too much like a
rant (and I know Pavel was very frustrated when he tried to use a
flash card with a sucky flash card socket) and it will get used the
wrong way by apoligists, because it mixes areas where "we suck, we
should do better", which a re bug reports, and "Posix or the
underlying block device layer makes it hard", and simply states them
as fundamental design requirements, when that's probably not true.

There's a lot of work that we could do to make I/O errors get better
reflected to userspace by fsync().  So state things as bald
requirements I think goes a little too far IMHO.  We can surely do
better.


> diff --git a/Documentation/filesystems/expectations.txt b/Documentation/filesystems/expectations.txt
> new file mode 100644
> index 0000000..710d119
> --- /dev/null
> +++ b/Documentation/filesystems/expectations.txt
> +
> +Write errors not allowed (NO-WRITE-ERRORS)
> +~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
> +
> +Writes to media never fail. Even if disk returns error condition
> +during write, filesystems can't handle that correctly, because success
> +on fsync was already returned when data hit the journal.

The last half of this sentence "because success on fsync was already
returned when data hit the journal", obviously doesn't apply to all
filesystems, since some filesystems, like ext2, don't journal data.
Even for ext3, it only applies in the case of data=journal mode.  

There are other issues here, such as fsync() only reports an I/O
problem to one caller, and in some cases I/O errors aren't propagated
up the storage stack.  The latter is clearly just a bug that should be
fixed; the former is more of an interface limitation.  But you don't
talk about in this section, and I think it would be good to have a
more extended discussion about I/O errors when writing data blocks,
and I/O errors writing metadata blocks, etc.


> +
> +Sector writes are atomic (ATOMIC-SECTORS)
> +~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
> +
> +Either whole sector is correctly written or nothing is written during
> +powerfail.

This requirement is not quite the same as what you discuss below.

> +
> +	Unfortunately, none of the cheap USB/SD flash cards I've seen
> +	do behave like this, and are thus unsuitable for all Linux
> +	filesystems I know.
> +
> +		An inherent problem with using flash as a normal block
> +		device is that the flash erase size is bigger than
> +		most filesystem sector sizes.  So when you request a
> +		write, it may erase and rewrite some 64k, 128k, or
> +		even a couple megabytes on the really _big_ ones.
> +
> +		If you lose power in the middle of that, filesystem
> +		won't notice that data in the "sectors" _around_ the
> +		one your were trying to write to got trashed.

The characteristic you descrive here is not an issue about whether
the whole sector is either written or nothing happens to the data ---
but rather, or at least in addition to that, there is also the issue
that when a there is a flash card failure --- particularly one caused
by a sucky flash card reader design causing the SD card to disconnect
from the laptop in the middle of a write --- there may be "collateral
damange"; that is, in addition to corrupting sector being writen,
adjacent sectors might also end up getting list as an unfortunate side
effect.

So there are actually two desirable properties for a storage system to
have; one is "don't damage the old data on a failed write"; and the
other is "don't cause collateral damage to adjacent sectors on a
failed write".

> +	Because RAM tends to fail faster than rest of system during 
> +	powerfail, special hw killing DMA transfers may be necessary;
> +	otherwise, disks may write garbage during powerfail.
> +	Not sure how common that problem is on generic PC machines.

This problem is still relatively common, from what I can tell.  And
ext3 handles this surprisingly well at least in the catastrophic case
of garbage getting written into the inode table, since the journal
replay often will "repair" the garbage that was written into the
filesystem metadata blocks.  It won't do a bit of good for the data
blocks, of course (unless you are using data=journal mode).  But this
means that in fact, ext3 is more resistant to suriving failures to the
first problem (powerfail while writing can damage old data on a failed
write) but fortunately, hard drives generally don't cause collateral
damage on a failed write.  Of course, there are some spectaular
exemption to this rule --- a physical shock which causes the head to
slam into a surface moving at 7200rpm can throw a lot of debris into
the hard drive enclosure, causing loss to adjacent sectors.

    	       		  	       	  - Ted
