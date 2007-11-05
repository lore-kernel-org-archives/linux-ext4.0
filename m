From: Coly Li <coyli@suse.de>
Subject: [RFC] ext4: designing and implementation of directory inode reservation
Date: Mon, 05 Nov 2007 20:24:18 +0800
Message-ID: <472F0B72.1030008@suse.de>
Reply-To: coyli@suse.de
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from victor.provo.novell.com ([137.65.250.26]:57074 "EHLO
	victor.provo.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754178AbXKEMPZ (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 5 Nov 2007 07:15:25 -0500
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Designing and Implementation of Directory Inode Reservation

version 1

Coly Li
Nov 4, 2007

This text explain the designing and implementation of the directory inode reservation patch to ext4
file system. The original idea was developed by Andreas Dilger and Danial Phillips when ext3 htree
was firstly written, I implement it in my understanding.

1 Issue for inode allocating in current ext[234] file system
  Current ext[234] allocate inodes in linear order in each block group, which means allocator always
tries to allocate first free inode from offset 0 to maximum size of a selected inodes table. It
works well in most cases, as we have seen in the past dozen of years. But when huge number of files
to be unlinked, it is still possible to improve performance observably.
  The reason for the poor performance is because,
* In order to improve directory entries look up performance, dentries are organized and accessed by
hashed order. Due to inodes are allocated in linear order, most of the time, the order which files
of a directory are accessed, is not the order which files' inodes are accessed in inodes table. E.g,
There are 24 files under a directory have name as a, b, c, d, e, f, g, h, i, j, k, l, m, n, o, p, q,
r, s, t, u, v, w, x, they are created in a selected inode table by bellow order:
  a, d, g, j, m, p, s, v, b, e, h, k, n, q, t, w, c, f, i, l, o, r, u, x
  But when we type 'rm -rf' to the parent directory, the inodes of the files will be unlinked and
written into hard disk in a hashed order:
  a, b, c, d, e, f, g, h, i, j, k, l, m, n, o, p, q, r, s, t, u, v, w, x
  On a ext3 file system with 1KB block and 128B inode, each block can hold 8 inode in inodes table.
Therefore the 24 inodes can be included into 3 blocks:
  block     N: inodes of a, d, g, j, m, p, s, v
  block N + 1: inodes of b, e, h, k, n, q, t, w
  block N + 2: inodes of c, f, i, l, o, r, u, x
  In order to type less characters, these three blocks are named as 0, 1, 2 in turn. In order to
unlink these 24 files, these 3 blocks will be written to hard disk in bellow sequence,
  0 1 2 0 1 2 0 1 2 0 1 2 0 1 2 0 1 2 0 1 2 0 1 2
  In these case, to delete 24 inodes, 24 blocks have to be written to hard disk.
* If huge number of directories are created, and files in each directory are crease alternatively,
the unlink performance will be worse. Here is an example, the uppercase characters represent
directories inode, and corresponded lowercase characters represent file inodes under the parent
directories. When number of directories are much more than number of block groups, some inodes of
directories will be allocated in inodes table like this,
  A B C D E F
  When the files under each directory increase alternatively, some time latter (if each directory
has 2 files), the layout of this inodes table will be,
  <--  blk 0  --> <-- blk 1  -->  <-- blk 2  -->
  A B C D E F H I a b c d e f h i a b c d e f h i
  Now if these directories are unlinked recursively in hashed order, because every time when unlink
a file from a directory, the inode of directory should also be updated to hard disk. The access
sequence should be (if update and unlink for each directory inode can be merged into one session),
  1 0 2 0 1 0 2 0 1 0 2 0 1 0 2 0 1 0 2 0 1 0 2 0 1 0 2 0 1 0 2 0
  From the above sequence, we can find in order to remove 8 directories (each has 2 files), 32
blocks should be written to hard disk.
  The above two examples do not talk about conditions that multiple I/O request to same block can be
merged into one session before time. But they can represent the key point of linear inode allocating
very well, when number of directories and files increases, only small number of I/O to same block
can be merged before session timeout.

2 Original designing of directory inode reservation
  Andreas Dilger and Danial Phillips pointed out, if inodes of directory's files can be placed in
inodes table as the same order as files accessed in hashed order, the performance of state/unlink
can be improved dramatically, especially for small size files.
  Here is an experiment and benchmark to prove this idea. To simulate the end user feeling, we only
recode the time from 'click ENTER' to 'back to shell', do not include sync time. To make things
simple, all files are 0 byte, which means all the block I/O are for inodes and directory file.
  * cd hdiskA/sub; for i in `seq 1 500000`;do touch `/usr/bin/keygen | head -c 8`;done;done
  * reboot
  * time cp -r hdiskA/sub hdiskB/ordered1
  * cp -r hdiskB/ordered1 hdiskA/ordered1
  * reboot
  * time cp -r hdiskA/ordered1 hdiskB/ordered2
  * reboot
  * time rm -rf hdiskA/ordered1
  * time rm -rf hdiskA/sub
  Here are the results for different journaling modes on ext3:
  a) data=writeback mode
      "cp -r hdiskA/sub hdiskB/ordered1"  |   "cp -r hdiskA/ordered1 hdiskB/ordered2"
       real    7m17.616s                  |    real    1m8.764s
       user    0m1.456s                   |    user    0m1.568s
       sys     0m27.586s                  |    sys     0m26.050s
      "rm -rf hdiskA/sub"                 |   "rm -rf hdiskA/ordered1"
       real    9m49.902s                  |    real    0m37.493s
       user    0m0.220s                   |    user    0m0.076s
       sys     0m14.377s                  |    sys     0m11.089s
  b) data=ordered
      "cp -r hdiskA/sub hdiskB/ordered1"  |   "cp -r hdiskA/ordered1 hdiskB/ordered2"
       real    7m57.016s                  |    real    7m46.037s
       user    0m1.632s                   |    user    0m1.604.s
       sys     0m25.558s                  |    sys     0m24.902s
      "rm -rf hdiskA/sub"                 |   "rm -rf hdiskA/ordered1"
       real    10m17.966s                 |    real    6m32.278s
       user    0m0.236s                   |    user    0m0.176s
       sys     0m14.453s                  |    sys     0m12.093s
  c) data=journal
      "cp -r hdiskA/sub hdiskB/ordered1"  |   "cp -r hdiskA/ordered1 hdiskB/ordered2"
       real    6m54.151s                  |    real    7m7.696s
       user    0m1.696s                   |    user    0m1.416s
       sys     0m22.705s                  |    sys     0m23.541s
      "rm -rf hdiskA/sub"                 |   "rm -rf hdiskA/ordered1"
       real    10m41.150s                 |    real    7m43.703s
       user    0m0.188s                   |    user    0m0.216s
       sys     0m13.781s                  |    sys     0m12.117s
  After copying a directory recursively to a new directory, the order to access inodes and dentries
