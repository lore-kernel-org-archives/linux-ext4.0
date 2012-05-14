From: Wang Sheng-Hui <shhuiw@gmail.com>
Subject: [PATCH] ext2: cleanup the comment for ext2_export_ops
Date: Mon, 14 May 2012 15:15:00 +0800
Message-ID: <4FB0B0F4.3060908@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
To: Jan Kara <jack@suse.cz>, linux-ext4@vger.kernel.org,
	linux-kernel@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-pz0-f46.google.com ([209.85.210.46]:55468 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754540Ab2ENHPX (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 14 May 2012 03:15:23 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

ext2_export_ops gets more valued fields, not get_parent only.
Clean up the comment.

Signed-off-by: Wang Sheng-Hui <shhuiw@gmail.com>
---
 fs/ext2/super.c |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/fs/ext2/super.c b/fs/ext2/super.c
index e1025c7..640b4c6 100644
--- a/fs/ext2/super.c
+++ b/fs/ext2/super.c
@@ -359,7 +359,6 @@ static struct dentry *ext2_fh_to_parent(struct super_block *sb, struct fid *fid,
 /* Yes, most of these are left as NULL!!
  * A NULL value implies the default, which works with ext2-like file
  * systems, but can be improved upon.
- * Currently only get_parent is required.
  */
 static const struct export_operations ext2_export_ops = {
 	.fh_to_dentry = ext2_fh_to_dentry,
-- 
1.7.1
