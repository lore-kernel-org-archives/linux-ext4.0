From: Toshi Kani <toshi.kani@hpe.com>
Subject: [PATCH v2 0/5] Align mmap address for DAX pmd mappings
Date: Tue, 12 Apr 2016 14:39:14 -0600
Message-ID: <1460493555-31611-1-git-send-email-toshi.kani@hpe.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: tytso@mit.edu, jack@suse.cz, linux-nvdimm@lists.01.org,
	linux-kernel@vger.kernel.org, xfs@oss.sgi.com,
	adilger.kernel@dilger.ca, viro@zeniv.linux.org.uk,
	linux-fsdevel@vger.kernel.org, willy@linux.intel.com,
	ross.zwisler@linux.intel.com, linux-ext4@vger.kernel.org,
	kirill.shutemov@linux.intel.com
To: akpm@linux-foundation.org,
	dan.j.williams@intel.com
Return-path: <xfs-bounces@oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
List-Id: linux-ext4.vger.kernel.org

When CONFIG_FS_DAX_PMD is set, DAX supports mmap() using pmd page
size.  This feature relies on both mmap virtual address and FS
block (i.e. physical address) to be aligned by the pmd page size.
Users can use mkfs options to specify FS to align block allocations.
However, aligning mmap address requires code changes to existing
applications for providing a pmd-aligned address to mmap().

For instance, fio with "ioengine=mmap" performs I/Os with mmap() [1].
It calls mmap() with a NULL address, which needs to be changed to
provide a pmd-aligned address for testing with DAX pmd mappings.
Changing all applications that call mmap() with NULL is undesirable.

This patch-set extends filesystems to align an mmap address for
a DAX file so that unmodified applications can use DAX pmd mappings.

[1]: https://github.com/axboe/fio/blob/master/engines/mmap.c

v2:
 - Change filesystems to provide their get_unmapped_area().
   (Matthew Wilcox)
 - Add more description about the benefit. (Matthew Wilcox)

---
Toshi Kani (5):
 1/5 dax: add dax_get_unmapped_area for pmd mappings
 2/5 ext4: call dax_get_unmapped_area() for DAX pmd mappings
 3/5 xfs: call dax_get_unmapped_area() for DAX pmd mappings
 4/5 ext2: call dax_get_unmapped_area() for DAX pmd mappings
 5/5 block: call dax_get_unmapped_area() for DAX pmd mappings

---
 fs/block_dev.c      |  3 +++
 fs/dax.c            | 45 +++++++++++++++++++++++++++++++++++++++++++++
 fs/ext2/file.c      |  3 +++
 fs/ext4/file.c      |  3 +++
 fs/xfs/xfs_file.c   |  3 +++
 include/linux/dax.h |  2 ++
 6 files changed, 59 insertions(+)

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
