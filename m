From: SF Markus Elfring <elfring@users.sourceforge.net>
Subject: [PATCH 2/2] ext4: Improve a size determination in two functions
Date: Sat, 19 Aug 2017 13:48:55 +0200
Message-ID: <c1941b22-bdab-fccf-06e2-2f9fc50daec1@users.sourceforge.net>
References: <ca49a6dc-f2ee-d427-5f16-052706277b38@users.sourceforge.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Cc: LKML <linux-kernel@vger.kernel.org>,
        kernel-janitors@vger.kernel.org
To: linux-ext4@vger.kernel.org,
        Andreas Dilger <adilger.kernel@dilger.ca>,
        Theodore Ts'o <tytso@mit.edu>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <ca49a6dc-f2ee-d427-5f16-052706277b38@users.sourceforge.net>
Content-Language: en-GB
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

From: Markus Elfring <elfring@users.sourceforge.net>
Date: Sat, 19 Aug 2017 13:14:26 +0200

Replace the specification of data structures by pointer dereferences
as the parameter for the operator "sizeof" to make the corresponding size
determination a bit safer according to the Linux coding style convention.

This issue was detected by using the Coccinelle software.

Signed-off-by: Markus Elfring <elfring@users.sourceforge.net>
---
 fs/ext4/dir.c | 2 +-
 fs/ext4/mmp.c | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/ext4/dir.c b/fs/ext4/dir.c
index e8b365000d73..b04e882179c6 100644
--- a/fs/ext4/dir.c
+++ b/fs/ext4/dir.c
@@ -411,7 +411,7 @@ static struct dir_private_info *ext4_htree_create_dir_info(struct file *filp,
 {
 	struct dir_private_info *p;
 
-	p = kzalloc(sizeof(struct dir_private_info), GFP_KERNEL);
+	p = kzalloc(sizeof(*p), GFP_KERNEL);
 	if (!p)
 		return NULL;
 	p->curr_hash = pos2maj_hash(filp, pos);
diff --git a/fs/ext4/mmp.c b/fs/ext4/mmp.c
index 1ce00453f612..3fa5df9f5573 100644
--- a/fs/ext4/mmp.c
+++ b/fs/ext4/mmp.c
@@ -367,5 +367,5 @@ int ext4_multi_mount_protect(struct super_block *sb,
 		goto failed;
 	}
 
-	mmpd_data = kmalloc(sizeof(struct mmpd_data), GFP_KERNEL);
+	mmpd_data = kmalloc(sizeof(*mmpd_data), GFP_KERNEL);
 	if (!mmpd_data)
-- 
2.14.0
