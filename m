From: Ross Zwisler <ross.zwisler-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Subject: [PATCH v3 0/5] DAX common 4k zero page
Date: Wed, 28 Jun 2017 16:01:47 -0600
Message-ID: <20170628220152.28161-1-ross.zwisler@linux.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: linux-xfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Theodore Ts'o <tytso-3s7WtUTddSA@public.gmane.org>,
 Matthew Wilcox <mawilcox-0li6OtcxBFHby3iVrkZq2A@public.gmane.org>,
 "Darrick J. Wong" <darrick.wong-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, Jonathan Corbet <corbet-T1hC0tSOHrs@public.gmane.org>,
 Steven Rostedt <rostedt-nx8X9YLhiw1AfugRpC6u6w@public.gmane.org>, linux-doc-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
 linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, Dave Hansen <dave.hansen-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>,
 Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Andreas Dilger <adilger.kernel-m1MBpc4rdrD3fQ9qLvQP4Q@public.gmane.org>,
 Alexander Viro <viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org>, linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
 Jan Kara <jack-AlSwsSmVLrQ@public.gmane.org>, linux-ext4-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
 Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>, linux-nvdimm-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org
To: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>,
	linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
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

When servicing mmap() reads from file holes the current DAX code allocates
a page cache page of all zeroes and places the struct page pointer in the
mapping->page_tree radix tree.  This has three major drawbacks:

1) It consumes memory unnecessarily.  For every 4k page that is read via a
DAX mmap() over a hole, we allocate a new page cache page.  This means that
if you read 1GiB worth of pages, you end up using 1GiB of zeroed memory.

2) It is slower than using a common zero page because each page fault has
more work to do.  Instead of just inserting a common zero page we have to
allocate a page cache page, zero it, and then insert it.

3) The fact that we had to check for both DAX exceptional entries and for
page cache pages in the radix tree made the DAX code more complex.

This series solves these issues by following the lead of the DAX PMD code
and using a common 4k zero page instead.  This reduces memory usage and
decreases latencies for some workloads, and it simplifies the DAX code,
removing over 100 lines in total.

Andrew, I'm still hoping to get this merged for v4.13 if possible. I I have
addressed all of Jan's feedback, but he is on vacation for the next few
weeks so he may not be able to give me Reviewed-by tags.  I think this
series is relatively low risk with clear benefits, and I think we should be
able to address any issues that come up during the v4.13 RC series.

This series has passed my targeted testing and a full xfstests run on both
XFS and ext4.

---
Changes since v2:
 - If we call insert_pfn() with 'mkwrite' for an entry that already exists,
   don't overwrite the pte with a brand new one.  Just add the appropriate
   flags. (Jan)

 - Keep put_locked_mapping_entry() as a simple wrapper for
   dax_unlock_mapping_entry() so it has naming parity with
   get_unlocked_mapping_entry(). (Jan)

 - Remove DAX special casing in page_cache_tree_insert(), move
   now-private definitions from dax.h to dax.c. (Jan)

Ross Zwisler (5):
  mm: add vm_insert_mixed_mkwrite()
  dax: relocate some dax functions
  dax: use common 4k zero page for dax mmap reads
  dax: remove DAX code from page_cache_tree_insert()
  dax: move all DAX radix tree defs to fs/dax.c

 Documentation/filesystems/dax.txt |   5 +-
 fs/dax.c                          | 345 ++++++++++++++++----------------------
 fs/ext2/file.c                    |  25 +--
 fs/ext4/file.c                    |  32 +---
 fs/xfs/xfs_file.c                 |   2 +-
 include/linux/dax.h               |  45 -----
 include/linux/mm.h                |   2 +
 include/trace/events/fs_dax.h     |   2 -
 mm/filemap.c                      |  13 +-
 mm/memory.c                       |  57 ++++++-
 10 files changed, 205 insertions(+), 323 deletions(-)

-- 
2.9.4
