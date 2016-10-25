From: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Subject: [PATCHv4 00/43] ext4: support of huge pages
Date: Tue, 25 Oct 2016 03:12:59 +0300
Message-ID: <20161025001342.76126-1-kirill.shutemov@linux.intel.com>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>,
        Hugh Dickins <hughd@google.com>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Dave Hansen <dave.hansen@intel.com>,
        Vlastimil Babka <vbabka@suse.cz>,
        Matthew Wilcox <willy@infradead.org>,
        Ross Zwisler <ross.zwisler@linux.intel.com>,
        linux-ext4@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        linux-block@vger.kernel.org,
        "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
To: "Theodore Ts'o" <tytso@mit.edu>,
        Andreas Dilger <adilger.kernel@dilger.ca>,
        Jan Kara <jack@suse.com>,
        Andrew Morton <akpm@linux-foundation.org>
Return-path: <linux-block-owner@vger.kernel.org>
Sender: linux-block-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Here's respin of my huge ext4 patchset on top of v4.9-rc2 with couple of
fixes (see below).

Please review and consider applying.

I don't see any xfstests regressions with huge pages enabled. Patch with
new configurations for xfstests-bld is below.

The basics are the same as with tmpfs[1] which is in Linus' tree now and
ext4 built on top of it. The main difference is that we need to handle
read out from and write-back to backing storage.

As with other THPs, the implementation is build around compound pages:
a naturally aligned collection of pages that memory management subsystem
[in most cases] treat as a single entity:

  - head page (the first subpage) on LRU represents whole huge page;
  - head page's flags represent state of whole huge page (with few
    exceptions);
  - mm can't migrate subpages of the compound page individually;

For THP, we use PMD-sized huge pages.

Head page links buffer heads for whole huge page. Dirty/writeback/etc.
tracking happens on per-hugepage level as all subpages share the same page
flags.

lock_page() on any subpage would lock whole hugepage for the same reason.

On radix-tree, a huge page represented as a multi-order entry of the same
order (HPAGE_PMD_ORDER). This allows us to track dirty/writeback on
radix-tree tags with the same granularity as on struct page.

We read out whole huge page at once. It required bumping BIO_MAX_PAGES to
not less than HPAGE_PMD_NR. I defined BIO_MAX_PAGES to HPAGE_PMD_NR if
huge pagecache enabled.

On IO via syscalls, we are still limited by copying upto PAGE_SIZE per
iteration. The limitation here comes from how copy_page_to_iter() and
copy_page_from_iter() work wrt. highmem: it can only handle one small
page a time.

On write side, we also have problem with assuming small pages: write
length and offset within page calculated before we know if small or huge
page is allocated. It's not easy to fix. Looks like it would require
change in ->write_begin() interface to accept len > PAGE_SIZE.

On split_huge_page() we need to free buffers before splitting the page.
Page buffers takes additional pin on the page and can be a vector to mess
with the page during split. We want to avoid this.
If try_to_free_buffers() fails, split_huge_page() would return -EBUSY.

Readahead doesn't play with huge pages well: 128k max readahead window,
assumption on page size, PageReadahead() to track hit/miss.  I've got it
to allocate huge pages, but it doesn't provide any readahead as such.
I don't know how to do this right. It's not clear at this point if we
really need readahead with huge pages. I guess it's good enough for now.

Shadow entries ignored on allocation -- recently evicted page is not
promoted to active list. Not sure if current workingset logic is adequate
for huge pages. On eviction, we split the huge page and setup 4k shadow
entries as usual.

Unlike tmpfs, ext4 makes use of tags in radix-tree. The approach I used
for tmpfs -- 512 entries in radix-tree per-hugepages -- doesn't work well
if we want to have coherent view on tags. So the first 8 patches of the
patchset converts tmpfs to use multi-order entries in radix-tree.
The same infrastructure used for ext4.

Encryption doesn't handle huge pages yet. To avoid regressions we just
disable huge pages for the inode if it has EXT4_INODE_ENCRYPT.

Tested with 4k, 1k, encryption and bigalloc. All with and without
huge=always. I think it's reasonable coverage.

The patchset is also in git:

git://git.kernel.org/pub/scm/linux/kernel/git/kas/linux.git hugeext4/v4

[1] http://lkml.kernel.org/r/1465222029-45942-1-git-send-email-kirill.shutemov@linux.intel.com

Changes since v3:
  - account huge page to dirty/writeback/reclaimable/etc. according to its
    size. It fixes background writback.
  - move code that adds huge page to radix-tree to
    page_cache_tree_insert() (Jan);
  - make ramdisk work with huge pages;
  - fix unaccont of shadow entries (Jan);
  - use try_to_release_page() instead of try_to_free_buffers() in
    split_huge_page() (Jan);
  -  make thp_get_unmapped_area() respect S_HUGE_MODE;
  - use huge-page aligned address to zap page range in wp_huge_pmd();
  - use ext4_kvmalloc in ext4_mpage_readpages() instead of
    kmalloc() (Andreas);

