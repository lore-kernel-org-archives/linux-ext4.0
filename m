From: jlayton@kernel.org
Subject: [PATCH v8 02/18] buffer: use mapping_set_error instead of setting the flag
Date: Thu, 29 Jun 2017 09:19:38 -0400
Message-ID: <20170629131954.28733-3-jlayton@kernel.org>
References: <20170629131954.28733-1-jlayton@kernel.org>
Cc: Carlos Maiolino <cmaiolino@redhat.com>,
	Eryu Guan <eguan@redhat.com>,
	David Howells <dhowells@redhat.com>,
	Christoph Hellwig <hch@infradead.org>,
	Liu Bo <bo.li.liu@oracle.com>,
	linux-fsdevel@vger.kernel.org,
	linux-mm@kvack.org,
	linux-ext4@vger.kernel.org,
	linux-xfs@vger.kernel.org,
	linux-btrfs@vger.kernel.org,
	linux-block@vger.kernel.org
To: Andrew Morton <akpm@linux-foundation.org>,
	Al Viro <viro@ZenIV.linux.org.uk>,
	Jan Kara <jack@suse.cz>,
	tytso@mit.edu,
	axboe@kernel.dk,
	mawilcox@microsoft.com,
	ross.zwisler@linux.intel.com,
	corbet@lwn.net,
	Chris Mason <clm@fb.com>,
	Josef Bacik <jbacik@fb.com>,
	David Sterba <dsterba@suse.com>,
	"Darrick J . Wong" <darrick.wong@oracle.com>
Return-path: <owner-linux-mm@kvack.org>
In-Reply-To: <20170629131954.28733-1-jlayton@kernel.org>
Sender: owner-linux-mm@kvack.org
List-Id: linux-ext4.vger.kernel.org

From: Jeff Layton <jlayton@redhat.com>

Signed-off-by: Jeff Layton <jlayton@redhat.com>
Reviewed-by: Jan Kara <jack@suse.cz>
Reviewed-by: Matthew Wilcox <mawilcox@microsoft.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 fs/buffer.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/buffer.c b/fs/buffer.c
index 161be58c5cb0..4be8b914a222 100644
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

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
