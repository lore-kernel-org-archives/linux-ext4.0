From: Drake Cai <dcai.xff@gmail.com>
Subject: Odd EXT4 corruption
Date: Mon, 2 Oct 2017 23:10:56 -0700
Message-ID: <CAD2SNyrVU-jeQCBRgfq7zGLZjZsa3_PDr=XSCfT=prNryZSYcg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-qt0-f194.google.com ([209.85.216.194]:47792 "EHLO
        mail-qt0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750797AbdJCGK5 (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Tue, 3 Oct 2017 02:10:57 -0400
Received: by mail-qt0-f194.google.com with SMTP id z50so6119974qtj.4
        for <linux-ext4@vger.kernel.org>; Mon, 02 Oct 2017 23:10:57 -0700 (PDT)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

As I was trying to install a new distribution I accidentally gdisk'd
/dev/sda instead of /dev/sdc and deleted all of the partitions off of
my device. I also wrote to the device a new GPT partition table label
with a 2G EFI partition and a Linux Filesystem partition that filled
the rest of the disk. I later then deleted the two partitions and made
an ext4 partition that filled the rest of the disk. At this point
forwards, I decided to do a complete dd backup of the 1.8TiB drive and
am now working on the backed up identical drive (also 1.8TiB). I never
mkfs'ed the device so the data in theory should all be there.

I have also used TestDisk and PhotoRec respectively. TestDisk fails to
detect this weird situation and PhotoRec generates way too many files
for it to be of use.

The disk in question was originally formatted with Gnome's Disk
Utility with no partitioning and just an ext4 filesystem. Mountings of
the device on the superblock backups blocks 65536, 131072, etc (but
not 32768) are successful.

However, after mounting, while the first directory of folders exists,
when any following directories are entered ls shows a "Structure needs
cleaning" error for the majority of the files and folders. Running
e2fsck with the superblock backups failed to fix the problem but left
me with 29GiB of the original 1TiB of data (the folders & files
without "Structure needs cleaning" errors) of the 1.8TiB drive.
Lost+Found did not contain any of the remaining data either.

A friend on IRC tried reproducing my exact steps (creating drive,
adding content, gdisking and attempting to mount/fsck) on his own
setup and also came to the same error of "Structure needs cleaning"
for directories.

I did a little more digging into GPT and EXT4 and realized using gdisk
meant I overwrote the first 33792 bytes of the EXT4 filesystem. I'm
having a little trouble understanding whether or not I overwote the
GDT blocks which I was not using or if I overwrote some crucial data &
inode bitmaps or possibly even inode table blocks. I should have only
overwritten 8 or so blocks to my judgement. I'm not too sure whether
or not GDT blocks come before bitmap or inode table blocks or are
variable to be more precise.

I've attached below the output of tune2fs of the device.

So far this is as far as I have got. Does anyone have any ideas on how
I could salvage the rest of the data? Any help is appreciated.

Thank you.

====================

tune2fs 1.43.4 (31-Jan-2017)
Filesystem volume name:   <none>
Last mounted on:          <not available>
Filesystem UUID:          57e8dc69-003e-4d43-a912-adcbc09d8110
Filesystem magic number:  0xEF53
Filesystem revision #:    1 (dynamic)
Filesystem features:      has_journal ext_attr resize_inode dir_index
filetype extent 64bit flex_bg sparse_super large_file huge_file
dir_nlink extra_isize metadata_csum
Filesystem flags:         signed_directory_hash
Default mount options:    user_xattr acl
Filesystem state:         clean
Errors behavior:          Continue
Filesystem OS type:       Linux
Inode count:              122101760
Block count:              488378646
Reserved block count:     24418932
Free blocks:              480431423
Free inodes:              122101749
First block:              0
Block size:               4096
Fragment size:            4096
Group descriptor size:    64
Reserved GDT blocks:      1024
Blocks per group:         32768
Fragments per group:      32768
Inodes per group:         8192
Inode blocks per group:   512
Flex block group size:    16
Filesystem created:       Mon Oct  2 20:55:33 2017
Last mount time:          Mon Oct  2 20:56:09 2017
Last write time:          Mon Oct  2 20:56:16 2017
Mount count:              2
Maximum mount count:      -1
Last checked:             Mon Oct  2 20:55:33 2017
Check interval:           0 (<none>)
Lifetime writes:          1054 MB
Reserved blocks uid:      0 (user root)
Reserved blocks gid:      0 (group root)
First inode:              11
Inode size:              256
Required extra isize:     32
Desired extra isize:      32
Journal inode:            8
Default directory hash:   half_md4
Directory Hash Seed:      cbf62753-15ca-4878-9a9e-6594eeaabc85
Journal backup:           inode blocks
Checksum type:            crc32c
Checksum:                 0x87d53c7b
