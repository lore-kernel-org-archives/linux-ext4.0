From: Theodore Ts'o <tytso@mit.edu>
Subject: [FOR-STABLE 16/20] ext4: Convert to host order before using the values.
Date: Sun, 16 Nov 2008 11:05:36 -0500
Message-ID: <1226851540-8032-17-git-send-email-tytso@mit.edu>
References: <1226851540-8032-1-git-send-email-tytso@mit.edu>
 <1226851540-8032-2-git-send-email-tytso@mit.edu>
 <1226851540-8032-3-git-send-email-tytso@mit.edu>
 <1226851540-8032-4-git-send-email-tytso@mit.edu>
 <1226851540-8032-5-git-send-email-tytso@mit.edu>
 <1226851540-8032-6-git-send-email-tytso@mit.edu>
 <1226851540-8032-7-git-send-email-tytso@mit.edu>
 <1226851540-8032-8-git-send-email-tytso@mit.edu>
 <1226851540-8032-9-git-send-email-tytso@mit.edu>
 <1226851540-8032-10-git-send-email-tytso@mit.edu>
 <1226851540-8032-11-git-send-email-tytso@mit.edu>
 <1226851540-8032-12-git-send-email-tytso@mit.edu>
 <1226851540-8032-13-git-send-email-tytso@mit.edu>
 <1226851540-8032-14-git-send-email-tytso@mit.edu>
 <1226851540-8032-15-git-send-email-tytso@mit.edu>
 <1226851540-8032-16-git-send-email-tytso@mit.edu>
Cc: Ext4 Developers List <linux-ext4@vger.kernel.org>,
	"Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>,
	"Theodore Ts'o" <tytso@mit.edu>
To: stable@kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from www.church-of-our-saviour.ORG ([69.25.196.31]:59007 "EHLO
	thunker.thunk.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753517AbYKPQXi (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sun, 16 Nov 2008 11:23:38 -0500
In-Reply-To: <1226851540-8032-16-git-send-email-tytso@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

From: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>

Use le16_to_cpu to read the s_reserved_gdt_blocks values
from super block.

Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
(cherry picked from commit d94e99a64c3beece22dbfb2b335771a59184eb0a)
---
 fs/ext4/super.c |    5 ++---
 1 files changed, 2 insertions(+), 3 deletions(-)

diff --git a/fs/ext4/super.c b/fs/ext4/super.c
index e1255cc..b6fdc2b 100644
--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -1506,9 +1506,8 @@ static int ext4_fill_flex_info(struct super_block *sb)
 
 	/* We allocate both existing and potentially added groups */
 	flex_group_count = ((sbi->s_groups_count + groups_per_flex - 1) +
-			    ((sbi->s_es->s_reserved_gdt_blocks +1 ) <<
-			      EXT4_DESC_PER_BLOCK_BITS(sb))) /
-			   groups_per_flex;
+			((le16_to_cpu(sbi->s_es->s_reserved_gdt_blocks) + 1) <<
+			      EXT4_DESC_PER_BLOCK_BITS(sb))) / groups_per_flex;
 	sbi->s_flex_groups = kzalloc(flex_group_count *
 				     sizeof(struct flex_groups), GFP_KERNEL);
 	if (sbi->s_flex_groups == NULL) {
-- 
1.6.0.4.8.g36f27.dirty