of files in new directory will be same. That is why the performance number on the right side are
much better than the left ones.
  Therefore, here comes the original idea of directory inode reservation,
  1) When creating a new directory, reserve an area on inodes table for the new directory. New file
inode of this directory will be allocated from the reserved area, new file inode of other director
will not be allocated from this area.
  2) When creating a new file under this directory, the inode position within the reserve area is
decided by a hash of file's name(like ext[34] htree does).
  3) Before the first reserved inodes table area full, always try to allocate inodes from it.
  4) If the first reserved inodes table area is full, try to find a bigger size reserved area from
inodes tables.
  5) Do not change on-disk layout of ext[34] file system.

3 Modified designing of my directory inode reservation patch
  During I implement the hashed order inode allocating, I find some issues of the original idea,
  * It's very hard to simulate a hashed inodes order which is perfect match to real hashed order of
dentries.
  * When creating large number of small files in a directory, hashed order inode allocating will
increase hard disk seeking time because inodes are not allocated continuously in inodes table. If
the reserved area is large, the performance will be much poor than linear allocating.
  * When previous reserved area is full, another new/bigger reserved area is needed to allocate new
inode. But there is no way to link these reserved area together if there is no on-disk format
modification. Therefore when next mount, we don't know where should the new inode to be allocated from.
  After several months to implement the original idea, I did some experiments, the result told me,
  * If use a on-harddisk list to link reserved areas of a directory together, the performance will
