From: Theodore Tso <tytso@mit.edu>
Subject: Re: [PATCH e2fsprogs] delete unused nodes in ext2fs_extent_delete
Date: Thu, 29 May 2008 18:24:01 -0400
Message-ID: <20080529222401.GA19617@mit.edu>
References: <48333F05.6080608@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: ext4 development <linux-ext4@vger.kernel.org>
To: Eric Sandeen <sandeen@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from www.church-of-our-saviour.ORG ([69.25.196.31]:40617 "EHLO
	thunker.thunk.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754896AbYE2WYa (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 29 May 2008 18:24:30 -0400
Content-Disposition: inline
In-Reply-To: <48333F05.6080608@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, May 20, 2008 at 04:13:41PM -0500, Eric Sandeen wrote:
> This patch causes ext2fs_extent_delete to remove an
> extent node if the last record in it has been deleted.

I needed to apply this fix on top of your patch; otherwise, when
deleting the last extent in the root node, the current extent pointer
is left pointing at an invalid extent.

					- Ted

diff --git a/lib/ext2fs/extent.c b/lib/ext2fs/extent.c
index c3863b5..19d7feb 100644
--- a/lib/ext2fs/extent.c
+++ b/lib/ext2fs/extent.c
@@ -1225,11 +1225,11 @@ errcode_t ext2fs_extent_delete(ext2_extent_handle_t handle, int flags)
 		ix--;
 		path->curr = ix;
 	}
-	path->entries--;
-	/* if non-root node has no entries left, remove it & parent ptr to it */
-	if (path->entries == 0 && handle->level) {
+	if (--path->entries == 0)
 		path->curr = 0;
 
+	/* if non-root node has no entries left, remove it & parent ptr to it */
+	if (path->entries == 0 && handle->level) {
 		if (!(flags & EXT2_EXTENT_DELETE_KEEP_EMPTY)) {
 			struct ext2fs_extent	extent;
 
@@ -1251,7 +1251,6 @@ errcode_t ext2fs_extent_delete(ext2_extent_handle_t handle, int flags)
 
 		retval = update_path(handle);
 	}
