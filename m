From: Jan Kara <jack@suse.cz>
Subject: Re: bio splits unnecessarily due to BH_Boundary in ext3 direct I/O
Date: Fri, 29 Mar 2013 18:15:36 +0100
Message-ID: <20130329171536.GF5913@quack.suse.cz>
References: <51385177.9030904@sx.jp.nec.com>
 <20130307104854.GB6723@quack.suse.cz>
 <51482381.7010508@sx.jp.nec.com>
 <20130319193132.GE5222@quack.suse.cz>
 <514AC848.6020104@sx.jp.nec.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="VbJkn9YxBvnuCH5J"
Cc: Jan Kara <jack@suse.cz>, akpm@linux-foundation.org,
	adilger.kernel@dilger.ca, linux-ext4@vger.kernel.org,
	linux-fsdevel@vger.kernel.org
To: Kazuya Mio <k-mio@sx.jp.nec.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:36048 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756300Ab3C2RPj (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 29 Mar 2013 13:15:39 -0400
Content-Disposition: inline
In-Reply-To: <514AC848.6020104@sx.jp.nec.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


--VbJkn9YxBvnuCH5J
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu 21-03-13 17:43:52, Kazuya Mio wrote:
> 2013/03/20 4:31, Jan Kara wrote:
> >  I'm not sure I understand. Looking into dio_send_cur_page() it seems may
> >prematurely submit the bio if sdio->boundary is set - in that case we
> >should probably first try to add the page to the bio and submit the bio
> >only after that. Is that what you mean?
> 
> I think the direct I/O works for each page into buffer_head by the following
> three steps:
> 1. submit sdio->bio if sdio->boudary is set
> 2. add sdio->cur_page to sdio->bio by dio_new_bio() or dio_bio_add_page()
> 3. set the curret page to sdio->cur_page in submit_page_section()
> 
> It is true that dio_send_cur_page() submits the bio if sdio->boudary is set.
> However, at this time, this bio does not contain sdio->cur_page and
> the current page do_direct_IO() passed.
  Sorry for not getting to you earlier. So we agree in our analysis. Do you
agree with the attached patch? Does it help your workload?

									Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR

--VbJkn9YxBvnuCH5J
Content-Type: text/x-patch; charset=us-ascii
Content-Disposition: attachment; filename="0001-direct-io-Submit-bio-after-boundary-buffer-is-added-.patch"

>From d9ef6ae45c80b298f7f3b718a101956071709b02 Mon Sep 17 00:00:00 2001
From: Jan Kara <jack@suse.cz>
Date: Fri, 29 Mar 2013 18:05:01 +0100
Subject: [PATCH] direct-io: Submit bio after boundary buffer is added to it

Currently, dio_send_cur_page() submits bio before current page
(sdio->cur_page) is added to the bio if sdio->boundary is set. This is
actually wrong because sdio->boundary means the current buffer is the
last one before metadata needs to be read. So we should rather submit
the bio *after* the current page is added to it.

Reported-by: Kazuya Mio <k-mio@sx.jp.nec.com>
Signed-off-by: Jan Kara <jack@suse.cz>
---
 fs/direct-io.c |   12 ++++++------
 1 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/fs/direct-io.c b/fs/direct-io.c
index e666854..2ccde31 100644
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
@@ -694,6 +688,12 @@ static inline int dio_send_cur_page(struct dio *dio, struct dio_submit *sdio,
 			BUG_ON(ret != 0);
 		}
 	}
+	/*
+	 * Submit now if the underlying fs is about to perform a
+	 * metadata read
+	 */
+	if (sdio->boundary)
+		dio_bio_submit(dio, sdio);
 out:
 	return ret;
 }
-- 
1.7.1


--VbJkn9YxBvnuCH5J--
