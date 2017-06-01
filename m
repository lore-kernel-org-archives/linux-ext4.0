From: Jan Kara <jack@suse.cz>
Subject: [PATCH 34/35] mm: Make find_get_entries_tag() update
 index
Date: Thu,  1 Jun 2017 11:32:44 +0200
Message-ID: <20170601093245.29238-35-jack@suse.cz>
References: <20170601093245.29238-1-jack@suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: cluster-devel@redhat.com, linux-nilfs@vger.kernel.org, tytso@mit.edu,
	linux-xfs@vger.kernel.org, "Yan, Zheng" <zyan@redhat.com>,
	Jan Kara <jack@suse.cz>, "Darrick J . Wong" <darrick.wong@oracle.com>,
	Hugh Dickins <hughd@google.com>, linux-f2fs-devel@lists.sourceforge.net,
	David Howells <dhowells@redhat.com>,
	David Sterba <dsterba@suse.com>, ceph-devel@vger.kernel.org,
	Nadia Yvette Chambers <nyc@holomorphy.com>,
	Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>,
	Bob Peterson <rpeterso@redhat.com>, Jaegeuk Kim <jaegeuk@kernel.org>,
	Ilya Dryomov <idryomov@gmail.com>, linux-ext4@vger.kernel.org,
	linux-afs@lists.infradead.org, linux-btrfs@vger.kernel.org
To: <linux-mm@kvack.org>
Return-path: <linux-f2fs-devel-bounces@lists.sourceforge.net>
In-Reply-To: <20170601093245.29238-1-jack@suse.cz>
List-Unsubscribe: <https://lists.sourceforge.net/lists/options/linux-f2fs-devel>,
	<mailto:linux-f2fs-devel-request@lists.sourceforge.net?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum_name=linux-f2fs-devel>
List-Post: <mailto:linux-f2fs-devel@lists.sourceforge.net>
List-Help: <mailto:linux-f2fs-devel-request@lists.sourceforge.net?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/linux-f2fs-devel>,
	<mailto:linux-f2fs-devel-request@lists.sourceforge.net?subject=subscribe>
Errors-To: linux-f2fs-devel-bounces@lists.sourceforge.net
List-Id: linux-ext4.vger.kernel.org

Make find_get_entries_tag() update 'start' to index the next page for
iteration.

Signed-off-by: Jan Kara <jack@suse.cz>
---
 fs/dax.c                | 3 +--
 include/linux/pagemap.h | 2 +-
 mm/filemap.c            | 8 ++++++--
 3 files changed, 8 insertions(+), 5 deletions(-)

diff --git a/fs/dax.c b/fs/dax.c
index c204445a69b0..4b295c544fd4 100644
--- a/fs/dax.c
+++ b/fs/dax.c
@@ -841,7 +841,7 @@ int dax_writeback_mapping_range(struct address_space *mapping,
 
 	pagevec_init(&pvec, 0);
 	while (!done) {
-		pvec.nr = find_get_entries_tag(mapping, start_index,
+		pvec.nr = find_get_entries_tag(mapping, &start_index,
 				PAGECACHE_TAG_TOWRITE, PAGEVEC_SIZE,
 				pvec.pages, indices);
 
@@ -859,7 +859,6 @@ int dax_writeback_mapping_range(struct address_space *mapping,
 			if (ret < 0)
 				goto out;
 		}
-		start_index = indices[pvec.nr - 1] + 1;
 	}
 out:
 	put_dax(dax_dev);
diff --git a/include/linux/pagemap.h b/include/linux/pagemap.h
index df128a56f44b..1dc7e54ec32a 100644
--- a/include/linux/pagemap.h
+++ b/include/linux/pagemap.h
@@ -365,7 +365,7 @@ static inline unsigned find_get_pages_tag(struct address_space *mapping,
 	return find_get_pages_range_tag(mapping, index, (pgoff_t)-1, tag,
 					nr_pages, pages);
 }
-unsigned find_get_entries_tag(struct address_space *mapping, pgoff_t start,
+unsigned find_get_entries_tag(struct address_space *mapping, pgoff_t *start,
 			int tag, unsigned int nr_entries,
 			struct page **entries, pgoff_t *indices);
 
diff --git a/mm/filemap.c b/mm/filemap.c
index e55100459710..3eb05c91c07a 100644
--- a/mm/filemap.c
+++ b/mm/filemap.c
@@ -1731,7 +1731,7 @@ EXPORT_SYMBOL(find_get_pages_range_tag);
  * Like find_get_entries, except we only return entries which are tagged with
  * @tag.
  */
-unsigned find_get_entries_tag(struct address_space *mapping, pgoff_t start,
+unsigned find_get_entries_tag(struct address_space *mapping, pgoff_t *start,
 			int tag, unsigned int nr_entries,
 			struct page **entries, pgoff_t *indices)
 {
@@ -1744,7 +1744,7 @@ unsigned find_get_entries_tag(struct address_space *mapping, pgoff_t start,
 
 	rcu_read_lock();
 	radix_tree_for_each_tagged(slot, &mapping->page_tree,
-				   &iter, start, tag) {
+				   &iter, *start, tag) {
 		struct page *head, *page;
 repeat:
 		page = radix_tree_deref_slot(slot);
@@ -1786,6 +1786,10 @@ unsigned find_get_entries_tag(struct address_space *mapping, pgoff_t start,
 			break;
 	}
 	rcu_read_unlock();
+
+	if (ret)
+		*start = indices[ret - 1] + 1;
+
 	return ret;
 }
 EXPORT_SYMBOL(find_get_entries_tag);
-- 
2.12.3


------------------------------------------------------------------------------
Check out the vibrant tech community on one of the world's most
engaging tech sites, Slashdot.org! http://sdm.link/slashdot
