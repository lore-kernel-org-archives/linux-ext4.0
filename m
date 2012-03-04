From: Ted Ts'o <tytso@mit.edu>
Subject: Re: [Bug 42859] New: kernel BUG at fs/ext4/extents.c:1953
Date: Sun, 4 Mar 2012 15:27:08 -0500
Message-ID: <20120304202708.GA9087@thunk.org>
References: <bug-42859-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, bugzilla-daemon@bugzilla.kernel.org
To: merll@web.de
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:46783 "EHLO
	test.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754888Ab2CDU1J (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sun, 4 Mar 2012 15:27:09 -0500
Content-Disposition: inline
In-Reply-To: <bug-42859-13602@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sun, Mar 04, 2012 at 02:39:09PM +0000, bugzilla-daemon@bugzilla.kernel.org wrote:
> 
> Messages "kernel BUG at fs/ext4/extents.c:1953" occur, which seem to be
> triggered when running certain processes (reproducible with init and gdm). The
> volume can be mounted without any apparent problems and e2fsck does not report
> any errors. Nevertheless, the file system may have been corrupted during an
> earlier system crash.

Would you be willing to apply the following patch, and then see which
inode number gets reported (and whether it is always the same inode
number or one that varies) and then report back the results of running
the following debugfs commands?

(assuming the inode number is 12345)

debugfs /dev/sdX

debugfs: stat <12345>
degbufs: ex <12345>

Thanks!!

					- Ted

diff --git a/fs/ext4/extents.c b/fs/ext4/extents.c
index 74f23c2..0393542 100644
--- a/fs/ext4/extents.c
+++ b/fs/ext4/extents.c
@@ -1949,7 +1949,13 @@ ext4_ext_put_in_cache(struct inode *inode, ext4_lblk_t block,
 			__u32 len, ext4_fsblk_t start)
 {
 	struct ext4_ext_cache *cex;
-	BUG_ON(len == 0);
+	if (unlikely(len == 0)) {
+		ext4_msg(inode->i_sb, KERN_CRIT,
+			 "ext4_put_in_cache has len == 0: "
+			 "ino %u, lblk %lu, pblk %llu", inode->i_ino,
+			 block, start);
+		BUG_ON(1);
+	}
 	spin_lock(&EXT4_I(inode)->i_block_reservation_lock);
 	trace_ext4_ext_put_in_cache(inode, block, len, start);
 	cex = &EXT4_I(inode)->i_cached_extent;
