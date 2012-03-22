From: Ted Ts'o <tytso@mit.edu>
Subject: Re: running mkfs.ext4 causes very high system load
Date: Thu, 22 Mar 2012 11:35:00 -0400
Message-ID: <20120322153500.GE25897@thunk.org>
References: <20120322140547.GA10657@pcnci2.linuxbox.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, Radovan Mzik <radovan.mzik@linuxbox.cz>
To: Nikola Ciprich <nikola.ciprich@linuxbox.cz>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:35665 "EHLO
	test.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757276Ab2CVPfD (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 22 Mar 2012 11:35:03 -0400
Content-Disposition: inline
In-Reply-To: <20120322140547.GA10657@pcnci2.linuxbox.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, Mar 22, 2012 at 03:05:47PM +0100, Nikola Ciprich wrote:
> Hi,
> 
> we've hit strange problem on one of our servers today.
> We needed to add new logical volume, so created 320GB LV,
> and tried to create ext4 using:
> 
> $ mkfs.ext4 /dev/vg/home2
> 
> the problem is, it progressed very slow, and seemed to block all
> other applications currently trying to access disks, thus causing system load
> jumping much over 150.

Mke2fs generates a large number of writes, and with LVM, if you are
writing a lot to an LV which uses physical disks shared by other LV's,
ultimately you are going to run into disk contention.  It sounds like
from your description that your system is pretty busy, and other
applications are using the disks pretty heavily.

The other potential thing that could be happening is that mke2fs is
dirtying a lot of memory blocks when it writes to the disk, and so
your system is thrashing due memory pressure.

If you can upgrade to a newer kernel, 2.6.39 or 3.0 has a new "lazy
inode table" initialization feature which allows mke2fs to write much
fewer blocks, and to then spread out the load of initialization the
bulk of the inode table after the file system is first mounted.  (We
try to use about 10% of the available disk bandwidth, but this can be
configured.)

If it is caused by memory pressure it may be that using direct I/O
will help make mke2fs be more "polite" at the expensive of taking a bit longer.

Here are patches versus the latest e2fsprogs (1.42.1) that might be
helpful.  After you apply them, run mke2fs with the -D option to force
the use of direct I/O.  Let me know if it makes a difference for you.

Regards,

						 - Ted

diff --git a/lib/ext2fs/initialize.c b/lib/ext2fs/initialize.c
index a63ea18..b06371c 100644
--- a/lib/ext2fs/initialize.c
+++ b/lib/ext2fs/initialize.c
@@ -119,6 +119,8 @@ errcode_t ext2fs_initialize(const char *name, int flags,
 	io_flags = IO_FLAG_RW;
 	if (flags & EXT2_FLAG_EXCLUSIVE)
 		io_flags |= IO_FLAG_EXCLUSIVE;
+	if (flags & EXT2_FLAG_DIRECT_IO)
+		io_flags |= IO_FLAG_DIRECT_IO;
 	retval = manager->open(name, io_flags, &fs->io);
 	if (retval)
 		goto cleanup;
diff --git a/misc/mke2fs.8.in b/misc/mke2fs.8.in
index 8e78249..9f1fa29 100644
--- a/misc/mke2fs.8.in
+++ b/misc/mke2fs.8.in
@@ -18,6 +18,9 @@ mke2fs \- create an ext2/ext3/ext4 filesystem
 .I block-size
 ]
 [
+.B \-D
+]
+[
 .B \-f
 .I fragment-size
 ]
@@ -184,6 +187,11 @@ Check the device for bad blocks before creating the file system.  If
 this option is specified twice, then a slower read-write
 test is used instead of a fast read-only test.
 .TP
+.B \-D
+Use direct I/O when writing to the disk.  This avoids mke2fs dirtying a
+lot of buffer cache memory which may impact other applications running
+on a busy server, at the expense of causing mke2fs to run much more slowly.
+.TP
 .BI \-E " extended-options"
 Set extended options for the filesystem.  Extended options are comma
 separated, and may take an argument using the equals ('=') sign.  The
diff --git a/misc/mke2fs.c b/misc/mke2fs.c
index 51435d2..b8ff19b 100644
--- a/misc/mke2fs.c
+++ b/misc/mke2fs.c
@@ -88,6 +88,7 @@ int	verbose;
 int	quiet;
 int	super_only;
 int	discard = 1;	/* attempt to discard device before fs creation */
+int	direct_io;
 int	force;
 int	noaction;
 int	journal_size;
@@ -1321,7 +1322,7 @@ profile_error:
 	}
 
 	while ((c = getopt (argc, argv,
-		    "b:cg:i:jl:m:no:qr:s:t:vC:E:FG:I:J:KL:M:N:O:R:ST:U:V")) != EOF) {
+		    "b:cg:i:jl:m:no:qr:s:t:vC:DE:FG:I:J:KL:M:N:O:R:ST:U:V")) != EOF) {
 		switch (c) {
 		case 'b':
 			blocksize = strtol(optarg, &tmp, 0);
@@ -1354,6 +1355,9 @@ profile_error:
 				exit(1);
 			}
 			break;
+		case 'D':
+			direct_io = 1;
+			break;
 		case 'g':
 			fs_param.s_blocks_per_group = strtoul(optarg, &tmp, 0);
 			if (*tmp) {
@@ -2257,6 +2261,8 @@ int main (int argc, char *argv[])
 	 * Initialize the superblock....
 	 */
 	flags = EXT2_FLAG_EXCLUSIVE;
+	if (direct_io)
+		flags |= EXT2_FLAG_DIRECT_IO;
 	profile_get_boolean(profile, "options", "old_bitmaps", 0, 0,
 			    &old_bitmaps);
 	if (!old_bitmaps)
