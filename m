From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH 3/3] ext3: Avoid starting a transaction in writepage
	when not necessary
Date: Mon, 30 Mar 2009 15:22:08 +0200
Message-ID: <20090330132208.GA30897@duck.suse.cz>
References: <1238185471-31152-1-git-send-email-tytso@mit.edu> <1238185471-31152-2-git-send-email-tytso@mit.edu> <1238185471-31152-3-git-send-email-tytso@mit.edu> <1238185471-31152-4-git-send-email-tytso@mit.edu> <20090327222346.GJ31071@duck.suse.cz> <20090327230341.GF5176@mit.edu>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="liOOAslEiF7prFVr"
To: Theodore Tso <tytso@mit.edu>,
	Linux Kernel Developers List <linux-kernel@vger.kernel.org>,
	Ext4 Developers List <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:34095 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751043AbZC3NWM (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 30 Mar 2009 09:22:12 -0400
Content-Disposition: inline
In-Reply-To: <20090327230341.GF5176@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


--liOOAslEiF7prFVr
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Fri 27-03-09 19:03:41, Theodore Tso wrote:
> On Fri, Mar 27, 2009 at 11:23:46PM +0100, Jan Kara wrote:
> > On Fri 27-03-09 16:24:31, Theodore Ts'o wrote:
> > > From: Jan Kara <jack@suse.cz>
> > > 
> > > We don't have to start a transaction in writepage() when all the blocks
> > > are a properly allocated. Even in ordered mode either the data has been
> > > written via write() and they are thus already added to transaction's list
> > > or the data was written via mmap and then it's random in which transaction
> > > they get written anyway.
> > > 
> > > This should help VM to pageout dirty memory without blocking on transaction
> > > commits.
> > > 
> > > Signed-off-by: Jan Kara <jack@suse.cz>
> > > Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
> >   Please, use the patch below instead (and I'd also wait a few days for
> > Mingo to check whether it also helps him). It also changes data=writeback
> > mode in the same way and it adheres to coding style...
> 
> FYI, Looks like Linus has already cherry-picked your first patch from
> LKML and dropped it into mainline.  My other two patches haven't gone
> in yet as far as I can tell.
> 
> So we'll need to do a delta patch that has the differences from your
> new patch and what Linus has already pulled into mainline.
  Thanks for letting me know. Attached is a rediff against current
Linus's tree.

									Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR

--liOOAslEiF7prFVr
Content-Type: text/x-patch; charset=us-ascii
Content-Disposition: attachment; filename="0001-ext3-Avoid-starting-a-transaction-in-writepage-when.patch"

>From f53cf013259b9c782b79f4c1be49d5961884f867 Mon Sep 17 00:00:00 2001
From: Jan Kara <jack@suse.cz>
Date: Mon, 30 Mar 2009 15:14:28 +0200
Subject: [PATCH] ext3: Avoid starting a transaction in writepage when not necessary

This does the same as commit 9e80d407736161d9b8b0c5a0d44f786e44c322ea
(avoid starting a transaction when no block allocation is needed)
but for data=writeback mode of ext3. We also cleanup the data=ordered
case a bit to stick to coding style...

Signed-off-by: Jan Kara <jack@suse.cz>
---
 fs/ext3/inode.c |   23 ++++++++++++++++++-----
 1 files changed, 18 insertions(+), 5 deletions(-)

diff --git a/fs/ext3/inode.c b/fs/ext3/inode.c
index 4a09ff1..70c86b0 100644
--- a/fs/ext3/inode.c
+++ b/fs/ext3/inode.c
@@ -1512,12 +1512,16 @@ static int ext3_ordered_writepage(struct page *page,
 	if (!page_has_buffers(page)) {
 		create_empty_buffers(page, inode->i_sb->s_blocksize,
 				(1 << BH_Dirty)|(1 << BH_Uptodate));
-	} else if (!walk_page_buffers(NULL, page_buffers(page), 0, PAGE_CACHE_SIZE, NULL, buffer_unmapped)) {
-		/* Provide NULL instead of get_block so that we catch bugs if buffers weren't really mapped */
-		return block_write_full_page(page, NULL, wbc);
+		page_bufs = page_buffers(page);
+	} else {
+		page_bufs = page_buffers(page);
+		if (!walk_page_buffers(NULL, page_bufs, 0, PAGE_CACHE_SIZE,
+				       NULL, buffer_unmapped)) {
+			/* Provide NULL get_block() to catch bugs if buffers
+			 * weren't really mapped */
+			return block_write_full_page(page, NULL, wbc);
+		}
 	}
-	page_bufs = page_buffers(page);
--liOOAslEiF7prFVr--
