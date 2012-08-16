From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: NULL pointer dereference in ext4_ext_remove_space on 3.5.1
Date: Wed, 15 Aug 2012 22:46:54 -0400
Message-ID: <20120816024654.GB3781@thunk.org>
References: <CABRT9RAOhaxcYdCxMn5neJ9WT85r=h=7WgZ2dmLaOs-MMqDW9A@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Kernel hackers <linux-kernel@vger.kernel.org>,
	ext4 hackers <linux-ext4@vger.kernel.org>, maze@google.com
To: Marti Raudsepp <marti@juffo.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:44911 "EHLO
	imap.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750828Ab2HPCrD (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 15 Aug 2012 22:47:03 -0400
Content-Disposition: inline
In-Reply-To: <CABRT9RAOhaxcYdCxMn5neJ9WT85r=h=7WgZ2dmLaOs-MMqDW9A@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, Aug 15, 2012 at 09:33:29PM +0300, Marti Raudsepp wrote:
> I was moving and deleting some files between two of my ext4 partitions
> when it suddenly crashed and dropped me into an kernel oops screen
> (below). I'm using ext4 on kernel 3.5.1 (Arch Linux). 

> BUG: unable to handle kernel NULL pointer dereference at 000...00028
> IP: [...] ext4_ext_remove_space+0xaa4/0xef0 [ext4]

Someone else has reported a similar crash, but we don't yet have
enough information to narrow it down quite yet.

If you could try applying the following debugging patch, and then try
to reproduce the failure, it would be really helpful.

Thanks!!

					- Ted

diff --git a/fs/ext4/extents.c b/fs/ext4/extents.c
index 769151d..3394d52 100644
--- a/fs/ext4/extents.c
+++ b/fs/ext4/extents.c
@@ -2432,6 +2432,10 @@ ext4_ext_rm_leaf(handle_t *handle, struct inode *inode,
 
 	/* the header must be checked already in ext4_ext_remove_space() */
 	ext_debug("truncate since %u in leaf to %u\n", start, end);
+	if (!path[depth].p_hdr && !path[depth].p_bh) {
+		EXT4_ERROR_INODE(inode, "depth %d", depth);
+		BUG_ON(1);
+	}
 	if (!path[depth].p_hdr)
 		path[depth].p_hdr = ext_block_hdr(path[depth].p_bh);
 	eh = path[depth].p_hdr;
@@ -2730,6 +2734,10 @@ cont:
 		/* this is index block */
 		if (!path[i].p_hdr) {
 			ext_debug("initialize header\n");
+			if (!path[i].p_hdr && !path[i].p_bh) {
+				EXT4_ERROR_INODE(inode, "i=%d", i);
+				BUG_ON(1);
+			}
 			path[i].p_hdr = ext_block_hdr(path[i].p_bh);
 		}
 
