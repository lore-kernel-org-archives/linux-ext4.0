From: Johannes Weiner <jweiner@redhat.com>
Subject: [patch 4/4] Btrfs: pass __GFP_WRITE for buffered write page allocations
Date: Tue, 20 Sep 2011 15:45:15 +0200
Message-ID: <1316526315-16801-5-git-send-email-jweiner@redhat.com>
References: <1316526315-16801-1-git-send-email-jweiner@redhat.com>
Cc: Mel Gorman <mgorman@suse.de>, Christoph Hellwig <hch@infradead.org>,
        Dave Chinner <david@fromorbit.com>,
        Wu Fengguang <fengguang.wu@intel.com>, Jan Kara <jack@suse.cz>,
        Rik van Riel <riel@redhat.com>, Minchan Kim <minchan.kim@gmail.com>,
        Chris Mason <chris.mason@oracle.com>, "Theodore Ts'o" <tytso@mit.edu>,
        Andreas Dilger <adilger.kernel@dilger.ca>, xfs@oss.sgi.com,
        linux-btrfs@vger.kernel.org, linux-ext4@vger.kernel.org,
        linux-mm@kvack.org, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org
To: Andrew Morton <akpm@linux-foundation.org>
Return-path: <owner-linux-mm@kvack.org>
In-Reply-To: <1316526315-16801-1-git-send-email-jweiner@redhat.com>
Sender: owner-linux-mm@kvack.org
List-Id: linux-ext4.vger.kernel.org

Tell the page allocator that pages allocated for a buffered write are
expected to become dirty soon.

Signed-off-by: Johannes Weiner <jweiner@redhat.com>
---
 fs/btrfs/file.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/fs/btrfs/file.c b/fs/btrfs/file.c
index e7872e4..ea1b892 100644
--- a/fs/btrfs/file.c
+++ b/fs/btrfs/file.c
@@ -1084,7 +1084,7 @@ static noinline int prepare_pages(struct btrfs_root *root, struct file *file,
 again:
 	for (i = 0; i < num_pages; i++) {
 		pages[i] = find_or_create_page(inode->i_mapping, index + i,
-					       GFP_NOFS);
+					       GFP_NOFS | __GFP_WRITE);
 		if (!pages[i]) {
 			faili = i - 1;
 			err = -ENOMEM;
-- 
1.7.6

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Fight unfair telecom internet charges in Canada: sign http://stopthemeter.ca/
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
