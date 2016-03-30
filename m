From: Vishal Verma <vishal.l.verma@intel.com>
Subject: [PATCH v2 2/5] dax: fallback from pmd to pte on error
Date: Tue, 29 Mar 2016 19:59:47 -0600
Message-ID: <1459303190-20072-3-git-send-email-vishal.l.verma@intel.com>
References: <1459303190-20072-1-git-send-email-vishal.l.verma@intel.com>
Cc: Dan Williams <dan.j.williams@intel.com>,
	linux-fsdevel@vger.kernel.org, linux-block@vger.kernel.org,
	xfs@oss.sgi.com, linux-ext4@vger.kernel.org, linux-mm@kvack.org,
	Matthew Wilcox <matthew.r.wilcox@intel.com>,
	Ross Zwisler <ross.zwisler@linux.intel.com>,
	Dave Chinner <david@fromorbit.com>, Jan Kara <jack@suse.cz>,
	Jens Axboe <axboe@fb.com>, Al Viro <viro@zeniv.linux.org.uk>,
	Andrew Morton <akpm@linux-foundation.org>,
	linux-kernel@vger.kernel.org, Christoph Hellwig <hch@infradead.org>
To: linux-nvdimm@lists.01.org
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <1459303190-20072-1-git-send-email-vishal.l.verma@intel.com>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

From: Dan Williams <dan.j.williams@intel.com>

In preparation for consulting a badblocks list in pmem_direct_access(),
teach dax_pmd_fault() to fallback rather than fail immediately upon
encountering an error.  The thought being that reducing the span of the
dax request may avoid the error region.

Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 fs/dax.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/dax.c b/fs/dax.c
index 90322eb..ec6417b 100644
--- a/fs/dax.c
+++ b/fs/dax.c
@@ -945,8 +945,8 @@ int __dax_pmd_fault(struct vm_area_struct *vma, unsigned long address,
 		long length = dax_map_atomic(bdev, &dax);
 
 		if (length < 0) {
-			result = VM_FAULT_SIGBUS;
-			goto out;
+			dax_pmd_dbg(&bh, address, "dax-error fallback");
+			goto fallback;
 		}
 		if (length < PMD_SIZE) {
 			dax_pmd_dbg(&bh, address, "dax-length too small");
-- 
2.5.5

