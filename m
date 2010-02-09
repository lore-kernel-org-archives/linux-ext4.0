From: Jan Kara <jack@suse.cz>
Subject: Re: ext4_da_block_invalidatepages() question
Date: Tue, 9 Feb 2010 16:39:07 +0100
Message-ID: <20100209153906.GC15318@atrey.karlin.mff.cuni.cz>
References: <20100126133608.GC25407@localhost> <20100126153222.GI3187@quack.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: "linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>
To: tytso@mit.edu
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:46361 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754255Ab0BIPjI (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 9 Feb 2010 10:39:08 -0500
Content-Disposition: inline
In-Reply-To: <20100126153222.GI3187@quack.suse.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

>   Hi,
> 
> On Tue 26-01-10 21:36:08, Wu Fengguang wrote:
> > I noticed that ext4_da_block_invalidatepages() does pagevec_lookup()
> > without pagevec_release()/put_page(). Is that OK?
>   Yes, the function looks buggy. Luckily, it is called only in case we are
> not able to allocate space for delay-allocated data which is a bug on its
> own. So people should never hit it.
>   Attached patch should fix the issue. Ted, will you merge it please?
> Thanks.
  Ted, could you please merge the patch below? Thanks!

 								Honza

---
>From 47085f1ac03eaca9e4d7a5f8f1e40e87d3879512 Mon Sep 17 00:00:00 2001
From: Jan Kara <jack@suse.cz>
Date: Tue, 26 Jan 2010 16:15:19 +0100
Subject: [PATCH] ext4: Release page references acquired in ext4_da_block_invalidatepages

We forget to release page references we acquire in
ext4_da_block_invalidatepages.  Luckily, this function gets called only if we
are not able to allocate blocks for delay-allocated data so that function
should better never be called.

Also cleanup handling of index variable.

Reported-by: Wu Fengguang <fengguang.wu@intel.com>
Signed-off-by: Jan Kara <jack@suse.cz>
---
 fs/ext4/inode.c |    7 +++----
 1 files changed, 3 insertions(+), 4 deletions(-)

diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index c818972..1680007 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -2127,17 +2127,16 @@ static void ext4_da_block_invalidatepages(struct mpage_da_data *mpd,
 			break;
 		for (i = 0; i < nr_pages; i++) {
 			struct page *page = pvec.pages[i];
-			index = page->index;
-			if (index > end)
+			if (page->index > end)
 				break;
-			index++;