Changes since v2:
  - fix intermittent crash in generic/299;
  - typo (condition inversion) in do_generic_file_read(),
    reported by Jitendra;

TODO:
  - on IO via syscalls, copy more than PAGE_SIZE per iteration to/from
    userspace;
  - readahead ?;
  - wire up madvise()/fadvise();
  - encryption with huge pages;
  - reclaim of file huge pages can be optimized -- split_huge_page() is not
    required for pages with backing storage;

>From f523dd3aad026f5a3f8cbabc0ec69958a0618f6b Mon Sep 17 00:00:00 2001
From: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Date: Fri, 12 Aug 2016 19:44:30 +0300
Subject: [PATCH] Add few more configurations to test ext4 with huge pages

Four new configurations: huge_4k, huge_1k, huge_bigalloc, huge_encrypt.

Signed-off-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
---
 .../test-appliance/files/root/fs/ext4/cfg/all.list       |  4 ++++
 .../test-appliance/files/root/fs/ext4/cfg/huge_1k        |  6 ++++++
 .../test-appliance/files/root/fs/ext4/cfg/huge_4k        |  6 ++++++
 .../test-appliance/files/root/fs/ext4/cfg/huge_bigalloc  | 14 ++++++++++++++
 .../files/root/fs/ext4/cfg/huge_bigalloc.exclude         |  7 +++++++
 .../test-appliance/files/root/fs/ext4/cfg/huge_encrypt   |  5 +++++
 .../files/root/fs/ext4/cfg/huge_encrypt.exclude          | 16 ++++++++++++++++
 kvm-xfstests/util/parse_cli                              |  1 +
 8 files changed, 59 insertions(+)
 create mode 100644 kvm-xfstests/test-appliance/files/root/fs/ext4/cfg/huge_1k
 create mode 100644 kvm-xfstests/test-appliance/files/root/fs/ext4/cfg/huge_4k
 create mode 100644 kvm-xfstests/test-appliance/files/root/fs/ext4/cfg/huge_bigalloc
 create mode 100644 kvm-xfstests/test-appliance/files/root/fs/ext4/cfg/huge_bigalloc.exclude
 create mode 100644 kvm-xfstests/test-appliance/files/root/fs/ext4/cfg/huge_encrypt
 create mode 100644 kvm-xfstests/test-appliance/files/root/fs/ext4/cfg/huge_encrypt.exclude

diff --git a/kvm-xfstests/test-appliance/files/root/fs/ext4/cfg/all.list b/kvm-xfstests/test-appliance/files/root/fs/ext4/cfg/all.list
index 7ec37f4bafaa..14a8e72d2e6e 100644
--- a/kvm-xfstests/test-appliance/files/root/fs/ext4/cfg/all.list
+++ b/kvm-xfstests/test-appliance/files/root/fs/ext4/cfg/all.list
@@ -9,3 +9,7 @@ dioread_nolock
 data_journal
 bigalloc
 bigalloc_1k
