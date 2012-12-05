From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [ext4:dev 40/60] fs/ext4/inode.c:1953
 __ext4_journalled_writepage() error: potential NULL dereference 'page_bufs'.
Date: Wed, 5 Dec 2012 00:41:25 -0500
Message-ID: <20121205054125.GC18885@thunk.org>
References: <20121204111011.GD22569@mwanda>
 <1354627545-2792-1-git-send-email-tm@tao.ma>
 <20121204135602.GE22569@mwanda>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Tao Ma <tm@tao.ma>, linux-ext4@vger.kernel.org
To: Dan Carpenter <dan.carpenter@oracle.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:36865 "EHLO
	imap.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750948Ab2LEFl3 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 5 Dec 2012 00:41:29 -0500
Content-Disposition: inline
In-Reply-To: <20121204135602.GE22569@mwanda>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, Dec 04, 2012 at 04:56:02PM +0300, Dan Carpenter wrote:
> It looks good.
> 
> Like I mentioned before Smatch doesn't understand
> ext4_has_inline_data() so it still complains later on in the
> function.  But it's now obvious to a human reader that there won't
> be a NULL dereference.

This is what I plan to fold into the patch.  It should make it easier
for gcc to produce optimized code, as well as being easier to
understand.   Hopefully this should also keep smatch happy.

	      		     	    	      - Ted

diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index 52f715e..ae253a2 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -1917,19 +1917,24 @@ static int __ext4_journalled_writepage(struct page *page,
 	struct inode *inode = mapping->host;
 	struct buffer_head *page_bufs = NULL;
 	handle_t *handle = NULL;
-	int ret = 0;
-	int err;
+	int ret = 0, err = 0;
+	int inline_data = ext4_has_inline_data(inode);
 	struct buffer_head *inode_bh = NULL;
 
 	ClearPageChecked(page);
 
-	if (ext4_has_inline_data(inode)) {
+	if (inline_data) {
 		BUG_ON(page->index != 0);
 		BUG_ON(len > ext4_get_max_inline_size(inode));
 		inode_bh = ext4_journalled_write_inline_data(inode, len, page);
+		if (inode_bh == NULL)
+			goto out;
 	} else {
 		page_bufs = page_buffers(page);
-		BUG_ON(!page_bufs);
+		if (!page_bufs) {
+			BUG();
+			goto out;
+		}
 		walk_page_buffers(handle, page_bufs, 0, len, NULL, bget_one);
 	}
 	/* As soon as we unlock the page, it can go away, but we have
@@ -1944,7 +1949,7 @@ static int __ext4_journalled_writepage(struct page *page,
 
 	BUG_ON(!ext4_handle_valid(handle));
 
-	if (ext4_has_inline_data(inode) && inode_bh) {
+	if (inline_data) {
 		ret = ext4_journal_get_write_access(handle, inode_bh);
 
 		err = ext4_handle_dirty_metadata(handle, inode, inode_bh);
