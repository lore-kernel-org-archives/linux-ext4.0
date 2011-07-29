From: Amir Goldstein <amir73il@gmail.com>
Subject: Re: flashing large eMMC partitions with ext4
Date: Fri, 29 Jul 2011 22:46:05 +0300
Message-ID: <CAOQ4uxh6a1qoZZs2SVxxrKfcd5q0vKkpCMDQ-X5eur3Tg07FXg@mail.gmail.com>
References: <CAOQ4uxhVNporfaNJrR7Zt++4tVZjJiuUhKRkNB+CzFzTeFmzGw@mail.gmail.com>
	<20110729190508.23751.qmail@web4202.mail.ogk.yahoo.co.jp>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Dilger Andreas <aedilger@gmail.com>, "Ted Ts'o" <tytso@mit.edu>,
	"linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>
To: Round Robinjp <roundrobinjp@yahoo.co.jp>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-ww0-f44.google.com ([74.125.82.44]:59411 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751292Ab1G2TqH convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 29 Jul 2011 15:46:07 -0400
Received: by wwe5 with SMTP id 5so3890924wwe.1
        for <linux-ext4@vger.kernel.org>; Fri, 29 Jul 2011 12:46:05 -0700 (PDT)
In-Reply-To: <20110729190508.23751.qmail@web4202.mail.ogk.yahoo.co.jp>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, Jul 29, 2011 at 10:05 PM, Round Robinjp
<roundrobinjp@yahoo.co.jp> wrote:
>> When I get to it I will try to play this game and let you guys know =
if
>> it worked.
>
> Thanks in advance. :-)
> Meanwhile, with my limited knowledge about ext4, I am trying your
> method. It seems it is working. But I am not sure about a few
> things. Details below.
>
>> If you know the estimated disk usage of the initial fs, say 1G:
>> 1. mkfs a 1G ext4 fs with no journal, flex_bg=3D32, resize=3D4G
>
> I did this: (hope you meant this)
>
> dd if=3D/dev/zero of=3Da.img bs=3D4K count=3D256K
> mkfs.ext4 -O ^has_journal,flex_bg -G 32 -E resize=3D4G a.img
>
>> 2. mount it and cp -a /foo/* /mnt/
>
> I did this:
>
> sudo mount -t ext4 -o loop a.img /mnt/
> cp -a /foo/* /mnt/
>
>> 3. use new online resize to resize fs to 4G (maintaining flex_bg lay=
out)
>
> I did this: (hope you meant this)

I meant using a newer version of resize2fs (which you do not have),
but running fsck on the flashed image can be a valid alternative.

>
> e2fsck -f a.img
> resize2fs a.img 4G
>
>> 4. add journal to mounted fs (.journal file should be allocated with=
 goal 0??)
>
> I skipped this because I am not sure how to allocate .journal with go=
al 0.

So your fs has no journal...
I meant to run:
# tune2fs -O has_journal /dev/loop<N>
while the image is mounted.
I never tried it, but I think it should create a .journal file at the
beginning of the partition.

>
>> if my calculations are correct, the only blocks written beyond the 1=
G mark
>> are the super block backup copies, so truncating the resulting image=
 to 1G
>> won't do any damage - even fsck shouldn't complain.
>
> I did this:
>
> sudo umount /mnt
> truncate -s 1G a.img
> e2fsck -f a.img
> =A0# this complains about several illegal blocks

They are "illegal" because they are beyond the end of the device.
You need to truncate -s 4G (after truncate -s 1G) to simulate that you
flashed to image to a 4G partition.

Please try that and send the post truncate/extend fsck report.
Please also send the 'dumpe2fs' of the pre-truncate and
post-truncate/extend image.

> =A0# but after fixing, a.img mounts okay and files
> =A0# inside it looks okay.

Yes, those files would look OK, but trying to write new files to the
'phantom' 3G, can cause some problem along the way.

>
>
> Full operation log below:
>
> --------------------------------------
> --------------------------------------
> --------------------------------------
> $ dd if=3D/dev/zero of=3Da.img bs=3D4K count=3D256K
> 262144+0 records in
> 262144+0 records out
> 1073741824 bytes (1.1 GB) copied, 23.4067 s, 45.9 MB/s
>
> $ mkfs.ext4 -O ^has_journal,flex_bg -G 32 -E resize=3D4G a.img
> mke2fs 1.41.14 (22-Dec-2010)
> a.img is not a block special device.
> Proceed anyway? (y,n) y
> Filesystem label=3D
> OS type: Linux
> Block size=3D4096 (log=3D2)
> Fragment size=3D4096 (log=3D2)
> Stride=3D0 blocks, Stripe width=3D0 blocks
> 65536 inodes, 262144 blocks
> 13107 blocks (5.00%) reserved for the super user
> First data block=3D0
> Maximum filesystem blocks=3D268435456
> 8 block groups
> 32768 blocks per group, 32768 fragments per group
> 8192 inodes per group
> Superblock backups stored on blocks:
> =A0 =A0 =A0 =A032768, 98304, 163840, 229376
>
> Writing inode tables: done
> Writing superblocks and filesystem accounting information: done
>
> This filesystem will be automatically checked every 31 mounts or
> 180 days, whichever comes first. =A0Use tune2fs -c or -i to override.
>
> $ sudo mount -t ext4 -o loop a.img /mnt/
>
> $ du -sh /usr/src/
> 92M =A0 =A0 /usr/src/
>
> $ cp -a /usr/src/* /mnt/
>
> $ e2fsck -f a.img
> e2fsck 1.41.14 (22-Dec-2010)
> Pass 1: Checking inodes, blocks, and sizes
> Pass 2: Checking directory structure
> Pass 3: Checking directory connectivity
> Pass 4: Checking reference counts
> Pass 5: Checking group summary information
> a.img: 11/65536 files (0.0% non-contiguous), 4443/262144 blocks
>
> $ resize2fs a.img 4G
> resize2fs 1.41.14 (22-Dec-2010)
> Resizing the filesystem on a.img to 1048576 (4k) blocks.
> The filesystem on a.img is now 1048576 blocks long.
>
> $ sudo umount /mnt
>
> $ truncate -s 1G a.img
>
> $ e2fsck -f a.img
> e2fsck 1.41.14 (22-Dec-2010)
> Pass 1: Checking inodes, blocks, and sizes
> Inode 7 has illegal block(s). =A0Clear<y>? yes
>
> Illegal block #2064 (294914) in inode 7. =A0CLEARED.
> Illegal block #2065 (819202) in inode 7. =A0CLEARED.
> Illegal block #2066 (884738) in inode 7. =A0CLEARED.
> Illegal block #3088 (294915) in inode 7. =A0CLEARED.
> Illegal block #3089 (819203) in inode 7. =A0CLEARED.
> Illegal block #3090 (884739) in inode 7. =A0CLEARED.
> Illegal block #4112 (294916) in inode 7. =A0CLEARED.
> Illegal block #4113 (819204) in inode 7. =A0CLEARED.
> Illegal block #4114 (884740) in inode 7. =A0CLEARED.
> Illegal block #5136 (294917) in inode 7. =A0CLEARED.
> Illegal block #5137 (819205) in inode 7. =A0CLEARED.
> Too many illegal blocks in inode 7.
> Clear inode<y>? yes
>
> Restarting e2fsck from the beginning...
> Resize inode not valid. =A0Recreate<y>? yes

So fsck re-created the resize inode, which it had just cleared...
I bet if you run fsck again you would get the exact same errors over ag=
ain.

>
> Pass 1: Checking inodes, blocks, and sizes
> Pass 2: Checking directory structure
> Pass 3: Checking directory connectivity
> Pass 4: Checking reference counts
> Pass 5: Checking group summary information
> Free blocks count wrong for group #0 (24746, counted=3D24747).
> Fix<y>? yes
>
> Free blocks count wrong (234383, counted=3D234384).
> Fix<y>? yes
>
>
> a.img: ***** FILE SYSTEM WAS MODIFIED *****
> a.img: 20864/65536 files (0.0% non-contiguous), 27760/262144 blocks
>
> $ tune2fs -l a.img
> tune2fs 1.41.14 (22-Dec-2010)
> Filesystem volume name: =A0 <none>
> Last mounted on: =A0 =A0 =A0 =A0 =A0/mnt
> Filesystem UUID: =A0 =A0 =A0 =A0 =A056f4818f-ee66-4a30-a31c-917b0816f=
139
> Filesystem magic number: =A00xEF53
> Filesystem revision #: =A0 =A01 (dynamic)
> Filesystem features: =A0 =A0 =A0ext_attr resize_inode dir_index filet=
ype extent flex_bg sparse_super large_file huge_file uninit_bg dir_nlin=
k extra_isize
> Filesystem flags: =A0 =A0 =A0 =A0 signed_directory_hash
> Default mount options: =A0 =A0(none)
> Filesystem state: =A0 =A0 =A0 =A0 clean
> Errors behavior: =A0 =A0 =A0 =A0 =A0Continue
> Filesystem OS type: =A0 =A0 =A0 Linux
> Inode count: =A0 =A0 =A0 =A0 =A0 =A0 =A065536
> Block count: =A0 =A0 =A0 =A0 =A0 =A0 =A0262144
> Reserved block count: =A0 =A0 13107
> Free blocks: =A0 =A0 =A0 =A0 =A0 =A0 =A0234384
> Free inodes: =A0 =A0 =A0 =A0 =A0 =A0 =A044672
> First block: =A0 =A0 =A0 =A0 =A0 =A0 =A00
> Block size: =A0 =A0 =A0 =A0 =A0 =A0 =A0 4096
> Fragment size: =A0 =A0 =A0 =A0 =A0 =A04096
> Reserved GDT blocks: =A0 =A0 =A063
> Blocks per group: =A0 =A0 =A0 =A0 32768
> Fragments per group: =A0 =A0 =A032768
> Inodes per group: =A0 =A0 =A0 =A0 8192
> Inode blocks per group: =A0 512
> Flex block group size: =A0 =A032
> Filesystem created: =A0 =A0 =A0 Sat Jul 30 03:18:44 2011
> Last mount time: =A0 =A0 =A0 =A0 =A0Sat Jul 30 03:19:04 2011
> Last write time: =A0 =A0 =A0 =A0 =A0Sat Jul 30 03:28:39 2011
> Mount count: =A0 =A0 =A0 =A0 =A0 =A0 =A00
> Maximum mount count: =A0 =A0 =A031
> Last checked: =A0 =A0 =A0 =A0 =A0 =A0 Sat Jul 30 03:28:39 2011
> Check interval: =A0 =A0 =A0 =A0 =A0 15552000 (6 months)
> Next check after: =A0 =A0 =A0 =A0 Thu Jan 26 03:28:39 2012
> Lifetime writes: =A0 =A0 =A0 =A0 =A0722 kB
> Reserved blocks uid: =A0 =A0 =A00 (user root)
> Reserved blocks gid: =A0 =A0 =A00 (group root)
> First inode: =A0 =A0 =A0 =A0 =A0 =A0 =A011
> Inode size: =A0 =A0 =A0 =A0 =A0 =A0 =A0 256
> Required extra isize: =A0 =A0 28
> Desired extra isize: =A0 =A0 =A028
> Default directory hash: =A0 half_md4
> Directory Hash Seed: =A0 =A0 =A06d50d9cc-e370-4868-acaa-92f7414df164
>
> $ sudo mount -t ext4 -o loop a.img /mnt/
>
> $ sudo du -sh /mnt/
> 92M =A0 =A0 /mnt/
>
> $ cat /mnt/linux-headers-2.6.38-8/Documentation/Makefile
> obj-m :=3D DocBook/ accounting/ auxdisplay/ connector/ \
> =A0 =A0 =A0 =A0filesystems/ filesystems/configfs/ ia64/ laptops/ netw=
orking/ \
> =A0 =A0 =A0 =A0pcmcia/ spi/ timers/ vm/ watchdog/src/
>
> $ ls -la /mnt/
> total 32
> drwxr-xr-x =A05 round round =A04096 Jul 30 03:26 .
> drwxr-xr-x 23 root root =A04096 Jul =A09 01:24 ..
> drwxr-xr-x 24 round round =A04096 Apr 26 08:08 linux-headers-2.6.38-8
> drwxr-xr-x =A07 round round =A04096 Apr 26 08:08 linux-headers-2.6.38=
-8-generic
> drwx------ =A02 root root 16384 Jul 30 03:18 lost+found
>
> $ sudo umount /mnt
> -------------------------------------
> -------------------------------------
> -------------------------------------
>
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
