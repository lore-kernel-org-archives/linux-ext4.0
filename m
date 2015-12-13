From: Vegard Nossum <vegard.nossum@oracle.com>
Subject: [PATCH] ext4: fix ext4_find_extent() allocation with order >= MAX_ORDER
Date: Mon, 14 Dec 2015 00:47:12 +0100
Message-ID: <1450050432-16248-1-git-send-email-vegard.nossum@oracle.com>
Cc: linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org,
	Vegard Nossum <vegard.nossum@oracle.com>,
	Quentin Casasnovas <quentin.casasnovas@oracle.com>,
	stable@vger.kernel.org
To: tytso@mit.edu, adilger.kernel@dilger.ca
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Mounting a fuzzed ext4 image on a recent linus/master I see the
following warning:

[ 2.370000] ------------[ cut here ]------------
[ 2.370000] WARNING: CPU: 0 PID: 1005 at mm/page_alloc.c:2989 __alloc_pages_nodemask+0x1afe/0x1d90()
[ 2.370000] Kernel panic - not syncing: panic_on_warn set ...
[ 2.370000]
[ 2.370000] CPU: 0 PID: 1005 Comm: ext4.exe Not tainted 4.4.0-rc4 #1
[ 2.370000] Stack:
[ 2.370000] e0eed440 601097ab 00000000 6187e780
[ 2.370000] 611ba838 601ada46 e0eed460 60acf851
[ 2.370000] 60acf814 60aef320 e0eed580 601ad587
[ 2.370000] Call Trace:
[ 2.370000] [<6005852e>] show_stack+0x1fe/0x430
[ 2.370000] [<60acf851>] dump_stack+0x3d/0x4c
[ 2.370000] [<601ad587>] panic+0x206/0x5be
[ 2.370000] [<60089923>] warn_slowpath_common+0x1e3/0x1f0
[ 2.370000] [<60089b84>] warn_slowpath_null+0x34/0x40
[ 2.370000] [<601c48ce>] __alloc_pages_nodemask+0x1afe/0x1d90
[ 2.370000] [<601c4f0f>] alloc_kmem_pages+0x2f/0x40
[ 2.370000] [<601f6e12>] kmalloc_order+0x32/0xc0
[ 2.370000] [<60246270>] __kmalloc+0x340/0x450
[ 2.370000] [<604469b4>] ext4_find_extent+0x3e4/0x6b0
[ 2.370000] [<60450074>] ext4_ext_map_blocks+0x84/0x2770
[ 2.370000] [<603fb68b>] ext4_map_blocks+0xfb/0xd80
[ 2.370000] [<603fc442>] _ext4_get_block+0x132/0x3c0
[ 2.370000] [<603fd3ab>] ext4_get_block+0x2b/0x40
[...]

This is mm/page_alloc.c:2989 __alloc_pages_nodemask+0x1afe/0x1d90():

	if (order >= MAX_ORDER) {
		WARN_ON_ONCE(!(gfp_mask & __GFP_NOWARN));

and the call into the memory allocator is coming from ext4_find_extent():

	if (!path) {
		/* account possible depth increase */
		path = kzalloc(sizeof(struct ext4_ext_path) * (depth + 2),
			GFP_NOFS);

The problem is that the 'depth' variable is a plain 'short', whereas
the value from the inode is a unsigned 16-bit number; in my case, its
value was -3328.

Simply changing the depth variable to be unsigned short is not
advisable, as that could still break on edge cases like 0xffff in the
subsequent loop without extra care.

Signed-off-by: Vegard Nossum <vegard.nossum@oracle.com>
Cc: Quentin Casasnovas <quentin.casasnovas@oracle.com>
Cc: stable@vger.kernel.org
---
 fs/ext4/extents.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git fs/ext4/extents.c fs/ext4/extents.c
index 551353b..a069cff 100644
--- fs/ext4/extents.c
+++ fs/ext4/extents.c
@@ -863,7 +863,7 @@ ext4_find_extent(struct inode *inode, ext4_lblk_t block,
 	struct ext4_extent_header *eh;
 	struct buffer_head *bh;
 	struct ext4_ext_path *path = orig_path ? *orig_path : NULL;
-	short int depth, i, ppos = 0;
+	int depth, i, ppos = 0;
 	int ret;
 
 	eh = ext_inode_hdr(inode);
-- 
1.9.1
