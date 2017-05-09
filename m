From: Jeff Layton <jlayton@redhat.com>
Subject: [PATCH v4 21/27] mm: clean up error handling in
	write_one_page
Date: Tue,  9 May 2017 11:49:24 -0400
Message-ID: <20170509154930.29524-22-jlayton@redhat.com>
References: <20170509154930.29524-1-jlayton@redhat.com>
Cc: axboe@kernel.dk, tytso@mit.edu, mawilcox@microsoft.com, neilb@suse.de,
	corbet@lwn.net, josef@toxicpanda.com, dhowells@redhat.com,
	clm@fb.com, bo.li.liu@oracle.com, viro@zeniv.linux.org.uk,
	jack@suse.com, akpm@linux-foundation.org,
	ross.zwisler@linux.intel.com, hubcap@omnibond.com
To: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-btrfs@vger.kernel.org, linux-ext4@vger.kernel.org,
	linux-cifs@vger.kernel.org, linux-nfs@vger.kernel.org,
	linux-mm@kvack.org, jfs-discussion@lists.sourceforge.net,
	linux-xfs@vger.kernel.org, cluster-devel@redhat.com,
	linux-f2fs-devel@lists.sourceforge.net,
	v9fs-developer@lists.sourceforge.net, linux-nilfs@vger.kernel.org,
	linux-block@vger.kernel.org
Return-path: <cluster-devel-bounces@redhat.com>
In-Reply-To: <20170509154930.29524-1-jlayton@redhat.com>
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

Don't try to check PageError since that's potentially racy and not
necessarily going to be set after writepage errors out.

Instead, sample the mapping error early on, and use that value to tell
us whether we got a writeback error since then.

Signed-off-by: Jeff Layton <jlayton@redhat.com>
---
 mm/page-writeback.c | 11 +++++------
 1 file changed, 5 insertions(+), 6 deletions(-)

diff --git a/mm/page-writeback.c b/mm/page-writeback.c
index de0dbf12e2c1..1643456881b4 100644
--- a/mm/page-writeback.c
+++ b/mm/page-writeback.c
@@ -2373,11 +2373,12 @@ int do_writepages(struct address_space *mapping, struct writeback_control *wbc)
 int write_one_page(struct page *page)
 {
 	struct address_space *mapping = page->mapping;
-	int ret = 0;
+	int ret = 0, ret2;
 	struct writeback_control wbc = {
 		.sync_mode = WB_SYNC_ALL,
 		.nr_to_write = 1,
 	};
+	errseq_t since = filemap_sample_wb_error(mapping);
 
 	BUG_ON(!PageLocked(page));
 
@@ -2386,16 +2387,14 @@ int write_one_page(struct page *page)
 	if (clear_page_dirty_for_io(page)) {
 		get_page(page);
 		ret = mapping->a_ops->writepage(page, &wbc);
-		if (ret == 0) {
+		if (ret == 0)
 			wait_on_page_writeback(page);
-			if (PageError(page))
-				ret = -EIO;
-		}
 		put_page(page);
 	} else {
 		unlock_page(page);
 	}
-	return ret;
+	ret2 = filemap_check_wb_error(mapping, since);
+	return ret ? : ret2;
 }
 EXPORT_SYMBOL(write_one_page);
 
-- 
2.9.3
