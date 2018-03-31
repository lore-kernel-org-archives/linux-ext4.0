From: Dan Williams <dan.j.williams-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH v8 00/18] dax: fix dma vs truncate/hole-punch
Date: Fri, 30 Mar 2018 21:02:09 -0700
Message-ID: <152246892890.36038.18436540150980653229.stgit@dwillia2-desk3.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org>, jack-AlSwsSmVLrQ@public.gmane.org, snitzer-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org,
 Dave Hansen <dave.hansen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>,
 Heiko Carstens <heiko.carstens-tA70FqPdS9bQT0dZR+AlfA@public.gmane.org>,
 Andreas Dilger <adilger.kernel-m1MBpc4rdrD3fQ9qLvQP4Q@public.gmane.org>, Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>,
 Alasdair Kergon <agk-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, kbuild test robot <lkp-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>,
 "Darrick J. Wong" <darrick.wong-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, Thomas Meyer <thomas-VsYtu1Qij5c@public.gmane.org>,
 Bart Van Assche <Bart.VanAssche-Sjgp3cTcYWE@public.gmane.org>, linux-ext4-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
 Dave Chinner <david-FqsqvQoI3Ljby3iVrkZq2A@public.gmane.org>, linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
 =?utf-8?b?SsOpcsO0bWU=?= Glisse <jglisse-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>,
 Alexander Viro <viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org>, Theodore Ts'o <tytso-3s7WtUTddSA@public.gmane.org>,
 Matthew Wilcox <mawilcox-0li6OtcxBFHby3iVrkZq2A@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
 linux-xfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Jan Kara <jack-IBi9RG/b67k@public.gmane.org>,
 Martin Schwidefsky <schwidefsky-tA70FqPdS9bQT0dZR+AlfA@public.gmane.org>,
 Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
To: linux-nvdimm-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org
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

Changes since v7 [1]:

* Introduce noop_direct_IO() and use it to clean up xfs_dax_aops,
  ext4_dax_aops, and ext2_dax_aops (Jan, Christoph)

* Clarify dax_associcate_entry() vs zero-page and empty entries with
  for_each_mapped_pfn() and a comment (Jan)

* Collect reviewed-by's from Jan and Darrick

* Fix an ARCH=UML build failure that made me realize that the patch to
  enable filesystems to trigger ->page_free() callbacks was incomplete
  with respect to the device-mapper dax enabling.

  The investigation of adding support for device-mapper and
  DEV_PAGEMAP_OPS resulted in a wider rework that includes 1) picking up
  the CONFIG_DAX_DRIVER patches that missed the 4.16 merge window. 2)
  Refactoring the build implementation to allow FS_DAX_LIMITED in the s390
  case with the dcssblk driver, and full blown FS_DAX + DEV_PAGEMAP_OPS
  for everyone else with the pmem driver.

[1]: https://lists.01.org/pipermail/linux-nvdimm/2018-March/014913.html
[2]: https://lists.01.org/pipermail/linux-nvdimm/2018-March/014921.html 

---

Background:

get_user_pages() in the filesystem pins file backed memory pages for
access by devices performing dma. However, it only pins the memory pages
not the page-to-file offset association. If a file is truncated the
pages are mapped out of the file and dma may continue indefinitely into
a page that is owned by a device driver. This breaks coherency of the
file vs dma, but the assumption is that if userspace wants the
file-space truncated it does not matter what data is inbound from the
device, it is not relevant anymore. The only expectation is that dma can
safely continue while the filesystem reallocates the block(s).

Problem:

This expectation that dma can safely continue while the filesystem
changes the block map is broken by dax. With dax the target dma page
*is* the filesystem block. The model of leaving the page pinned for dma,
but truncating the file block out of the file, means that the filesytem
is free to reallocate a block under active dma to another file and now
the expected data-incoherency situation has turned into active
data-corruption.

Solution:

Defer all filesystem operations (fallocate(), truncate()) on a dax mode
file while any page/block in the file is under active dma. This solution
assumes that dma is transient. Cases where dma operations are known to
not be transient, like RDMA, have been explicitly disabled via
commits like 5f1d43de5416 "IB/core: disable memory registration of
filesystem-dax vmas".

