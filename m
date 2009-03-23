From: Pavel Machek <pavel@ucw.cz>
Subject: Re: ext2/3: document conditions when reliable operation is possible
Date: Mon, 23 Mar 2009 19:23:41 +0100
Message-ID: <20090323182341.GA2695@elf.ucw.cz>
References: <20090312092114.GC6949@elf.ucw.cz> <200903121413.04434.rob@landley.net> <20090316123051.GJ2405@elf.ucw.cz> <20090316190308.GE6357@mit.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: Theodore Tso <tytso@mit.edu>, Rob Landley <rob@landley.net>,
	kernel list <linux-kernel@vger.kernel.org>,
	Andrew Morton <akpm@osdl.org>, mtk.manpages@gmail.com,
	rdunlap@xenotime.net, l
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:45313 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757974AbZCWSUs (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 23 Mar 2009 14:20:48 -0400
Content-Disposition: inline
In-Reply-To: <20090316190308.GE6357@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi!

> > > > Not all block devices are suitable for all filesystems. In fact, some
> > > > block devices are so broken that reliable operation is pretty much
> > > > impossible. Document stuff ext2/ext3 needs for reliable operation.
> 
> Some of what is here are bugs, and some are legitimate long-term
> interfaces (for example, the question of losing I/O errors when two
> processes are writing to the same file, or to a directory entry, and
> errors aren't or in some cases, can't, be reflected back to
> userspace).

Well, I guess there's thin line between error and "legitimate
long-term interfaces". I still believe that fsync() is broken by
design.

> I'm a little concerned that some of this reads a bit too much like a
> rant (and I know Pavel was very frustrated when he tried to use a
> flash card with a sucky flash card socket) and it will get used the

It started as a rant, obviously I'd like to get away from that and get
it into suitable format for inclusion. (Not being native speaker does
not help here).

But I do believe that we should get this documented; many common
storage subsystems are broken, and can cause data loss. We should at
least tell to the users.

> wrong way by apoligists, because it mixes areas where "we suck, we
> should do better", which a re bug reports, and "Posix or the
> underlying block device layer makes it hard", and simply states them
> as fundamental design requirements, when that's probably not true.

Well, I guess that can be refined later. Heck, I'm not able to tell
which are simple bugs likely to be fixed soon, and which are
fundamental issues that are unlikely to be fixed sooner than 2030. I
guess it is fair to document them ASAP, and then fix those that can be
fixed...

> There's a lot of work that we could do to make I/O errors get better
> reflected to userspace by fsync().  So state things as bald
> requirements I think goes a little too far IMHO.  We can surely do
> better.

If the fsync() can be fixed... that would be great. But I'm not sure
how easy that will be.

> > +Write errors not allowed (NO-WRITE-ERRORS)
> > +~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
> > +
> > +Writes to media never fail. Even if disk returns error condition
> > +during write, filesystems can't handle that correctly, because success
> > +on fsync was already returned when data hit the journal.
> 
> The last half of this sentence "because success on fsync was already
> returned when data hit the journal", obviously doesn't apply to all
> filesystems, since some filesystems, like ext2, don't journal data.
> Even for ext3, it only applies in the case of data=journal mode.  

Ok, I removed the explanation.

> There are other issues here, such as fsync() only reports an I/O
> problem to one caller, and in some cases I/O errors aren't propagated
> up the storage stack.  The latter is clearly just a bug that should be
> fixed; the former is more of an interface limitation.  But you don't
> talk about in this section, and I think it would be good to have a
> more extended discussion about I/O errors when writing data blocks,
> and I/O errors writing metadata blocks, etc.

Could you write a paragraph or two?

> > +
> > +Sector writes are atomic (ATOMIC-SECTORS)
> > +~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
> > +
> > +Either whole sector is correctly written or nothing is written during
> > +powerfail.
> 
> This requirement is not quite the same as what you discuss below.

Ok, you are right. Fixed.

> So there are actually two desirable properties for a storage system to
> have; one is "don't damage the old data on a failed write"; and the
> other is "don't cause collateral damage to adjacent sectors on a
> failed write".

Thanks, its indeed clearer that way. I split those in two.

> > +	Because RAM tends to fail faster than rest of system during 
> > +	powerfail, special hw killing DMA transfers may be necessary;
> > +	otherwise, disks may write garbage during powerfail.
> > +	Not sure how common that problem is on generic PC machines.
> 
> This problem is still relatively common, from what I can tell.  And
> ext3 handles this surprisingly well at least in the catastrophic case
> of garbage getting written into the inode table, since the journal
> replay often will "repair" the garbage that was written into the
...

Ok, added to ext3 specific section. New version is attached. Feel free
to help here; my goal is to get this documented, I'm not particulary
attached to wording etc...

Signed-off-by: Pavel Machek <pavel@ucw.cz>
									Pavel

diff --git a/Documentation/filesystems/expectations.txt b/Documentation/filesystems/expectations.txt
new file mode 100644
index 0000000..0de456d
--- /dev/null
+++ b/Documentation/filesystems/expectations.txt
@@ -0,0 +1,49 @@
+Linux block-backed filesystems can only work correctly when several
+conditions are met in the block layer and below (disks, flash
+cards). Some of them are obvious ("data on media should not change
+randomly"), some are less so.
+
+Write errors not allowed (NO-WRITE-ERRORS)
+~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
+
+Writes to media never fail. Even if disk returns error condition
+during write, filesystems can't handle that correctly.
+
+	Fortunately writes failing are very uncommon on traditional 
+	spinning disks, as they have spare sectors they use when write
+	fails.
+
+Don't cause collateral damage to adjacent sectors on a failed write (NO-COLLATERALS)
+~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
+
+Unfortunately, cheap USB/SD flash cards I've seen do have this bug,
+and are thus unsuitable for all filesystems I know.
+
+	An inherent problem with using flash as a normal block device
+	is that the flash erase size is bigger than most filesystem
+	sector sizes.  So when you request a write, it may erase and
+	rewrite some 64k, 128k, or even a couple megabytes on the
+	really _big_ ones.
+
+	If you lose power in the middle of that, filesystem won't
+	notice that data in the "sectors" _around_ the one your were
+	trying to write to got trashed.
+
+
+Don't damage the old data on a failed write (ATOMIC-WRITES)
+~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
+
+Either whole sector is correctly written or nothing is written during
+powerfail.
+
+	Because RAM tends to fail faster than rest of system during 
+	powerfail, special hw killing DMA transfers may be necessary;
+	otherwise, disks may write garbage during powerfail.
+	This may be quite common on generic PC machines.
+
+	Note that atomic write is very hard to guarantee for RAID-4/5/6,
+	because it needs to write both changed data, and parity, to 
+	different disks. UPS for RAID array should help.
+
+
+
diff --git a/Documentation/filesystems/ext2.txt b/Documentation/filesystems/ext2.txt
index 2344855..ee88467 100644
--- a/Documentation/filesystems/ext2.txt
+++ b/Documentation/filesystems/ext2.txt
@@ -338,27 +339,30 @@ enough 4-character names to make up unique directory entries, so they
 have to be 8 character filenames, even then we are fairly close to
 running out of unique filenames.
 
+Requirements
+============
+
+Ext2 expects disk/storage subsystem to behave sanely. On sanely
+behaving disk subsystem, data that have been successfully synced will
+stay on the disk. Sane means:
+
+* write errors not allowed (NO-WRITE-ERRORS)
+
+* don't damage the old data on a failed write (ATOMIC-WRITES)
+
+and obviously:
+
+* don't cause collateral damage to adjacent sectors on a failed write
+  (NO-COLLATERALS)
+
+(see expectations.txt; note that most/all linux block-based
+filesystems have similar expectations)
+
+* write caching is disabled. ext2 does not know how to issue barriers
+  as of 2.6.28. hdparm -W0 disables it on SATA disks.
+
 Journaling
-----------
-
-A journaling extension to the ext2 code has been developed by Stephen
-Tweedie.  It avoids the risks of metadata corruption and the need to
-wait for e2fsck to complete after a crash, without requiring a change
-to the on-disk ext2 layout.  In a nutshell, the journal is a regular
-file which stores whole metadata (and optionally data) blocks that have
-been modified, prior to writing them into the filesystem.  This means
-it is possible to add a journal to an existing ext2 filesystem without
-the need for data conversion.
-
-When changes to the filesystem (e.g. a file is renamed) they are stored in
-a transaction in the journal and can either be complete or incomplete at
-the time of a crash.  If a transaction is complete at the time of a crash
-(or in the normal case where the system does not crash), then any blocks
-in that transaction are guaranteed to represent a valid filesystem state,
-and are copied into the filesystem.  If a transaction is incomplete at
-the time of the crash, then there is no guarantee of consistency for
-the blocks in that transaction so they are discarded (which means any
-filesystem changes they represent are also lost).
+==========
 Check Documentation/filesystems/ext3.txt if you want to read more about
 ext3 and journaling.
 
diff --git a/Documentation/filesystems/ext3.txt b/Documentation/filesystems/ext3.txt
index e5f3833..6de8af4 100644
--- a/Documentation/filesystems/ext3.txt
+++ b/Documentation/filesystems/ext3.txt
@@ -188,6 +200,45 @@ mke2fs: 	create a ext3 partition with the -j flag.
 debugfs: 	ext2 and ext3 file system debugger.
 ext2online:	online (mounted) ext2 and ext3 filesystem resizer
 
+Requirements
+============
+
+Ext3 expects disk/storage subsystem to behave sanely. On sanely
+behaving disk subsystem, data that have been successfully synced will
+stay on the disk. Sane means:
+
+* write errors not allowed (NO-WRITE-ERRORS)
+
+* don't damage the old data on a failed write (ATOMIC-WRITES)
+
+	(Thrash may get written into sectors during powerfail.  And
+	ext3 handles this surprisingly well at least in the
+	catastrophic case of garbage getting written into the inode
+	table, since the journal replay often will "repair" the
+	garbage that was written into the filesystem metadata blocks.
+	It won't do a bit of good for the data blocks, of course
+	(unless you are using data=journal mode).  But this means that
+	in fact, ext3 is more resistant to suriving failures to the
+	first problem (powerfail while writing can damage old data on
+	a failed write) but fortunately, hard drives generally don't
+	cause collateral damage on a failed write.
+
+and obviously:
+
+* don't cause collateral damage to adjacent sectors on a failed write
+  (NO-COLLATERALS)
+
+
+(see expectations.txt; note that most/all linux block-based
+filesystems have similar expectations)
+
+* either write caching is disabled, or hw can do barriers and they are enabled.
+
+	   (Note that barriers are disabled by default, use "barrier=1"
+	   mount option after making sure hw can support them). 
+
+	   hdparm -I reports disk features. If you have "Native
+	   Command Queueing" is the feature you are looking for.
 
 References
 ==========

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
