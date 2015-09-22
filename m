From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: resize2fs stuck in ext4_group_extend with 100% CPU Utilization
 With Small Volumes
Date: Tue, 22 Sep 2015 19:02:05 -0400
Message-ID: <20150922230204.GD3318@thunk.org>
References: <06724CF51D6BC94E9BEE7A8A8CB82A6740FE22BCBA@MX01A.corp.emc.com>
 <5601ACFE.5080904@redhat.com>
 <06724CF51D6BC94E9BEE7A8A8CB82A6740FE22BCCC@MX01A.corp.emc.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Eric Sandeen <sandeen@redhat.com>,
	"linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>
To: "Pocas, Jamie" <Jamie.Pocas@emc.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:37612 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758219AbbIVXCJ (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 22 Sep 2015 19:02:09 -0400
Content-Disposition: inline
In-Reply-To: <06724CF51D6BC94E9BEE7A8A8CB82A6740FE22BCCC@MX01A.corp.emc.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, Sep 22, 2015 at 04:28:39PM -0400, Pocas, Jamie wrote:
> # mount -o loop testfile mnt
> # truncate --size=1G testfile
> # losetup -c /dev/loop0 ## Cause loop device to reread size of backing file while still online
> # resize2fs /dev/loop0

It looks like the problem is with the loopback driver, and I can
reproduce the problem using 4.3-rc2.

If you don't do *either* the truncate or the resize2fs command in the
above sequence, and then do a "touch mnt/foo ; sync", the sync command
will hang.

The problem is the losetup -c command, which calls the
LOOP_SET_CAPACITY ioctl.  The problem is that this causes
bd_set_size() to be called, which has the side effect of forcing the
block size of /dev/loop0 to 4096 --- which is a problem if the file
system is using a 1k block size, and so the block size was properly
set to 1024.  This is subsequently causing the buffer cache operations
to hang.

So this will cause a hang:

cp /dev/null /tmp/foo.img
mke2fs -t ext4 /tmp/foo.img 100M
mount -o loop /tmp/foo.img /mnt
losetup -c /dev/loop0
touch /mnt/foo
sync

This will not hang:

cp /dev/null /tmp/foo.img
mke2fs -t ext4 -b 4096 /tmp/foo.img 100M
mount -o loop /tmp/foo.img /mnt
losetup -c /dev/loop0
touch /mnt/foo
sync

And this also explains why you weren't seeing the problem with small
file systems.  By default mke2fs uses a block size of 1k for file
systems smaller than 512 MB.  This is largely for historical reasons
since there was a time when we worried about optimizing the storage of
every single byte of your 80MB disk (which was all you had on your 40
MHz 80386 :-).

With larger file systems, the block size defaults to 4096, so we don't
run into problems when losetup -c attempts to set the block size ---
which is something that is *not* supposed to change if the block
device is currently mounted.  So for example, if you try to run the
command "blockdev --setbsz", it will fail with an EBUSY if the block
device is curently mounted.

So the workaround is to just create the file system with "-b 4096"
when you call mkfs.ext4.  This is a good idea if you intend to grow
the file system, since it is far more efficient to use a 4k block
size.

The proper fix in the kernel is to have the loop device check to see
if the block device is currently mounted.  If it is, then needs to
avoid changing the block size (which probably means it will need to
call a modified version of bd_set_size), and the capacity of the block
device needs to be rounded-down to the current block size.

(Currently if you set the capacity of the block device to be say, 1MB
plus 2k, and the current block size is 4k, it will change the block
size of the device to be 2k, so that the entire block device is
addressable.  If the block device is mount and the block size is fixed
to 4k, then it must not change the block size --- either up or down.
Instead, it must keep the block size at 4k, and only allow the
capacity to be set to 1MB.)

Cheers,

					- Ted
