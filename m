From: Pavel Machek <pavel@ucw.cz>
Subject: Re: ext2/3: document conditions when reliable operation is possible
Date: Mon, 23 Mar 2009 11:45:25 +0100
Message-ID: <20090323104525.GA17969@elf.ucw.cz>
References: <20090312092114.GC6949@elf.ucw.cz> <200903121413.04434.rob@landley.net> <20090316122847.GI2405@elf.ucw.cz> <200903161426.24904.rob@landley.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: kernel list <linux-kernel@vger.kernel.org>,
	Andrew Morton <akpm@osdl.org>, mtk.manpages@gmail.com,
	tytso@mit.edu, rdunlap@xenotime.net, linux-doc@vger.kernel.org,
	linux-ext4@vger.kernel.org
To: Rob Landley <rob@landley.net>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:44875 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752964AbZCWKmf (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 23 Mar 2009 06:42:35 -0400
Content-Disposition: inline
In-Reply-To: <200903161426.24904.rob@landley.net>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon 2009-03-16 14:26:23, Rob Landley wrote:
> On Monday 16 March 2009 07:28:47 Pavel Machek wrote:
> > Hi!
> > > > +	Fortunately writes failing are very uncommon on traditional
> > > > +	spinning disks, as they have spare sectors they use when write
> > > > +	fails.
> > >
> > > I vaguely recall that the behavior of when a write error _does_ occur is
> > > to remount the filesystem read only?  (Is this VFS or per-fs?)
> >
> > Per-fs.
> 
> Might be nice to note that in the doc.

Ok, can you suggest a patch? I believe remount-ro is already
documented ... somewhere :-).

> > > I'm aware write errors shouldn't happen, and by the time they do it's too
> > > late to gracefully handle them, and all we can do is fail.  So how do we
> > > fail?
> >
> > Well, even remount-ro may be too late, IIRC.
> 
> Care to elaborate?  (When a filesystem is mounted RO, I'm not sure what 
> happens to the pages that have already been dirtied...)

Well, fsync() error reporting does not really work properly, but I
guess it will save you for the remount-ro case. So the data will be in
the journal, but it will be impossible to replay it...

> > > (Writes aren't always cleanly at the start of an erase block, so critical
> > > data _before_ what you touch is endangered too.)
> >
> > Well, flashes do remap, so it is actually "random blocks".
> 
> Fun.

Yes.

> > > > +	otherwise, disks may write garbage during powerfail.
> > > > +	Not sure how common that problem is on generic PC machines.
> > > > +
> > > > +	Note that atomic write is very hard to guarantee for RAID-4/5/6,
> > > > +	because it needs to write both changed data, and parity, to
> > > > +	different disks.
> > >
> > > These days instead of "atomic" it's better to think in terms of
> > > "barriers".
> >
> > This is not about barriers (that should be different topic). Atomic
> > write means that either whole sector is written, or nothing at all is
> > written. Because raid5 needs to update both master data and parity at
> > the same time, I don't think it can guarantee this during powerfail.
> 
> Good point, but I thought that's what journaling was for?

I believe journaling operates on assumption that "either whole sector
is written, or nothing at all is written".

> I'm aware that any flash filesystem _must_ be journaled in order to work 
> sanely, and must be able to view the underlying erase granularity down to the 
> bare metal, through any remapping the hardware's doing.  Possibly what's 
> really needed is a "flash is weird" section, since flash filesystems can't be 
> mounted on arbitrary block devices.

> Although an "-O erase_size=128" option so they _could_ would be nice.  There's 
> "mtdram" which seems to be the only remaining use for ram disks, but why there 
> isn't an "mtdwrap" that works with arbitrary underlying block devices, I have 
> no idea.  (Layering it on top of a loopback device would be most
> useful.)

I don't think that works. Compactflash (etc) cards basically randomly
remap the data, so you can't really run flash filesystem over
compactflash/usb/SD card -- you don't know the details of remapping.
									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
