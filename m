From: Jeff Layton <jlayton@redhat.com>
Subject: [PATCH v7 02/22] buffer: use mapping_set_error instead of setting the flag
Date: Fri, 16 Jun 2017 15:34:07 -0400
Message-ID: <20170616193427.13955-3-jlayton@redhat.com>
References: <20170616193427.13955-1-jlayton@redhat.com>
Cc: Carlos Maiolino <cmaiolino@redhat.com>,
        Eryu Guan <eguan@redhat.com>,
        David Howells <dhowells@redhat.com>,
        Christoph Hellwig <hch@infradead.org>,
        linux-fsdevel@vger.kernel.org, linux-mm@kvack.org,
        linux-ext4@vger.kernel.org, linux-xfs@vger.kernel.org,
        linux-btrfs@vger.kernel.org, linux-block@vger.kernel.org
To: Andrew Morton <akpm@linux-foundation.org>,
        Al Viro <viro@ZenIV.linux.org.uk>, Jan Kara <jack@suse.cz>,
        tytso@mit.edu, axboe@kernel.dk, mawilcox@microsoft.com,
        ross.zwisler@linux.intel.com, corbet@lwn.net,
        Chris Mason <clm@fb.com>, Josef Bacik <jbacik@fb.com>,
        David Sterba <dsterba@suse.com>,
        "Darrick J . Wong" <darrick.wong@oracle.com>
Return-path: <linux-block-owner@vger.kernel.org>
In-Reply-To: <20170616193427.13955-1-jlayton@redhat.com>
Sender: linux-block-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Signed-off-by: Jeff Layton <jlayton@redhat.com>
Reviewed-by: Jan Kara <jack@suse.cz>
Reviewed-by: Matthew Wilcox <mawilcox@microsoft.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 fs/buffer.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/buffer.c b/fs/buffer.c
index 44172d11efae..7b4f4bfde91e 100644
--- a/fs/buffer.c
+++ b/fs/buffer.c
@@ -482,7 +482,7 @@ static void __remove_assoc_queue(struct buffer_head *bh)
 	list_del_init(&bh->b_assoc_buffers);
 	WARN_ON(!bh->b_assoc_map);
 	if (buffer_write_io_error(bh))
-		set_bit(AS_EIO, &bh->b_assoc_map->flags);
+		mapping_set_error(bh->b_assoc_map, -EIO);
 	bh->b_assoc_map = NULL;
 }
 
-- 
2.13.0
