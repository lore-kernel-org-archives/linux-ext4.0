From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 6/6] writeback: limit write_cache_pages integrity scanning to current EOF
Date: Tue, 25 May 2010 20:54:12 +1000
Message-ID: <1274784852-30502-7-git-send-email-david@fromorbit.com>
References: <1274784852-30502-1-git-send-email-david@fromorbit.com>
Cc: xfs@oss.sgi.com, linux-fsdevel@vger.kernel.org,
	linux-ext4@vger.kernel.org, tytso@mit.edu, jens.axboe@oracle.com
To: linux-kernel@vger.kernel.org
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1274784852-30502-1-git-send-email-david@fromorbit.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

From: Dave Chinner <dchinner@redhat.com>

sync can currently take a really long time if a concurrent writer is
extending a file. The problem is that the dirty pages on the address
space grow in the same direction as write_cache_pages scans, so if
the writer keeps ahead of writeback, the writeback will not
terminate until the writer stops adding dirty pages.

For a data integrity sync, we only need to write the pages dirty at
the time we start the writeback, so we can stop scanning once we get
to the page that was at the end of the file at the time the scan
started.

This will prevent operations like copying a large file preventing
sync from completing as it will not write back pages that were
dirtied after the sync was started. This does not impact the
existing integrity guarantees, as any dirty page (old or new)
within the EOF range at the start of the scan will still be
captured.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 mm/page-writeback.c |   15 +++++++++++++++
 1 files changed, 15 insertions(+), 0 deletions(-)

diff --git a/mm/page-writeback.c b/mm/page-writeback.c
index 0fe713d..c97e973 100644
--- a/mm/page-writeback.c
+++ b/mm/page-writeback.c
@@ -855,7 +855,22 @@ int write_cache_pages(struct address_space *mapping,
 		if (wbc->range_start == 0 && wbc->range_end == LLONG_MAX)
 			range_whole = 1;
 		cycled = 1; /* ignore range_cyclic tests */
+
+		/*
+		 * If this is a data integrity sync, cap the writeback to the
+		 * current end of file. Any extension to the file that occurs
+		 * after this is a new write and we don't need to write those
+		 * pages out to fulfil our data integrity requirements. If we
+		 * try to write them out, we can get stuck in this scan until
+		 * the concurrent writer stops adding dirty pages and extending
+		 * EOF.
+		 */
+		if (wbc->sync_mode == WB_SYNC_ALL &&
+		    wbc->range_end == LLONG_MAX) {
+			end = i_size_read(mapping->host) >> PAGE_CACHE_SHIFT;
+		}
 	}
+
 retry:
 	done_index = index;
 	while (!done && (index <= end)) {
-- 
1.5.6.5
