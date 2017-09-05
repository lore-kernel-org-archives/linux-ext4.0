From: Colin King <colin.king@canonical.com>
Subject: [PATCH][ext4-next] ext4: fix null pointer dereference on sbi
Date: Tue,  5 Sep 2017 17:51:23 +0100
Message-ID: <20170905165123.22245-1-colin.king@canonical.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Cc: kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org,
        Dan Williams <dan.j.williams@intel.com>
To: Theodore Ts'o <tytso@mit.edu>,
        Andreas Dilger <adilger.kernel@dilger.ca>,
        linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from youngberry.canonical.com ([91.189.89.112]:51638 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752191AbdIEQv1 (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Tue, 5 Sep 2017 12:51:27 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

From: Colin Ian King <colin.king@canonical.com>

In the case of a kzalloc failure when allocating sbi we end up
with a null pointer dereference on sbi when assigning sbi->s_daxdev.
Fix this by moving the assignment of sbi->s_daxdev to after the
null pointer check of sbi.

Detected by CoverityScan CID#1455379 ("Dereference before null check")

Fixes: 5e405595e5bf ("ext4: perform dax_device lookup at mount")
Signed-off-by: Colin Ian King <colin.king@canonical.com>
---
 fs/ext4/super.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/ext4/super.c b/fs/ext4/super.c
index 0e63fcd12c5b..71b9a667e1bc 100644
--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -3422,10 +3422,10 @@ static int ext4_fill_super(struct super_block *sb, void *data, int silent)
 	unsigned int journal_ioprio = DEFAULT_JOURNAL_IOPRIO;
 	ext4_group_t first_not_zeroed;
 
-	sbi->s_daxdev = dax_dev;
 	if ((data && !orig_data) || !sbi)
 		goto out_free_base;
 
+	sbi->s_daxdev = dax_dev;
 	sbi->s_blockgroup_lock =
 		kzalloc(sizeof(struct blockgroup_lock), GFP_KERNEL);
 	if (!sbi->s_blockgroup_lock)
-- 
2.14.1
