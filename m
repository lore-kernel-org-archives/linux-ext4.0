From: Jeff Layton <jlayton@redhat.com>
Subject: [PATCH v3 10/20] fuse: set mapping error in
	writepage_locked when it fails
Date: Mon, 24 Apr 2017 09:22:49 -0400
Message-ID: <20170424132259.8680-11-jlayton@redhat.com>
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

This ensures that we see errors on fsync when writeback fails.

Signed-off-by: Jeff Layton <jlayton@redhat.com>
---
 fs/fuse/file.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/fs/fuse/file.c b/fs/fuse/file.c
index ec238fb5a584..07d0efcb050c 100644
--- a/fs/fuse/file.c
+++ b/fs/fuse/file.c
@@ -1669,6 +1669,7 @@ static int fuse_writepage_locked(struct page *page)
 err_free:
 	fuse_request_free(req);
 err:
+	mapping_set_error(page->mapping, error);
 	end_page_writeback(page);
 	return error;
 }
-- 
2.9.3
