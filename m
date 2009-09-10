From: Theodore Tso <tytso@mit.edu>
Subject: Re: buggy_init_scritps and e2fsprogs 1.41.9
Date: Thu, 10 Sep 2009 16:29:27 -0400
Message-ID: <20090910202927.GK23700@mit.edu>
References: <200909101455.38400.coolo@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org,
	Scott James Remnant <scott@canonical.com>
To: Stephan Kulow <coolo@suse.de>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from THUNK.ORG ([69.25.196.29]:46230 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753224AbZIJU3b (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 10 Sep 2009 16:29:31 -0400
Content-Disposition: inline
In-Reply-To: <200909101455.38400.coolo@suse.de>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, Sep 10, 2009 at 02:55:38PM +0200, Stephan Kulow wrote:
> 
> I face a bug in openSUSE since I updated to 1.41.9: you have
> to manually fix your file system if you happened to mount the
> file system in the wrong timezone on a machine using localtime
> hardware clock.

Yeah, it just so happened that I was working with Scott Remnant at
Canonical on this problem.  The problem is that if you (a) live east
of the GMT time zone (or it's British Summer Time :-), (b) configure
your hardware clock to tick localtime instead of GMT for Windows
bug-for-bug compatibility (meaning that you have to deal with problems
if your system happens to be down during the Daylight Savings Time
adjustment, and many other annoyances inflicted on us thanks to
Microsoft), and (c) suffer an unclean shutdown of your system,
requiring the system to perform journal recovery on the root
filesystem, *then* we run into problem where the system clock ---
which is always defined to tick GMT, but which is set from the
hardware clock at boot-time and is incorrect thanks to (a) --- is in
the future, thanks to (b), and part of the journal replay is requires
the kernel to update the superblock, and this causes the superblock's
last write time to be set in the future.  This causes e2fsck to decide
something must be seriously wrong, and it forces a full file system
check.

This problem has been around for a long time, but my best guess as to
why it hasn't been noticed is that many Europeans (especially Germans
:-) who are running SLES tend to be hard-core Linux folk, so they do
the One True Correct Thing, which is make their hardware CMOS clocks
tick GMT.  (I believe that SLES, being written by Germans who tend to
want to do the correct thing from an engineering point of view, also
strongly encourages the use of GMT for the CMOS clock).  Others tend
to use Ubuntu, which up until recently have set buggy_init_scripts=1
by default, which tends to paper over this problem.

Linux users in the US and others who live west of GMT don't see this
problem at all, since those that run in Windows bug-compatibity mode
simply have sb->s_wtime set in the past, and this is largely harmless.
Hence, no one has really noticed this problem until recently, when
Ubuntu's Karmic Koala release has exposed the problem by removing the
buggy_init_scripts config.

> I don't want to set buggy_init_scripts for openSUSE as the init
> scripts are not buggy, but a live cd is a live cd and has no idea
> what the timezone of the system is configured to and even a ro
> mount will destroy your file system ;(

Well, you're over-dramatizing things; it doesn't destroy your
filesystem --- it just forces an unnnecessary fsck.  And it only does
this if the system had been uncleanly shutdown before the the boot. 

Here's a kernel patch which should fix things for ext4.  I'll follow
up with a patch for ext3.  Scott, Stephen, you want to give this patch
a spin?

   	  	    	   	      	   - Ted

commit a55a57d6da66f80f4de1f8451602395bbdc49c26
Author: Theodore Ts'o <tytso@mit.edu>
Date:   Thu Sep 10 14:33:20 2009 -0400

    ext4: Don't update superblock write time when filesystem is read-only
    
    This avoids updating the superblock write time when we are mounting
    the root file system read/only but we need to replay the journal; at
    that point, for people who are east of GMT and who make their clock
    tick in localtime for Windows bug-for-bug compatibility, and this will
    cause e2fsck to complain and force a full file system check.
    
    Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>

diff --git a/fs/ext4/super.c b/fs/ext4/super.c
index f644a5c..33837c7 100644
--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -3244,7 +3244,18 @@ static int ext4_commit_super(struct super_block *sb, int sync)
 		clear_buffer_write_io_error(sbh);
 		set_buffer_uptodate(sbh);
 	}
-	es->s_wtime = cpu_to_le32(get_seconds());
+	/*
+	 * If the file system is mounted read-only, don't update the
+	 * superblock write time.  This avoids updating the superblock
+	 * write time when we are mounting the root file system
+	 * read/only but we need to replay the journal; at that point,
+	 * for people who are east of GMT and who make their clock
+	 * tick in localtime for Windows bug-for-bug compatibility,
+	 * the clock is set in the future, and this will cause e2fsck
+	 * to complain and force a full file system check.
+	 */
+	if (!(sb->s_flag & MS_RDONLY))
+		es->s_wtime = cpu_to_le32(get_seconds());
 	es->s_kbytes_written =
 		cpu_to_le64(EXT4_SB(sb)->s_kbytes_written + 
 			    ((part_stat_read(sb->s_bdev->bd_part, sectors[1]) -
