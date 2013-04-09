From: Jan Kara <jack@suse.cz>
Subject: Re: bio splits unnecessarily due to BH_Boundary in ext3 direct I/O
Date: Tue, 9 Apr 2013 17:40:59 +0200
Message-ID: <20130409154059.GA15214@quack.suse.cz>
References: <51385177.9030904@sx.jp.nec.com>
 <20130307104854.GB6723@quack.suse.cz>
 <51482381.7010508@sx.jp.nec.com>
 <20130319193132.GE5222@quack.suse.cz>
 <514AC848.6020104@sx.jp.nec.com>
 <20130329171536.GF5913@quack.suse.cz>
 <51594494.3070207@sx.jp.nec.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="sm4nu43k4a2Rpi4c"
Cc: Jan Kara <jack@suse.cz>, akpm@linux-foundation.org,
	adilger.kernel@dilger.ca, linux-ext4@vger.kernel.org,
	linux-fsdevel@vger.kernel.org
To: Kazuya Mio <k-mio@sx.jp.nec.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:34281 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760614Ab3DIPlG (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 9 Apr 2013 11:41:06 -0400
Content-Disposition: inline
In-Reply-To: <51594494.3070207@sx.jp.nec.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


--sm4nu43k4a2Rpi4c
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon 01-04-13 17:25:56, Kazuya Mio wrote:
> 2013/03/30 2:15, Jan Kara wrote:
> >  Sorry for not getting to you earlier. So we agree in our analysis. Do you
> >agree with the attached patch? Does it help your workload?
> 
> According to your two patches, direct I/O works as the following steps:
> 1. add sdio->cur_page to sdio->bio by dio_new_bio() or dio_bio_add_page()
> 2. submit sdio->bio if sdio->boudary is set
> 3. set the curret page to sdio->cur_page in submit_page_section()
> 
> Only one page is submitted separately because of submitting bio before step 3.
> 
> For example, we write 52KB data with O_DIRECT, it is ideal that filesystem
> submits a bio twice (48KB and 4KB). However, after applying your two patches,
> 52KB data is split into three bios (44KB, 4KB and 4KB).
  Ah, thanks for pointing that out. It took me a while to get things
correct but with the attached patch (on top of the first patch), I'm
getting all the bios with maximum size. I've also checked that for direct
IO on ramdisk, I get about 3x faster IO on ext3 with both patches applied.
I also get a decent 10% speedup of dio reads on standard harddrive.

								Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR

--sm4nu43k4a2Rpi4c
Content-Type: text/x-patch; charset=us-ascii
Content-Disposition: attachment; filename="0001-direct-io-Submit-bio-after-boundary-buffer-is-added-.patch"

>From 8e0ae2a449f996e0ea5ad865d3147ee6758743aa Mon Sep 17 00:00:00 2001
From: Jan Kara <jack@suse.cz>
Date: Fri, 29 Mar 2013 18:05:01 +0100
Subject: [PATCH] direct-io: Submit bio after boundary buffer is added to it

Currently, dio_send_cur_page() submits bio before current page and
cached sdio->cur_page is added to the bio if sdio->boundary is set. This
is actually wrong because sdio->boundary means the current buffer is the
last one before metadata needs to be read. So we should rather submit
the bio after the current page is added to it.

Reported-by: Kazuya Mio <k-mio@sx.jp.nec.com>
Signed-off-by: Jan Kara <jack@suse.cz>
---
 fs/direct-io.c |   28 +++++++++++-----------------
 1 files changed, 11 insertions(+), 17 deletions(-)

diff --git a/fs/direct-io.c b/fs/direct-io.c
index e666854..c57add7 100644
--- a/fs/direct-io.c
+++ b/fs/direct-io.c
@@ -672,12 +672,6 @@ static inline int dio_send_cur_page(struct dio *dio, struct dio_submit *sdio,
 		if (sdio->final_block_in_bio != sdio->cur_page_block ||
 		    cur_offset != bio_next_offset)
 			dio_bio_submit(dio, sdio);
-		/*
-		 * Submit now if the underlying fs is about to perform a
-		 * metadata read
-		 */
-		else if (sdio->boundary)
-			dio_bio_submit(dio, sdio);
 	}
 
 	if (sdio->bio == NULL) {
@@ -737,16 +731,6 @@ submit_page_section(struct dio *dio, struct dio_submit *sdio, struct page *page,
 	    sdio->cur_page_block +
 	    (sdio->cur_page_len >> sdio->blkbits) == blocknr) {
 		sdio->cur_page_len += len;
-
-		/*
-		 * If sdio->boundary then we want to schedule the IO now to
-		 * avoid metadata seeks.
-		 */
-		if (sdio->boundary) {
-			ret = dio_send_cur_page(dio, sdio, map_bh);
-			page_cache_release(sdio->cur_page);
-			sdio->cur_page = NULL;
-		}
 		goto out;
 	}
 
@@ -758,7 +742,7 @@ submit_page_section(struct dio *dio, struct dio_submit *sdio, struct page *page,
 		page_cache_release(sdio->cur_page);
 		sdio->cur_page = NULL;
 		if (ret)
-			goto out;
+			return ret;
 	}
 
 	page_cache_get(page);		/* It is in dio */
@@ -768,6 +752,16 @@ submit_page_section(struct dio *dio, struct dio_submit *sdio, struct page *page,
 	sdio->cur_page_block = blocknr;
 	sdio->cur_page_fs_offset = sdio->block_in_file << sdio->blkbits;
 out:
+	/*
+	 * If sdio->boundary then we want to schedule the IO now to
+	 * avoid metadata seeks.
+	 */
+	if (sdio->boundary) {
+		ret = dio_send_cur_page(dio, sdio, map_bh);
+		dio_bio_submit(dio, sdio);
+		page_cache_release(sdio->cur_page);
+		sdio->cur_page = NULL;
+	}
 	return ret;
 }
 
-- 
1.7.1


--sm4nu43k4a2Rpi4c--
