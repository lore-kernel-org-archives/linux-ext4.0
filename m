From: Theodore Tso <tytso@mit.edu>
Subject: Re: [PATCH][e2fsprogs] New bitmap and inode table allocation for
	FLEX_BG
Date: Thu, 3 Apr 2008 09:12:40 -0400
Message-ID: <20080403131240.GA13486@mit.edu>
References: <20080401031311.10442.12267.stgit@gara.konoha.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: "Jose R. Santos" <jrs@us.ibm.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from www.church-of-our-saviour.ORG ([69.25.196.31]:55406 "EHLO
	thunker.thunk.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754732AbYDCNNF (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 3 Apr 2008 09:13:05 -0400
Content-Disposition: inline
In-Reply-To: <20080401031311.10442.12267.stgit@gara.konoha.net>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Mar 31, 2008 at 10:13:11PM -0500, Jose R. Santos wrote:
> From: Jose R. Santos <jrs@us.ibm.com>
> 
> New bitmap and inode table allocation for FLEX_BG
> 
> Change the way we allocate bitmaps and inode tables if the FLEX_BG
> feature is used at mke2fs time.  It places calculates a new offset for
> bitmaps and inode table base on the number of groups that the user
> wishes to pack together using the new "-G" option.  Creating a
> filesystem with 64 block groups in a flex group can be done by:

I was just testing out this patch, and it looks like it creates a
filesystem with an incorrect free blocks count when creating a
filesystem with both uninit_groups and flex_bg.  Can you look at this,
please?

						- Ted

<tytso.root@closure> {/usr/projects/e2fsprogs/e2fsprogs/build/misc}, level 2  [js/flex-bg]
550# ./mke2fs -O uninit_groups,flex_bg /dev/closure/testext4 
mke2fs 1.40.8 (13-Mar-2008)
Filesystem label=
OS type: Linux
Block size=4096 (log=2)
Fragment size=4096 (log=2)
65536 inodes, 262144 blocks
13107 blocks (5.00%) reserved for the super user
First data block=0
Maximum filesystem blocks=268435456
8 block groups
32768 blocks per group, 32768 fragments per group
8192 inodes per group
Superblock backups stored on blocks: 
        32768, 98304, 163840, 229376

Writing inode tables: done                            
Writing superblocks and filesystem accounting information: done

This filesystem will be automatically checked every 27 mounts or
180 days, whichever comes first.  Use tune2fs -c or -i to override.
<tytso.root@closure> {/usr/projects/e2fsprogs/e2fsprogs/build/misc}, level 2  [js/flex-bg]
551# ../e2fsck/e2fsck -fy /dev/closure/testext4
e2fsck 1.40.8 (13-Mar-2008)
Pass 1: Checking inodes, blocks, and sizes
Pass 2: Checking directory structure
Pass 3: Checking directory connectivity
Pass 4: Checking reference counts
Pass 5: Checking group summary information
Free blocks count wrong for group #0 (31669, counted=32183).
Fix? yes

Free blocks count wrong for group #1 (31675, counted=32189).
Fix? yes

Free blocks count wrong for group #2 (31740, counted=32254).
Fix? yes

Free blocks count wrong for group #3 (31675, counted=32189).
Fix? yes

Free blocks count wrong for group #4 (31740, counted=32254).
Fix? yes

Free blocks count wrong for group #5 (31675, counted=32189).
Fix? yes

Free blocks count wrong for group #6 (31740, counted=32254).
Fix? yes

Free blocks count wrong for group #7 (31675, counted=32189).
Fix? yes

Free blocks count wrong (253589, counted=257701).
Fix? yes


/dev/closure/testext4: ***** FILE SYSTEM WAS MODIFIED *****
/dev/closure/testext4: 11/65536 files (9.1% non-contiguous), 4443/262144 blocks

