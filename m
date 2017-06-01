From: Jan Kara <jack@suse.cz>
Subject: [PATCH 05/35] mm: Fix THP handling in
	invalidate_mapping_pages()
Date: Thu,  1 Jun 2017 11:32:15 +0200
Message-ID: <20170601093245.29238-6-jack@suse.cz>
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

The condition checking for THP straddling end of invalidated range is
wrong - it checks 'index' against 'end' but 'index' has been already
advanced to point to the end of THP and thus the condition can never be
true. As a result THP straddling 'end' has been fully invalidated. Given
the nature of invalidate_mapping_pages(), this could be only performance
issue. In fact, we are lucky the condition is wrong because if it was
ever true, we'd leave locked page behind.

Fix the condition checking for THP straddling 'end' and also properly
unlock the page. Also update the comment before the condition to explain
why we decide not to invalidate the page as it was not clear to me and I
had to ask Kirill.

Signed-off-by: Jan Kara <jack@suse.cz>
---
 mm/truncate.c | 10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

diff --git a/mm/truncate.c b/mm/truncate.c
index 6479ed2afc53..2330223841fb 100644
--- a/mm/truncate.c
+++ b/mm/truncate.c
@@ -530,9 +530,15 @@ unsigned long invalidate_mapping_pages(struct address_space *mapping,
 			} else if (PageTransHuge(page)) {
 				index += HPAGE_PMD_NR - 1;
 				i += HPAGE_PMD_NR - 1;
-				/* 'end' is in the middle of THP */
-				if (index ==  round_down(end, HPAGE_PMD_NR))
+				/*
+				 * 'end' is in the middle of THP. Don't
+				 * invalidate the page as the part outside of
+				 * 'end' could be still useful.
+				 */
+				if (index > end) {
+					unlock_page(page);
 					continue;
+				}
 			}
 
 			ret = invalidate_inode_page(page);
-- 
2.12.3
