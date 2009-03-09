From: Christian <cjs@dhp.com>
Subject: Re: EXT4-fs: group descriptors corrupted!
Date: Mon, 9 Mar 2009 12:13:04 -0400
Message-ID: <20090309161304.GA6199@dhp.com>
References: <20090307065531.GC6947@dhp.com>
Reply-To: Christian <cjs@dhp.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from eastrmmtao102.cox.net ([68.230.240.8]:46832 "EHLO
	eastrmmtao102.cox.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752210AbZCIRKU (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 9 Mar 2009 13:10:20 -0400
Received: from eastrmimpo03.cox.net ([68.1.16.126])
          by eastrmmtao102.cox.net
          (InterMail vM.7.08.02.01 201-2186-121-102-20070209) with ESMTP
          id <20090309171018.UJIE8735.eastrmmtao102.cox.net@eastrmimpo03.cox.net>
          for <linux-ext4@vger.kernel.org>; Mon, 9 Mar 2009 13:10:18 -0400
Content-Disposition: inline
In-Reply-To: <20090307065531.GC6947@dhp.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

I fixed this problem using fsck, but I will detail what occured incase
someone else comes across the same problem.   

Running fsck -n on the disk gave me the following:

fsck 1.41.4 (27-Jan-2009)
Group descriptor 0 checksum is invalid.  Fix? no
Group descriptor 1 checksum is invalid.  Fix? no
Group descriptor 2 checksum is invalid.  Fix? no
[33,000+ of these..]
Group descriptor 33534 checksum is invalid.  Fix? no
Pass 1: Checking inodes, blocks, and sizes
Pass 2: Checking directory structure
Pass 3: Checking directory connectivity
Pass 4: Checking reference counts
Pass 5: Checking group summary information

Free blocks count wrong for group #0 (23513, counted=1880).
Fix? no
Free blocks count wrong for group #1 (31743, counted=684).
Fix? no
[58,000+ of these..]
Free blocks count wrong for group #58287 (32254, counted=5095).
Fix? no

Free inodes count wrong for group #0 (8181, counted=0).
Fix? no
Directories count wrong for group #0 (2, counted=110).
Fix? no
[751 of these..]
Free inodes count wrong for group #913 (8192, counted=3376).
Fix? no
Directories count wrong for group #913 (0, counted=160).
Fix? no
Free inodes count wrong for group #928 (8192, counted=4034).
Fix? no
Directories count wrong for group #928 (0, counted=548).
Fix? no
Free inodes count wrong (545908446, counted=546390043).
Fix? no


/dev/md1: ********** WARNING: Filesystem still has errors **********

/dev/md1: 3520802/549429248 files (5.2% non-contiguous),
1170576453/2197703904 blocks


Next was running fsck -y with fingers crossed..

fsck 1.41.4 (27-Jan-2009)
Group descriptor 0 checksum is invalid.  Fix? yes

[same thing as above but yes..]

Directories count wrong for group #928 (0, counted=548).
Fix? yes
Free inodes count wrong (549429237, counted=546390043).
Fix? yes
/dev/md1: ***** FILE SYSTEM WAS MODIFIED *****
/dev/md1: 3039205/549429248 files (6.0% non-contiguous),
1252924969/2197703904 blocks

After this the file system was back to normal, with no data loss.  I'm
thinking that something screwy occured during the 3 times that I ran
resize2fs (live) to expand the ext4 filesystem.  I initially started
with 5 1.5TB drives, and then added three more 1.5TB drives one-by-one
running resize2fs each time.  During all of this I never unmounted the
device or rebooted the system.

-Christian


> Hello,
> 
> I have an EXT4 filesystem on a raid6 that I created with 2.6.28.  After
> the initial creation of the partition I later did 3 filesystem expands
> after adding drives.  I didn't have a problem until I recently had a
> kernel panic and rebooted.  I think the kernel panic was related to my
> nvidia driver.  After rebooting the raid no longer mounted, and dmesg
> reported:
> 
> EXT4-fs: ext4_check_descriptors: Inode bitmap for group 0 not in group
> (block 3245938880)!
> EXT4-fs: group descriptors corrupted!
> 
> After reading several threads online, I attempted a fsck pointing to a
> backup superblock and now I receive this error:
> 
> EXT4-fs: ext4_check_descriptors: Checksum for group 0 failed
> (7390!=34008)
> EXT4-fs: group descriptors corrupted!
> 
> using dd if=/dev/md1|strings I can see a number of the files on the disk. 
> 
> Running Gentoo: 
> 
> Linux server1 2.6.28.5 #5 SMP Mon Feb 23 00:52:10 EST 2009 x86_64
> Intel(R) Core(TM) i7 CPU 920 @ 2.67GHz GenuineIntel GNU/Linux
> 
> e2fsprogs 1.41.3
> 
> 6GB memory
> 6GB swap
