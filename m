From: Ross Zwisler <ross.zwisler-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Subject: [PATCH v3 00/11] re-enable DAX PMD support
Date: Tue, 27 Sep 2016 14:47:51 -0600
Message-ID: <1475009282-9818-1-git-send-email-ross.zwisler@linux.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: Theodore Ts'o <tytso-3s7WtUTddSA@public.gmane.org>, Matthew Wilcox <mawilcox-0li6OtcxBFHby3iVrkZq2A@public.gmane.org>,
 Dave Chinner <david-FqsqvQoI3Ljby3iVrkZq2A@public.gmane.org>, linux-nvdimm-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org,
 Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>, linux-xfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org,
 Andreas Dilger <adilger.kernel-m1MBpc4rdrD3fQ9qLvQP4Q@public.gmane.org>,
 Alexander Viro <viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org>, Jan Kara <jack-IBi9RG/b67k@public.gmane.org>,
 linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-ext4-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
 Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
To: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Return-path: <linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
List-Unsubscribe: <https://lists.01.org/mailman/options/linux-nvdimm>,
 <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=unsubscribe>
List-Archive: <http://lists.01.org/pipermail/linux-nvdimm/>
List-Post: <mailto:linux-nvdimm-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
List-Help: <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=help>
List-Subscribe: <https://lists.01.org/mailman/listinfo/linux-nvdimm>,
 <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=subscribe>
Errors-To: linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org
Sender: "Linux-nvdimm" <linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
List-Id: linux-ext4.vger.kernel.org

DAX PMDs have been disabled since Jan Kara introduced DAX radix tree based
locking.  This series allows DAX PMDs to participate in the DAX radix tree
based locking scheme so that they can be re-enabled.

Jan and Christoph, can you please help review these changes?

Andrew, when the time is right can you please push these changes to Linus via
the -mm tree?

In some simple mmap I/O testing with FIO the use of PMD faults more than
doubles I/O performance as compared with PTE faults.  Here is the FIO script I
used for my testing:

  [global]
  bs=4k
  size=2G
  directory=/mnt/pmem0
  ioengine=mmap
  [randrw]
  rw=randrw

Here are the performance results with XFS using only pte faults:
   READ: io=1022.7MB, aggrb=557610KB/s, minb=557610KB/s, maxb=557610KB/s, mint=1878msec, maxt=1878msec
  WRITE: io=1025.4MB, aggrb=559084KB/s, minb=559084KB/s, maxb=559084KB/s, mint=1878msec, maxt=1878msec

Here are performance numbers for that same test using PMD faults:
   READ: io=1022.7MB, aggrb=1406.7MB/s, minb=1406.7MB/s, maxb=1406.7MB/s, mint=727msec, maxt=727msec
  WRITE: io=1025.4MB, aggrb=1410.4MB/s, minb=1410.4MB/s, maxb=1410.4MB/s, mint=727msec, maxt=727msec

This was done on a random lab machine with a PMEM device made from memmap'd
RAM.  To get XFS to use PMD faults, I did the following:

  mkfs.xfs -f -d su=2m,sw=1 /dev/pmem0
  mount -o dax /dev/pmem0 /mnt/pmem0
  xfs_io -c "extsize 2m" /mnt/pmem0

Changes since v2:
- Removed the struct buffer_head + get_block_t based dax_pmd_fault() handler.
  All DAX PMD faults will now happen via the new struct iomap based
  iomap_dax_pmd_fault().
- Added a new struct iomap based PMD path which is now used by XFS.
- Now that it is using struct iomap, ext2 no longer needs to modified so that
  ext2_get_block() will give us the size of a hole.
- Remove support for DAX PMD faults for ext2.  I can't get them to reliably
  happen in my testing.
- Removed unused xfs_get_blocks_dax_fault() wrapper
- Added a bunch of comments around my changes in dax.c.

This was built upon xfs/for-next with PMD performance fixes from Toshi Kani and
Dan Williams.  Dan's patch has already been merged for v4.8, and Toshi's
patches are currently queued in Andrew Morton's mm tree for v4.9 inclusion.

Here is a tree containing my changes and all the fixes that I've been testing:
https://git.kernel.org/cgit/linux/kernel/git/zwisler/linux.git/log/?h=dax_pmd_v3

Ross Zwisler (11):
  ext4: allow DAX writeback for hole punch
  ext4: tell DAX the size of allocation holes
  dax: remove buffer_size_valid()
  ext2: remove support for DAX PMD faults
  dax: make 'wait_table' global variable static
  dax: consistent variable naming for DAX entries
  dax: coordinate locking for offsets in PMD range
  dax: remove dax_pmd_fault()
  dax: add struct iomap based DAX PMD support
  xfs: use struct iomap based DAX PMD fault path
  dax: remove "depends on BROKEN" from FS_DAX_PMD

 fs/Kconfig          |   1 -
 fs/dax.c            | 696 +++++++++++++++++++++++++++++-----------------------
 fs/ext2/file.c      |  24 +-
 fs/ext4/inode.c     |   7 +-
 fs/xfs/xfs_aops.c   |  25 +-
 fs/xfs/xfs_aops.h   |   3 -
 fs/xfs/xfs_file.c   |   2 +-
 include/linux/dax.h |  37 ++-
 mm/filemap.c        |   6 +-
 9 files changed, 434 insertions(+), 367 deletions(-)

-- 
2.7.4
