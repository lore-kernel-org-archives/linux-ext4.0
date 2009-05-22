From: Akira Fujita <a-fujita@rs.jp.nec.com>
Subject: [RFC][PATCH 0/3]ext4: online defrag (ver 2.0)
Date: Fri, 22 May 2009 16:05:45 +0900
Message-ID: <4A164EC9.3070405@rs.jp.nec.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Cc: linux-fsdevel@vger.kernel.org
To: Theodore Tso <tytso@mit.edu>, linux-ext4@vger.kernel.org
Return-path: <linux-fsdevel-owner@vger.kernel.org>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Hi,

There are the updated patches for ext4 online defrag.
I have addressed the comments that I had got about defrag V1
(http://marc.info/?l=linux-ext4&m=123329594919001&w=3).
Changes of this version are as follows:

- Change function name from ext4_defrag_xxx to ext4_mext_xxx
  and also change the source file name from defrag.c to move_extent.c.
- Disallow swapfile defrag.
- Support uninitialized extent defrag.
- Disallow data write out for uninitalized extent.
- Call fget() and fput() instead of fget_light() and fput_light()
  for module compile.
- Acquire mutex and semaphore of orig and donor inodes by i_ino order.
- Localized semaphore acquisition/release.
- Add ext4_mext_inode_double_lock/unlock() for i_mutex lock/unlock,
  since inode_double_lock/unlock() have been removed.
- Replace random printk() with ext4_debug().
- Some cleanups.

Ext4 online defrag uses EXT4_IOC_MOVE_EXT ioctl and move_extent structure.

#define EXT4_IOC_MOVE_EXT               _IOWR('f', 15, struct move_extent)

struct move_extent {
        int orig_fd;            /* original file descriptor */
        int donor_fd;           /* donor file descriptor */
        __u64 orig_start;       /* logical start offset in block for orig */
        __u64 donor_start;      /* logical start offset in block for donor */
        __u64 len;              /* block length to be moved */
        __u64 moved_len;        /* moved block length */
};


Ext4 online defrag is done in the following steps:
(U:User space K:Kernel space)

1:U  Create donor inode and then call unlink() to it.

2:U  Allocate contiguous blocks to donor inode with fallocate().

3:U  Call the FS_IOC_FIEMAP ioctl to get the extents information of donor inode.
     And check the extents of donor inode are less than the defrag target inode's.

4:U  Call the EXT4_IOC_MOVE_EXT ioctl extent unit.

5:K  In kernel space, the EXT4_IOC_MOVE_EXT ioctl calls ext4_mext_move_extent()
     to exchange the blocks between orig_fd and donor_fd.
     Then write the file data of orig_fd to donor_fd.

6:U  Close donor inode, then it will be deleted.

Note: More tests may be needed without journal,
      so I recommend that e4defrag is run on ext4 with journal.

Summary of patch series:
* The patch can be applied to the ext4 patch queue (2.6.30-rc6).

[PATCH 1/3] Add EXT4_IOC_DEFRAG ioctl and defrag functions
- Add EXT4_IOC_DEFRAG ioctl and related functions.
- For each page, exchange the extents between original inode
  and donor inode, and then write the file data of
  the original inode to donor inode.

[PATCH 2/3] Ext4 online defrag command
- Usage is as follows:
  - Defrag for a single file.
    # e4defrag file, directory, device
  - Check the file fragments on ext4.
    # e4defrag -c file, directory, device

[PATCH 3/3] Manpage of e4defrag
-  Ext4 online defrag command manpage
    # nroff -man e4defrag.8

Best regards,
Akira Fujita

