From: Jeff Layton <jlayton@redhat.com>
Subject: [PATCH v3 11/20] cifs: set mapping error when page
	writeback fails in writepage or launder_pages
Date: Mon, 24 Apr 2017 09:22:50 -0400
Message-ID: <20170424132259.8680-12-jlayton@redhat.com>
References: <20170424132259.8680-1-jlayton@redhat.com>
Cc: axboe@kernel.dk, tytso@mit.edu, mawilcox@microsoft.com, neilb@suse.de,
	corbet@lwn.net, dhowells@redhat.com, clm@fb.com,
	viro@zeniv.linux.org.uk, jack@suse.com,
	akpm@linux-foundation.org, ross.zwisler@linux.intel.com
To: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-btrfs@vger.kernel.org, linux-ext4@vger.kernel.org,
	linux-cifs@vger.kernel.org, linux-mm@kvack.org,
	jfs-discussion@lists.sourceforge.net, linux-xfs@vger.kernel.org,
	cluster-devel@redhat.com, linux-f2fs-devel@lists.sourceforge.net,
	v9fs-developer@lists.sourceforge.net, osd-dev@open-osd.org,
	linux-nilfs@vger.kernel.org, linux-block@vger.kernel.org
Return-path: <cluster-devel-bounces@redhat.com>
In-Reply-To: <20170424132259.8680-1-jlayton@redhat.com>
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

Signed-off-by: Jeff Layton <jlayton@redhat.com>
---
 fs/cifs/file.c | 10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

diff --git a/fs/cifs/file.c b/fs/cifs/file.c
index 21d404535739..4b696a23b0b1 100644
--- a/fs/cifs/file.c
+++ b/fs/cifs/file.c
@@ -2234,14 +2234,16 @@ cifs_writepage_locked(struct page *page, struct writeback_control *wbc)
 	set_page_writeback(page);
 retry_write:
 	rc = cifs_partialpagewrite(page, 0, PAGE_SIZE);
-	if (rc == -EAGAIN && wbc->sync_mode == WB_SYNC_ALL)
+	if (rc == -EAGAIN && wbc->sync_mode == WB_SYNC_ALL) {
 		goto retry_write;
-	else if (rc == -EAGAIN)
+	} else if (rc == -EAGAIN) {
 		redirty_page_for_writepage(wbc, page);
-	else if (rc != 0)
+	} else if (rc != 0) {
 		SetPageError(page);
-	else
+		mapping_set_error(page->mapping, rc);
+	} else {
 		SetPageUptodate(page);
+	}
 	end_page_writeback(page);
 	put_page(page);
 	free_xid(xid);
-- 
2.9.3
