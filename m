From: Ross Zwisler <ross.zwisler-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Subject: [PATCH v6 00/17] re-enable DAX PMD support
Date: Wed, 12 Oct 2016 16:50:05 -0600
Message-ID: <20161012225022.15507-1-ross.zwisler@linux.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: Theodore Ts'o <tytso-3s7WtUTddSA@public.gmane.org>, Matthew Wilcox <mawilcox-0li6OtcxBFHby3iVrkZq2A@public.gmane.org>,
 Dave Chinner <david-FqsqvQoI3Ljby3iVrkZq2A@public.gmane.org>, linux-nvdimm-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org,
 Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>, linux-xfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org,
 Andreas Dilger <adilger.kernel-m1MBpc4rdrD3fQ9qLvQP4Q@public.gmane.org>,
 Alexander Viro <viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org>, linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
 Jan Kara <jack-AlSwsSmVLrQ@public.gmane.org>, linux-ext4-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
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

For now I'm still using the same baseline for this series as I did with v5.
I'll update the baseline once v4.9-rc1 is released, dropping whatever patches
have already been merged.

Changes since v5:
 - Reworked the way that DAX radix tree flags were handled. The old
   handling was correct but a bit hard for the reader to parse.  Hopefully
   this new way is more readable & maintainable.  (Jan & Christoph)
 - Made the definition of dax_radix_order() conditional based on
   CONFIG_FS_DAX_PMD.  This was necessary because PMD_SHIFT isn't defined
   on all systems. (kbuild)
 - Dropped the incorrect patch "ext2: return -EIO on ext2_iomap_end()
   failure".  (Jan)
 - A few error path fixes in grab_mapping_entry().  (Jan)
 - A few more comments in grab_mapping_entry(),
   dax_wake_mapping_entry_waiter() and dax_insert_mapping_entry(). (Jan)
 - Removed the 'inline' keyword from dax_iomap_sector().  (Dan)
 - Cleaned up the path through ops->iomap_end() in both dax_iomap_fault()
   and dax_iomap_pmd_fault().  We now pass 0 for the 'written' argument on
   error conditions.  (Jan & Christoph)
 - Improved the naming of 'size' to 'max_pgoff' in dax_iomap_pmd_fault().
   (Jan)

Thank you to Jan and Christoph for their review feedback.

Here is a tree containing my changes:
https://git.kernel.org/cgit/linux/kernel/git/zwisler/linux.git/log/?h=dax_pmd_v6

This tree has passed xfstests for ext2, ext4 and XFS both with and without
DAX, and has passed targeted testing where I inserted, removed and flushed
DAX PTEs and PMDs in every combination I could think of.

Ross Zwisler (17):
  ext4: allow DAX writeback for hole punch
  ext4: tell DAX the size of allocation holes
  dax: remove buffer_size_valid()
  ext2: remove support for DAX PMD faults
  dax: make 'wait_table' global variable static
  dax: remove the last BUG_ON() from fs/dax.c
  dax: consistent variable naming for DAX entries
  dax: coordinate locking for offsets in PMD range
  dax: remove dax_pmd_fault()
  dax: correct dax iomap code namespace
  dax: add dax_iomap_sector() helper function
  dax: dax_iomap_fault() needs to call iomap_end()
  dax: move RADIX_DAX_* defines to dax.h
  dax: move put_(un)locked_mapping_entry() in dax.c
  dax: add struct iomap based DAX PMD support
  xfs: use struct iomap based DAX PMD fault path
  dax: remove "depends on BROKEN" from FS_DAX_PMD

 fs/Kconfig          |   1 -
 fs/dax.c            | 825 +++++++++++++++++++++++++++++-----------------------
 fs/ext2/file.c      |  35 +--
 fs/ext4/inode.c     |   7 +-
 fs/xfs/xfs_aops.c   |  26 +-
 fs/xfs/xfs_aops.h   |   3 -
 fs/xfs/xfs_file.c   |  10 +-
 include/linux/dax.h |  58 +++-
 mm/filemap.c        |   5 +-
 9 files changed, 538 insertions(+), 432 deletions(-)

-- 
2.9.0
