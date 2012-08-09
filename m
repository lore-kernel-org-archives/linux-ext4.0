From: "George Spelvin" <linux@horizon.com>
Subject: Arrgh!  Even more excitement with metadata checksumming
Date: 9 Aug 2012 19:48:43 -0400
Message-ID: <20120809234843.25187.qmail@science.horizon.com>
References: <20120809050058.23273.qmail@science.horizon.com>
To: linux-ext4@vger.kernel.org, linux@horizon.com, tytso@mit.edu
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from science.horizon.com ([71.41.210.146]:23251 "HELO
	science.horizon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1759875Ab2HIXsp (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 9 Aug 2012 19:48:45 -0400
In-Reply-To: <20120809050058.23273.qmail@science.horizon.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Havimg, I think, fixed the entire memory corruption problem that inspired
me to turn on metadata checksums, I want to revert to the standard Ubuntu
kernel, but first I need to figure out how to turn them off!

The obvious answer is with tune2fs:

> ~# tune2fs -O ^metadata_csum /dev/md0
> tune2fs 1.43-WIP (1-Aug-2012)
> rewrite_extents: Corrupt extent header while rewriting extents
> ~# 

Arrgh!  The file system passes e2fsck fine.  Well, *now* it doesn't; it
bitches about a zillion missing directory checksums and the lack
of lost+found:

> Directory inode 82676842, block #1, offset 3260: directory passes checks but fails checksum
> Fix? yes
> 
> Directory inode 82676842, block #2, offset 3264: directory passes checks but fails checksum
> Fix? yes
> 
> Directory inode 82677333, block #1, offset 3260: directory passes checks but fails checksum
> Fix? yes
> 
> Directory inode 82677333, block #2, offset 1328: directory passes checks but fails checksum
> Fix? yes
> 
> Directory inode 82675733, block #3, offset 124: directory passes checks but fails checksum
> Fix? yes
> 
> Directory inode 82676842, block #3, offset 432: directory passes checks but fails checksum
> Fix? yes
> 
> Pass 3: Checking directory connectivity
> Error while trying to find /lost+found: Directory block checksum does not match directory block
> /lost+found not found.  Create? yes
> 
> Error creating /lost+found directory (ext2fs_link): Directory block checksum does not match directory block
> Pass 3A: Optimizing directories
> Pass 4: Checking reference counts
> Unattached inode 12
> Connect to /lost+found? yes
> 
> Pass 5: Checking group summary information
> Block bitmap differences:  -937953738
> Fix? yes
> 
> Free blocks count wrong for group #28624 (28170, counted=28171).
> Fix? yes
> 
> Free blocks count wrong (841115975, counted=841115976).
> Fix? yes
> 
> 
> /dev/md0: ***** FILE SYSTEM WAS MODIFIED *****

But *after* that, it passes fine.

Unfortunately, I don't know where the problem is or I'd see if I could
just delete the damn problematic file.  (Or move it somewhere else
temporarily.)

I'm adding debugging to tune2fs and trying to track down the source.

Step 1:
eh_magic = dabe != f30a
Problem with extent of inode #85800449
rewrite_extents: Corrupt extent header while rewriting extents

Step 2:
debugfs:  ncheck 85800449
Inode   Pathname
debugfs:  testi <85800449>
Inode 85800449 is not in use

Step 3: ???
The print is in ext2fs_extent_open2, and I'm just printing the "ino"
parameter if ext2fs_extent_header_verify fails.

Why is tune2fs looking at an inode that's not in use?
That *would* explain the magic number error...

