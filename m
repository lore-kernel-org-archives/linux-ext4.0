From: jlayton@kernel.org
Subject: [PATCH v8 06/18] mm: clear AS_EIO/AS_ENOSPC when writeback initiation fails
Date: Thu, 29 Jun 2017 09:19:42 -0400
Message-ID: <20170629131954.28733-7-jlayton@kernel.org>
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

filemap_write_and_wait{_range} will return an error if writeback
initiation fails, but won't clear errors in the address_space. This is
particularly problematic on DAX, as it's effectively synchronous. Ensure
that we clear the AS_EIO/AS_ENOSPC flags when filemap_fdatawrite returns
an error.

Signed-off-by: Jeff Layton <jlayton@redhat.com>
---
 mm/filemap.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/mm/filemap.c b/mm/filemap.c
index e5711b2728f4..49bc9720fb00 100644
--- a/mm/filemap.c
+++ b/mm/filemap.c
@@ -515,6 +515,9 @@ int filemap_write_and_wait(struct address_space *mapping)
 			int err2 = filemap_fdatawait(mapping);
 			if (!err)
 				err = err2;
+		} else {
+			/* Clear any previously stored errors */
+			filemap_check_errors(mapping);
 		}
 	} else {
 		err = filemap_check_errors(mapping);
@@ -549,6 +552,9 @@ int filemap_write_and_wait_range(struct address_space *mapping,
 						lstart, lend);
 			if (!err)
 				err = err2;
+		} else {
+			/* Clear any previously stored errors */
+			filemap_check_errors(mapping);
 		}
 	} else {
 		err = filemap_check_errors(mapping);
-- 
2.13.0

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
