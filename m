From: akpm@linux-foundation.org
Subject: - ext4_ext_put_in_cache-uses-__u32-to-receive-physical.patch removed from -mm tree
Date: Tue, 31 Jul 2007 16:55:25 -0700
Message-ID: <200707312355.l6VNtP6g029224@imap1.linux-foundation.org>
To: cmm@us.ibm.com, linux-ext4@vger.kernel.org, stable@kernel.org,
	yanzheng@21cn.com, mm-commits@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:34423 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1761044AbXHAAR2 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>);
	Tue, 31 Jul 2007 20:17:28 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org


The patch titled
     "ext4_ext_put_in_cache" uses __u32 to receive physical block number
has been removed from the -mm tree.  Its filename was
     ext4_ext_put_in_cache-uses-__u32-to-receive-physical.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: "ext4_ext_put_in_cache" uses __u32 to receive physical block number
From: Mingming Cao <cmm@us.ibm.com>

Yan Zheng wrote:

> I think I found a bug in ext4/extents.c, "ext4_ext_put_in_cache" uses
> "__u32" to receive physical block number.  "ext4_ext_put_in_cache" is
> used in "ext4_ext_get_blocks", it sets ext4 inode's extent cache
> according most recently tree lookup (higher 16 bits of saved physical
> block number are always zero). when serving a mapping request,
> "ext4_ext_get_blocks" first check whether the logical block is in
> inode's extent cache. if the logical block is in the cache and the
> cached region isn't a gap, "ext4_ext_get_blocks" gets physical block
> number by using cached region's physical block number and offset in
> the cached region.  as described above, "ext4_ext_get_blocks" may
> return wrong result when there are physical block numbers bigger than
> 0xffffffff.
>

You are right.  Thanks for reporting this!

Signed-off-by: Mingming Cao <cmm@us.ibm.com>
Cc: Yan Zheng <yanzheng@21cn.com>
Cc: <stable@kernel.org>
Cc: <linux-ext4@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ext4/extents.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN fs/ext4/extents.c~ext4_ext_put_in_cache-uses-__u32-to-receive-physical fs/ext4/extents.c
--- a/fs/ext4/extents.c~ext4_ext_put_in_cache-uses-__u32-to-receive-physical
+++ a/fs/ext4/extents.c
@@ -1544,7 +1544,7 @@ int ext4_ext_walk_space(struct inode *in
 
 static void
 ext4_ext_put_in_cache(struct inode *inode, __u32 block,
-			__u32 len, __u32 start, int type)
+			__u32 len, ext4_fsblk_t start, int type)
 {
 	struct ext4_ext_cache *cex;
 	BUG_ON(len == 0);
_

Patches currently in -mm which might be from cmm@us.ibm.com are

origin.patch
convert-ill-defined-log2-to-ilog2.patch
ext2-reservations.patch
fix-for-ext2-reservation.patch
ext2-balloc-use-io_error-label.patch
