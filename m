From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 1/3] ext4: Allow IO submission without io_end
Date: Sun, 30 Apr 2017 18:01:01 -0400
Message-ID: <20170430220101.trrgiaphp756kxw4@thunk.org>
References: <20170411135418.9638-1-jack@suse.cz>
 <20170411135418.9638-2-jack@suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Jan Kara <jack@suse.cz>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:34902 "EHLO imap.thunk.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1425656AbdD3WBE (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Sun, 30 Apr 2017 18:01:04 -0400
Content-Disposition: inline
In-Reply-To: <20170411135418.9638-2-jack@suse.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, Apr 11, 2017 at 03:54:16PM +0200, Jan Kara wrote:
> Allow submission of bio through ext4_bio_write_page() without io_end.
> For the case where we are not converting unwritten extents we don't need
> io_end for anything anyway.

So this patch doesn't work, because if there is an error, we need the
inode in io_end so we can set the error in the mapping:

> @@ -298,23 +298,20 @@ static void ext4_end_bio(struct bio *bio)
>  	ext4_io_end_t *io_end = bio->bi_private;
>  	sector_t bi_sector = bio->bi_iter.bi_sector;
>  
> -	BUG_ON(!io_end);
>  	bio->bi_end_io = NULL;
>  
>  	if (bio->bi_error) {
>  		struct inode *inode = io_end->inode;
                                      ^^^^^^^^^  NULL pointer dereference

Otherwise, we can crash above.  The best way to reproduce it is
"gce-xfstests -c ext3 -C 10 generic/081" (it will usually crash on the
very first attempt to run generic/081).  It doesn't repro using
kvm-xfstests for me, so there does seem to be a certain amount of
timing that's needed to trigger it.  I assume the reason using the
ext3 configuration is necessary to ticklet the bug is because it turns
off delayed allocation --- and we probably don't have any workloads in
xfstests where we are doing writes to preallocated blocks while we
trigger an I/O error by letting a snapshot fill up, which is why you
didn't notice this when doing your tests using 4k and 1k block sizes.

To fix this, I've dropped the first two patches in your series, and
just stuck with the last patch ("ext4: avoid unnecessary transaction
stalls during writeback") with the following patch applied on top (I
will merge it into your patch).  We still allocate and deallocate
io_end everywhere, but we do avoid the unnecessary handle starts and
thus, the transaction stalls.

Cheers,

						- Ted

commit d4d6313a2298ec91e6f8bc95ed0d437f33453b45
Author: Theodore Ts'o <tytso@mit.edu>
Date:   Sun Apr 30 16:03:06 2017 -0400

    patch fixup-avoid-unnecessary-transaction-stalls

diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index c5eb8b861629..c65e29953800 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -1643,6 +1643,7 @@ struct mpage_da_data {
 	 */
 	struct ext4_map_blocks map;
 	struct ext4_io_submit io_submit;	/* IO submission data */
+	unsigned int do_map:1;
 };
 
 static void mpage_release_unused_pages(struct mpage_da_data *mpd,
@@ -2180,7 +2181,7 @@ static bool mpage_add_bh_to_extent(struct mpage_da_data *mpd, ext4_lblk_t lblk,
 	/* First block in the extent? */
 	if (map->m_len == 0) {
 		/* We cannot map unless handle is started... */
-		if (!mpd->io_submit.io_end)
+		if (!mpd->do_map)
 			return false;
 		map->m_lblk = lblk;
 		map->m_len = 1;
@@ -2235,7 +2236,7 @@ static int mpage_process_page_bufs(struct mpage_da_data *mpd,
 			if (mpd->map.m_len)
 				return 0;
 			/* Buffer needs mapping and handle is not started? */
-			if (!mpd->io_submit.io_end)
+			if (!mpd->do_map)
 				return 0;
 			/* Everything mapped so far and we hit EOF */
 			break;
@@ -2760,9 +2761,17 @@ static int ext4_writepages(struct address_space *mapping,
 	 * in the block layer on device congestion while having transaction
 	 * started.
 	 */
+	mpd.do_map = 0;
+	mpd.io_submit.io_end = ext4_init_io_end(inode, GFP_KERNEL);
+	if (!mpd.io_submit.io_end) {
+		ret = -ENOMEM;
+		goto unplug;
+	}
 	ret = mpage_prepare_extent_to_map(&mpd);
 	/* Submit prepared bio */
 	ext4_io_submit(&mpd.io_submit);
+	ext4_put_io_end_defer(mpd.io_submit.io_end);
+	mpd.io_submit.io_end = NULL;
 	/* Unlock pages we didn't use */
 	mpage_release_unused_pages(&mpd, false);
 	if (ret < 0)
@@ -2799,6 +2808,7 @@ static int ext4_writepages(struct address_space *mapping,
 			mpd.io_submit.io_end = NULL;
 			break;
 		}
+		mpd.do_map = 1;
 
 		trace_ext4_da_write_pages(inode, mpd.first_page, mpd.wbc);
 		ret = mpage_prepare_extent_to_map(&mpd);
@@ -2829,6 +2839,7 @@ static int ext4_writepages(struct address_space *mapping,
 		if (!ext4_handle_valid(handle) || handle->h_sync == 0) {
 			ext4_journal_stop(handle);
 			handle = NULL;
+			mpd.do_map = 0;
 		}
 		/* Submit prepared bio */
 		ext4_io_submit(&mpd.io_submit);