+huge_4k
+huge_1k
+huge_bigalloc
+huge_encrypt
diff --git a/kvm-xfstests/test-appliance/files/root/fs/ext4/cfg/huge_1k b/kvm-xfstests/test-appliance/files/root/fs/ext4/cfg/huge_1k
new file mode 100644
index 000000000000..209c76a8a6c1
--- /dev/null
+++ b/kvm-xfstests/test-appliance/files/root/fs/ext4/cfg/huge_1k
@@ -0,0 +1,6 @@
+export FS=ext4
+export TEST_DEV=$SM_TST_DEV
+export TEST_DIR=$SM_TST_MNT
+export MKFS_OPTIONS="-q -b 1024"
+export EXT_MOUNT_OPTIONS="huge=always"
+TESTNAME="Ext4 1k block with huge pages"
diff --git a/kvm-xfstests/test-appliance/files/root/fs/ext4/cfg/huge_4k b/kvm-xfstests/test-appliance/files/root/fs/ext4/cfg/huge_4k
new file mode 100644
index 000000000000..bae901cb2bab
--- /dev/null
+++ b/kvm-xfstests/test-appliance/files/root/fs/ext4/cfg/huge_4k
@@ -0,0 +1,6 @@
+export FS=ext4
+export TEST_DEV=$PRI_TST_DEV
+export TEST_DIR=$PRI_TST_MNT
+export MKFS_OPTIONS="-q"
+export EXT_MOUNT_OPTIONS="huge=always"
+TESTNAME="Ext4 4k block with huge pages"
diff --git a/kvm-xfstests/test-appliance/files/root/fs/ext4/cfg/huge_bigalloc b/kvm-xfstests/test-appliance/files/root/fs/ext4/cfg/huge_bigalloc
new file mode 100644
index 000000000000..b3d87562bce6
--- /dev/null
+++ b/kvm-xfstests/test-appliance/files/root/fs/ext4/cfg/huge_bigalloc
@@ -0,0 +1,14 @@
+SIZE=large
+export MKFS_OPTIONS="-O bigalloc"
+export EXT_MOUNT_OPTIONS="huge=always"
+
+# Until we can teach xfstests the difference between cluster size and
+# block size, avoid collapse_range, insert_range, and zero_range since
+# these will fail due the fact that these operations require
+# cluster-aligned ranges.
+export FSX_AVOID="-C -I -z"
+export FSSTRESS_AVOID="-f collapse=0 -f insert=0 -f zero=0"
+export XFS_IO_AVOID="fcollapse finsert zero"
+
+TESTNAME="Ext4 4k block w/bigalloc"
+
diff --git a/kvm-xfstests/test-appliance/files/root/fs/ext4/cfg/huge_bigalloc.exclude b/kvm-xfstests/test-appliance/files/root/fs/ext4/cfg/huge_bigalloc.exclude
new file mode 100644
index 000000000000..bd779be99518
--- /dev/null
+++ b/kvm-xfstests/test-appliance/files/root/fs/ext4/cfg/huge_bigalloc.exclude
@@ -0,0 +1,7 @@
+# bigalloc does not support on-line defrag
+ext4/301
+ext4/302
+ext4/303
+ext4/304
+ext4/307
+ext4/308
diff --git a/kvm-xfstests/test-appliance/files/root/fs/ext4/cfg/huge_encrypt b/kvm-xfstests/test-appliance/files/root/fs/ext4/cfg/huge_encrypt
new file mode 100644
index 000000000000..29f058ba937d
--- /dev/null
+++ b/kvm-xfstests/test-appliance/files/root/fs/ext4/cfg/huge_encrypt
@@ -0,0 +1,5 @@
+SIZE=small
+export MKFS_OPTIONS=""
+export EXT_MOUNT_OPTIONS="test_dummy_encryption,huge=always"
+REQUIRE_FEATURE=encryption
+TESTNAME="Ext4 encryption"
diff --git a/kvm-xfstests/test-appliance/files/root/fs/ext4/cfg/huge_encrypt.exclude b/kvm-xfstests/test-appliance/files/root/fs/ext4/cfg/huge_encrypt.exclude
new file mode 100644
index 000000000000..b91cc58b5aa3
--- /dev/null
+++ b/kvm-xfstests/test-appliance/files/root/fs/ext4/cfg/huge_encrypt.exclude
@@ -0,0 +1,16 @@
+ext4/004	# dump/restore doesn't handle quotas
+
+# encryption doesn't play well with quota
+generic/082
+generic/219
+generic/230
+generic/231
+generic/232
+generic/233
+generic/235
+generic/270
+
+# generic/204 tests ENOSPC handling; it doesn't correctly
+# anticipate the external extended attribute required when
+# using a 1k block size
+generic/204
diff --git a/kvm-xfstests/util/parse_cli b/kvm-xfstests/util/parse_cli
index 83400ea71985..ba64ce5df016 100644
--- a/kvm-xfstests/util/parse_cli
+++ b/kvm-xfstests/util/parse_cli
@@ -36,6 +36,7 @@ print_help ()
     echo "Common file system configurations are:"
     echo "	4k 1k ext3 nojournal ext3conv metacsum dioread_nolock "
     echo "	data_journal bigalloc bigalloc_1k inline"
+    echo "	huge_4k huge_1k huge_bigalloc huge_encrypt"
     echo ""
     echo "xfstest names have the form: ext4/NNN generic/NNN shared/NNN"
     echo ""
-- 
2.9.3

