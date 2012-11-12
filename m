From: Kimmo Mustonen <k-20121112-81452+linux-ext4@tzimmola.net>
Subject: resize2fs running out of reserved gdb blocks.
Date: Mon, 12 Nov 2012 13:21:32 +0200 (EET)
Message-ID: <alpine.DEB.1.10.1211121241000.2903@wormhole.tzimmola.net>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; format=flowed; charset=US-ASCII
Cc: k-20121112-81452+linux-ext4@tzimmola.net
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from wormhole.tzimmola.net ([83.150.105.79]:52508 "EHLO
	wormhole.tzimmola.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752467Ab2KLLbA (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 12 Nov 2012 06:31:00 -0500
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

I have an ext4 partition that seems to have used all reserved gdt blocks.

Symptoms:

--8<--8<--
$ sudo time resize2fs -p /dev/sdb
resize2fs 1.42.5 (29-Jul-2012)
Filesystem at /dev/sdb is mounted on /m/nfs/dvb3; on-line resizing required
old_desc_blocks = 1102, new_desc_blocks = 1744
Performing an on-line resize of /dev/sdb to 3656906240 (4k) blocks.
resize2fs: Toiminto ei ole sallittu While trying to add group #87872
Command exited with non-zero status 1
1.06user 23.92system 1:14:43elapsed 0%CPU (0avgtext+0avgdata 
2967168maxresident)k
2762520inputs+0outputs (2major+185506minor)pagefaults 0swaps
--8<--8<--

dmesg output

--8<--8<--
[ 5984.360959] EXT4-fs warning (device sdb): ext4_group_add:790: No 
reserved GDT blocks, can't resize
--8<--8<--

1) Why did they run out?
2) Is there a way to add more of them?
3) If not, how to recover and/or make sure it doesn't happen again?

History and steps done:

System: Debian 6, Squeeze (stable), 64-bit.

--8<--8<--
The filesystem was originally made on a 2x3TB mirror (usable size 3 TB) 
using e2fsprogs-1.42.4 and kernel 2.6.38-2-amd64:

sudo ~/src/e2fsprogs-1.42.4/build/misc/mke2fs \
-O 64bit,has_journal,extents,huge_file,flex_bg,uninit_bg,dir_nlink,extra_isize \
-i 4194304 /dev/sdb

I most probably run

tune2fs -L /m/nfs/dvb3 -m 0 -c 0 -i 0 /dev/sdb

but have no record of this.

Then it was converted to a 3x3TB RAID5 (usable size 6 TB):

sudo /usr/local/sbin/resize2fs-1.42.5 /dev/sdb

At this point the kernel was upgraded to 3.2.0-0.bpo.3-amd64 trying to 
resolve one (unrelated) issue but it didn't seem to improve anything.

Then it was converted to a 4x3TB RAID5 (usable size 9 TB):

sudo /usr/local/sbin/resize2fs-1.42.5 /dev/sdb

And now I added two more disks and tried to convert it to a 6x3TB RAID5 
(usable size 15 TB) but it failed at 12 TB.

sudo time resize2fs -p /dev/sdb

resize2fs 1.42.5 (29-Jul-2012)
Filesystem at /dev/sdb is mounted on /m/nfs/dvb3; on-line resizing required
old_desc_blocks = 1102, new_desc_blocks = 1744
Performing an on-line resize of /dev/sdb to 3656906240 (4k) blocks.
resize2fs: Toiminto ei ole sallittu While trying to add group #87872
Command exited with non-zero status 1
1.06user 23.92system 1:14:43elapsed 0%CPU (0avgtext+0avgdata 
2967168maxresident)k
2762520inputs+0outputs (2major+185506minor)pagefaults 0swaps

and now when trying to (continue) resizing it it fails immediately:

sudo time resize2fs-1.42.6 -p /dev/sdb
resize2fs 1.42.6 (21-Sep-2012)
Filesystem at /dev/sdb is mounted on /m/nfs/dvb3; on-line resizing 
required
old_desc_blocks = 1373, new_desc_blocks = 1744
resize2fs-1.42.6: Not enough reserved gdt blocks for resizing
Command exited with non-zero status 1
0.02user 0.01system 0:00.07elapsed 41%CPU (0avgtext+0avgdata 
25456maxresident)k
400inputs+0outputs (2major+1640minor)pagefaults 0swaps
--8<--8<--

