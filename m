From: Jeff Layton <jlayton@redhat.com>
Subject: [RFC PATCH 2/4] dax: set errors in mapping when writeback fails
Date: Fri, 31 Mar 2017 15:26:01 -0400
Message-ID: <20170331192603.16442-3-jlayton@redhat.com>
References: <20170331192603.16442-1-jlayton@redhat.com>
Cc: linux-kernel@vger.kernel.org, linux-ext4@vger.kernel.org,
        akpm@linux-foundation.org, tytso@mit.edu, jack@suse.cz,
        willy@infradead.org, neilb@suse.com
To: linux-fsdevel@vger.kernel.org
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20170331192603.16442-1-jlayton@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

In order to get proper error codes from fsync, we must set an error in
the mapping range when writeback fails.

Signed-off-by: Jeff Layton <jlayton@redhat.com>
---
 fs/dax.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/fs/dax.c b/fs/dax.c
index de622d4282a6..b76b3ffc141a 100644
--- a/fs/dax.c
+++ b/fs/dax.c
@@ -892,8 +892,10 @@ int dax_writeback_mapping_range(struct address_space *mapping,
 
 			ret = dax_writeback_one(bdev, mapping, indices[i],
 					pvec.pages[i]);
-			if (ret < 0)
+			if (ret < 0) {
+				filemap_set_wb_error(mapping, ret);
 				return ret;
+			}
 		}
 	}
 	return 0;
-- 
2.9.3
