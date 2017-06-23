From: Colin King <colin.king@canonical.com>
Subject: [PATCH][ext4-next] ext4: ensure error return ret is zero on successful return
Date: Fri, 23 Jun 2017 15:58:40 +0100
Message-ID: <20170623145840.26779-1-colin.king@canonical.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Cc: kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
To: Theodore Ts'o <tytso@mit.edu>,
        Andreas Dilger <adilger.kernel@dilger.ca>,
        linux-ext4@vger.kernel.org
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

From: Colin Ian King <colin.king@canonical.com>

The error return ret is not set on a successful return path and
so it returns a garbage value. Ensure it is is set to zero on
a successful return.

Detected by CoverityScan, CID#1446616 ("Uninitialized scalar variable")

Fixes: 3499c0fb822d ("quota: add get_inode_usage callback to transfer multi-inode charges")

Signed-off-by: Colin Ian King <colin.king@canonical.com>
---
 fs/ext4/xattr.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/fs/ext4/xattr.c b/fs/ext4/xattr.c
index ce12c3fb7e59..f454b2709b5a 100644
--- a/fs/ext4/xattr.c
+++ b/fs/ext4/xattr.c
@@ -794,6 +794,7 @@ int ext4_get_inode_usage(struct inode *inode, qsize_t *usage)
 				ea_inode_refs++;
 	}
 	*usage = ea_inode_refs + 1;
+	ret = 0;
 out:
 	brelse(iloc.bh);
 	brelse(bh);
-- 
2.11.0
