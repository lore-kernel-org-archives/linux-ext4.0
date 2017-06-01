From: Jan Kara <jack@suse.cz>
Subject: [PATCH 11/35] hugetlbfs: Use pagevec_lookup_range() in
 remove_inode_hugepages()
Date: Thu,  1 Jun 2017 11:32:21 +0200
Message-ID: <20170601093245.29238-12-jack@suse.cz>
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

We want only pages from given range in remove_inode_hugepages(). Use
pagevec_lookup_range() instead of pagevec_lookup().

CC: Nadia Yvette Chambers <nyc@holomorphy.com>
Signed-off-by: Jan Kara <jack@suse.cz>
---
 fs/hugetlbfs/inode.c | 18 ++----------------
 1 file changed, 2 insertions(+), 16 deletions(-)

diff --git a/fs/hugetlbfs/inode.c b/fs/hugetlbfs/inode.c
index 372fc8aac38e..99885f9b9d56 100644
--- a/fs/hugetlbfs/inode.c
+++ b/fs/hugetlbfs/inode.c
@@ -403,7 +403,6 @@ static void remove_inode_hugepages(struct inode *inode, loff_t lstart,
 	struct pagevec pvec;
 	pgoff_t next, index;
 	int i, freed = 0;
-	long lookup_nr = PAGEVEC_SIZE;
 	bool truncate_op = (lend == LLONG_MAX);
 
 	memset(&pseudo_vma, 0, sizeof(struct vm_area_struct));
@@ -412,30 +411,17 @@ static void remove_inode_hugepages(struct inode *inode, loff_t lstart,
 	next = start;
 	while (next < end) {
 		/*
-		 * Don't grab more pages than the number left in the range.
-		 */
-		if (end - next < lookup_nr)
-			lookup_nr = end - next;
-
-		/*
 		 * When no more pages are found, we are done.
 		 */
-		if (!pagevec_lookup(&pvec, mapping, &next, lookup_nr))
+		if (!pagevec_lookup_range(&pvec, mapping, &next, end - 1,
+					  PAGEVEC_SIZE))
 			break;
 
 		for (i = 0; i < pagevec_count(&pvec); ++i) {
 			struct page *page = pvec.pages[i];
 			u32 hash;
 
-			/*
-			 * The page (index) could be beyond end.  This is
-			 * only possible in the punch hole case as end is
-			 * max page offset in the truncate case.
-			 */
 			index = page->index;
-			if (index >= end)
-				break;
-
 			hash = hugetlb_fault_mutex_hash(h, current->mm,
 							&pseudo_vma,
 							mapping, index, 0);
-- 
2.12.3


------------------------------------------------------------------------------
Check out the vibrant tech community on one of the world's most
engaging tech sites, Slashdot.org! http://sdm.link/slashdot
