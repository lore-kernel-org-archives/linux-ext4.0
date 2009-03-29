From: "J.D. Bakker" <jdb@lartmaker.nl>
Subject: Re: Once more: Recovering a damaged ext4 fs?
Date: Sun, 29 Mar 2009 23:01:40 +0100
Message-ID: <p062405b1c5f59a4c5ed1@[130.161.115.44]>
References: <p0624058dc5f2d7be08cc@[130.161.115.44]>
 <20090327224616.GD5176@mit.edu> <p0624058ec5f30b501efb@[130.161.115.44]>
 <20090328123035.GD2155@mit.edu> <p06240592c5f3caee289b@[130.161.115.44]>
 <20090328130922.GE2155@mit.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii" ; format="flowed"
Cc: linux-ext4@vger.kernel.org
To: Theodore Tso <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from www.lartmaker.nl ([69.93.127.100]:33637 "EHLO www.lartmaker.nl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752256AbZC2VBi (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sun, 29 Mar 2009 17:01:38 -0400
In-Reply-To: <20090328130922.GE2155@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

At 09:09 -0400 28-03-2009, Theodore Tso wrote:
>On Sat, Mar 28, 2009 at 01:53:35PM +0100, J.D. Bakker wrote:
>  > In the meantime I've tried mkfs -S, this complained about "File exists
>  > while trying to create journal". fsck -y is running (has been for a few
>  > hours) and appears to cycle through
>
>You should be able to work around the "File exists..." error via this
>command:
>
>	debugfs -w /dev/XXXX -R "clri <8>"
>
>... and then retrying the mke2fs -S command.

Tried that, gave somewhat unexpected results. I cancelled the running 
fsck, and issued 'debugfs -w /dev/md0 -R "clri <8>"'. This appeared 
to work, but when I retried the mkfs -S, I still got the "File exists 
while trying to create journal " error. I re-issued the debugfs 
command, which then failed with

   debugfs 1.41.4 (27-Jan-2009)
   /dev/md0: Bad magic number in super-block while opening filesystem

I have restarted the fsck (e2fsck -yv /dev/md0), but it appears to be 
stuck in a loop:

  e2fsck 1.41.4 (27-Jan-2009)
  ./e2fsck/e2fsck: Superblock invalid, trying backup blocks...
  Group descriptor 1 checksum is invalid.  Fix? yes
  Group descriptor 2 checksum is invalid.  Fix? yes
  [...]
  Group descriptor 27775 checksum is invalid.  Fix? yes
  Group descriptor 27941 checksum is invalid.  Fix? yes
  newraidfs contains a file system with errors, check forced.
  Pass 1: Checking inodes, blocks, and sizes
  Group 859's inode table at 3080346 conflicts with some other fs block.
  Relocate? yes
  Group 860's block bitmap at 33161701 conflicts with some other fs block.
  Relocate? yes
  [...]
  Group 25840's inode table at 846725656 conflicts with some other fs block.
  Relocate? yes
  Group 25840's inode table at 846725657 conflicts with some other fs block.
  Relocate? yes
  Root inode is not a directory.  Clear? yes
  [no output for a few minutes]
  Error allocating 1 contiguous block(s) in block group 175 for block 
bitmap: Could not allocate block in ext2 filesystem
  Error allocating 512 contiguous block(s) in block group 175 for 
inode table: Could not allocate block in ext2 filesystem
  Error allocating 1 contiguous block(s) in block group 769 for inode 
bitmap: Could not allocate block in ext2 filesystem
  [...]
  Error allocating 512 contiguous block(s) in block group 16353 for 
inode table: Could not allocate block in ext2 filesystem
  Error allocating 512 contiguous block(s) in block group 25840 for 
inode table: Could not allocate block in ext2 filesystem
  Restarting e2fsck from the beginning...
  ./e2fsck/e2fsck: Group descriptors look bad... trying backup blocks...
  Group descriptor 1 checksum is invalid.  Fix? yes

...and it starts all over again. I had left it running overnight; in 
the morning it had produced the exact same output 97 times. Over 
those runs the e2fsck process grew from a few hundred MB to 3GB (all 
of the RAM installed in the machine), and had pushed all other 
processes out to swap. Full log file is available at 
http://lartmaker.nl/ext4/e2fsck-md0-20090327-yv-2.txt . I have since 
killed e2fsck in the belief that if 97 passes weren't going to do it, 
number 98 would be unlikely to help much.

Is there anything else I can do? Before the crash the fs was ~66% 
full, so I'm not sure why e2fsck fails to allocate blocks.

Thanks,

JDB.
-- 
LART. 250 MIPS under one Watt. Free hardware design files.
http://www.lartmaker.nl/
