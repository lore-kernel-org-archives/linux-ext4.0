From: Jan Kara <jack@suse.cz>
Subject: [PATCH 26/35] afs: Use find_get_pages_range_tag()
Date: Thu,  1 Jun 2017 11:32:36 +0200
Message-ID: <20170601093245.29238-27-jack@suse.cz>
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

Use find_get_pages_range_tag() in afs_writepages_region() as we are
interested only in pages from given range. Remove unnecessary code after
this conversion.

CC: David Howells <dhowells@redhat.com>
CC: linux-afs@lists.infradead.org
Signed-off-by: Jan Kara <jack@suse.cz>
---
 fs/afs/write.c | 11 ++---------
 1 file changed, 2 insertions(+), 9 deletions(-)

diff --git a/fs/afs/write.c b/fs/afs/write.c
index 2d2fccd5044b..630f2a42fae7 100644
--- a/fs/afs/write.c
+++ b/fs/afs/write.c
@@ -497,20 +497,13 @@ static int afs_writepages_region(struct address_space *mapping,
 	_enter(",,%lx,%lx,", index, end);
 
 	do {
-		n = find_get_pages_tag(mapping, &index, PAGECACHE_TAG_DIRTY,
-				       1, &page);
+		n = find_get_pages_range_tag(mapping, &index, end,
+					PAGECACHE_TAG_DIRTY, 1, &page);
 		if (!n)
 			break;
 
 		_debug("wback %lx", page->index);
 
-		if (page->index > end) {
-			*_next = index;
-			put_page(page);
-			_leave(" = 0 [%lx]", *_next);
-			return 0;
-		}
-
 		/* at this point we hold neither mapping->tree_lock nor lock on
 		 * the page itself: the page may be truncated or invalidated
 		 * (changing page->mapping to NULL), or even swizzled back from
-- 
2.12.3
