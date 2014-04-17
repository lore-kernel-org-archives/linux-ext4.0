From: =?ISO-8859-15?Q?Luk=E1=A8_Czerner?= <lczerner@redhat.com>
Subject: Re: Make huge files strictly contiguous (fallocate, bigalloc,
 e4defrag...)
Date: Thu, 17 Apr 2014 14:04:34 +0200 (CEST)
Message-ID: <alpine.LFD.2.00.1404171325400.2143@localhost.localdomain>
References: <534F39F6.2000208@ovh.fr>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: "linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>
To: Contact <neitsab@ovh.fr>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:20148 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755284AbaDQMEk (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 17 Apr 2014 08:04:40 -0400
In-Reply-To: <534F39F6.2000208@ovh.fr>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, 17 Apr 2014, Contact wrote:

> Date: Thu, 17 Apr 2014 04:18:30 +0200
> From: Contact <neitsab@ovh.fr>
> To: "linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>
> Subject: Make huge files strictly contiguous (fallocate, bigalloc,
>     e4defrag...)
> 
> Hi everybody,
> 
> I'm trying to create a multiboot medium using Easy2Boot on a 64 GB USB
> key. Easy2Boot [1] is a "software" (well a collection of files really)
> that relies on grub4dos [2] to work and thus requires payload files to
> be strictly contiguous to do its trick. It's supposed to be set up once
> and then one just has to add files to boot from to a folder to modify
> the multiboot setup.
> 
> The ISO files I have are between 230 MB and 2 GB each. I divided my USB
> drive into two partitions : first one, 16 GB ntfs formatted so that
> grub4dos actually works (for some reasons it doesn't with ext4, plus I
> want to be able to use it with other OS); second one 48 GB formatted as
> ext4 with e2fsprogs version 1.42.9 from Archlinux. However when I try
> to boot from those files I systematically get the "file not contiguous"
> error in Easy2Boot.
> 
> Question is: is it possible to make huge files strictly contiguous on
> ex4, and if yes how?
> 
> 
> *******
> Details
> *******
> 
> I tried different mkfs.ext4 options so as to cater to my use case, but
> to no avail. I tried pushing the inode_ratio to its maximum value (64
> MB) and using fallocate besides regular copy:
> # mkfs.ext4 -m 0 -L iso -i 67108864 -E root_owner=1000:100 /dev/sdc2
> # fallocate -l 1235451904
> /path/to/mounted/usb/folder/debian-live-7.2-amd64-gnome-desktop_fal.iso
> # cp debian-live-7.2-amd64-gnome-desktop.iso
> /path/to/folder/debian-live-7.2-amd64-gnome-desktop_fal.iso

This is not how it it supposed to be used. Yes fallocate
preallocates the file, but cp will truncate it so fallocate will
certainly not help you in any way. In order for fallocate to be
useful you'll have to write into the file without actually
truncating it (dd can do this if you do not want to write your own
program)

Also the file is probably as contiguous as it could be. Here is what
I get on the file system with default mkfs options.

# e4defrag -c /mnt/test/file1
<File>                                         now/best      size/ext
/mnt/test/file1                                 10/1         120649 KB

But that does not tell the whole story. See

xfs_io -f -c "fiemap -v" /mnt/test/file1
/mnt/test/file1:
 EXT: FILE-OFFSET        BLOCK-RANGE       TOTAL FLAGS
   0: [0..262143]:       2768896..3031039 262144   0x0
   1: [262144..524287]:  3031040..3293183 262144   0x0
   2: [524288..786431]:  3293184..3555327 262144   0x0
   3: [786432..1048575]: 3555328..3817471 262144   0x0
   4: [1048576..1310719]: 3817472..4079615 262144   0x0
   5: [1310720..1425407]: 4079616..4194303 114688   0x0
   6: [1425408..1687551]: 4456448..4718591 262144   0x0
   7: [1687552..1949695]: 4718592..4980735 262144   0x0
   8: [1949696..2211839]: 4980736..5242879 262144   0x0
   9: [2211840..2412991]: 5242880..5444031 201152   0x1

(Note that the output is in 512B blocks)

As you can see the file is mostly contiguous, but it is divided into
several extents because of two reasons.

1. The extent in ext4 has a limited size of 32768 blocks for
initialized extent and 32767 block for unwritten extent. So when we
exceed that size we need another extent which might be physically
contiguous on disk with the previous one.

2. Ext4 divides disk space into allocation groups of certain size
(cluster size * 8)blocks. Now with flex_bg medatada such as inode
tables, block bitmaps and so one are packed closely together so the
do not have to be stored with each block group and you'll get more
contiguous data space.

However we're still storing backup superblock and Groups descriptors
in certain groups and those are the gaps you're seeing in the fiemap
list.

For detailed overview you can use dumpe2fs to see what is allocated
where on the file system.

Bigalloc file system should help since you'll get much larger
contiguous data spaces since the cluster size would be much bigger
hence you'll get much bigger block groups. But you'll still get
multiple extents (I do not really know how grub4dos recognizes
contiguous files) even though there will be mostly contiguous.

But then again you'll have Group descriptors and backup superblocks
in some groups so potentially some files might end up not
contiguous. And even though you can turn off backup superblock you
can not turn off writing group descriptors.

So no, at the moment there is not way to make really *really* sure
that the file you're creating even with fallocate will allways be
strictly contiguous. It'll mostly work, but it really depends on
where the file will be put on the file system and how big is the
file.

Also I've been talking about the case where nothing else is using
the file system, when that's not the case. It might happen that the
allocation will interfere (even though we're trying to allocate as
contiguous file as we can). And also the file system free space will
become more fragmented over time as it is used, but it really
depends on the workload.


Now for the problem with bigalloc, I am not sure what kernel version
are you using, but it's probably old. fallocate on bigalloc should
work just fine.

Hope it helps.
Thanks!
-Lukas



> 
> But files aren't contiguous. e4defrag seems to confirm it:
> # e4defrag -c '/run/media/neitsab/iso/_ISO'
> <Fragmented files>                             now/best       size/ext
> 1. /run/media/neitsab/iso/_ISO/manjaro-gnome-0.8.9-x86_64.iso
>                                                 13/1         119378 KB
> 2. /run/media/neitsab/iso/_ISO/manjaro-gnome-0.8.9-x86_64_fal.iso
>                                                 13/1         119378 KB
> 
> Total/best extents                26/2
> Average size per extent            119378 KB
> Fragmentation score                0
> [0-30 no problem: 31-55 a little bit fragmented: 56- needs defrag]
> This directory (/run/media/neitsab/iso/_ISO) does not need defragmentation.
> Done.
> 
> Then I tried to use bigalloc and clusters:
> # mkfs.ext4 -m 0 -L iso -i 67108864 -O bigalloc -C 256M -E
> root_owner=1000:100 /dev/sdc2
> mke2fs 1.42.9 (28-Dec-2013)
> 
> Warning: the bigalloc feature is still under development
> See https://ext4.wiki.kernel.org/index.php/Bigalloc for more information
> 
> warning: 53248 blocks unused.
> 
> Filesystem label=iso
> OS type: Linux
> Block size=4096 (log=2)
> Cluster size=268435456 (log=18)
> Stride=0 blocks, Stripe width=0 blocks
> 720 inodes, 11665408 blocks
> 0 blocks (0.00%) reserved for the super user
> First data block=0
> Root directory owner=1000:100
> 1 block group
> 2146959360 blocks per group, 32760 clusters per group
> 720 inodes per group
> 
> Allocating group tables: done
> Writing inode tables: done
> Creating journal (32768 blocks): done
> Writing superblocks and filesystem accounting information: done
> 
> It took it some lengthy time to allocate the group tables, then regular
> copy worked but fallocate hanged (process uninterruptible) and I had to
> reboot the machine, which led me to a kernel panic mentionning
> fallocate. The file copied via Nautilus still wasn't contiguous enough
> for Easy2Boot.
> 
> So what's left? Is it at all possible to make completely contiguous
> files on ext4? Not even on a fresh FS with plenty of free space?
> 
> Thanks for your comments!
> 
> 
> [1] http://www.easy2boot.com/introduction/
> [2] https://code.google.com/p/grub4dos-chenall/
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
