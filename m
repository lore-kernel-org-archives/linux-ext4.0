From: Ross Zwisler <ross.zwisler@linux.intel.com>
Subject: [PATCH v6 06/17] dax: remove the last BUG_ON() from fs/dax.c
Date: Wed, 12 Oct 2016 16:50:11 -0600
Message-ID: <20161012225022.15507-7-ross.zwisler@linux.intel.com>
References: <20161012225022.15507-1-ross.zwisler@linux.intel.com>
Cc: Ross Zwisler <ross.zwisler@linux.intel.com>,
	"Theodore Ts'o" <tytso@mit.edu>,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	Andreas Dilger <adilger.kernel@dilger.ca>,
	Andrew Morton <akpm@linux-foundation.org>,
	Christoph Hellwig <hch@lst.de>,
	Dan Williams <dan.j.williams@intel.com>,
	Dave Chinner <david@fromorbit.com>,
	Jan Kara <jack@suse.cz>,
	Matthew Wilcox <mawilcox@microsoft.com>,
	linux-ext4@vger.kernel.org,
	linux-fsdevel@vger.kernel.org,
	linux-mm@kvack.org,
	linux-nvdimm@lists.01.org,
	linux-xfs@vger.kernel.org
To: linux-kernel@vger.kernel.org
Return-path: <owner-linux-mm@kvack.org>
In-Reply-To: <20161012225022.15507-1-ross.zwisler@linux.intel.com>
Sender: owner-linux-mm@kvack.org
List-Id: linux-ext4.vger.kernel.org

Don't take down the kernel if we get an invalid 'from' and 'length'
argument pair.  Just warn once and return an error.

Signed-off-by: Ross Zwisler <ross.zwisler@linux.intel.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Jan Kara <jack@suse.cz>
---
 fs/dax.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/fs/dax.c b/fs/dax.c
index ac28cdf..98189ac 100644
--- a/fs/dax.c
+++ b/fs/dax.c
@@ -1194,7 +1194,8 @@ int dax_zero_page_range(struct inode *inode, loff_t from, unsigned length,
 	/* Block boundary? Nothing to do */
 	if (!length)
 		return 0;
-	BUG_ON((offset + length) > PAGE_SIZE);
+	if (WARN_ON_ONCE((offset + length) > PAGE_SIZE))
+		return -EINVAL;
 
 	memset(&bh, 0, sizeof(bh));
 	bh.b_bdev = inode->i_sb->s_bdev;
-- 
2.9.0

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
