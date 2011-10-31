From: Ted Ts'o <tytso@mit.edu>
Subject: Re: [PATCH] Ext4: Don't normalize an falloc request if it can fit
 in 1 extent.
Date: Mon, 31 Oct 2011 18:42:34 -0400
Message-ID: <20111031224234.GP16825@thunk.org>
References: <1319824917-28345-1-git-send-email-gharm@google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Andreas Dilger <adilger.kernel@dilger.ca>,
	linux-ext4@vger.kernel.org
To: Greg Harm <gharm@google.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:35894 "EHLO
	test.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934441Ab1JaWmi (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 31 Oct 2011 18:42:38 -0400
Content-Disposition: inline
In-Reply-To: <1319824917-28345-1-git-send-email-gharm@google.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, Oct 28, 2011 at 11:01:57AM -0700, Greg Harm wrote:
> If an fallocate request fits in EXT_UNINIT_MAX_LEN, then set the
> EXT4_GET_BLOCKS_NO_NORMALIZE flag. For larger fallocate requests,
> let mballoc.c normalize the request.
> This fixes a problem where large requests were being split
> into non-contiguous extents due to haldar@google.com's
> "ext4: do not normalize block requests from fallocate."
> 
> Testing: Checked that 8.x MB falloc'ed files are still laid down
> next to each other (contiguously).
> Checked that the maximum size extent (127.9MB) is allocated as 1
> extent.
> Checked that a 1GB file is somewhat contiguous (often 5-6
> non-contiguous extents now).
> Checked that a 120MB file can still be falloc'ed even if there are no
> single extents large enough to hold it.
> 
> Signed-off-by: Greg Harm <gharm@google.com>

Thanks, I had to tweak the patch slightly to make it apply given the
current ext4 tree.

					- Ted

commit 5f11e7c457769808bafe5048a98c5cfd624e85f3
Author: Greg Harm <gharm@google.com>
Date:   Mon Oct 31 18:41:47 2011 -0400

    ext4: Don't normalize an falloc request if it can fit in 1 extent.
    
    If an fallocate request fits in EXT_UNINIT_MAX_LEN, then set the
    EXT4_GET_BLOCKS_NO_NORMALIZE flag. For larger fallocate requests,
    let mballoc.c normalize the request.
    
    This fixes a problem where large requests were being split into
    non-contiguous extents due to commit 556b27abf73: ext4: do not
    normalize block requests from fallocate.
    
    Testing:
    *) Checked that 8.x MB falloc'ed files are still laid down next to
    each other (contiguously).
    *) Checked that the maximum size extent (127.9MB) is allocated as 1
    extent.
    *) Checked that a 1GB file is somewhat contiguous (often 5-6
    non-contiguous extents now).
    *) Checked that a 120MB file can still be falloc'ed even if there are
    no single extents large enough to hold it.
    
    Signed-off-by: Greg Harm <gharm@google.com>
    Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>

diff --git a/fs/ext4/extents.c b/fs/ext4/extents.c
index e585caa..9dfdf8f 100644
--- a/fs/ext4/extents.c
+++ b/fs/ext4/extents.c
@@ -4336,10 +4336,16 @@ long ext4_fallocate(struct file *file, int mode, loff_t offset, loff_t len)
 		trace_ext4_fallocate_exit(inode, offset, max_blocks, ret);
 		return ret;
 	}
-	flags = EXT4_GET_BLOCKS_CREATE_UNINIT_EXT |
-		EXT4_GET_BLOCKS_NO_NORMALIZE;
+	flags = EXT4_GET_BLOCKS_CREATE_UNINIT_EXT;
 	if (mode & FALLOC_FL_KEEP_SIZE)
 		flags |= EXT4_GET_BLOCKS_KEEP_SIZE;
+	/*
+	 * Don't normalize the request if it can fit in one extent so
+	 * that it doesn't get unnecessarily split into multiple
+	 * extents.
+	 */
+	if (len <= EXT_UNINIT_MAX_LEN << blkbits)
+		flags |= EXT4_GET_BLOCKS_NO_NORMALIZE;
 retry:
 	while (ret >= 0 && ret < max_blocks) {
 		map.m_lblk = map.m_lblk + ret;
