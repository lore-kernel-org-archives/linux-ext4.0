From: coly <colyli@gmail.com>
Subject: [RFC] Designing and Implementation of Directory Inode Reservation
Date: Tue, 27 Mar 2007 01:12:59 +0800
Message-ID: <1174929180.27337.5.camel@colyT43.site>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Cc: Xin Wei Hu <xwhu@novell.com>
To: linux-ext4 <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from ug-out-1314.google.com ([66.249.92.174]:54404 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753007AbXCZRIb (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 26 Mar 2007 13:08:31 -0400
Received: by ug-out-1314.google.com with SMTP id 44so1654261uga
        for <linux-ext4@vger.kernel.org>; Mon, 26 Mar 2007 10:08:29 -0700 (PDT)
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Hi, list,

I am working on the directory inode reservation feature now. Here is the
detailed description of my understand of the designing, and current
implementations.

Please give me your comments on this idea. Thanks for your help in
advance.

Best regards.

Coly Li


-----------------------------------------------------------------------------
Designing and Implementation of Directory Inode Reservation

version 0.1

Coly Li

  This text explains what is the idea of directory inode reservation,
and current designing and implementation for this idea. Andreas Dilger
and Danial Phillips developed this idea when ext3 htree was first
written, now it is the time to implement it.

1. Issues for current inode allocating
  Currently ext3 and ext4dev allocate inodes in linear order within each
block groups. The linear allocating may causes bad performance when stat
or unlink huge number of files under a directory recursively. The
reasons are:
  * Inodes are allocated in linear order, while dentries of files are
accessed by hashed order in directory files. The difference in ordering
may cause a single inode block in inode table to be submitted multiple
times. For example, in hashed order of directory file, the inode of
first accessed file is in second inode block, inode of second accessed
file is in first inode block, inode of third accessed file is in second
inode block ... This will cause each inode block be dirtied and
submitted into journal or nature filesystem multiple times, especially
in data=writeback mode.
  * Inodes of files in different sub-directories may be allocated in one
inode block. This condition will also cause multiple dirtying and
submitting to this inode block, it can not be helpful that even the
inodes of same directory are in hashed order.
  The issue will happen when creating huge number of files under a
directory, and even worse when creating huge number of files under
multiple directories alternately within one block group.

2. Improve performance by inode reservation for sub-directories
  Inode reservation for sub-directories means when creating a
sub-directory, reserve a number of continuous inodes in inode table for
it. When creating new files under the sub-directory, inodes can be
allocated from the reserved region. Once the reserved region is full,
just find another larger reservd region in inode tables.
  * First goal, make new file inodes of same directory be allocated from
reserved inode region.
  * Second goal, make new file inodes of same directory be allocated in
hashed (like) order from reserved inode region.
  The first goal can avoid inodes from different sub-directories mixed
in one inode blocks. The second goal can try best to make inodes
allocating order follow hashed order of dentries in directory file. Both
can decrease multiple times for inode block dirting and submitting.

3. Benchmarks for ideal performance improvement
  A benchmark is done for ideal condition, the improved results are
impressive (copy operations are done on differenct harddisk, all the
files are 0 byte). Operations are:
  * cd hdiskA/sub; for i in `seq 1 500000`;do touch `/usr/bin/keygen |
head -c 8`;done;done
  * reboot
  * time cp -r hdiskA/sub hdiskB/ordered1
  * cp -r hdiskB/ordered1 hdiskA/ordered1
  * reboot
  * time cp -r hdiskA/ordered1 hdiskB/ordered2
  * reboot
  * time rm -rf hdiskA/ordered1
  * time rm -rf hdiskA/sub
  Here are the results for different journaling modes:
  a) data=writeback mode
    "cp -r hdiskA/sub hdiskB/ordered1" | "cp -r hdiskA/ordered1
hdiskB/ordered2"
       real    7m17.616s               |    real    1m8.764s
       user    0m1.456s                |    user    0m1.568s
       sys     0m27.586s               |    sys     0m26.050s
      "rm -rf hdiskA/sub"              |   "rm -rf hdiskA/ordered1"
       real    9m49.902s               |    real    0m37.493s
       user    0m0.220s                |    user    0m0.076s
       sys     0m14.377s               |    sys     0m11.089s
  b) data=ordered
    "cp -r hdiskA/sub hdiskB/ordered1" |   "cp -r hdiskA/ordered1
hdiskB/ordered2"
       real    7m57.016s               |    real    7m46.037s
       user    0m1.632s                |    user    0m1.604.s
       sys     0m25.558s               |    sys     0m24.902s
      "rm -rf hdiskA/sub"              |   "rm -rf hdiskA/ordered1"
       real    10m17.966s              |    real    6m32.278s
       user    0m0.236s                |    user    0m0.176s
       sys     0m14.453s               |    sys     0m12.093s
  c) data=journal
    "cp -r hdiskA/sub hdiskB/ordered1" |   "cp -r hdiskA/ordered1
hdiskB/ordered2"
       real    6m54.151s               |    real    7m7.696s
       user    0m1.696s                |    user    0m1.416s
       sys     0m22.705s               |    sys     0m23.541s
      "rm -rf hdiskA/sub"              |   "rm -rf hdiskA/ordered1"
       real    10m41.150s              |    real    7m43.703s
       user    0m0.188s                |    user    0m0.216s
       sys     0m13.781s               |    sys     0m12.117s

  From the results we can find that if inodes of same directory are
allocated continuously, and in same order of the dentries hashed in
directory file, there will be much performance improved. In
data=writeback mode, the improvement is astonishing. In data=ordered and
data=journal mode, performance of stat can not be improved much, but
unlink can be improved around 27% ~ 36%. 
  Andreas Dilger points out that in this benchmark, all files are 0
