From: Theodore Tso <tytso@mit.edu>
Subject: Re: [patch] ext2/3: document conditions when reliable operation is
	possible
Date: Mon, 24 Aug 2009 09:01:25 -0400
Message-ID: <20090824130125.GG23677@mit.edu>
References: <20090312092114.GC6949@elf.ucw.cz> <200903121413.04434.rob@landley.net> <20090316122847.GI2405@elf.ucw.cz> <200903161426.24904.rob@landley.net> <20090323104525.GA17969@elf.ucw.cz> <87ljqn82zc.fsf@frosties.localdomain> <20090824093143.GD25591@elf.ucw.cz> <82k50tjw7u.fsf@mid.bfk.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Pavel Machek <pavel@ucw.cz>,
	Goswin von Brederlow <goswin-v-b@web.de>,
	Rob Landley <rob@landley.net>,
	kernel list <linux-kernel@vger.kernel.org>,
	Andrew Morton <akpm@osdl.org>, mtk.manpages@gmail.com,
	rdunlap@xenotime.net, linux-doc@vger.kernel.org,
	linux-ext4@vger.kernel.org
To: Florian Weimer <fweimer@bfk.de>
Return-path: <linux-doc-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <82k50tjw7u.fsf@mid.bfk.de>
Sender: linux-doc-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Mon, Aug 24, 2009 at 11:19:01AM +0000, Florian Weimer wrote:
> * Pavel Machek:
> 
> > +Linux block-backed filesystems can only work correctly when several
> > +conditions are met in the block layer and below (disks, flash
> > +cards). Some of them are obvious ("data on media should not change
> > +randomly"), some are less so.
> 
> You should make clear that the file lists per-file-system rules and
> that some file sytems can recover from some of the error conditions.

The only one that falls into that category is the one about not being
able to handle failed writes, and the way most failures take place,
they generally fail the ATOMIC-WRITES criterion in any case.  That is,
when a write fails, an attempt to read from that sector will generally
result in either (a) an error, or (b) data other than what was there
before the write was attempted.

> > +* don't damage the old data on a failed write (ATOMIC-WRITES)
> > +
> > +	(Thrash may get written into sectors during powerfail.  And
> > +	ext3 handles this surprisingly well at least in the
> > +	catastrophic case of garbage getting written into the inode
> > +	table, since the journal replay often will "repair" the
> > +	garbage that was written into the filesystem metadata blocks.
> 
> Isn't this by design?  In other words, if the metadata doesn't survive
> non-atomic writes, wouldn't it be an ext3 bug?

Part of the problem here is that "atomic-writes" is confusing; it
doesn't mean what many people think it means.  The assumption which
many naive filesystem designers make is that writes succeed or they
don't.  If they don't succeed, they don't change the previously
existing data in any way.  

So in the case of journalling, the assumption which gets made is that
when the power fails, the disk either writes a particular disk block,
or it doesn't.  The problem here is as with humans and animals, death
is not an event, it is a process.  When the power fails, the system
just doesn't stop functioning; the power on the +5 and +12 volt rails
start dropping to zero, and different components fail at different
times.  Specifically, DRAM, being the most voltage sensitve, tends to
fail before the DMA subsystem, the PCI bus, and the hard drive fails.
So as a result, garbage can get written out to disk as part of the
failure.  That's just the way hardware works.

Now consider a file system which does logical journalling.  It has
written to the journal, using a compact encoding, "the i_blocks field
is now 25, and i_size is 13000", and the journal transaction has
committed.  So now, it's time to update the inode on disk; but at that
precise moment, the power failures, and garbage is written to the
inode table.  Oops!  The entire sector containing the inode is
trashed.  But the only thing which recorded in the journal is the new
value of i_blocks and i_size.  So a journal replay won't help file
systems that do logical block journalling. 

Is that a file system "bug"?  Well, it's better to call that a
mismatch between the assumptions made of physical devices, and of the
file system code.  On Irix, SGI hardware had a powerfail interrupt,
and the power supply and extra-big capacitors, so that when a power
fail interrupt came in, the Irix would run around frantically shutting
down pending DMA transfers to prevent this failure mode from causing
problems.  PC class hardware (according to Ted's law), is cr*p, and
doesn't have a powerfail interrupt, so it's not something that we
have.

Ext3, ext4, and ocfs2 does physical block journalling, so as long as
journal truncate hasn't taken place right before the failure, the
replay of the physical block journal tends to repair this most (but
not necessarily all) cases of "garbage is written right before power
failure".  People who care about this should really use a UPS, and
wire up the USB and/or serial cable from the UPS to the system, so
that the OS can do a controlled shutdown if the UPS is close to
shutting down due to an extended power failure.


There is another kind of non-atomic write that nearly all file systems
are subject to, however, and to give an example of this, consider what
happens if you a laptop is subjected to a sudden shock while it is
writing a sector, and the hard drive doesn't an accelerometer which
tries to anticipates such shocks.  (nb, these things aren't
fool-proof; even if a HDD has one of these sensors, they only work if
they can detect the transition to free-fall, and the hard drive has
time to retract the heads before the actual shock hits; if you have a
sudden shock, the g-shock sensors won't have time to react and save
the hard drive).

Depending on how severe the shock happens to be, the head could end up
impacting the platter, destroying the medium (which used to be
iron-oxide; hence the term "spinning rust platters") at that spot.
This will obviously cause a write failure, and the previous contents
of the sector will be lost.  This is also considered a failure of the
ATOMIC-WRITE property, and no, ext3 doesn't handle this case
gracefully.  Very few file systems do.  (It is possible for an OS that
doesn't have fixed metadata to immediately write the inode table to a
different location on the disk, and then update the pointers to the
inode table point to the new location on disk; but very few
filesystems do this, and even those that do usually rely on the
superblock being available on a fixed location on disk.  It's much
simpler to assume that hard drives usually behave sanely, and that
writes very rarely fail.)

It's for this reason that I've never been completely sure how useful
Pavel's proposed treatise about file systems expectations really are
--- because all storage subsystems *usually* provide these guarantees,
but it is the very rare storage system that *always* provides these
guarantees.

We could just as easily have several kilobytes of explanation in
Documentation/* explaining how we assume that DRAM always returns the
same value that was stored in it previously --- and yet most PC class
hardware still does not use ECC memory, and cosmic rays are a reality.
That means that most Linux systems run on systems that are vulnerable
to this kind of failure --- and the world hasn't ended.

As I recall, the main problem which Pavel had was when he was using
ext3 on a *really* trashy flash drive, on a *really* trashing laptop
where the flash card stuck out slightly, and any jostling of the
netbook would cause the flash card to become disconnected from the
laptop, and cause write errors, very easily and very frequently.  In
those circumstnaces, it's highly unlikely that ***any*** file system
would have been able to survive such an unreliable storage system.


One of the problems I have with the break down which Pavel has used is
that it doesn't break things down according to probability; the chance
of a storage subsystem scribbling garbage on its last write during a
power failure is very different from the chance that the hard drive
fails due to a shock, or due to some spilling printer toner near the
disk drive which somehow manages to find its way inside the enclosure
containing the spinning platters, versus the other forms of random
failures that lead to write failures.  All of these fall into the
category of a failure of the property he has named "ATOMIC-WRITE", but
in fact ways in which the filesystem might try to protect itself are
varied, and it isn't necessarily all or nothing.  One can imagine a
file system which can handle write failures for data blocks, but not
for metadata blocks; given that data blocks outnumber metadata blocks
by hundreds to one, and that write failures are relatively rare
(unless you have said trashy laptop with a trash flash card), a file
system that can gracefully deal with data block failures would be a
useful advancement.

But these things are never absolute, mainly because people aren't
willing to pay for either the cost of superior hardware (consider the
cost of ECC memory, which isn't *that* much more expensive; and yet
most PC class systems don't use it) or in terms of software overhead
(historically many file system designers have eschewed the use of
physical block journalling because it really hurts on meta-data
intensive benchmarks), talking about absolute requirements for
ATOMIC-WRITE isn't all that useful --- because nearly all hardware
doesn't provide these guarantees, and nearly all filesystems require
them.  So to call out ext2 and ext3 for requiring them, without making
clear that pretty much *all* file systems require them, ends up
causing people to switch over to some other file system that
ironically enough, might end up being *more* vulernable, but which
didn't earn Pavel's displeasure because he didn't try using, say, XFS
on his flashcard on his trashy laptop.

						- Ted
