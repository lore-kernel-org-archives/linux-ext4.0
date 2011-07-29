From: Round Robinjp <roundrobinjp@yahoo.co.jp>
Subject: Re: flashing large eMMC partitions with ext4
Date: Sat, 30 Jul 2011 04:05:08 +0900 (JST)
Message-ID: <20110729190508.23751.qmail@web4202.mail.ogk.yahoo.co.jp>
References: <CAOQ4uxhVNporfaNJrR7Zt++4tVZjJiuUhKRkNB+CzFzTeFmzGw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Cc: Ted Ts'o <tytso@mit.edu>,
	"linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>
To: Goldstein Amir <amir73il@gmail.com>,
	Dilger Andreas <aedilger@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from web4202.mail.ogk.yahoo.co.jp ([124.83.212.22]:35832 "HELO
	web4202.mail.ogk.yahoo.co.jp" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751496Ab1G2TFK convert rfc822-to-8bit
	(ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 29 Jul 2011 15:05:10 -0400
In-Reply-To: <CAOQ4uxhVNporfaNJrR7Zt++4tVZjJiuUhKRkNB+CzFzTeFmzGw@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

> When I get to it I will try to play this game and let you guys know if
> it worked.

Thanks in advance. :-)
Meanwhile, with my limited knowledge about ext4, I am trying your
method. It seems it is working. But I am not sure about a few
things. Details below.

> If you know the estimated disk usage of the initial fs, say 1G:
> 1. mkfs a 1G ext4 fs with no journal, flex_bg=32, resize=4G

I did this: (hope you meant this)

dd if=/dev/zero of=a.img bs=4K count=256K
mkfs.ext4 -O ^has_journal,flex_bg -G 32 -E resize=4G a.img

> 2. mount it and cp -a /foo/* /mnt/

I did this:

sudo mount -t ext4 -o loop a.img /mnt/
cp -a /foo/* /mnt/

> 3. use new online resize to resize fs to 4G (maintaining flex_bg layout)

I did this: (hope you meant this)

e2fsck -f a.img
resize2fs a.img 4G

> 4. add journal to mounted fs (.journal file should be allocated with goal 0??)

I skipped this because I am not sure how to allocate .journal with goal 0.

> if my calculations are correct, the only blocks written beyond the 1G mark
> are the super block backup copies, so truncating the resulting image to 1G
> won't do any damage - even fsck shouldn't complain.

I did this:

sudo umount /mnt
truncate -s 1G a.img
e2fsck -f a.img
 # this complains about several illegal blocks
 # but after fixing, a.img mounts okay and files
 # inside it looks okay.


Full operation log below:

--------------------------------------
--------------------------------------
--------------------------------------
$ dd if=/dev/zero of=a.img bs=4K count=256K
262144+0 records in
262144+0 records out
1073741824 bytes (1.1 GB) copied, 23.4067 s, 45.9 MB/s

$ mkfs.ext4 -O ^has_journal,flex_bg -G 32 -E resize=4G a.img
mke2fs 1.41.14 (22-Dec-2010)
a.img is not a block special device.
Proceed anyway? (y,n) y
Filesystem label=
OS type: Linux
Block size=4096 (log=2)
Fragment size=4096 (log=2)
Stride=0 blocks, Stripe width=0 blocks
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

This filesystem will be automatically checked every 31 mounts or
180 days, whichever comes first.  Use tune2fs -c or -i to override.

$ sudo mount -t ext4 -o loop a.img /mnt/

$ du -sh /usr/src/
92M     /usr/src/

$ cp -a /usr/src/* /mnt/

$ e2fsck -f a.img
e2fsck 1.41.14 (22-Dec-2010)
Pass 1: Checking inodes, blocks, and sizes
Pass 2: Checking directory structure
Pass 3: Checking directory connectivity
Pass 4: Checking reference counts
Pass 5: Checking group summary information
a.img: 11/65536 files (0.0% non-contiguous), 4443/262144 blocks

$ resize2fs a.img 4G
resize2fs 1.41.14 (22-Dec-2010)
Resizing the filesystem on a.img to 1048576 (4k) blocks.
The filesystem on a.img is now 1048576 blocks long.

$ sudo umount /mnt

$ truncate -s 1G a.img

$ e2fsck -f a.img
e2fsck 1.41.14 (22-Dec-2010)
Pass 1: Checking inodes, blocks, and sizes
Inode 7 has illegal block(s).  Clear<y>? yes

Illegal block #2064 (294914) in inode 7.  CLEARED.
Illegal block #2065 (819202) in inode 7.  CLEARED.
Illegal block #2066 (884738) in inode 7.  CLEARED.
Illegal block #3088 (294915) in inode 7.  CLEARED.
Illegal block #3089 (819203) in inode 7.  CLEARED.
Illegal block #3090 (884739) in inode 7.  CLEARED.
Illegal block #4112 (294916) in inode 7.  CLEARED.
Illegal block #4113 (819204) in inode 7.  CLEARED.
Illegal block #4114 (884740) in inode 7.  CLEARED.
Illegal block #5136 (294917) in inode 7.  CLEARED.
Illegal block #5137 (819205) in inode 7.  CLEARED.
Too many illegal blocks in inode 7.
Clear inode<y>? yes

Restarting e2fsck from the beginning...
Resize inode not valid.  Recreate<y>? yes

Pass 1: Checking inodes, blocks, and sizes
Pass 2: Checking directory structure
Pass 3: Checking directory connectivity
Pass 4: Checking reference counts
Pass 5: Checking group summary information
Free blocks count wrong for group #0 (24746, counted=24747).
Fix<y>? yes

Free blocks count wrong (234383, counted=234384).
Fix<y>? yes


a.img: ***** FILE SYSTEM WAS MODIFIED *****
a.img: 20864/65536 files (0.0% non-contiguous), 27760/262144 blocks

$ tune2fs -l a.img
tune2fs 1.41.14 (22-Dec-2010)
Filesystem volume name:   <none>
Last mounted on:          /mnt
Filesystem UUID:          56f4818f-ee66-4a30-a31c-917b0816f139
Filesystem magic number:  0xEF53
Filesystem revision #:    1 (dynamic)
Filesystem features:      ext_attr resize_inode dir_index filetype extent flex_bg sparse_super large_file huge_file uninit_bg dir_nlink extra_isize
Filesystem flags:         signed_directory_hash
Default mount options:    (none)
Filesystem state:         clean
Errors behavior:          Continue
Filesystem OS type:       Linux
Inode count:              65536
Block count:              262144
Reserved block count:     13107
Free blocks:              234384
Free inodes:              44672
First block:              0
Block size:               4096
Fragment size:            4096
Reserved GDT blocks:      63
Blocks per group:         32768
Fragments per group:      32768
Inodes per group:         8192
Inode blocks per group:   512
Flex block group size:    32
Filesystem created:       Sat Jul 30 03:18:44 2011
Last mount time:          Sat Jul 30 03:19:04 2011
Last write time:          Sat Jul 30 03:28:39 2011
Mount count:              0
Maximum mount count:      31
Last checked:             Sat Jul 30 03:28:39 2011
Check interval:           15552000 (6 months)
Next check after:         Thu Jan 26 03:28:39 2012
Lifetime writes:          722 kB
Reserved blocks uid:      0 (user root)
Reserved blocks gid:      0 (group root)
First inode:              11
Inode size:               256
Required extra isize:     28
Desired extra isize:      28
Default directory hash:   half_md4
Directory Hash Seed:      6d50d9cc-e370-4868-acaa-92f7414df164

$ sudo mount -t ext4 -o loop a.img /mnt/

$ sudo du -sh /mnt/
92M     /mnt/

$ cat /mnt/linux-headers-2.6.38-8/Documentation/Makefile
obj-m := DocBook/ accounting/ auxdisplay/ connector/ \
        filesystems/ filesystems/configfs/ ia64/ laptops/ networking/ \
        pcmcia/ spi/ timers/ vm/ watchdog/src/

$ ls -la /mnt/
total 32
drwxr-xr-x  5 round round  4096 Jul 30 03:26 .
drwxr-xr-x 23 root root  4096 Jul  9 01:24 ..
drwxr-xr-x 24 round round  4096 Apr 26 08:08 linux-headers-2.6.38-8
drwxr-xr-x  7 round round  4096 Apr 26 08:08 linux-headers-2.6.38-8-generic
drwx------  2 root root 16384 Jul 30 03:18 lost+found

$ sudo umount /mnt
-------------------------------------
-------------------------------------
-------------------------------------
