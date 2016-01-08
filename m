From: Ross Zwisler <ross.zwisler@linux.intel.com>
Subject: [PATCH v8 0/9] DAX fsync/msync support
Date: Thu,  7 Jan 2016 22:27:50 -0700
Message-ID: <1452230879-18117-1-git-send-email-ross.zwisler@linux.intel.com>
Cc: Ross Zwisler <ross.zwisler@linux.intel.com>,
	"H. Peter Anvin" <hpa@zytor.com>,
	"J. Bruce Fields" <bfields@fieldses.org>,
	"Theodore Ts'o" <tytso@mit.edu>,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	Andreas Dilger <adilger.kernel@dilger.ca>,
	Andrew Morton <akpm@linux-foundation.org>,
	Dan Williams <dan.j.williams@intel.com>,
	Dave Chinner <david@fromorbit.com>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	Ingo Molnar <mingo@redhat.com>, Jan Kara <jack@suse.com>,
	Jeff Layton <jlayton@poochiereds.net>,
	Matthew Wilcox <matthew.r.wilcox@intel.com>,
	Matthew Wilcox <willy@linux.intel.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	linux-ext4@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	linux-mm@kvack.org, linux-nvdimm@lists.01.org, x86@kernel.org,
	xfs@oss.sgi.com
To: linux-kernel@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mga14.intel.com ([192.55.52.115]:53828 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750738AbcAHF2M (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 8 Jan 2016 00:28:12 -0500
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Changes since v7 [1]:

1) Update patch 1 so that we initialize bh->b_bdev before passing it to
get_block() instead of working around the fact that it could still be NULL
after get_block() completes. (Dan)

2) Add a check to dax_radix_entry() so that we WARN_ON_ONCE() and exit
gracefully if we find a page cache entry still in the radix tree when
trying to insert a DAX entry.

This series replaces v7 in the MM tree and in the "akpm" branch of the next
tree.  A working tree can be found here:

https://git.kernel.org/cgit/linux/kernel/git/zwisler/linux.git/log/?h=fsync_v8

[1]: https://lists.01.org/pipermail/linux-nvdimm/2016-January/003886.html

Ross Zwisler (9):
  dax: fix NULL pointer dereference in __dax_dbg()
  dax: fix conversion of holes to PMDs
  pmem: add wb_cache_pmem() to the PMEM API
  dax: support dirty DAX entries in radix tree
  mm: add find_get_entries_tag()
  dax: add support for fsync/msync
  ext2: call dax_pfn_mkwrite() for DAX fsync/msync
  ext4: call dax_pfn_mkwrite() for DAX fsync/msync
  xfs: call dax_pfn_mkwrite() for DAX fsync/msync

 arch/x86/include/asm/pmem.h |  11 +--
 fs/block_dev.c              |   2 +-
 fs/dax.c                    | 215 ++++++++++++++++++++++++++++++++++++++++----
 fs/ext2/file.c              |   4 +-
 fs/ext4/file.c              |   4 +-
 fs/inode.c                  |   2 +-
 fs/xfs/xfs_file.c           |   7 +-
 include/linux/dax.h         |   7 ++
 include/linux/fs.h          |   3 +-
 include/linux/pagemap.h     |   3 +
 include/linux/pmem.h        |  22 ++++-
 include/linux/radix-tree.h  |   9 ++
 mm/filemap.c                |  91 +++++++++++++++++--
 mm/truncate.c               |  69 +++++++-------
 mm/vmscan.c                 |   9 +-
 mm/workingset.c             |   4 +-
 16 files changed, 393 insertions(+), 69 deletions(-)

-- 
2.5.0

