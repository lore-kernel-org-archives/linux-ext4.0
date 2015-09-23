From: "Pocas, Jamie" <Jamie.Pocas@emc.com>
Subject: RE: resize2fs stuck in ext4_group_extend with 100% CPU Utilization
 With Small Volumes
Date: Wed, 23 Sep 2015 00:20:17 -0400
Message-ID: <06724CF51D6BC94E9BEE7A8A8CB82A6740FE22BCF8@MX01A.corp.emc.com>
References: <06724CF51D6BC94E9BEE7A8A8CB82A6740FE22BCBA@MX01A.corp.emc.com>
 <5601ACFE.5080904@redhat.com>
 <06724CF51D6BC94E9BEE7A8A8CB82A6740FE22BCCC@MX01A.corp.emc.com>
 <20150922230204.GD3318@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Cc: Eric Sandeen <sandeen@redhat.com>,
	"linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>
To: "Theodore Ts'o" <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mailuogwdur.emc.com ([128.221.224.79]:29808 "EHLO
	mailuogwdur.emc.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750712AbbIWEUp convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 23 Sep 2015 00:20:45 -0400
In-Reply-To: <20150922230204.GD3318@thunk.org>
Content-Language: en-US
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Ted, just to add another data point, with some minor adjustments to the script to use xfs instead, such as using "mkfs.xfs -b size=1024" to force 1k blocks, I cannot reproduce the issue and the data block size doesn't change from 1k. This is still using loopback so I am a bit skeptical that the blame is due to the use of a loopback device or filesystems with an initial 1k fs block size. I can see this on other virtualized disks that can be resized online such as VMware virtual disks and remote iSCSI targets. I haven't tried LVM but I suspect that would be another good test. Suffer this small analogy for me and let me know where I am wrong: say hypothetically I expand a small partition (or LVM for that matter). Then I try to use resize2fs to grow the ext filesystem on it. I expect that this
  should *not* change the block size of the underlying device (of course not!) nor the filesystem's block size. Is that a correct assumption? I can see that it doesn't change the block size with xfs, nor the underlying device queue parameters for /dev/loop0 either (under /sys/block/loop0/queue).

This use of a relatively tiny volume is not a normal use case for my application so I want to express that this is not a super urgent issue for me to resolve right away. For my purposes I can just disallow using devices that are that small. They are really impractical anyway and this just came up in testing. I just wanted to do my duty and report what I think is a legitimate issue, and maybe validate someone else's frustration if they are having this issue, however small of an edge case this might turn out to be :). I also wasn't sure if was indicative of a bug on a boundary condition that might happen with other potentially incompatible combinations of mkfs/mount parameters or sizes of volumes that are not validated before use. That would be more serious. I deal more with the block storag
 e itself and so I admit I am not an ext4 expert, hence the possibly bad analogy earlier :). I am willing to take a deeper look into the code and see if I can figure out a patch when I get some more time but I was just picking your brain in case it was something really obvious.

-Jamie


-----Original Message-----
From: Theodore Ts'o [mailto:tytso@mit.edu] 
Sent: Tuesday, September 22, 2015 7:02 PM
To: Pocas, Jamie
Cc: Eric Sandeen; linux-ext4@vger.kernel.org
Subject: Re: resize2fs stuck in ext4_group_extend with 100% CPU Utilization With Small Volumes

On Tue, Sep 22, 2015 at 04:28:39PM -0400, Pocas, Jamie wrote:
> # mount -o loop testfile mnt
> # truncate --size=1G testfile
> # losetup -c /dev/loop0 ## Cause loop device to reread size of backing 
> file while still online # resize2fs /dev/loop0

It looks like the problem is with the loopback driver, and I can reproduce the problem using 4.3-rc2.

If you don't do *either* the truncate or the resize2fs command in the above sequence, and then do a "touch mnt/foo ; sync", the sync command will hang.

The problem is the losetup -c command, which calls the LOOP_SET_CAPACITY ioctl.  The problem is that this causes
bd_set_size() to be called, which has the side effect of forcing the block size of /dev/loop0 to 4096 --- which is a problem if the file system is using a 1k block size, and so the block size was properly set to 1024.  This is subsequently causing the buffer cache operations to hang.

So this will cause a hang:

cp /dev/null /tmp/foo.img
mke2fs -t ext4 /tmp/foo.img 100M
mount -o loop /tmp/foo.img /mnt
losetup -c /dev/loop0
touch /mnt/foo
sync

This will not hang:

cp /dev/null /tmp/foo.img
mke2fs -t ext4 -b 4096 /tmp/foo.img 100M mount -o loop /tmp/foo.img /mnt losetup -c /dev/loop0 touch /mnt/foo sync

And this also explains why you weren't seeing the problem with small file systems.  By default mke2fs uses a block size of 1k for file systems smaller than 512 MB.  This is largely for historical reasons since there was a time when we worried about optimizing the storage of every single byte of your 80MB disk (which was all you had on your 40 MHz 80386 :-).

With larger file systems, the block size defaults to 4096, so we don't run into problems when losetup -c attempts to set the block size --- which is something that is *not* supposed to change if the block device is currently mounted.  So for example, if you try to run the command "blockdev --setbsz", it will fail with an EBUSY if the block device is curently mounted.

So the workaround is to just create the file system with "-b 4096"
when you call mkfs.ext4.  This is a good idea if you intend to grow the file system, since it is far more efficient to use a 4k block size.

The proper fix in the kernel is to have the loop device check to see if the block device is currently mounted.  If it is, then needs to avoid changing the block size (which probably means it will need to call a modified version of bd_set_size), and the capacity of the block device needs to be rounded-down to the current block size.

(Currently if you set the capacity of the block device to be say, 1MB plus 2k, and the current block size is 4k, it will change the block size of the device to be 2k, so that the entire block device is addressable.  If the block device is mount and the block size is fixed to 4k, then it must not change the block size --- either up or down.
Instead, it must keep the block size at 4k, and only allow the capacity to be set to 1MB.)

Cheers,

					- Ted
