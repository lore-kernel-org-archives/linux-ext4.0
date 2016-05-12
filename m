From: Jan Kara <jack@suse.cz>
Subject: [PATCH 1/7] dax: Fix condition for filling of PMD holes
Date: Thu, 12 May 2016 18:29:14 +0200
Message-ID: <1463070560-1979-2-git-send-email-jack@suse.cz>
References: <1463070560-1979-1-git-send-email-jack@suse.cz>
Cc: Ted Tso <tytso@mit.edu>, linux-ext4@vger.kernel.org,
	Vishal Verma <vishal.l.verma@intel.com>,
	Ross Zwisler <ross.zwisler@linux.intel.com>,
	Dan Williams <dan.j.williams@intel.com>,
	linux-fsdevel@vger.kernel.org, Jan Kara <jack@suse.cz>
To: linux-nvdimm@lists.01.org
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <1463070560-1979-1-git-send-email-jack@suse.cz>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Currently dax_pmd_fault() decides to fill a PMD-sized hole only if
returned buffer has BH_Uptodate set. However that doesn't get set for
any mapping buffer so that branch is actually a dead code. The
BH_Uptodate check doesn't make any sense so just remove it.

Signed-off-by: Jan Kara <jack@suse.cz>
---
 fs/dax.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/dax.c b/fs/dax.c
index 9bc6624251b4..d7addfab2094 100644
--- a/fs/dax.c
+++ b/fs/dax.c
@@ -820,7 +820,7 @@ int __dax_pmd_fault(struct vm_area_struct *vma, unsigned long address,
 
 	i_mmap_lock_read(mapping);
 
-	if (!write && !buffer_mapped(&bh) && buffer_uptodate(&bh)) {
+	if (!write && !buffer_mapped(&bh)) {
 		spinlock_t *ptl;
 		pmd_t entry;
 		struct page *zero_page = get_huge_zero_page();
-- 
2.6.6

