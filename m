From: Willy Tarreau <w@1wt.eu>
Subject: [2.6.20.17 review 26/58] "ext4_ext_put_in_cache" uses __u32 to receive physical block number
Date: Wed, 22 Aug 2007 11:39:10 +0200
Message-ID: <20070822084011.%N@1wt.eu>
References: <20070822083844.%N@1wt.eu>
Cc: Mingming Cao <cmm@us.ibm.com>, Yan Zheng <yanzheng@21cn.com>,
	<linux-ext4@vger.kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Greg Kroah-Hartman <gregkh@suse.de>, Willy Tarreau <w@1wt.eu>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1762562AbXHVJGo@vger.kernel.org>
Content-Disposition: inline; filename=0026-ext4_ext_put_in_cache-uses-__u32-to-receive-physic.patch
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

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
Cc: <linux-ext4@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
Signed-off-by: Willy Tarreau <w@1wt.eu>
---
 fs/ext4/extents.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/fs/ext4/extents.c b/fs/ext4/extents.c
index dc2724f..14b0b49 100644
--- a/fs/ext4/extents.c
+++ b/fs/ext4/extents.c
@@ -1397,7 +1397,7 @@ int ext4_ext_walk_space(struct inode *inode, unsigned long block,
 
 static void
 ext4_ext_put_in_cache(struct inode *inode, __u32 block,
-			__u32 len, __u32 start, int type)
+			__u32 len, ext4_fsblk_t start, int type)
 {
 	struct ext4_ext_cache *cex;
 	BUG_ON(len == 0);
-- 
1.5.2.5

-- 
