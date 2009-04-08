From: Nick Dokos <nicholas.dokos@hp.com>
Subject: [PATCH 0/5][64-BIT] Miscellaneous e2fsprogs 64-bit patches - description
Date: Wed, 08 Apr 2009 17:45:47 -0400
Message-ID: <11629.1239227147@alphaville.usa.hp.com>
Reply-To: nicholas.dokos@hp.com
Cc: nicholas.dokos@hp.com, linux-ext4@vger.kernel.org,
	Valerie Aurora <vaurora@redhat.com>
To: Theodore Ts'o <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from g1t0026.austin.hp.com ([15.216.28.33]:34988 "EHLO
	g1t0026.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761544AbZDHVpq (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 8 Apr 2009 17:45:46 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

[I submitted the first three of these last week, but the first one,
although the fix was correct (in the sense of fiddling with the correct
bits), stylistically and from the point of code conventions and
readability, was rather a botch.  #2 and #3 are identical as patches but
I fixed up parts of the commentary that were wrong or misleading. So I
am reposting these as well as a couple of new ones. Please let me know
if there are other problems of this sort. Thanks!]

The following bugs were found by running various commands on a 32TiB file
system, containing a 16TiB file (maximum size).

---------------------------------------------------------------------------
1) ext2fs_block_alloc_stats2: fix size comparison for 64-bit compatibility.

Fixes a journal malformation that would not allow the fs to even be mounted.


2) Enable 64-bitness in e2image.c.

I needed to use it later.


3) blk_t -> blk64_t change in ext2fs_extent_get()/cast in extent_node_split().

e2image was reporting a corrupt extent header on the big file. I wrote a python
script to dump the extents (since debugfs was not working - see 4) and determined
that the on-disk extents were fine. Running e2image in gdb led to this.


4) debugfs.c extents display.

The inode of the 16TiB file was 13. I tried doing a "stat <13>" in
debugfs and it produced wrong extent info (block numbers wrapped).

With this change, it seems to produce the right block numbers: I spot-checked
against the extents that my script reported, but I have not done an
exhaustive comparison.


5) Fix inode->i_blocks 32-bit wrap in e2fsck/pass1.c.

e2fsck was complaining about an i_blocks mismatch on inode <13> (among
other things that I'm still working on).

This fixes the i_blocks mismatch issue.


---------------------------------------------------------------------------


Thanks,
Nick


P.S. Here is an interesting side issue:

Patch 3 mentions that e2image ran to completion after the patch was applied
(btw, in addition to the 16TiB file, the fs contains a directory with about
10^7 zero length files):

# time e2image -r /dev/mapper/bigvg-bigvol /dev/null
e2image 1.41.4-shared-64bit (27-Jan-2009)

real	37m18.991s
user	15m21.148s
sys	17m57.151s

but there is an interesting catch-22: how do I save its output?

I can try the command line suggested in the manual page:

  e2image -r <dev> - | bzip2 > image.bz2

but it takes forever: I started a run on Saturday and it was not
done by Tuesday when I killed it - writing to the pipe at 4096 bytes
a pop is very slow.

Or I can forego the compression and try to save to a file: it's sparse
(I only used 7GiB before it failed), but its nominal size exceeded the
maximum file size limit on ext4, at which point I start getting lseek
failures.



