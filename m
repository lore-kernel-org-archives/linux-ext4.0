From: Joe Perches <joe@perches.com>
Subject: [PATCH 3/9] ext4: Fix indentation
Date: Thu, 15 Mar 2012 17:07:31 -0700
Message-ID: <3457473a97c505cf9e5c5a34781a82e4e867a2e6.1331856300.git.joe@perches.com>
References: <cover.1331856299.git.joe@perches.com>
Cc: linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org
To: "Theodore Ts'o" <tytso@mit.edu>,
	Andreas Dilger <adilger.kernel@dilger.ca>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <cover.1331856299.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Indent a line appropriate.

Signed-off-by: Joe Perches <joe@perches.com>
---
 fs/ext4/extents.c |    5 +++--
 1 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/fs/ext4/extents.c b/fs/ext4/extents.c
index 4ca1c7e..c39a737 100644
--- a/fs/ext4/extents.c
+++ b/fs/ext4/extents.c
@@ -533,8 +533,9 @@ ext4_ext_binsearch_idx(struct inode *inode,
 
 		chix = ix = EXT_FIRST_INDEX(eh);
 		for (k = 0; k < le16_to_cpu(eh->eh_entries); k++, ix++) {
-		  if (k != 0 &&
-		      le32_to_cpu(ix->ei_block) <= le32_to_cpu(ix[-1].ei_block)) {
+			if (k != 0 &&
+			    le32_to_cpu(ix->ei_block) <=
+			    le32_to_cpu(ix[-1].ei_block)) {
 				pr_debug("k=%d, ix=0x%p, first=0x%p\n",
 					 k, ix, EXT_FIRST_INDEX(eh));
 				pr_debug("%u <= %u\n",
-- 
1.7.8.111.gad25c.dirty
