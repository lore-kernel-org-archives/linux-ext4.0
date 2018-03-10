From: Dan Williams <dan.j.williams-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH v5 00/11] dax: fix dma vs truncate/hole-punch
Date: Fri, 09 Mar 2018 22:54:49 -0800
Message-ID: <152066488891.40260.14605734226832760468.stgit@dwillia2-desk3.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: Theodore Ts'o <tytso-3s7WtUTddSA@public.gmane.org>, Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org>, jack-AlSwsSmVLrQ@public.gmane.org,
 Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>,
 Matthew Wilcox <mawilcox-0li6OtcxBFHby3iVrkZq2A@public.gmane.org>, Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>,
 Dave Hansen <dave.hansen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, Dave Chinner <david-FqsqvQoI3Ljby3iVrkZq2A@public.gmane.org>,
 =?utf-8?b?SsOpcsO0bWU=?= Glisse <jglisse-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>,
 linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-xfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
 Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Andreas Dilger <adilger.kernel-m1MBpc4rdrD3fQ9qLvQP4Q@public.gmane.org>,
 Alexander Viro <viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org>, Jan Kara <jack-IBi9RG/b67k@public.gmane.org>,
 linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, "Darrick J. Wong" <darrick.wong-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>,
 linux-ext4-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, hch-jcswGhMUV9g@public.gmane.org
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

Changes since v4 [1]:
* Kill the DEFINE_FSDAX_AOPS macro and just open code new
  address_space_operations instances for each fs (Matthew, Jan, Dave,
  Christoph)

* Rename routines that had a 'dma_' prefix with 'dax_layout_' and merge
  the dax-layout-break into xfs_break_layouts() (Dave, Christoph)

* Rework the implementation to have the fsdax core find the pages, but
  leave the responsibility of waiting on those pages to the filesystem
  (Dave).

* Drop the nfit_test infrastructure for testing this mechanism, I plan
  to investigate better mechanisms for injecting arbitrary put_page()
  delays for dax pages relative to an extent unmap operation. The
  dm_delay target does not do what I want since it operates at whole
  device level. A better test interface would be a mechanism to delay
  I/O completion based on whether a bio referenced a given LBA.

Not changed since v4:
* This implementation still relies on RCU for synchronizing
  get_user_pages() and get_user_pages_fast() against
  dax_layout_busy_page(). We could perform the operation with just
  barriers if we knew at get_user_pages() time that the pages were flagged
  for truncation.  However, dax_layout_busy_page() does not have the
  information to flag that a page is actually going to be truncated, only
  that it *might* be truncated.

[1]: https://lists.01.org/pipermail/linux-nvdimm/2017-December/013704.html

----

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

Dan Williams (11):
      dax: store pfns in the radix
      xfs, dax: introduce xfs_dax_aops
      ext4, dax: introduce ext4_dax_aops
      ext2, dax: introduce ext2_dax_aops
      fs, dax: use page->mapping to warn if truncate collides with a busy page
      mm, dax: enable filesystems to trigger dev_pagemap ->page_free callbacks
      mm, dev_pagemap: introduce CONFIG_DEV_PAGEMAP_OPS
      wait_bit: introduce {wait_on,wake_up}_atomic_one
      mm, fs, dax: handle layout changes to pinned dax mappings
      xfs: prepare xfs_break_layouts() for another layout type
      xfs, dax: introduce xfs_break_dax_layouts()


 drivers/dax/super.c      |   96 +++++++++++++++--
 drivers/nvdimm/pmem.c    |    3 -
 fs/Kconfig               |    1 
 fs/dax.c                 |  259 +++++++++++++++++++++++++++++++++++++---------
 fs/ext2/ext2.h           |    1 
 fs/ext2/inode.c          |   28 ++++-
 fs/ext2/namei.c          |   18 ---
 fs/ext2/super.c          |    6 +
 fs/ext4/inode.c          |   11 ++
 fs/ext4/super.c          |    6 +
 fs/xfs/xfs_aops.c        |    7 +
 fs/xfs/xfs_aops.h        |    1 
 fs/xfs/xfs_file.c        |   94 ++++++++++++++++-
 fs/xfs/xfs_inode.h       |    9 ++
 fs/xfs/xfs_ioctl.c       |    9 +-
 fs/xfs/xfs_iops.c        |   17 ++-
 fs/xfs/xfs_pnfs.c        |    8 +
 fs/xfs/xfs_pnfs.h        |    4 -
 fs/xfs/xfs_super.c       |   20 ++--
 include/linux/dax.h      |   45 +++++++-
 include/linux/memremap.h |   28 ++---
 include/linux/mm.h       |   61 ++++++++---
 include/linux/wait_bit.h |   13 ++
 kernel/memremap.c        |   30 +++++
 kernel/sched/wait_bit.c  |   59 +++++++++-
 mm/Kconfig               |    5 +
 mm/gup.c                 |    5 +
 mm/hmm.c                 |   13 --
 mm/swap.c                |    3 -
 29 files changed, 663 insertions(+), 197 deletions(-)