be terribly bad. Only a list of 2 reserved area can make unlink time 2 times longer than linear
inode allocator.
  * Inode accessing sometimes jumps between multiple reserved area, no evidence shows this
behaviours has better/worse performance against linear inode allocator.
  Finally I decide to implement a simplified version of directory inode reservation, the simple one
can still achieve perfect performance improvement, and work as well as linear inodes allocator in
common condition. Here comes the simplified idea of directory inode reservation,
  * When creating a new directory, reserve an area on inodes table for the new directory.
  * New file inode of this directory will be allocated in linear order from the reserved area.
  * If the reserved area is full, use linear inode allocator, do not look for another reserved area.
  * Need to add a flag in super block to identify this feature.

4 Implementation of simplified directory inode reservation
  Current directory inode reservation patch for ext4 should work in this behavior,
  * Reserved area size can be specified in mounting time.
  * Use gb_itable_unused of group descriptor to record next inode to be allocated to new directory.
Every time when a new directory inode allocated, gb_itable_unused should be updated by minusing
reserve area size.
  * Reserved inode area follows the directory inode in inodes table.
  * When a new file inode is allocated from reserved area of a directory, do not search free inode
slot from offset 0 of inodes table. The offset of directory inode in the inodes table will be given
to linear inode allocator, so new file inode will be allocated from directory's reserved area.
  * when unlinking a directory, if the reserved inode area is the latest one of group block, try to
expend bg_itable_unused to make more continuous free area in inodes table for reservation.
  * If no available room in inodes table for a new created directory to reserve, inode of this
directory will be allocated from linear inode allocator.
  * Even a directory has no reserved inode area for him, its new created file can also try to find
free inode after directory inode offset in inodes table. Before this inode table is full, a file
inode can be found without unnecessary inode bitmap scanning. Once the inode table is full, at least
it will not be worse than linear inode allocator.

5 Performance advance of simplified directory inode reservation
  * If huge number of directories are created, and files in each directory are created
alternatively, file inodes are alllocated from reserved area, they are very near to directory inode.
When update directory inode with new file created, the harddisk seeking time on inodes table is less
than linear inode allocator. If block size is 4KB and inode size is 128B, the first 35 file inodes
can be written to hard disk in 1 block I/O. In May 2007 I did a benchmark that creating time can be
decreased by 50% !
  * When unlink the directories created in the above condition recursively, because file inodes of a
directory is placed in reserved area and very near to directory inode, harddisk seeking time can
also be decreased. For a 4KB block and 128B ext4 partition, the first 35 file inodes can be unlinked
from hard disk within 1 block I/O. Here is a benchmark I did in May 2007
(http://lkml.org/lkml/2007/5/23/281). I am still working on benchmark for new code, since the
designing is improved, the performance number is expected to be better than previous one.

6 Compatibility issues
  * Now directory inode patch depends on uninit group patch, because bg_itable_unused is introduced
from uninit group patch. When directory inode reservation and uninitiated group both are enabled,
reserved inode area will cause much more less gb_itable_unused in each block group, then cause
sparse inodes tables, then cause fsck spending more time to scan inodes tables. Fortunately, enable
directory inode reservation based on uninit group does not introduce logical conflict.
  * In order to make directory inode reservation patch independent from uninit group patch, and
provide backward compatibility to ext[23], a new flag is needed for super block flags.

7 Where to get directory inode reservation patch
  The patch can be found from linux-ext4 mailing list, I will try best to push it in ext4 patch
queue within Nov 2007. Any feedback/advice/discussion for the idea and patches of directory inode
reservation are welcome, please email me to coyli@suse.de.




-- 
Coly Li
SuSE PRC Labs
