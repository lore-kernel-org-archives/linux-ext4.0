From: Jan Kara <jack@suse.cz>
Subject: [PATCH 23/35] mm: Use pagevec_lookup_range_tag() in
	__filemap_fdatawait_range()
Date: Thu,  1 Jun 2017 11:32:33 +0200
Message-ID: <20170601093245.29238-24-jack@suse.cz>
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

Use pagevec_lookup_range_tag() in __filemap_fdatawait_range() as it is
interested only in pages from given range. Remove unnecessary code
resulting from this.

Signed-off-by: Jan Kara <jack@suse.cz>
---
 mm/filemap.c | 9 ++-------
 1 file changed, 2 insertions(+), 7 deletions(-)

diff --git a/mm/filemap.c b/mm/filemap.c
index 56af68f6a375..8039b6bb9c27 100644
--- a/mm/filemap.c
+++ b/mm/filemap.c
@@ -390,18 +390,13 @@ static int __filemap_fdatawait_range(struct address_space *mapping,
 
 	pagevec_init(&pvec, 0);
 	while ((index <= end) &&
-			(nr_pages = pagevec_lookup_tag(&pvec, mapping, &index,
-			PAGECACHE_TAG_WRITEBACK,
-			min(end - index, (pgoff_t)PAGEVEC_SIZE-1) + 1)) != 0) {
+			(nr_pages = pagevec_lookup_range_tag(&pvec, mapping,
+			&index, end, PAGECACHE_TAG_WRITEBACK, PAGEVEC_SIZE))) {
 		unsigned i;
 
 		for (i = 0; i < nr_pages; i++) {
 			struct page *page = pvec.pages[i];
 
-			/* until radix tree lookup accepts end_index */
-			if (page->index > end)
-				continue;
-
 			wait_on_page_writeback(page);
 			if (TestClearPageError(page))
 				ret = -EIO;
-- 
2.12.3
