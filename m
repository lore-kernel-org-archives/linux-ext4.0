From: Jeff Layton <jlayton@redhat.com>
Subject: [PATCH v3 06/20] dax: set errors in mapping when writeback fails
Date: Mon, 24 Apr 2017 09:22:45 -0400
Message-ID: <20170424132259.8680-7-jlayton@redhat.com>
References: <20170424132259.8680-1-jlayton@redhat.com>
Cc: dhowells@redhat.com, akpm@linux-foundation.org, hch@infradead.org,
        ross.zwisler@linux.intel.com, mawilcox@microsoft.com,
        jack@suse.com, viro@zeniv.linux.org.uk, corbet@lwn.net,
        neilb@suse.de, clm@fb.com, tytso@mit.edu, axboe@kernel.dk
To: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-btrfs@vger.kernel.org, linux-ext4@vger.kernel.org,
        linux-cifs@vger.kernel.org, linux-mm@kvack.org,
        jfs-discussion@lists.sourceforge.net, linux-xfs@vger.kernel.org,
        cluster-devel@redhat.com, linux-f2fs-devel@lists.sourceforge.net,
        v9fs-developer@lists.sourceforge.net, osd-dev@open-osd.org,
        linux-nilfs@vger.kernel.org, linux-block@vger.kernel.org
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <20170424132259.8680-1-jlayton@redhat.com>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

In order to get proper error codes from fsync, we must set an error in
the mapping range when writeback fails.

Signed-off-by: Jeff Layton <jlayton@redhat.com>
---
 fs/dax.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/fs/dax.c b/fs/dax.c
index 85abd741253d..9b6b04030c3f 100644
--- a/fs/dax.c
+++ b/fs/dax.c
@@ -901,8 +901,10 @@ int dax_writeback_mapping_range(struct address_space *mapping,
 
 			ret = dax_writeback_one(bdev, mapping, indices[i],
 					pvec.pages[i]);
-			if (ret < 0)
+			if (ret < 0) {
+				mapping_set_error(mapping, ret);
 				return ret;
+			}
 		}
 	}
 	return 0;
-- 
2.9.3
