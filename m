From: Johan Harvyl <johan@harvyl.se>
Subject: resize2fs: Should never happen: resize inode corrupt! - lost key
 inodes
Date: Tue, 11 Aug 2015 20:15:58 +0200
Message-ID: <55CA3BDE.7020401@harvyl.se>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-lb0-f176.google.com ([209.85.217.176]:35195 "EHLO
	mail-lb0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752390AbbHKSQE (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 11 Aug 2015 14:16:04 -0400
Received: by lbcbn3 with SMTP id bn3so23662413lbc.2
        for <linux-ext4@vger.kernel.org>; Tue, 11 Aug 2015 11:16:01 -0700 (PDT)
Received: from [192.168.86.212] (h135n11-ld-c-a31.ias.bredband.telia.com. [78.73.132.135])
        by smtp.googlemail.com with ESMTPSA id kc4sm624704lbc.39.2015.08.11.11.15.59
        for <linux-ext4@vger.kernel.org>
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 11 Aug 2015 11:16:00 -0700 (PDT)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi,

I recently attempted an operation I have done many many times before, add a
drive to a raid array followed by offline resize2fs to expand the ext4fs 
on it.

This time however it failed miserably and key parts of the filesystem appear
so corrupt that it can no longer be mounted.

Here is what triggered all this:
# umount /dev/md0
# fsck.ext4 -f /dev/md0
# resize2fs /dev/md0
Should never happen: resize inode corrupt!

It looks to me like there is some sanity check missing in resize2fs, and I
would like to figure out what.

Scanning through the linux-ext4 archives a bit I found the
"64bit + resize2fs... this is Not Good" thread:
http://www.spinics.net/lists/linux-ext4/msg35039.html

His problem looks somewhat similar to mine although I do not see the same
possible root cause.

Googling I also find a few threads like:
http://www.spinics.net/lists/linux-ext4/msg27511.html
That suggests it would not be possible to resize a 64bit fs with 
resize_inode
and flex_bg, but those threads are old and resize2fs 1.42.13 (my 
version) did
not articulate that combination being a problem.

Any input on what resize2fs has actually done and suggestions on what to try
to recover would be greatly appreciated.

The md array has been re-started read-only and will remain so for the time
being, I want a clear understanding of what has actually happened before I
try something possibly destructive (like disabling the journal and running
e2fsck -f).To be honest part of me enjoy getting my hands dirty digging
through the filesystem internals and there are backups of the important
stuff but still there are some data I would like to recover.

What I would like is something along the lines of a read-only fsck that 
lets me
work with the fixed-up fs without actually modifying the underlying 
block device
as I do not quite trust e2fsprogs to make further changes to that 
filesystem.

The best I have found so far is UFS explorer, which looks promising. It 
does find
a lot of the files and has options to copy entire directories onto another
filesystem but I have no way of knowing that the contents in the files 
are actually
intact so it or may not be worth spending money on.

I will now try to go through a bit of what I have tried and found so far.

For reference here is the md reshape. At the end of this post there will be
some further history on how the md and ext4fs was created and expanded:
# mdadm --add /dev/md0 /dev/sdr
mdadm: added /dev/sdr
# mdadm --grow /dev/md0 --raid-devices=8

[119591.811743] md0: detected capacity change from 20003262300160 to 
24003914760192
[119592.891563] VFS: busy inodes on changed media or resized disk md0

Attempt at mounting /dev/md0:
[146160.561297] EXT4-fs (md0): no journal found

Attempt at mounting /dev/md0 with -o ro,noload:
[146592.329911] EXT4-fs (md0): get root inode failed
[146592.329914] EXT4-fs (md0): mount failed

debugfs:  stat <2>
Inode: 2   Type: bad type    Mode:  0000   Flags: 0x0
Generation: 0    Version: 0x00000000
User:     0   Group:     0   Size: 0
File ACL: 0    Directory ACL: 0
Links: 0   Blockcount: 0
Fragment:  Address: 0    Number: 0    Size: 0
ctime: 0x00000000 -- Thu Jan  1 01:00:00 1970
atime: 0x00000000 -- Thu Jan  1 01:00:00 1970
mtime: 0x00000000 -- Thu Jan  1 01:00:00 1970
Size of extra inode fields: 0
BLOCKS:

debugfs:  stat <7>
Inode: 7   Type: bad type    Mode:  0000   Flags: 0x0
Generation: 0    Version: 0x00000000
User:     0   Group:     0   Size: 0
File ACL: 0    Directory ACL: 0
Links: 0   Blockcount: 0
Fragment:  Address: 0    Number: 0    Size: 0
ctime: 0x00000000 -- Thu Jan  1 01:00:00 1970
atime: 0x00000000 -- Thu Jan  1 01:00:00 1970
mtime: 0x00000000 -- Thu Jan  1 01:00:00 1970
Size of extra inode fields: 0
BLOCKS:

Manual check of the root inode on the broken filesystem:
  Group  0: block bitmap at 2881, inode bitmap at 2897, inode table at 2913
            4294963995 free blocks, 501 free inodes, 2 used directories, 
501 unused inodes
            [Checksum 0x404c]

Clearly the 4294963995 free blocks in a 32768 block group does not make 
sense.
00001000  41 0B 00 00  51 0B 00 00   61 0B 00 00  1B F3 F5 01
00001010  02 00 04 00  00 00 00 00   00 00 00 00  F5 01 4C 40
00001020  00 00 00 00  00 00 00 00   00 00 00 00 *FF FF*00 00
00001030  00 00 00 00  00 00 00 00   00 00 00 00  00 00 00 00

In [72]: hex(2913 * 4096 + 1 * 256)
Out[72]: '0xb61100'

00B61100  00 00 00 00  00 00 00 00   00 00 00 00  00 00 00 00
00B61110  00 00 00 00  00 00 00 00   00 00 00 00  00 00 00 00
00B61120  00 00 00 00  00 00 00 00   00 00 00 00  00 00 00 00
00B61130  00 00 00 00  00 00 00 00   00 00 00 00  00 00 00 00
...
00B61700  00 00 00 00  00 00 00 00   00 00 00 00  00 00 00 00
00B61710  00 00 00 00  00 00 00 00   00 00 00 00  00 00 00 00
00B61720  00 00 00 00  00 00 00 00   00 00 00 00  00 00 00 00
00B61730  00 00 00 00  00 00 00 00   00 00 00 00  00 00 00 00
Uh oh, where did the root inode, and the resize inode go?

Just to confirm the math, here is the same thing on a reference clean 
filesystem:
  Group  0: block bitmap at 2641, inode bitmap at 2657, inode table at 2673
            19 free blocks, 501 free inodes, 2 used directories, 501 
unused inodes
            [Checksum 0x5791]

In [42]: hex(2673*4096 + 1*256)
Out[42]: '0xa71100'

00A71100  ED 41 00 00  00 10 00 00   D9 D3 BD 55  B7 D3 BD 55
00A71110  B7 D3 BD 55  00 00 00 00   00 00 13 00  08 00 00 00
00A71120  00 00 08 00  23 00 00 00   0A F3 01 00  04 00 00 00
00A71130  00 00 00 00  00 00 00 00   01 00 00 00  EF 5F 00 00

The dirent for / is at 0x5FEF * 4096:
05FEF000  02 00 00 00  0C 00 01 02   2E 00 00 00  02 00 00 00
05FEF010  0C 00 02 02  2E 2E 00 00   0B 00 00 00  14 00 0A 02
05FEF020  6C 6F 73 74  2B 66 6F 75   6E 64 00 00  01 80 46 02
In other words ".", "..", "lost+found" and so on...
<END of reference clean file system data>

Going back to the broken filesystem again, the root dirent is at:
01DE8000  02 00 00 00  0C 00 01 02   2E 00 00 00  02 00 00 00
01DE8010  0C 00 02 02  2E 2E 00 00   0B 00 00 00  14 00 0A 02
01DE8020  6C 6F 73 74  2B 66 6F 75   6E 64 00 00  0C 40 8C 03
But again where is its inode?

I have not been able to find an inode that references that block, at least
not in the same way I see on other filesystems.

###
Current kernel (stock debian):
4.0.0-2-amd64 #1 SMP Debian 4.0.8-2 (2015-07-22) x86_64 GNU/Linux
Current (when failing resize2fs was executed) e2fsprogs version (stock 
debian): 1.42.13-1

MD and FS information
---
/dev/md0:
      Raid Level : raid6
      Array Size : 23441323008 (22355.39 GiB 24003.91 GB)
   Used Dev Size : 3906887168 (3725.90 GiB 4000.65 GB)
    Raid Devices : 8
   Total Devices : 8

# dumpe2fs -h /dev/md0
dumpe2fs 1.42.13 (17-May-2015)
Filesystem volume name:   <none>
Last mounted on:          /mnt/r0
Filesystem UUID: 13c2eb37-e951-4ad1-b194-21f0880556db
Filesystem magic number:  0xEF53
Filesystem revision #:    1 (dynamic)
Filesystem features:      has_journal ext_attr resize_inode dir_index 
filetype extent 64bit flex_bg sparse_super large_file huge_file un\
init_bg dir_nlink extra_isize
Filesystem flags:         signed_directory_hash
Default mount options:    user_xattr acl
Filesystem state:         clean with errors
Errors behavior:          Continue
Filesystem OS type:       Linux
Inode count:              91568128
Block count:              5860330752
Reserved block count:     0
Free blocks:              1013128185
Free inodes:              88364147
First block:              0
Block size:               4096
Fragment size:            4096
Group descriptor size:    64
Blocks per group:         32768
Fragments per group:      32768
Inodes per group:         512
Inode blocks per group:   32
RAID stride:              128
RAID stripe width:        512
Flex block group size:    16
Filesystem created:       Wed Jun 25 23:22:06 2014
Last mount time:          Fri Jul 31 15:35:09 2015
Last write time:          Sun Aug  2 08:03:47 2015
Mount count:              0
Maximum mount count:      -1
Last checked:             Sun Aug  2 07:44:35 2015
Check interval:           0 (<none>)
Lifetime writes:          19 TB
Reserved blocks uid:      0 (user root)
Reserved blocks gid:      0 (group root)
First inode:              11
Inode size:               256
Required extra isize:     28
Desired extra isize:      28
Journal inode:            8
Default directory hash:   half_md4
Directory Hash Seed:      6bb07dee-8871-4b62-aa92-20080e16cb8c
Journal backup:           inode blocks
Journal superblock magic number invalid!

Some possibly relevant pieces from /etc/mke2fs.conf:
[defaults]
         base_features = 
sparse_super,large_file,filetype,resize_inode,dir_index,ext_attr
         default_mntopts = acl,user_xattr
         enable_periodic_fsck = 0
         blocksize = 4096
         inode_size = 256
         inode_ratio = 16384

[fs_types]
         ext4 = {
                 features = 
has_journal,extent,huge_file,flex_bg,uninit_bg,dir_nlink,extra_isize
                 auto_64-bit_support = 1
                 inode_size = 256
         }
Note that this is what that file looks like right now, I cannot think of 
a way
of telling what it looked like when the filesystem was initially created.

What I can come up with is a best guess since another ext4fs on that same
machine created around the same time (and therefore likely with the same
mke2fs.conf) does not have the resize_inode flag set, which my corrupt
fs has. I have no idea how that got enabled on my corrupt fs.

###
How the md and ext4fs was created and expanded
---
# mdadm --create --verbose --chunk=512 /dev/md0 --level=5 
--raid-devices=5 /dev/sdi /dev/sdj /dev/sdk /dev/sdl /dev/sdm
mdadm: layout defaults to left-symmetric
mdadm: layout defaults to left-symmetric
mdadm: /dev/sdm appears to be part of a raid array:
        level=raid6 devices=8 ctime=Wed Jan 25 23:49:02 2012
mdadm: size set to 3906887168K
mdadm: automatically enabling write-intent bitmap on large array
Continue creating array? y
mdadm: Defaulting to version 1.2 metadata
mdadm: array /dev/md0 started.
---
# mkfs.ext4 /dev/md0 -i 262144 -m 0 -O 64bit
mke2fs 1.42.10 (18-May-2014)
Creating filesystem with 3906887168 4k blocks and 61045248 inodes
Filesystem UUID: 13c2eb37-e951-4ad1-b194-21f0880556db
Superblock backups stored on blocks:
         32768, 98304, 163840, 229376, 294912, 819200, 884736, 1605632, 
2654208,
         4096000, 7962624, 11239424, 20480000, 23887872, 71663616, 78675968,
         102400000, 214990848, 512000000, 550731776, 644972544, 1934917632,
         2560000000, 3855122432

Allocating group tables: done
Writing inode tables: done
Creating journal (32768 blocks): done
Writing superblocks and filesystem accounting information: done
---
# mdadm --add /dev/md0 /dev/sdo
mdadm: added /dev/sdo
# mdadm --grow /dev/md0 --level=6 --raid-devices=6 
--backup-file=/mnt/md100/md0_backup
mdadm: level of /dev/md0 changed to raid6
---
# mdadm --add /dev/md0 /dev/sdq
mdadm: added /dev/sdq
# mdadm --grow /dev/md0 --raid-devices=7
---
# umount /dev/md0
# fsck.ext4 -f /dev/md0
# resize2fs /dev/md0

