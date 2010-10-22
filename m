From: Eric Sandeen <sandeen@redhat.com>
Subject: [PATCH 2/3] ext4: implement writeback livelock avoidance using page
 tagging
Date: Fri, 22 Oct 2010 16:37:40 -0500
Message-ID: <4CC20424.8000503@redhat.com>
References: <4CC2023A.7060607@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: Jan Kara <jack@suse.cz>
To: ext4 development <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:9711 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750910Ab0JVVhq (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 22 Oct 2010 17:37:46 -0400
In-Reply-To: <4CC2023A.7060607@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

This is analogous to Jan Kara's commit,
f446daaea9d4a420d16c606f755f3689dcb2d0ce
mm: implement writeback livelock avoidance using page tagging

but since we forked write_cache_pages, we need to reimplement
it there (and in ext4_da_writepages, since range_cyclic handling
was moved to there)

If you start a large buffered IO to a file, and then set
fsync after it, you'll find that fsync does not complete
until the other IO stops.

If you continue re-dirtying the file (say, putting dd
with conv=notrunc in a loop), when fsync finally completes
(after all IO is done), it reports via tracing that
it has written many more pages than the file contains;
in other words it has synced and re-synced pages in
the file multiple times.

This then leads to problems with our writeback_index
update, since it advances it by pages written, and
essentially sets writeback_index off the end of the
file...

With the following patch, we only sync as much as was
dirty at the time of the sync.

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
--

diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index 854917e..163ffca 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -2834,16 +2834,21 @@ static int write_cache_pages_da(struct address_space *mapping,
 	pgoff_t index;
 	pgoff_t end;		/* Inclusive */
 	long nr_to_write = wbc->nr_to_write;
+	int tag;
 
 	pagevec_init(&pvec, 0);
 	index = wbc->range_start >> PAGE_CACHE_SHIFT;
 	end = wbc->range_end >> PAGE_CACHE_SHIFT;
 
+	if (wbc->sync_mode == WB_SYNC_ALL)
+		tag = PAGECACHE_TAG_TOWRITE;
+	else
+		tag = PAGECACHE_TAG_DIRTY;
+
 	while (!done && (index <= end)) {
 		int i;
 
-		nr_pages = pagevec_lookup_tag(&pvec, mapping, &index,
-			      PAGECACHE_TAG_DIRTY,
+		nr_pages = pagevec_lookup_tag(&pvec, mapping, &index, tag,
 			      min(end - index, (pgoff_t)PAGEVEC_SIZE-1) + 1);
 		if (nr_pages == 0)
 			break;
@@ -2948,6 +2953,7 @@ static int ext4_da_writepages(struct address_space *mapping,
 	long desired_nr_to_write, nr_to_writebump = 0;
 	loff_t range_start = wbc->range_start;
 	struct ext4_sb_info *sbi = EXT4_SB(mapping->host->i_sb);
+	pgoff_t end;
 
 	trace_ext4_da_writepages(inode, wbc);
 
@@ -2983,8 +2989,11 @@ static int ext4_da_writepages(struct address_space *mapping,
 		wbc->range_start = index << PAGE_CACHE_SHIFT;
 		wbc->range_end  = LLONG_MAX;
 		wbc->range_cyclic = 0;
-	} else
+		end = -1;
+	} else {
 		index = wbc->range_start >> PAGE_CACHE_SHIFT;
+		end = wbc->range_end >> PAGE_CACHE_SHIFT;
+	}
 
 	/*
 	 * This works around two forms of stupidity.  The first is in
@@ -3025,6 +3034,9 @@ static int ext4_da_writepages(struct address_space *mapping,
 	pages_skipped = wbc->pages_skipped;
 
 retry:
+	if (wbc->sync_mode == WB_SYNC_ALL)
+		tag_pages_for_writeback(mapping, index, end);
+
 	while (!ret && wbc->nr_to_write > 0) {
 
 		/*
diff --git a/include/linux/writeback.h b/include/linux/writeback.h
index 72a5d64..3d132bf 100644
--- a/include/linux/writeback.h
+++ b/include/linux/writeback.h
@@ -143,6 +143,8 @@ typedef int (*writepage_t)(struct page *page, struct writeback_control *wbc,
 
 int generic_writepages(struct address_space *mapping,
 		       struct writeback_control *wbc);
+void tag_pages_for_writeback(struct address_space *mapping,
+			     pgoff_t start, pgoff_t end);
 int write_cache_pages(struct address_space *mapping,
 		      struct writeback_control *wbc, writepage_t writepage,
 		      void *data);

