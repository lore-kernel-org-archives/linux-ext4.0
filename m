From: Julia Lawall <Julia.Lawall@lip6.fr>
Subject: [PATCH 9/16] fs/ext4/indirect.c: use WARN
Date: Sat,  3 Nov 2012 11:58:30 +0100
Message-ID: <1351940317-14812-10-git-send-email-Julia.Lawall@lip6.fr>
References: <1351940317-14812-1-git-send-email-Julia.Lawall@lip6.fr>
Cc: kernel-janitors@vger.kernel.org,
	Andreas Dilger <adilger.kernel@dilger.ca>,
	linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org
To: "Theodore Ts'o" <tytso@mit.edu>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1351940317-14812-1-git-send-email-Julia.Lawall@lip6.fr>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

From: Julia Lawall <Julia.Lawall@lip6.fr>

Use WARN rather than printk followed by WARN_ON(1), for conciseness.

A simplified version of the semantic patch that makes this transformation
is as follows: (http://coccinelle.lip6.fr/)

// <smpl>
@@
expression list es;
@@

-printk(
+WARN(1,
  es);
-WARN_ON(1);
// </smpl>

Signed-off-by: Julia Lawall <Julia.Lawall@lip6.fr>

---
 fs/ext4/indirect.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/fs/ext4/indirect.c b/fs/ext4/indirect.c
index 792e388..0cdd20f 100644
--- a/fs/ext4/indirect.c
+++ b/fs/ext4/indirect.c
@@ -354,9 +354,8 @@ static int ext4_alloc_blocks(handle_t *handle, struct inode *inode,
 			 * for the first direct block
 			 */
 			new_blocks[index] = current_block;
-			printk(KERN_INFO "%s returned more blocks than "
+			WARN(1, KERN_INFO "%s returned more blocks than "
 						"requested\n", __func__);
-			WARN_ON(1);
 			break;
 		}
 	}
