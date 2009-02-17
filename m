From: Theodore Ts'o <tytso@mit.edu>
Subject: [PATCH FOR-STABLE-2.6.27 04/24] ext4: avoid ext4_error when mounting a fs with a single bg
Date: Tue, 17 Feb 2009 10:58:24 -0500
Message-ID: <1234886324-15105-5-git-send-email-tytso@mit.edu>
References: <1234886324-15105-1-git-send-email-tytso@mit.edu>
 <1234886324-15105-2-git-send-email-tytso@mit.edu>
 <1234886324-15105-3-git-send-email-tytso@mit.edu>
 <1234886324-15105-4-git-send-email-tytso@mit.edu>
Cc: linux-ext4@vger.kernel.org,
	"Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>,
	"Theodore Ts'o" <tytso@mit.edu>
To: stable@kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from thunk.org ([69.25.196.29]:35292 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751894AbZBQP7W (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 17 Feb 2009 10:59:22 -0500
In-Reply-To: <1234886324-15105-4-git-send-email-tytso@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

From: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>

Remove some completely unneeded code which which caused an ext4_error
to be generated when mounting a file system with only a single block
group.

Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
Cc: stable@kernel.org
(cherry picked from commit 565a9617b2151e21b22700e97a8b04e70e103153)
---
 fs/ext4/super.c |    4 ----
 1 files changed, 0 insertions(+), 4 deletions(-)

diff --git a/fs/ext4/super.c b/fs/ext4/super.c
index 787455a..2dabc32 100644
--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -1493,7 +1493,6 @@ static int ext4_fill_flex_info(struct super_block *sb)
 	ext4_group_t flex_group_count;
 	ext4_group_t flex_group;
 	int groups_per_flex = 0;
-	__u64 block_bitmap = 0;
 	int i;
 
 	if (!sbi->s_es->s_log_groups_per_flex) {
@@ -1516,9 +1515,6 @@ static int ext4_fill_flex_info(struct super_block *sb)
 		goto failed;
 	}
 
-	gdp = ext4_get_group_desc(sb, 1, &bh);
-	block_bitmap = ext4_block_bitmap(sb, gdp) - 1;
