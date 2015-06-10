From: Rasmus Villemoes <linux@rasmusvillemoes.dk>
Subject: [PATCH] ext4: mballoc: avoid 20-argument function call
Date: Thu, 11 Jun 2015 00:28:02 +0200
Message-ID: <1433975282-20694-1-git-send-email-linux@rasmusvillemoes.dk>
Cc: Rasmus Villemoes <linux@rasmusvillemoes.dk>,
	linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org
To: "Theodore Ts'o" <tytso@mit.edu>,
	Andreas Dilger <adilger.kernel@dilger.ca>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Making a function call with 20 arguments is rather expensive in both
stack and .text. In this case, doing the formatting manually doesn't
make it any less readable, so we might as well save 155 bytes of .text
and 112 bytes of stack.

Signed-off-by: Rasmus Villemoes <linux@rasmusvillemoes.dk>
---
 fs/ext4/mballoc.c | 9 +++------
 1 file changed, 3 insertions(+), 6 deletions(-)

diff --git a/fs/ext4/mballoc.c b/fs/ext4/mballoc.c
index 8d1e60214ef0..a74bbbd6d57d 100644
--- a/fs/ext4/mballoc.c
+++ b/fs/ext4/mballoc.c
@@ -2257,12 +2257,9 @@ static int ext4_mb_seq_groups_show(struct seq_file *seq, void *v)
 
 	group--;
 	if (group == 0)
-		seq_printf(seq, "#%-5s: %-5s %-5s %-5s "
-				"[ %-5s %-5s %-5s %-5s %-5s %-5s %-5s "
-				  "%-5s %-5s %-5s %-5s %-5s %-5s %-5s ]\n",
-			   "group", "free", "frags", "first",
-			   "2^0", "2^1", "2^2", "2^3", "2^4", "2^5", "2^6",
-			   "2^7", "2^8", "2^9", "2^10", "2^11", "2^12", "2^13");
+		seq_puts(seq, "#group: free  frags first ["
+			      " 2^0   2^1   2^2   2^3   2^4   2^5   2^6  "
+			      " 2^7   2^8   2^9   2^10  2^11  2^12  2^13  ]");
 
 	i = (sb->s_blocksize_bits + 2) * sizeof(sg.info.bb_counters[0]) +
 		sizeof(struct ext4_group_info);
-- 
2.1.3
