From: Roman Pen <roman.penyaev@profitbricks.com>
Subject: [PATCH 3/3] ext4: Find desired extent in ext4_ext_shift_extents() using binsearch
Date: Mon,  2 Jan 2017 13:54:50 +0100
Message-ID: <20170102125450.22807-4-roman.penyaev@profitbricks.com>
References: <20170102125450.22807-1-roman.penyaev@profitbricks.com>
Cc: Roman Pen <roman.penyaev@profitbricks.com>,
        Namjae Jeon <namjae.jeon@samsung.com>,
        "Theodore Ts'o" <tytso@mit.edu>,
        Andreas Dilger <adilger.kernel@dilger.ca>,
        linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org
To: unlisted-recipients:; (no To-header on input)
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20170102125450.22807-1-roman.penyaev@profitbricks.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

The aim of this patch is to optimize a search of an extent while
doing right shift using binsearch.

Cc: Namjae Jeon <namjae.jeon@samsung.com>
Cc: "Theodore Ts'o" <tytso@mit.edu>
Cc: Andreas Dilger <adilger.kernel@dilger.ca>
Cc: linux-ext4@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
---
 fs/ext4/extents.c | 13 +++++++++----
 1 file changed, 9 insertions(+), 4 deletions(-)

diff --git a/fs/ext4/extents.c b/fs/ext4/extents.c
index 9fbf92ca358c..f65cc2762780 100644
--- a/fs/ext4/extents.c
+++ b/fs/ext4/extents.c
@@ -5433,10 +5433,15 @@ ext4_ext_shift_extents(struct inode *inode, handle_t *handle,
 			else
 				/* Beginning is reached, end of the loop */
 				iterator = NULL;
-			/* Update path extent in case we need to stop */
-			while (le32_to_cpu(extent->ee_block) < start)
-				extent++;
-			path[depth].p_ext = extent;
+			if (le32_to_cpu(extent->ee_block) < start)
+				/*
+				 * Desired extent is somewhere in the middle,
+				 * do binsearch and update a path with it.
+				 */
+				ext4_ext_binsearch(inode, &path[depth], start);
+			else
+				/* Set the first extent */
+				path[depth].p_ext = extent;
 		}
 		ret = ext4_ext_shift_path_extents(path, shift, inode,
 				handle, SHIFT);
-- 
2.10.2