tune2fs -l doesn't show any gdt entries, probably because there are 0 or 
them left:

--8<--8<--
$ sudo tune2fs-1.42.6 -l /dev/sdb
tune2fs 1.42.6 (21-Sep-2012)
Filesystem volume name:   /m/nfs/dvb3
Last mounted on:          /m/nfs/dvb3
Filesystem UUID:          901df891-a9b7-42d6-828e-f8e4d08dd665
Filesystem magic number:  0xEF53
Filesystem revision #:    1 (dynamic)
Filesystem features:      has_journal ext_attr resize_inode 
dir_index filetype needs_recovery extent 64bit flex_bg 
sparse_super large_file huge_file uninit_bg dir_nlink 
extra_isize
Filesystem flags:         signed_directory_hash
Default mount options:    user_xattr acl
Filesystem state:         clean
Errors behavior:          Continue
Filesystem OS type:       Linux
Inode count:              2811904
Block count:              2879389696
Reserved block count:     0
Free blocks:              701905763
Free inodes:              2796804
First block:              0
Block size:               4096
Fragment size:            4096
Blocks per group:         32768
Fragments per group:      32768
Inodes per group:         32
Inode blocks per group:   2
Flex block group size:    16
Filesystem created:       Fri Jun 22 03:08:32 2012
Last mount time:          Mon Nov 12 11:44:10 2012
Last write time:          Mon Nov 12 11:44:10 2012
Mount count:              1
Maximum mount count:      -1
Last checked:             Mon Nov 12 09:40:19 2012
Check interval:           0 (<none>)
Lifetime writes:          77 TB
Reserved blocks uid:      0 (user root)
Reserved blocks gid:      0 (group root)
First inode:              11
Inode size:               256
Required extra isize:     28
Desired extra isize:      28
Journal inode:            8
Default directory hash:   half_md4
Directory Hash Seed:      a3addc24-77ec-4154-8dd2-7b70fa0d942b
Journal backup:           inode blocks
--8<--8<--

and fsck shows it still looks to be okay:

--8<--8<--
$ sudo /usr/local/sbin/e2fsck-1.42.6 -v -f /dev/sdb
e2fsck 1.42.6 (21-Sep-2012)
Pass 1: Checking inodes, blocks, and sizes
Pass 2: Checking directory structure
Pass 3: Checking directory connectivity
Pass 4: Checking reference counts
Pass 5: Checking group summary information

        15100 inodes used (0.54%, out of 2811904)
         6440 non-contiguous files (42.6%)
           24 non-contiguous directories (0.2%)
              # of inodes with ind/dind/tind blocks: 0/0/0
              Extent depth histogram: 4762/10283/44
   2177483933 blocks used (75.62%, out of 2879389696)
            0 bad blocks
         1047 large files

        14864 regular files
          224 directories
            0 character device files
            0 block device files
            0 fifos
            0 links
            3 symbolic links (3 fast symbolic links)
            0 sockets
------------
        15091 files
--8<--8<--

When this has been resolved, my next plans after this it go increase it 
past the 16 TB barrier. Which kernel version should I use for having a 
chance to succeed? Any recommended distribution if Debian Stable + 
updated kernel/e2fsprogs is a bad choice?

Another thing I have observed. I have about a constant data write of about 
50MB/s-90MB/s to that filesystem and whenever I try to resize it online 
without moving that write process to another filesystem, it hangs after an 
hour or so. It seems like the filesystem is no longer able to perform 
write operations on it any more and resizing also stops. It doesn't seem 
to affect reading the file system; the files and directories can be 
accessed fine. There is not much Dirty or Writeback visible under 
/proc/meminfo but still nothing gets written. I have mounted it with 
noatime options so that reads do not need to update access times. Those 
writing processes cannot be killed, not even with kill -KILL and the 
system does not shutdown. Reboot using magic sysreq is needed to recover. 
However, now that I know of this resize hang during writes I can live 
with it.

Regards,
Kimmo Mustonen
