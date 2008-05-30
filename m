From: Akira Fujita <a-fujita@rs.jp.nec.com>
Subject: [RFC][PATCH 0/8]ext4: online defrag (ver 0.9)
Date: Fri, 30 May 2008 20:17:35 +0900
Message-ID: <483FE24F.50105@rs.jp.nec.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Cc: Akira Fujita <a-fujita@rs.jp.nec.com>
To: linux-ext4@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	Theodore Tso <tytso@mit.edu>, Mingming Cao <cmm@us.ibm.com>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Hello,

I've updated the ext4 online defragmentation patches.
I've addressed the review comment from Mingming, and there are some cleanups
but no functional changes since the previous version.

Changelog:
- 0.9 (May 30, 2008)
  - Create some new functions (ext4_defrag_fill_ar(),
    ext4_defrag_check_phase() ...) to separate block allocation function,
    since the phase mode plug into the allocation function isn't good.
  - Add the description of ext4_defrag() which is main function.
  - Add the capability check.
  - Some cleanups.
- 0.8 (April 8, 2008)
    Fix sparse warnings and change the construction of patches.
- 0.7 (January 10, 2008)
    Interchange the data blocks of the target and temporary files
    in an atomic manner.

Outline for ext4 online defragmentation:
Ext4 online defrag has the following three functions.

 no option  Solving a single file fragmentation.
            Single file fragmentation is solved by moving file
            data to contiguous free blocks.

    -r      Solving a relevant file fragmentation.
            Relevant file fragmentation could be solved by moving
            the files under the specified directory close together with
            the block containing the directory data.

    -f      Solving a free space fragmentation.
            If there is no contiguous free blocks in the filesystem,
            the other files are moved to make sufficient space to allocate
            contiguous blocks for the target file.

Notes:
- Ext4 online defarg needs "mballoc" and "extents" mount options,
  and it only supports 4KB block size (It will go away soon).
- Current mballoc in the ext4 patch queue (linux-2.6.26-rc4) doesn't
  work fine, ext4_mb_init_caches() which is changed by
  ext4-add-error-handling-in-ext4-mb_laod_buddy.patch returns -EIO.
  You can reproduce this kind of issue easily with following procedure.
  1. mke2fs -j -E test_fs /devname
  2. mount -t ext4dev -o mballoc,extents /devname /mountpoint
  3. mkdir DIR /mountpint
     mkdir: cannot create directory `/mnt/mp2/DIR1': No space left on device

Next steps:
1. Implement FS_IOC_FIEMAP instead of EXT4_EXTENTS_INFO to reduce ioctl count.
2. Remove the restriction of block size (Enable defrag with 1KB and 2KB).
3. Remove the limit of target file size (now 128MB) in -f mode.
   * The post about -f mode can be found at:
   http://marc.info/?l=linux-ext4&m=118239067704899&w=4

Summary of patches:
* The following patches are new ext4 online defrag patches.
  Mingming, please replace these patches with the ext4 patch queue's.

[PATCH 1/8] Main function of ext4 online defrag and ioctl implementation
- Create the temporary inode and do defrag per
  defrag_size (defalut 64MB).

[PATCH 2/8] Allocate new contiguous blocks with mballoc
- Search contiguous free blocks with mutil-block allocation
  and allocate them for the temporary inode.

[PATCH 3/8] Read and write file data with memory page
- Read the file data from the old blocks to the page cache and
  write the file data on the page into the new blocks.

[PATCH 4/8]  Exchange the blocks between two inodes
- Exchange the data blocks between the temporary inode and
  the original inode.

[PATCH 5/8] Defragmentation for the relevant files (-r mode)
- Relevant file fragmentation could be solved by moving
  the files under the specified directory close together with
  the block containing the directory data.

[PATCH 6/8] Check the free space fragmentation (-f mode)
- Check the free space fragmentation in the block group
  where target file is located.

[PATCH 7/8] Move victim files for the target file (-f mode)
- Move victim files to make sufficient space and reallocate
  the contiguous blocks for the target file.

[PATCH 8/8] Online defrag command
- The defrag command. Usage is as follows:
  - Defrag for a single file.
    # e4defrag file-name
  - Defrag for all files on ext4.
    # e4defrag device-name
  - Put the multiple files closer together.
    # e4defrag -r directory-name
  - Defrag for free space fragmentation.
    # e4defrag -f file-name

Performance test:
I created 1GB files with parallel writing then ran the e4defrag to it.
As a result, I got the following improvement.

                        <Before>           <After>
--------------------------------------------------------------------
Fragments                  127      ->       20
I/O performance(sec)       40.3     ->       36 (10% improved)

		Kernel: 2.6.26-rc4 + ext4 patch queue Arch: x86_64
		Mount options: extents, mballoc, delalloc, data=writeback

* "Fragments" is the number of fragments in 1GB file shown by filefrag.
  "I/O performance" is the execution time for reading 1GB file
   with "cat" command (cat file* > /dev/null).

Any comments are welcome.

Regards,
Akira Fujita
