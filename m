From: Pavel Machek <pavel@ucw.cz>
Subject: Re: ext2/3: document conditions when reliable operation is possible
Date: Mon, 16 Mar 2009 13:30:51 +0100
Message-ID: <20090316123051.GJ2405@elf.ucw.cz>
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

Updated version here.

On Thu 2009-03-12 14:13:03, Rob Landley wrote:
> On Thursday 12 March 2009 04:21:14 Pavel Machek wrote:
> > Not all block devices are suitable for all filesystems. In fact, some
> > block devices are so broken that reliable operation is pretty much
> > impossible. Document stuff ext2/ext3 needs for reliable operation.
> >
> > Signed-off-by: Pavel Machek <pavel@ucw.cz>


diff --git a/Documentation/filesystems/expectations.txt b/Documentation/filesystems/expectations.txt
new file mode 100644
index 0000000..710d119
--- /dev/null
+++ b/Documentation/filesystems/expectations.txt
@@ -0,0 +1,47 @@
+Linux block-backed filesystems can only work correctly when several
+conditions are met in the block layer and below (disks, flash
+cards). Some of them are obvious ("data on media should not change
+randomly"), some are less so.
+
+Write errors not allowed (NO-WRITE-ERRORS)
+~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
+
+Writes to media never fail. Even if disk returns error condition
+during write, filesystems can't handle that correctly, because success
+on fsync was already returned when data hit the journal.
+
+	Fortunately writes failing are very uncommon on traditional 
+	spinning disks, as they have spare sectors they use when write
+	fails.
+
+Sector writes are atomic (ATOMIC-SECTORS)
+~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
+
+Either whole sector is correctly written or nothing is written during
+powerfail.
+
+	Unfortunately, none of the cheap USB/SD flash cards I've seen
+	do behave like this, and are thus unsuitable for all Linux
+	filesystems I know.
+
+		An inherent problem with using flash as a normal block
+		device is that the flash erase size is bigger than
+		most filesystem sector sizes.  So when you request a
+		write, it may erase and rewrite some 64k, 128k, or
+		even a couple megabytes on the really _big_ ones.
+
+		If you lose power in the middle of that, filesystem
+		won't notice that data in the "sectors" _around_ the
+		one your were trying to write to got trashed.
+
+	Because RAM tends to fail faster than rest of system during 
+	powerfail, special hw killing DMA transfers may be necessary;
+	otherwise, disks may write garbage during powerfail.
+	Not sure how common that problem is on generic PC machines.
+
+	Note that atomic write is very hard to guarantee for RAID-4/5/6,
+	because it needs to write both changed data, and parity, to 
+	different disks. UPS for RAID array should help.
+
+
+
diff --git a/Documentation/filesystems/ext2.txt b/Documentation/filesystems/ext2.txt
index 4333e83..41fd2ec 100644
--- a/Documentation/filesystems/ext2.txt
+++ b/Documentation/filesystems/ext2.txt
@@ -338,27 +339,25 @@ enough 4-character names to make up unique directory entries, so they
 have to be 8 character filenames, even then we are fairly close to
 running out of unique filenames.
 
+Requirements
+============
+
+Ext2 expects disk/storage subsystem to behave sanely. On sanely
+behaving disk subsystem, data that have been successfully synced will
+stay on the disk. Sane means:
+
+* write errors not allowed
+
+* sector writes are atomic
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
index 9dd2a3b..02a9bd5 100644
--- a/Documentation/filesystems/ext3.txt
+++ b/Documentation/filesystems/ext3.txt
@@ -188,6 +200,27 @@ mke2fs: 	create a ext3 partition with the -j flag.
 debugfs: 	ext2 and ext3 file system debugger.
 ext2online:	online (mounted) ext2 and ext3 filesystem resizer
 
+Requirements
+============
+
+Ext3 expects disk/storage subsystem to behave sanely. On sanely
+behaving disk subsystem, data that have been successfully synced will
+stay on the disk. Sane means:
+
+* write errors not allowed
+
+* sector writes are atomic
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
