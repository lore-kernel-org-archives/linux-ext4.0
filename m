From: Jan Kara <jack@suse.cz>
Subject: [PATCH 08/35] fs: Fix performance regression in
	clean_bdev_aliases()
Date: Thu,  1 Jun 2017 11:32:18 +0200
Message-ID: <20170601093245.29238-9-jack@suse.cz>
References: <20170601093245.29238-1-jack@suse.cz>
Cc: cluster-devel@redhat.com, linux-nilfs@vger.kernel.org, tytso@mit.edu,
	linux-xfs@vger.kernel.org, "Yan, Zheng" <zyan@redhat.com>,
	Jan Kara <jack@suse.cz>, "Darrick J . Wong" <darrick.wong@oracle.com>,
	Hugh Dickins <hughd@google.com>, linux-f2fs-devel@lists.sourceforge.net,
	David Howells <dhowells@redhat.com>,
	David Sterba <dsterba@suse.com>, ceph-devel@vger.kernel.org,
	Nadia Yvette Chambers <nyc@holomorphy.com>,
	Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>,
	Jaegeuk Kim <jaegeuk@kernel.org>,
	Ilya Dryomov <idryomov@gmail.com>, linux-ext4@vger.kernel.org,
	linux-afs@lists.infradead.org, linux-btrfs@vger.kernel.org
To: <linux-mm@kvack.org>
Return-path: <cluster-devel-bounces@redhat.com>
In-Reply-To: <20170601093245.29238-1-jack@suse.cz>
List-Unsubscribe: <https://www.redhat.com/mailman/options/cluster-devel>,
	<mailto:cluster-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/cluster-devel>
List-Post: <mailto:cluster-devel@redhat.com>
List-Help: <mailto:cluster-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/cluster-devel>,
	<mailto:cluster-devel-request@redhat.com?subject=subscribe>
Sender: cluster-devel-bounces@redhat.com
Errors-To: cluster-devel-bounces@redhat.com
List-Id: linux-ext4.vger.kernel.org

Commit e64855c6cfaa "fs: Add helper to clean bdev aliases under a bh and
use it" added a wrapper for clean_bdev_aliases() that invalidates bdev
aliases underlying a single buffer head. However this has caused a
performance regression for bonnie++ benchmark on ext4 filesystem when
delayed allocation is turned off (ext3 mode) - average of 3 runs:

Hmean SeqOut Char  164787.55 (  0.00%) 107189.06 (-34.95%)
Hmean SeqOut Block 219883.89 (  0.00%) 168870.32 (-23.20%)

The reason for this regression is that clean_bdev_aliases() is slower
when called for a single block because pagevec_lookup() it uses will end
up iterating through the radix tree until it finds a page (which may
take a while) but we are only interested whether there's a page at a
particular index.

Fix the problem by using pagevec_lookup_range() instead which avoids the
needless iteration.

Fixes: e64855c6cfaa0a80c1b71c5f647cb792dc436668
Signed-off-by: Jan Kara <jack@suse.cz>
---
 fs/buffer.c | 14 ++++++++------
 1 file changed, 8 insertions(+), 6 deletions(-)

diff --git a/fs/buffer.c b/fs/buffer.c
index fe0ee01c5a44..d63b22e50f38 100644
--- a/fs/buffer.c
+++ b/fs/buffer.c
@@ -1632,19 +1632,18 @@ void clean_bdev_aliases(struct block_device *bdev, sector_t block, sector_t len)
 	struct pagevec pvec;
 	pgoff_t index = block >> (PAGE_SHIFT - bd_inode->i_blkbits);
 	pgoff_t end;
-	int i;
+	int i, count;
 	struct buffer_head *bh;
 	struct buffer_head *head;
 
 	end = (block + len - 1) >> (PAGE_SHIFT - bd_inode->i_blkbits);
 	pagevec_init(&pvec, 0);
-	while (index <= end && pagevec_lookup(&pvec, bd_mapping, &index,
-			min(end - index, (pgoff_t)PAGEVEC_SIZE - 1) + 1)) {
-		for (i = 0; i < pagevec_count(&pvec); i++) {
+	while (pagevec_lookup_range(&pvec, bd_mapping, &index, end,
+				    PAGEVEC_SIZE)) {
+		count = pagevec_count(&pvec);
+		for (i = 0; i < count; i++) {
 			struct page *page = pvec.pages[i];
 
-			if (page->index > end)
-				break;
 			if (!page_has_buffers(page))
 				continue;
 			/*
@@ -1674,6 +1673,9 @@ void clean_bdev_aliases(struct block_device *bdev, sector_t block, sector_t len)
 		}
 		pagevec_release(&pvec);
 		cond_resched();
+		/* End of range already reached? */
+		if (index > end || !index)
+			break;
 	}
 }
 EXPORT_SYMBOL(clean_bdev_aliases);
-- 
2.12.3