Kirill A. Shutemov (37):
  mm, shmem: swich huge tmpfs to multi-order radix-tree entries
  Revert "radix-tree: implement radix_tree_maybe_preload_order()"
  page-flags: relax page flag policy for few flags
  mm, rmap: account file thp pages
  thp: try to free page's buffers before attempt split
  thp: handle write-protection faults for file THP
  truncate: make sure invalidate_mapping_pages() can discard huge pages
  filemap: allocate huge page in page_cache_read(), if allowed
  filemap: handle huge pages in do_generic_file_read()
  filemap: allocate huge page in pagecache_get_page(), if allowed
  filemap: handle huge pages in filemap_fdatawait_range()
  HACK: readahead: alloc huge pages, if allowed
  block: define BIO_MAX_PAGES to HPAGE_PMD_NR if huge page cache enabled
  brd: make it handle huge pages
  mm: make write_cache_pages() work on huge pages
  thp: introduce hpage_size() and hpage_mask()
  thp: do not threat slab pages as huge in hpage_{nr_pages,size,mask}
  thp: make thp_get_unmapped_area() respect S_HUGE_MODE
  fs: make block_read_full_page() be able to read huge page
  fs: make block_write_{begin,end}() be able to handle huge pages
  fs: make block_page_mkwrite() aware about huge pages
  truncate: make truncate_inode_pages_range() aware about huge pages
  truncate: make invalidate_inode_pages2_range() aware about huge pages
  mm: account huge pages to dirty, writaback, reclaimable, etc.
  ext4: make ext4_mpage_readpages() hugepage-aware
  ext4: make ext4_writepage() work on huge pages
  ext4: handle huge pages in ext4_page_mkwrite()
  ext4: handle huge pages in __ext4_block_zero_page_range()
  ext4: make ext4_block_write_begin() aware about huge pages
  ext4: handle huge pages in ext4_da_write_end()
  ext4: make ext4_da_page_release_reservation() aware about huge pages
  ext4: handle writeback with huge pages
  ext4: make EXT4_IOC_MOVE_EXT work with huge pages
  ext4: fix SEEK_DATA/SEEK_HOLE for huge pages
  ext4: make fallocate() operations work with huge pages
  mm, fs, ext4: expand use of page_mapping() and page_to_pgoff()
  ext4, vfs: add huge= mount option

Matthew Wilcox (5):
  tools: Add WARN_ON_ONCE
  radix tree test suite: Allow GFP_ATOMIC allocations to fail
  radix-tree: Add radix_tree_join
  radix-tree: Add radix_tree_split
  radix-tree: Add radix_tree_split_preload()

Naoya Horiguchi (1):
  mm, hugetlb: switch hugetlbfs to multi-order radix-tree entries

 block/bio.c                           |   3 +-
 drivers/base/node.c                   |   6 +
 drivers/block/brd.c                   |  17 +-
 fs/buffer.c                           | 106 +++---
 fs/ext4/ext4.h                        |   5 +
 fs/ext4/extents.c                     |  10 +-
 fs/ext4/file.c                        |  18 +-
 fs/ext4/inode.c                       | 171 ++++++----
 fs/ext4/move_extent.c                 |  12 +-
 fs/ext4/page-io.c                     |  11 +-
 fs/ext4/readpage.c                    |  39 ++-
 fs/ext4/super.c                       |  26 ++
 fs/fs-writeback.c                     |  10 +-
 fs/hugetlbfs/inode.c                  |  22 +-
 fs/proc/meminfo.c                     |   4 +
 fs/proc/task_mmu.c                    |   5 +-
 include/linux/backing-dev.h           |  10 +
 include/linux/bio.h                   |   4 +
 include/linux/buffer_head.h           |  10 +-
 include/linux/fs.h                    |   5 +
 include/linux/huge_mm.h               |  18 +-
 include/linux/memcontrol.h            |   5 +-
 include/linux/mm.h                    |   1 +
 include/linux/mmzone.h                |   2 +
 include/linux/page-flags.h            |  12 +-
 include/linux/pagemap.h               |  32 +-
 include/linux/radix-tree.h            |  18 +-
 include/linux/swap.h                  |   2 +
 lib/radix-tree.c                      | 352 ++++++++++++++------
 mm/filemap.c                          | 585 ++++++++++++++++++++++++----------
 mm/huge_memory.c                      |  73 ++++-
 mm/hugetlb.c                          |  19 +-
 mm/khugepaged.c                       |  26 +-
 mm/memory.c                           |  15 +-
 mm/migrate.c                          |   1 +
 mm/page-writeback.c                   |  86 +++--
 mm/page_alloc.c                       |   5 +
 mm/readahead.c                        |  17 +-
 mm/rmap.c                             |  12 +-
 mm/shmem.c                            |  36 +--
 mm/truncate.c                         | 157 +++++++--
 mm/vmstat.c                           |   2 +
 mm/workingset.c                       |  23 ++
 tools/include/asm/bug.h               |  11 +
 tools/testing/radix-tree/Makefile     |   2 +-
 tools/testing/radix-tree/linux.c      |   7 +-
 tools/testing/radix-tree/linux/bug.h  |   2 +-
 tools/testing/radix-tree/linux/gfp.h  |  22 +-
 tools/testing/radix-tree/linux/slab.h |   5 -
 tools/testing/radix-tree/multiorder.c |  82 +++++
 tools/testing/radix-tree/test.h       |   9 +
 51 files changed, 1542 insertions(+), 591 deletions(-)

-- 
2.9.3

