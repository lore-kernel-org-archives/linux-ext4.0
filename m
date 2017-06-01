From: Jan Kara <jack@suse.cz>
Subject: [PATCH 31/35] shmem: Convert to
	pagevec_lookup_entries_range()
Date: Thu,  1 Jun 2017 11:32:41 +0200
Message-ID: <20170601093245.29238-32-jack@suse.cz>
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

Convert radix tree scanners to use pagevec_lookup_entries_range() and
find_get_entries_range() since they all want only entries from given
range.

CC: Hugh Dickins <hughd@google.com>
Signed-off-by: Jan Kara <jack@suse.cz>
---
 mm/shmem.c | 23 +++++++----------------
 1 file changed, 7 insertions(+), 16 deletions(-)

diff --git a/mm/shmem.c b/mm/shmem.c
index f9c4afbdd70c..e5ea044aae24 100644
--- a/mm/shmem.c
+++ b/mm/shmem.c
@@ -768,16 +768,12 @@ static void shmem_undo_range(struct inode *inode, loff_t lstart, loff_t lend,
 	pagevec_init(&pvec, 0);
 	index = start;
 	while (index < end) {
-		if (!pagevec_lookup_entries(&pvec, mapping, &index,
-				min(end - index, (pgoff_t)PAGEVEC_SIZE),
-				indices))
+		if (!pagevec_lookup_entries_range(&pvec, mapping, &index,
+				end - 1, PAGEVEC_SIZE, indices))
 			break;
 		for (i = 0; i < pagevec_count(&pvec); i++) {
 			struct page *page = pvec.pages[i];
 
-			if (indices[i] >= end)
-				break;
-
 			if (radix_tree_exceptional_entry(page)) {
 				if (unfalloc)
 					continue;
@@ -860,9 +856,8 @@ static void shmem_undo_range(struct inode *inode, loff_t lstart, loff_t lend,
 
 		cond_resched();
 
-		if (!pagevec_lookup_entries(&pvec, mapping, &index,
-				min(end - index, (pgoff_t)PAGEVEC_SIZE),
-				indices)) {
+		if (!pagevec_lookup_entries_range(&pvec, mapping, &index,
+				end - 1, PAGEVEC_SIZE, indices)) {
 			/* If all gone or hole-punch or unfalloc, we're done */
 			if (lookup_start == start || end != -1)
 				break;
@@ -873,9 +868,6 @@ static void shmem_undo_range(struct inode *inode, loff_t lstart, loff_t lend,
 		for (i = 0; i < pagevec_count(&pvec); i++) {
 			struct page *page = pvec.pages[i];
 
-			if (indices[i] >= end)
-				break;
-
 			if (radix_tree_exceptional_entry(page)) {
 				if (unfalloc)
 					continue;
@@ -2494,9 +2486,9 @@ static pgoff_t shmem_seek_hole_data(struct address_space *mapping,
 
 	pagevec_init(&pvec, 0);
 	pvec.nr = 1;		/* start small: we may be there already */
-	while (!done) {
+	while (!done && index < end) {
 		last = index;
-		pvec.nr = find_get_entries(mapping, &index,
+		pvec.nr = find_get_entries_range(mapping, &index, end - 1,
 					pvec.nr, pvec.pages, indices);
 		if (!pvec.nr) {
 			if (whence == SEEK_DATA)
@@ -2516,8 +2508,7 @@ static pgoff_t shmem_seek_hole_data(struct address_space *mapping,
 				if (!PageUptodate(page))
 					page = NULL;
 			}
-			if (last >= end ||
-			    (page && whence == SEEK_DATA) ||
+			if ((page && whence == SEEK_DATA) ||
 			    (!page && whence == SEEK_HOLE)) {
 				done = true;
 				break;
-- 
2.12.3
