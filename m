From: Pavel Machek <pavel@ucw.cz>
Subject: Re: ext2/3: document conditions when reliable operation is possible
Date: Mon, 16 Mar 2009 13:28:47 +0100
Message-ID: <20090316122847.GI2405@elf.ucw.cz>
References: <20090312092114.GC6949@elf.ucw.cz> <200903121413.04434.rob@landley.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: kernel list <linux-kernel@vger.kernel.org>,
	Andrew Morton <akpm@osdl.org>, mtk.manpages@gmail.com,
	tytso@mit.edu, rdunlap@xenotime.net, linux-doc@vger.kernel.org,
	linux-ext4@vger.kernel.org
To: Rob Landley <rob@landley.net>
Return-path: <linux-doc-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <200903121413.04434.rob@landley.net>
Sender: linux-doc-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Hi!

> > +Write errors not allowed (NO-WRITE-ERRORS)
> > +~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
> > +
> > +Writes to media never fail. Even if disk returns error condition
> > +during write, filesystems can't handle that correctly, because success
> > +on fsync was already returned when data hit the journal.
> > +
> > +	Fortunately writes failing are very uncommon on traditional
> > +	spinning disks, as they have spare sectors they use when write
> > +	fails.
> 
> I vaguely recall that the behavior of when a write error _does_ occur is to 
> remount the filesystem read only?  (Is this VFS or per-fs?)

Per-fs.

> Is there any kind of hotplug event associated with this?

I don't think so.

> I'm aware write errors shouldn't happen, and by the time they do it's too late 
> to gracefully handle them, and all we can do is fail.  So how do we
> fail?

Well, even remount-ro may be too late, IIRC.

> > +	Unfortuantely, none of the cheap USB/SD flash cards I seen do
> 
> I've seen
> 
> > +	behave like this, and are unsuitable for all linux filesystems
> 
> "are thus unsuitable", perhaps?  (Too pretentious? :)

ACK, thanks.

> > +	I know.
> > +
> > +		An inherent problem with using flash as a normal block
> > +		device is that the flash erase size is bigger than
> > +		most filesystem sector sizes.  So when you request a
> > +		write, it may erase and rewrite the next 64k, 128k, or
> > +		even a couple megabytes on the really _big_ ones.
> 
> Somebody corrected me, it's not "the next" it's "the surrounding".

Its "some" ... due to wear leveling logic.

> (Writes aren't always cleanly at the start of an erase block, so critical data 
> _before_ what you touch is endangered too.)

Well, flashes do remap, so it is actually "random blocks".

> > +	otherwise, disks may write garbage during powerfail.
> > +	Not sure how common that problem is on generic PC machines.
> > +
> > +	Note that atomic write is very hard to guarantee for RAID-4/5/6,
> > +	because it needs to write both changed data, and parity, to
> > +	different disks.
> 
> These days instead of "atomic" it's better to think in terms of
> "barriers".  

This is not about barriers (that should be different topic). Atomic
write means that either whole sector is written, or nothing at all is
written. Because raid5 needs to update both master data and parity at
the same time, I don't think it can guarantee this during powerfail.


> > +Requirements
> > +* write errors not allowed
> > +
> > +* sector writes are atomic
> > +
> > +(see expectations.txt; note that most/all linux block-based
> > +filesystems have similar expectations)
> > +
> > +* write caching is disabled. ext2 does not know how to issue barriers
> > +  as of 2.6.28. hdparm -W0 disables it on SATA disks.
> 
> And here we're talking about ext2.  Does neither one know about write 
> barriers, or does this just apply to ext2?  (What about ext4?)

This document is about ext2. Ext3 can support barriers in
2.6.28. Someone else needs to write ext4 docs :-).

> Also I remember a historical problem that not all disks honor write barriers, 
> because actual data integrity makes for horrible benchmark numbers.  Dunno how 
> current that is with SATA, Alan Cox would probably know.

Sounds like broken disk, then. We should blacklist those.
									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
