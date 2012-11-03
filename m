From: Julia Lawall <Julia.Lawall@lip6.fr>
Subject: [PATCH 4/8] fs/ext3/inode.c: drop if around WARN_ON
Date: Sat,  3 Nov 2012 21:30:21 +0100
Message-ID: <1351974625-10282-5-git-send-email-Julia.Lawall@lip6.fr>
References: <1351974625-10282-1-git-send-email-Julia.Lawall@lip6.fr>
Cc: kernel-janitors@vger.kernel.org,
	Andrew Morton <akpm@linux-foundation.org>,
	Andreas Dilger <adilger.kernel@dilger.ca>,
	linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org
To: Jan Kara <jack@suse.cz>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1351974625-10282-1-git-send-email-Julia.Lawall@lip6.fr>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

From: Julia Lawall <Julia.Lawall@lip6.fr>

Just use WARN_ON rather than an if containing only WARN_ON(1).

A simplified version of the semantic patch that makes this transformation
is as follows: (http://coccinelle.lip6.fr/)

// <smpl>
@@
expression e;
@@
- if (e) WARN_ON(1);
+ WARN_ON(e);
// </smpl>

Signed-off-by: Julia Lawall <Julia.Lawall@lip6.fr>

---
 fs/ext3/inode.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/fs/ext3/inode.c b/fs/ext3/inode.c
index 7e87e37..b176d42 100644
--- a/fs/ext3/inode.c
+++ b/fs/ext3/inode.c
@@ -1071,8 +1071,7 @@ struct buffer_head *ext3_getblk(handle_t *handle, struct inode *inode,
 	 * mapped. 0 in case of a HOLE.
 	 */
 	if (err > 0) {
-		if (err > 1)
-			WARN_ON(1);
+		WARN_ON(err > 1);
 		err = 0;
 	}
 	*errp = err;
