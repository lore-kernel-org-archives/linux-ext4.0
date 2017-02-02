From: Arnd Bergmann <arnd@arndb.de>
Subject: [PATCH] ext4: fix up huge_fault rename
Date: Thu,  2 Feb 2017 12:36:12 +0100
Message-ID: <20170202113625.702169-1-arnd@arndb.de>
Cc: Matthew Wilcox <mawilcox@microsoft.com>,
        Arnd Bergmann <arnd@arndb.de>, "Theodore Ts'o" <tytso@mit.edu>,
        Andreas Dilger <adilger.kernel@dilger.ca>,
        Jan Kara <jack@suse.cz>,
        Ross Zwisler <ross.zwisler@linux.intel.com>,
        Dave Jiang <dave.jiang@intel.com>,
        Miklos Szeredi <mszeredi@redhat.com>,
        linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org
To: Andrew Morton <akpm@linux-foundation.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

It looks like a search+replace accidentally change one function pointer that
should have remained as before, as shown by this new warning:

fs/ext4/file.c:279:1: error: 'ext4_dax_huge_fault' defined but not used [-Werror=unused-function]

This reverts the one line of the changeset.

Fixes: 80a841811260 ("mm,fs,dax: change ->pmd_fault to ->huge_fault")
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 fs/ext4/file.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/ext4/file.c b/fs/ext4/file.c
index ed22d20e843c..e1a581133aa1 100644
--- a/fs/ext4/file.c
+++ b/fs/ext4/file.c
@@ -329,7 +329,7 @@ static int ext4_dax_pfn_mkwrite(struct vm_fault *vmf)
 static const struct vm_operations_struct ext4_dax_vm_ops = {
 	.fault		= ext4_dax_fault,
 	.huge_fault	= ext4_dax_fault,
-	.page_mkwrite	= ext4_dax_fault,
+	.page_mkwrite	= ext4_dax_huge_fault,
 	.pfn_mkwrite	= ext4_dax_pfn_mkwrite,
 };
 #else
-- 
2.9.0
