From: Carlos Maiolino <cmaiolino@redhat.com>
Subject: [PATCH 1/2] ext3: fix possible non-initialized variable on htree_dirblock_to_tree()
Date: Mon,  1 Oct 2012 16:50:54 -0300
Message-ID: <1349121055-8168-2-git-send-email-cmaiolino@redhat.com>
References: <1349121055-8168-1-git-send-email-cmaiolino@redhat.com>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:33103 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751493Ab2JATtY (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 1 Oct 2012 15:49:24 -0400
Received: from int-mx12.intmail.prod.int.phx2.redhat.com (int-mx12.intmail.prod.int.phx2.redhat.com [10.5.11.25])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id q91JnOv6029623
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-ext4@vger.kernel.org>; Mon, 1 Oct 2012 15:49:24 -0400
Received: from hades.maiolino.org.com (ovpn-113-128.phx2.redhat.com [10.3.113.128])
	by int-mx12.intmail.prod.int.phx2.redhat.com (8.14.4/8.14.4) with ESMTP id q91JnEF6013279
	for <linux-ext4@vger.kernel.org>; Mon, 1 Oct 2012 15:49:23 -0400
In-Reply-To: <1349121055-8168-1-git-send-email-cmaiolino@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

This is a backport of ext4 commit 90b0a9732 which fixes a possible
non-initialized variable on htree_dirblock_to_tree().
Ext3 has the same non initialized variable, but, in any case it will be
initialized by ext3_get_blocks_handle(), which will avoid the bug to be
triggered, but, the non-initialized variable by htree_dirblock_to_tree() is
still a bug.

Signed-off-by: Carlos Maiolino <cmaiolino@redhat.com>
---
 fs/ext3/namei.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/ext3/namei.c b/fs/ext3/namei.c
index 8f4fdda..7f6c938 100644
--- a/fs/ext3/namei.c
+++ b/fs/ext3/namei.c
@@ -559,7 +559,7 @@ static int htree_dirblock_to_tree(struct file *dir_file,
 {
 	struct buffer_head *bh;
 	struct ext3_dir_entry_2 *de, *top;
-	int err, count = 0;
+	int err = 0, count = 0;
 
 	dxtrace(printk("In htree dirblock_to_tree: block %d\n", block));
 	if (!(bh = ext3_bread (NULL, dir, block, 0, &err)))
-- 
1.7.11.4