The dax_layout_busy_page() routine is called by filesystems with a lock
held against mm faults (i_mmap_lock) to find pinned / busy dax pages.
The process of looking up a busy page invalidates all mappings
to trigger any subsequent get_user_pages() to block on i_mmap_lock.
The filesystem continues to call dax_layout_busy_page() until it finally
returns no more active pages. This approach assumes that the page
pinning is transient, if that assumption is violated the system would
have likely hung from the uncompleted I/O.

---

Dan Williams (18):
      dax: store pfns in the radix
      fs, dax: prepare for dax-specific address_space_operations
      block, dax: remove dead code in blkdev_writepages()
      xfs, dax: introduce xfs_dax_aops
      ext4, dax: introduce ext4_dax_aops
      ext2, dax: introduce ext2_dax_aops
      fs, dax: use page->mapping to warn if truncate collides with a busy page
      dax: introduce CONFIG_DAX_DRIVER
      dax, dm: allow device-mapper to operate without dax support
      dax, dm: introduce ->fs_{claim,release}() dax_device infrastructure
      mm, dax: enable filesystems to trigger dev_pagemap ->page_free callbacks
      memremap: split devm_memremap_pages() and memremap() infrastructure
      mm, dev_pagemap: introduce CONFIG_DEV_PAGEMAP_OPS
      memremap: mark devm_memremap_pages() EXPORT_SYMBOL_GPL
      mm, fs, dax: handle layout changes to pinned dax mappings
      xfs: prepare xfs_break_layouts() to be called with XFS_MMAPLOCK_EXCL
      xfs: prepare xfs_break_layouts() for another layout type
      xfs, dax: introduce xfs_break_dax_layouts()


 drivers/dax/Kconfig        |    5 +
 drivers/dax/super.c        |  118 +++++++++++++++++++---
 drivers/md/Kconfig         |    1 
 drivers/md/dm-linear.c     |    6 +
 drivers/md/dm-log-writes.c |   95 +++++++++---------
 drivers/md/dm-stripe.c     |    6 +
 drivers/md/dm.c            |   66 +++++++++++-
 drivers/nvdimm/Kconfig     |    2 
 drivers/nvdimm/pmem.c      |    3 -
 drivers/s390/block/Kconfig |    2 
 fs/Kconfig                 |    1 
 fs/block_dev.c             |    5 -
 fs/dax.c                   |  238 ++++++++++++++++++++++++++++++++++----------
 fs/ext2/ext2.h             |    1 
 fs/ext2/inode.c            |   46 +++++----
 fs/ext2/namei.c            |   18 ---
 fs/ext2/super.c            |    6 +
 fs/ext4/inode.c            |   42 ++++++--
 fs/ext4/super.c            |    6 +
 fs/libfs.c                 |   39 +++++++
 fs/xfs/xfs_aops.c          |   34 +++---
 fs/xfs/xfs_aops.h          |    1 
 fs/xfs/xfs_file.c          |   73 ++++++++++++-
 fs/xfs/xfs_inode.h         |   16 +++
 fs/xfs/xfs_ioctl.c         |    8 -
 fs/xfs/xfs_iops.c          |   21 +++-
 fs/xfs/xfs_pnfs.c          |   16 ++-
 fs/xfs/xfs_pnfs.h          |    6 +
 fs/xfs/xfs_super.c         |   20 ++--
 include/linux/dax.h        |  115 ++++++++++++++++++---
 include/linux/fs.h         |    4 +
 include/linux/memremap.h   |   25 +----
 include/linux/mm.h         |   71 ++++++++++---
 kernel/Makefile            |    3 -
 kernel/iomem.c             |  167 +++++++++++++++++++++++++++++++
 kernel/memremap.c          |  210 +++++----------------------------------
 mm/Kconfig                 |    5 +
 mm/gup.c                   |    5 +
 mm/hmm.c                   |   13 --
 mm/swap.c                  |    3 -
 40 files changed, 1047 insertions(+), 475 deletions(-)
 create mode 100644 kernel/iomem.c
