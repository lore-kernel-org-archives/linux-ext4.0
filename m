From: Jeff Layton <jlayton@redhat.com>
Subject: [PATCH v3 08/20] mm: ensure that we set mapping
	error if writeout() fails
Date: Mon, 24 Apr 2017 09:22:47 -0400
Message-ID: <20170424132259.8680-9-jlayton@redhat.com>
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

If writepage fails during a page migration, then we need to ensure that
fsync will see it by flagging the mapping.

Signed-off-by: Jeff Layton <jlayton@redhat.com>
---
 mm/migrate.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/mm/migrate.c b/mm/migrate.c
index 738f1d5f8350..3a59830bdae2 100644
--- a/mm/migrate.c
+++ b/mm/migrate.c
@@ -792,7 +792,11 @@ static int writeout(struct address_space *mapping, struct page *page)
 		/* unlocked. Relock */
 		lock_page(page);
 
-	return (rc < 0) ? -EIO : -EAGAIN;
+	if (rc < 0) {
+		mapping_set_error(mapping, rc);
+		return -EIO;
+	}
+	return -EAGAIN;
 }
 
 /*
-- 
2.9.3
