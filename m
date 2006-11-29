From: Mingming Cao <cmm@us.ibm.com>
Subject: [PATCH 8/12] ext4 balloc: fix off-by-one against grp_goal
Date: Tue, 28 Nov 2006 20:15:06 -0800
Message-ID: <1164773706.4341.42.camel@localhost.localdomain>
References: <20061114014125.dd315fff.akpm@osdl.org>
	 <20061114184919.GA16020@skynet.ie>
	 <Pine.LNX.4.64.0611141858210.11956@blonde.wat.veritas.com>
	 <20061114113120.d4c22b02.akpm@osdl.org>
	 <Pine.LNX.4.64.0611142111380.19259@blonde.wat.veritas.com>
	 <Pine.LNX.4.64.0611151404260.11929@blonde.wat.veritas.com>
	 <20061115214534.72e6f2e8.akpm@osdl.org> <455C0B6F.7000201@us.ibm.com>
	 <20061115232228.afaf42f2.akpm@osdl.org>
	 <1163666960.4310.40.camel@localhost.localdomain>
	 <20061116011351.1401a00f.akpm@osdl.org>
	 <1163708116.3737.12.camel@dyn9047017103.beaverton.ibm.com>
	 <20061116132724.1882b122.akpm@osdl.org>
	 <Pine.LNX.4.64.0611201544510.16530@blonde.wat.veritas.com>
	 <1164073652.20900.34.camel@dyn9047017103.beaverton.ibm.com>
	 <Pine.LNX.4.64.0611210508270.22957@blonde.wat.veritas.com>
	 <1164156193.3804.48.camel@dyn9047017103.beaverton.ibm.com>
	 <Pine.LNX.4.64.0611281659190.29701@blonde.wat.veritas.com>
	 <Pine.LNX.4.64.0611281740110.29701@blonde.wat.veritas.com>
Reply-To: cmm@us.ibm.com
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Cc: Andrew Morton <akpm@osdl.org>, Mel Gorman <mel@skynet.ie>,
	"Martin J. Bligh" <mbligh@mbligh.org>,
	linux-kernel@vger.kernel.org,
	"linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1758763AbWK2EQp@vger.kernel.org>
To: Hugh Dickins <hugh@veritas.com>
In-Reply-To: <Pine.LNX.4.64.0611281740110.29701@blonde.wat.veritas.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org


Subject: ext2 balloc: fix off-by-one against grp_goal
From: Hugh Dickins <hugh@veritas.com>

grp_goal 0 is a genuine goal (unlike -1), so ext2_try_to_allocate_with_rsv
should treat it as such.
------------------------------------------------------
Sync up with ext2 reservation fix  in ext4
Signed-off-by: Mingming Cao <cmm@us.ibm.com>
---


---

 linux-2.6.19-rc5-cmm/fs/ext4/balloc.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN fs/ext4/balloc.c~ext4-balloc-fix-off-by-one-against-grp_goal fs/ext4/balloc.c
--- linux-2.6.19-rc5/fs/ext4/balloc.c~ext4-balloc-fix-off-by-one-against-grp_goal	2006-11-28 19:37:05.000000000 -0800
+++ linux-2.6.19-rc5-cmm/fs/ext4/balloc.c	2006-11-28 19:37:05.000000000 -0800
@@ -1288,7 +1288,7 @@ ext4_try_to_allocate_with_rsv(struct sup
 	}
 	/*
 	 * grp_goal is a group relative block number (if there is a goal)
-	 * 0 < grp_goal < EXT4_BLOCKS_PER_GROUP(sb)
+	 * 0 <= grp_goal < EXT4_BLOCKS_PER_GROUP(sb)
 	 * first block is a filesystem wide block number
 	 * first block is the block number of the first block in this group
 	 */
@@ -1324,7 +1324,7 @@ ext4_try_to_allocate_with_rsv(struct sup
 			if (!goal_in_my_reservation(&my_rsv->rsv_window,
 							grp_goal, group, sb))
 				grp_goal = -1;
-		} else if (grp_goal > 0) {
+		} else if (grp_goal >= 0) {
 			int curr = my_rsv->rsv_end -
 					(grp_goal + group_first_block) + 1;
 

_