byte. If allocated data blocks to these files (as in practice),
performance improvement can be more obvious.

4. Designing and implementation
  The designing principle is quite simple. 
  * When a directory is created, reserved a couple of inodes for it. 
  * When a file under this directory is created, allocating inodes from
this reserved region.
  * When allocating an inode in reserved inode region, 
  * If no free inode in the reserved region, find a another double sized
continuous inodes region from the inode tables.
  * If there is no available inodes for inode reservation, use original
linear inodes allocator.
  * Do not change the on disk layout of ext4 filesystem.
  * Some inodes will serve as magic inodes. There are 2 kinds of magic
inode, EXT4_MINODE_TYPE_LASTRES records the offset of latest reserved
inode for directory in a inode table of a block group,
EXT4_MINODE_TYPE_LINK records the inode number at the head of next
reserved inode area for the same directory.

  Here are the details for implementation.
  a) Initial number of reserved inodes is 1 block in inode table. When
the reserved area is full, looking for a doubled size free inode block
for the directory, until there is not available free inode blocks in all
block groups, or the size of reserved inode area reachs maximum size of
one inode table.
  b) The last inode in each reserved inode block are
EXT4_MINODE_TYPE_LINK magic inode. In this magic inode, records the head
inode number of next double sized inode block, and the size for next
reserved inode block for the same directory, and whethere there is no
next reserved inode block for the directory.
  c) For each block group, there is a EXT4_MINODE_TYPE_LASTRES magic
inode stays in the last inode of last inode block of inode table. This
magic inode records the offset of last inode used in reservation within
its inode table. When creating a new directory in a block group, the
inodes for itself and reserved inodes can be allocated after the offset
recorded in the EXT4_MINODE_TYPE_LASTRES magic inode.
  d) Inode reservation for sub-directory is different to inode/block
reservation for root user. The latter one will set all the reserved
inode/block in inode/block bitmap as busy, so others can not use the
inode or block within the reserved region. In the sub-directory inode
reservation, all inodes in reserved region are still free in bitmap,
only magic inodes are set as busy in inode bitmap. By this scheme,
others also can allocated inodes from the reserved area (e.g. in case of
no available reservation inode area for new created sub-directory), but
this is the lastest choice.
  e) Inode of each sub-directory will be the first inode in reserved
inode blocks for itself. When a new file is created under this
sub-directory, the inode for the new file will be allocated from the
reserved area. Firstly, the inode will try to be allocated in a hashed
order (same as htree for dentries) other than current linear order.
Secondly, if the resulted position is allocated already, find a new
position near around. If no near around free inode can be found to
allocate, the inode will be allocated by linear order in the reserved
inode area.
  f) In theory, the smallest size of reserved inode area is 1 inode
block in inode talbe of a block group, while the largest size of
reserved inode area is the whole inode table of a block group (except
inodes reserved for root user and all magic inodes).
  g) When creating a new directory, the target block group is decided by
orlov allocator. But a restriction should be patched in the orlov
allocator, that is the target block group should also have enough
continuous inodes in inode table to be reserved for the new created
directory.
  h) When creating a new file under a directory, the initial target
block group is the same block group with the dirctory is located on. But
if the inode will be allocated in a reserved inode area on another block
group, the target block group will be switched.
  i) Maigc inode will mark with EXT4_MINODE_MAGIC_STR string, kernel and
fsck can verify it by magic string and checksum.
  j) Mke2fs and fsck should be patched to understand magic inodes for
sub-directory inode reservation.

5. Compatibility issues
  Current designing and implementation can work well with legacy
e2fsprogs and ext3/ext4dev kernel code.
  * If a sub-directory inode reservation enabled ext4 partition is
mounted on a ext3 or current ext4dev kernel, the magic inodes will be
taken as busy inodes, and no affect to normal inodes allocating or
reaping.
  * If a sub-directory inode reservation enabled ext4 partition is
checked by a magic-inode-unknown legacy fsck, the magic inodes will be
taken as corrupted inodes and be reaped. For the next mount, the
partition will work as a sub-directory inode reservation disabled
parition.
  * For other conditions, kernel will try to fix the error firstly. Only
when the error is unrecoverable, kernel will disable the inode
reservation automatically. e.g. a incorrect EXT4_MINODE_TYPE_LASTRES
inode is found in a sub-directory inode reservation enabled ext4
partition. Kernel will try to fix offset recorded in this magic inode,
if this error is unrecoverable, kernel will disable inode reservation,
and any new inode will be allocated in traditional linear order.
  Therefor, even several magic inodes are added into the ext4 ondisk
layout, basic format is unchanged. The new format can continue to work
with legacy kernel or e2fsprogs.

6. Modification in ext4 source code
  As Andreas Dilger predicts, about 500 lines C code needed to implement
this patch. The patch will be in:
  * Super block filling code. Kernel needs to check whether inode
reservation is enabled in the mounting partition, and try best to fix
founded magic inode errors.
  * Orlov allocator. Add extra restriction to choose the target block
group for inode reservation.
  * Inode allocator for non-directory files. New inodes will not be
allocated as the first free inode in inode table of a block group, it
will be allocated from reserved inode area of the directory. 
  * Other unpredictable places in ext4 kernel code. e.g. If dynamic
inode allocation is accepted, now patch will be made to implement
sub-directory inode reservation in dynamic inode allocation.

7. Expected performance improvement
  I am not confident to make improvement as better as the ideal
condition benchmark. How about 50% improvement of the benchmark in ideal
condition? Who knows, let me implement it firstly. The benchmakr will
give us the result :-)


	
