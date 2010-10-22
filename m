From: Eric Sandeen <sandeen@redhat.com>
Subject: [PATCH 3/3] ext4: update writeback_index based on last page scanned
Date: Fri, 22 Oct 2010 16:45:17 -0500
Message-ID: <4CC205ED.4090007@redhat.com>
References: <4CC2023A.7060607@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
To: ext4 development <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:47079 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751086Ab0JVVpU (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 22 Oct 2010 17:45:20 -0400
Received: from int-mx02.intmail.prod.int.phx2.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
	by mx1.redhat.com (8.13.8/8.13.8) with ESMTP id o9MLjKPv024252
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-ext4@vger.kernel.org>; Fri, 22 Oct 2010 17:45:20 -0400
Received: from liberator.lan (ovpn01.gateway.prod.ext.phx2.redhat.com [10.5.9.1])
	by int-mx02.intmail.prod.int.phx2.redhat.com (8.13.8/8.13.8) with ESMTP id o9MLjHnQ014431
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-ext4@vger.kernel.org>; Fri, 22 Oct 2010 17:45:20 -0400
In-Reply-To: <4CC2023A.7060607@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

As pointed out in a prior patch, updating the mapping's
writeback_index based on pages written isn't quite right;
what the writeback index is really supposed to reflect is
the next page which should be scanned for writeback during
periodic flush.

As in write_cache_pages(), write_cache_pages_da() does
this scanning for us as we assemble the mpd for later
writeout.  If we keep track of the next page after the
current scan, we can easily update writeback_index without
worrying about pages written vs. pages skipped, etc.

Without this, an fsync will reset writeback_index to
0 (its starting index) + however many pages it wrote, which
can mess up the progress of periodic flush.

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---

diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index 163ffca..767e8b5 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -2825,12 +2825,13 @@ static int ext4_da_writepages_trans_blocks(struct inode *inode)
  */
 static int write_cache_pages_da(struct address_space *mapping,
 				struct writeback_control *wbc,
-				struct mpage_da_data *mpd)
+				struct mpage_da_data *mpd,
+				pgoff_t *done_index)
 {
 	int ret = 0;
 	int done = 0;
 	struct pagevec pvec;
-	int nr_pages;
+	unsigned nr_pages;
 	pgoff_t index;
 	pgoff_t end;		/* Inclusive */
 	long nr_to_write = wbc->nr_to_write;
@@ -2845,6 +2846,7 @@ static int write_cache_pages_da(struct address_space *mapping,
 	else
 		tag = PAGECACHE_TAG_DIRTY;
 
+	*done_index = index;
 	while (!done && (index <= end)) {
 		int i;
 
@@ -2868,6 +2870,8 @@ static int write_cache_pages_da(struct address_space *mapping,
 				break;
 			}
 
+			*done_index = page->index + 1;
+
 			lock_page(page);
 
 			/*
@@ -2953,6 +2957,7 @@ static int ext4_da_writepages(struct address_space *mapping,
 	long desired_nr_to_write, nr_to_writebump = 0;
 	loff_t range_start = wbc->range_start;
 	struct ext4_sb_info *sbi = EXT4_SB(mapping->host->i_sb);
+	pgoff_t done_index = 0;
 	pgoff_t end;
 
 	trace_ext4_da_writepages(inode, wbc);
@@ -3075,7 +3080,7 @@ retry:
 		mpd.io_done = 0;
 		mpd.pages_written = 0;
 		mpd.retval = 0;
-		ret = write_cache_pages_da(mapping, wbc, &mpd);
+		ret = write_cache_pages_da(mapping, wbc, &mpd, &done_index);
 		/*
 		 * If we have a contiguous extent of pages and we
 		 * haven't done the I/O yet, map the blocks and submit
@@ -3131,14 +3136,13 @@ retry:
 			 __func__, wbc->nr_to_write, ret);
 
 	/* Update index */
-	index += pages_written;
 	wbc->range_cyclic = range_cyclic;
 	if (wbc->range_cyclic || (range_whole && wbc->nr_to_write > 0))
 		/*
 		 * set the writeback_index so that range_cyclic
 		 * mode will write it back later
 		 */
-		mapping->writeback_index = index;
+		mapping->writeback_index = done_index;
 
 out_writepages:
 	wbc->nr_to_write -= nr_to_writebump;

