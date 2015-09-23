From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: resize2fs stuck in ext4_group_extend with 100% CPU Utilization
 With Small Volumes
Date: Wed, 23 Sep 2015 11:14:06 -0400
Message-ID: <20150923151406.GE3318@thunk.org>
References: <06724CF51D6BC94E9BEE7A8A8CB82A6740FE22BCBA@MX01A.corp.emc.com>
 <5601ACFE.5080904@redhat.com>
 <06724CF51D6BC94E9BEE7A8A8CB82A6740FE22BCCC@MX01A.corp.emc.com>
 <20150922230204.GD3318@thunk.org>
 <06724CF51D6BC94E9BEE7A8A8CB82A6740FE22BCF8@MX01A.corp.emc.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Eric Sandeen <sandeen@redhat.com>,
	"linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>
To: "Pocas, Jamie" <Jamie.Pocas@emc.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:38848 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755411AbbIWPOJ (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 23 Sep 2015 11:14:09 -0400
Content-Disposition: inline
In-Reply-To: <06724CF51D6BC94E9BEE7A8A8CB82A6740FE22BCF8@MX01A.corp.emc.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, Sep 23, 2015 at 12:20:17AM -0400, Pocas, Jamie wrote:
> Ted, just to add another data point, with some minor adjustments to
> the script to use xfs instead, such as using "mkfs.xfs -b size=1024"
> to force 1k blocks, I cannot reproduce the issue and the data block
> size doesn't change from 1k.

Yes, that's not surprising, because XFS doesn't use the buffer cache
layer.  Ext4 does, because that's the basis of how the jbd2 layer
works.  It does change the block size as reported by the block device
and which is used by the buffer cache layer, though.  (Internally,
this is known as the "soft" block size; it's basically the data in
which data is cached in the buffer cache layer):

root@kvm-xfstests:~# truncate -s 100M /tmp/foo.img
root@kvm-xfstests:~# mkfs.xfs -b size=1024 /tmp/foo.img
meta-data=/tmp/foo.img           isize=512    agcount=4, agsize=25600 blks
         =                       sectsz=512   attr=2, projid32bit=1
         =                       crc=1        finobt=1, sparse=0
data     =                       bsize=1024   blocks=102400, imaxpct=25
         =                       sunit=0      swidth=0 blks
naming   =version 2              bsize=4096   ascii-ci=0 ftype=1
log      =internal log           bsize=1024   blocks=2573, version=2
         =                       sectsz=512   sunit=0 blks, lazy-count=1
realtime =none                   extsz=4096   blocks=0, rtextents=0
root@kvm-xfstests:~# mount -o loop /tmp/foo.img /mnt
root@kvm-xfstests:~# blockdev --getbsz /dev/loop0
1024
root@kvm-xfstests:~# losetup -c /dev/loop0
root@kvm-xfstests:~# blockdev --getbsz /dev/loop0
4096 <--------- BUG, note the change in the block size
root@kvm-xfstests:~# touch /mnt/foo
root@kvm-xfstests:~# sync
<------ The reason why we don't hang is that XFS doesn't use the
<------ buffer cache
root@kvm-xfstests:~# umount /mnt



Also feel free to try my repro, but using "blockdev --getbsz
/dev/loop" before and after the losetup -c command, and note that it
does not hang even though there is no resize2fs in the command
sequence at all:

root@kvm-xfstests:~# cp /dev/null /tmp/foo.img
root@kvm-xfstests:~# truncate -s 100M /tmp/foo.img
root@kvm-xfstests:~# mke2fs -t ext4 /tmp/foo.img
mke2fs 1.43-WIP (18-May-2015)
Discarding device blocks: done                            
Creating filesystem with 102400 1k blocks and 25688 inodes
Filesystem UUID: 27dfdbbe-f3a9-48a7-abe8-5a52798a9849
Superblock backups stored on blocks: 
	8193, 24577, 40961, 57345, 73729

Allocating group tables: done                            
Writing inode tables: done                            
Creating journal (4096 blocks): done
Writing superblocks and filesystem accounting information: done 

root@kvm-xfstests:~# mount -o loop /tmp/foo.img /mnt
root@kvm-xfstests:~# blockdev --getbsz /dev/loop0
1024
root@kvm-xfstests:~# losetup -c /dev/loop0
root@kvm-xfstests:~# blockdev --getbsz /dev/loop0
4096 <------------ BUG
root@kvm-xfstests:~# touch /mnt/foo
<------- Should hang here, even though there is no resize2fs command
<------- If it doesn't hang right away, try typing the "sync" command


> Suffer this small analogy
> for me and let me know where I am wrong: say hypothetically I expand
> a small partition (or LVM for that matter). Then I try to use
> resize2fs to grow the ext filesystem on it. I expect that this
> should *not* change the block size of the underlying device (of
> course not!) nor the filesystem's block size.

The cause of your misunderstanding is not understanding that there are
actually 4 different concepts of block/sector size:

* The logical block/sector size of the underlying storage device
	- Retrived via "blockdev --getss /dev/sdXX"
	- This is the smallest unit that can be sent to the disk from
	  the Host OS.  If the logical sector size is different from
	  the physical block size, and write is smaller than the
	  physical sector size (see below), then the disk will do a
	  read-modify-write.
	- The file system block size MUST be greater than or equal to
	  the logical sector size.

* The physical block/sector size of the underlying storage device
	- Retrived via "blockdev --getpbsz /dev/sdXX"
	- This is the smallest unit can be physically written to the
	  storage media.
  	- The file system block size SHOULD be greater than or equal
	  to the logical sector size.  (To avoid read-modify-write
	  operations by the hard drive that will bad for performance.)

* The "soft" block size of the block device.
	- Retrived via "blockdev --getbsz /dev/sdXX"
	- This represents the units of storage which is used to cache
	  data in the buffer cache.  This only matters if you are
	  using buffer cache --- for example, if you are doing
	  buffered I/O to a block device, or if you are using a file
	  system such as ext4 which is using buffer cache.  Since data
	  is indexed in the buffer cache by the 3-tuple (block device,
	  block number, block size), Bad Things happen if you try to
	  change the block size while the file system is mounted.
	  Normally, the kernel will prevent you from changing the
	  block size under these circumstances.

* The file system block size.
	- Retrieved by some file-system dependent command.  For ext4,
	  this is "dumpe2fs -h".
	- Set at format time.  For file systems that use the buffer
	  cache, the file system driver will automatically set the
	  "soft" block size of the block device when the file system
	  is mounted.


Speaking of LVM, I can't reproduce the problem using LVM, at least not
with a 4.3-rc2 kernel:

root@kvm-xfstests:~# pvcreate /dev/vdc
  Physical volume "/dev/vdc" successfully created
root@kvm-xfstests:~# vgcreate test /dev/vdc
  Volume group "test" successfully created
root@kvm-xfstests:~# lvcreate -L 100M -n small /dev/test
  Logical volume "small" created
root@kvm-xfstests:~# mkfs.ext4 -Fq /dev/test/small 
root@kvm-xfstests:~# mount -o loop /dev/test/small /mnt
root@kvm-xfstests:~# blockdev --getbsz /dev/loop0
1024
root@kvm-xfstests:~# lvresize -L 1G /dev/test/small
  Size of logical volume test/small changed from 100.00 MiB (25 extents) to 1.00 GiB (256 extents).
  Logical volume small successfully resized
root@kvm-xfstests:~# blockdev --getbsz /dev/loop0
1024  <------ NO BUG, see the block size has not changed
root@kvm-xfstests:~# lvcreate -L 100M -n small /dev/test^C
root@kvm-xfstests:~# touch /mnt/foo ; sync
root@kvm-xfstests:~# resize2fs /dev/test/small
resize2fs 1.43-WIP (18-May-2015)
Filesystem at /dev/test/small is mounted on /mnt; on-line resizing required
old_desc_blocks = 1, new_desc_blocks = 8
The filesystem on /dev/test/small is now 1048576 (1k) blocks long.
<------ Note that resize2fs works just fine!
root@kvm-xfstests:~# touch /mnt/bar ; sync
root@kvm-xfstests:~# umount /mnt
root@kvm-xfstests:~# 

You might see if this works on CentOS; but if it doesn't, I'm pretty
convinced this is a bug outside of ext4, and I've already given you a
workaround --- using "-b 4096" on the command line to mkfs.ext4 or
mke2fs.

Alternatively, here's another workaround; you can change modify your
/etc/mke2fs.conf so the "small" and "floppy" stanzas read:

[fs_types]
	small = {
		blocksize = 4096
		inode_size = 128
		inode_ratio = 4096
	}
	floppy = {
		blocksize = 4096
		inode_size = 128
		inode_ratio = 8192
	}

I'm pretty certain your failures won't reproduce if you either change
how you call mke2fs for small file systems, or change your
/etc/mke2fs.conf file as shown above.

Cheers,

					- Ted
