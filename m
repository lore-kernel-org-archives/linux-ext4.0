From: Jeff Layton <jlayton@redhat.com>
Subject: [PATCH v7 06/22] mm: clear AS_EIO/AS_ENOSPC when writeback initiation fails
Date: Fri, 16 Jun 2017 15:34:11 -0400
Message-ID: <20170616193427.13955-7-jlayton@redhat.com>
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
index 37f286df7c95..c349a5d3a34b 100644
--- a/mm/filemap.c
+++ b/mm/filemap.c
@@ -517,6 +517,9 @@ int filemap_write_and_wait(struct address_space *mapping)
 			int err2 = filemap_fdatawait(mapping);
 			if (!err)
 				err = err2;
+		} else {
+			/* Clear any previously stored errors */
+			filemap_check_errors(mapping);
 		}
 	} else {
 		err = filemap_check_errors(mapping);
@@ -551,6 +554,9 @@ int filemap_write_and_wait_range(struct address_space *mapping,
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
