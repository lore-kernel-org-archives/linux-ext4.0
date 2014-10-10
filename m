From: Jan Kara <jack@suse.cz>
Subject: [PATCH] mm: Fixup pagecache_isize_extended() definitions for !CONFIG_MMU
Date: Fri, 10 Oct 2014 16:23:26 +0200
Message-ID: <1412951028-4085-22-git-send-email-jack@suse.cz>
References: <1412951028-4085-1-git-send-email-jack@suse.cz>
Cc: linux-ext4@vger.kernel.org, Dave Chinner <david@fromorbit.com>,
	xfs@oss.sgi.com, cluster-devel@redhat.com,
	Steven Whitehouse <swhiteho@redhat.com>,
	Mark Fasheh <mfasheh@suse.com>,
	Joel Becker <jlbec@evilplan.org>, ocfs2-devel@oss.oracle.com,
	reiserfs-devel@vger.kernel.org, Jeff Mahoney <jeffm@suse.de>,
	Dave Kleikamp <shaggy@kernel.org>,
	jfs-discussion@lists.sourceforge.net, tytso@mit.edu,
	viro@zeniv.linux.org.uk, Jan Kara <jack@suse.cz>
To: linux-fsdevel@vger.kernel.org
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <1412951028-4085-1-git-send-email-jack@suse.cz>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

For !CONFIG_MMU systems we defined pagecache_isize_extended() in both
include/linux/mm.h and mm/truncate.c which causes compilation error.
Although pagecache_isize_extended() doesn't do anything useful for
!CONFIG_MMU systems, it could do something in future and it's overhead
isn't huge. So don't try to be too smart and remove !CONFIG_MMU
definition of pagecache_isize_extended().

Signed-off-by: Jan Kara <jack@suse.cz>
---
 include/linux/mm.h | 7 -------
 1 file changed, 7 deletions(-)

diff --git a/include/linux/mm.h b/include/linux/mm.h
index f0e53e5a3b17..5005464fe012 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -1155,14 +1155,7 @@ static inline void unmap_shared_mapping_range(struct address_space *mapping,
 
 extern void truncate_pagecache(struct inode *inode, loff_t new);
 extern void truncate_setsize(struct inode *inode, loff_t newsize);
-#ifdef CONFIG_MMU
 void pagecache_isize_extended(struct inode *inode, loff_t from, loff_t to);
-#else
-static inline void pagecache_isize_extended(struct inode *inode, loff_t from,
-					    loff_t to)
-{
-}
-#endif
 void truncate_pagecache_range(struct inode *inode, loff_t offset, loff_t end);
 int truncate_inode_page(struct address_space *mapping, struct page *page);
 int generic_error_remove_page(struct address_space *mapping, struct page *page);
-- 
1.8.1.4

