From: Jan Kara <jack@suse.cz>
Subject: Re: ext4_da_block_invalidatepages() question
Date: Tue, 26 Jan 2010 16:32:22 +0100
Message-ID: <20100126153222.GI3187@quack.suse.cz>
References: <20100126133608.GC25407@localhost>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="/04w6evG8XlLl3ft"
Cc: Jan Kara <jack@suse.cz>,
	"linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>,
	tytso@mit.edu
To: Wu Fengguang <fengguang.wu@intel.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cantor.suse.de ([195.135.220.2]:43335 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752107Ab0AZPcS (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 26 Jan 2010 10:32:18 -0500
Content-Disposition: inline
In-Reply-To: <20100126133608.GC25407@localhost>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


--/04w6evG8XlLl3ft
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

  Hi,

On Tue 26-01-10 21:36:08, Wu Fengguang wrote:
> I noticed that ext4_da_block_invalidatepages() does pagevec_lookup()
> without pagevec_release()/put_page(). Is that OK?
  Yes, the function looks buggy. Luckily, it is called only in case we are
not able to allocate space for delay-allocated data which is a bug on its
own. So people should never hit it.
  Attached patch should fix the issue. Ted, will you merge it please?
Thanks.

								Honza

-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR

--/04w6evG8XlLl3ft
Content-Type: text/x-patch; charset=us-ascii
Content-Disposition: attachment; filename="0001-ext4-Release-page-references-acquired-in-ext4_da_blo.patch"

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
--/04w6evG8XlLl3ft--
