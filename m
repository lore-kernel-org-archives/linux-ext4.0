From: Theodore Tso <tytso@mit.edu>
Subject: Re: [PATCH: e2fsprogs: resize2fs failed when "mkfs.ext4 -O
	flex_bg"]
Date: Tue, 10 Feb 2009 11:48:31 -0500
Message-ID: <20090210164831.GA29220@mini-me.lan>
References: <4990CB6A.1020403@cn.fujitsu.com> <20090210010917.GA30689@mini-me.lan> <4990F546.3050906@cn.fujitsu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Gui Xiaohua <guixh@cn.fujitsu.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from thunk.org ([69.25.196.29]:60542 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752443AbZBJSVd (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 10 Feb 2009 13:21:33 -0500
Content-Disposition: inline
In-Reply-To: <4990F546.3050906@cn.fujitsu.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, Feb 10, 2009 at 11:32:22AM +0800, Gui Xiaohua wrote:
> Hi Ted
> I have tested your patch,but occurs some messages like below:
> resize2fs: Illegal triply indirect block found while trying to resize /dev/sda7
> 

Hi, Could you be a bit more precise with your reproduction
instructions?  I've tried this, and it works for me.  Stupid question
--- you did install e2fsprogs 1.41.4 before you tried this, right?  If
you built with shared libraries, and ended up using 1.41.3's shared
libraries with the 1.41.4 binaries, this might cause this problem,
since a number of the bug fixes which I applied were in the libext2fs
library.

							- Ted

<tytso.root@mini-me> {/home/tytso/e2fsprogs/build}, level 2  [master]
513# dd if=/dev/zero of=/var/tmp/resize-test.img bs=4k count=16032
16032+0 records in
16032+0 records out
65667072 bytes (66 MB) copied, 1.08768 s, 60.4 MB/s
<tytso.root@mini-me> {/home/tytso/e2fsprogs/build}, level 2  [master]
514# mke2fs -t ext4 -O flex_bg /var/tmp/resize-test.img 
mke2fs 1.41.4 (27-Jan-2009)
/var/tmp/resize-test.img is not a block special device.
Proceed anyway? (y,n) y
Filesystem label=
OS type: Linux
Block size=1024 (log=0)
Fragment size=1024 (log=0)
16064 inodes, 64128 blocks
3206 blocks (5.00%) reserved for the super user
First data block=1
Maximum filesystem blocks=65798144
8 block groups
8192 blocks per group, 8192 fragments per group
2008 inodes per group
Superblock backups stored on blocks: 
	   8193, 24577, 40961, 57345

Writing inode tables: done                            
Creating journal (4096 blocks): done
Writing superblocks and filesystem accounting information: done

This filesystem will be automatically checked every 39 mounts or
180 days, whichever comes first.  Use tune2fs -c or -i to override.
<tytso.root@mini-me> {/home/tytso/e2fsprogs/build}, level 2  [master]
515# mount -o loop -t ext4 /var/tmp/resize-test.img  /mnt
<tytso.root@mini-me> {/home/tytso/e2fsprogs/build}, level 2  [master]
516# (cd /mnt; mkdir -p foo; cd foo; seq 1 2500 | xargs touch)
<tytso.root@mini-me> {/home/tytso/e2fsprogs/build}, level 2  [master]
517# umount /mnt
<tytso.root@mini-me> {/home/tytso/e2fsprogs/build}, level 2  [master]
518# e2fsck -f /var/tmp/resize-test.img 
e2fsck 1.41.4 (27-Jan-2009)
Pass 1: Checking inodes, blocks, and sizes
Pass 2: Checking directory structure
Pass 3: Checking directory connectivity
Pass 4: Checking reference counts
Pass 5: Checking group summary information
/var/tmp/resize-test.img: 2512/16064 files (0.1% non-contiguous), 7441/64128 blocks
<tytso.root@mini-me> {/home/tytso/e2fsprogs/build}, level 2  [master]
519# resize2fs -M /var/tmp/resize-test.img
resize2fs 1.41.4 (27-Jan-2009)
Resizing the filesystem on /var/tmp/foo.img to 8857 (1k) blocks.
The filesystem on /var/tmp/foo.img is now 8857 blocks long.

<tytso.root@mini-me> {/home/tytso/e2fsprogs/build}, level 2  [master]
520# 

