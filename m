From: Jeff Layton <jlayton@redhat.com>
Subject: [PATCH v4 10/27] 9p: set mapping error when
	writeback fails in launder_page
Date: Tue,  9 May 2017 11:49:13 -0400
Message-ID: <20170509154930.29524-11-jlayton@redhat.com>
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

launder_page is just writeback under the page lock. We still need to
mark the mapping for errors there when they occur.

Signed-off-by: Jeff Layton <jlayton@redhat.com>
Reviewed-by: Jan Kara <jack@suse.cz>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 fs/9p/vfs_addr.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/fs/9p/vfs_addr.c b/fs/9p/vfs_addr.c
index adaf6f6dd858..7af6e6501698 100644
--- a/fs/9p/vfs_addr.c
+++ b/fs/9p/vfs_addr.c
@@ -223,8 +223,11 @@ static int v9fs_launder_page(struct page *page)
 	v9fs_fscache_wait_on_page_write(inode, page);
 	if (clear_page_dirty_for_io(page)) {
 		retval = v9fs_vfs_writepage_locked(page);
-		if (retval)
+		if (retval) {
+			if (retval != -EAGAIN)
+				mapping_set_error(page->mapping, retval);
 			return retval;
+		}
 	}
 	return 0;
 }
-- 
2.9.3
