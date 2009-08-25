From: Pavel Machek <pavel@ucw.cz>
Subject: [patch] document flash/RAID dangers
Date: Wed, 26 Aug 2009 00:21:12 +0200
Message-ID: <20090825222112.GB4300@elf.ucw.cz>
References: <20090824195159.GD29763@elf.ucw.cz> <4A92F6FC.4060907@redhat.com> <20090824205209.GE29763@elf.ucw.cz> <4A930160.8060508@redhat.com> <20090824212518.GF29763@elf.ucw.cz> <20090824223915.GI17684@mit.edu> <20090824230036.GK29763@elf.ucw.cz> <20090825000842.GM17684@mit.edu> <20090825094244.GC15563@elf.ucw.cz> <20090825161110.GP17684@mit.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: Theodore Tso <tytso@mit.edu>, Ric Wheeler <rwheeler@redhat.com>,
	Florian Weimer <fweimer@bfk.de>,
	Goswin von Brederlow <goswin-v-b@web.de>,
	Rob Landley <rob@landley.net>,
	kernel list
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:60419 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756206AbZHYWVW (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 25 Aug 2009 18:21:22 -0400
Content-Disposition: inline
In-Reply-To: <20090825161110.GP17684@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi!

> It seems that you are really hung up on whether or not the filesystem
> metadata is consistent after a power failure, when I'd argue that the
> problem with using storage devices that don't have good powerfail
> properties have much bigger problems (such as the potential for silent
> data corruption, or even if fsck will fix a trashed inode table with
> ext2, massive data loss).  So instead of your suggested patch, it
> might be better simply to have a file in Documentation/filesystems
> that states something along the lines of:
> 
> "There are storage devices that high highly undesirable properties
> when they are disconnected or suffer power failures while writes are
> in progress; such devices include flash devices and software RAID 5/6
> arrays without journals, as well as hardware RAID 5/6 devices without
> battery backups.  These devices have the property of potentially
> corrupting blocks being written at the time of the power failure, and
> worse yet, amplifying the region where blocks are corrupted such that
> adjacent sectors are also damaged during the power failure.

In FTL case, damaged sectors are not neccessarily adjacent. Otherwise
this looks okay and fair to me.

> Users who use such storage devices are well advised take
> countermeasures, such as the use of Uninterruptible Power Supplies,
> and making sure the flash device is not hot-unplugged while the device
> is being used.  Regular backups when using these devices is also a
> Very Good Idea.
> 
> Otherwise, file systems placed on these devices can suffer silent data
> and file system corruption.  An forced use of fsck may detect metadata
> corruption resulting in file system corruption, but will not suffice
> to detect data corruption."

Ok, would you be against adding:

"Running non-journalled filesystem on these may be desirable, as
journalling can not provide meaningful protection, anyway."

> My big complaint is that you seem to think that ext3 some how let you
> down, but I'd argue that the real issue is that the storage device let
> you down.  Any journaling filesystem will have the properties that you
> seem to be complaining about, so the fact that your patch only
> documents this as assumptions made by ext2 and ext3 is unfair; it also
> applies to xfs, jfs, reiserfs, reiser4, etc.  Further more, most
> users

Yes, it applies to all journalling filesystems; it is just that I was 
clever/paranoid enough to avoid anything non-ext3.

ext3 docs still says:
# The journal supports the transactions start and stop, and in case of a
# crash, the journal can replay the transactions to quickly put the
# partition back into a consistent state.

> are even more concerned about possibility of massive data loss and/or
> silent data corruption.  So if your complaint that we don't have
> documentation warning users about the potential pitfalls of using
> storage devices with undesirable power fail properties, let's document
> that as a shortcoming in those storage devices.

Ok, works for me.

---

From: Theodore Tso <tytso@mit.edu>

Document that many devices are too broken for filesystems to protect
data in case of powerfail.

Signed-of-by: Pavel Machek <pavel@ucw.cz> 

diff --git a/Documentation/filesystems/dangers.txt b/Documentation/filesystems/dangers.txt
new file mode 100644
index 0000000..e1a46dd
--- /dev/null
+++ b/Documentation/filesystems/dangers.txt
@@ -0,0 +1,19 @@
+There are storage devices that high highly undesirable properties
+when they are disconnected or suffer power failures while writes are
+in progress; such devices include flash devices and software RAID 5/6
+arrays without journals, as well as hardware RAID 5/6 devices without
+battery backups.  These devices have the property of potentially
+corrupting blocks being written at the time of the power failure, and
+worse yet, amplifying the region where blocks are corrupted such that
+additional sectors are also damaged during the power failure.
+        
+Users who use such storage devices are well advised take
+countermeasures, such as the use of Uninterruptible Power Supplies,
+and making sure the flash device is not hot-unplugged while the device
+is being used.  Regular backups when using these devices is also a
+Very Good Idea.
+        
+Otherwise, file systems placed on these devices can suffer silent data
+and file system corruption.  An forced use of fsck may detect metadata
+corruption resulting in file system corruption, but will not suffice
+to detect data corruption.
\ No newline at end of file

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
