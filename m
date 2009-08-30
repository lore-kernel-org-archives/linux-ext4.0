From: Andreas Schlick <schlick@lavabit.com>
Subject: [PATCH 1/2] ext4: Always set dx_node's fake_dirent explicitly.
Date: Sun, 30 Aug 2009 16:57:50 +0200
Message-ID: <200908301657.50561.schlick@lavabit.com>
References: <200908301656.40866.schlick@lavabit.com>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
To: Ext4 Developers List <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from karen.lavabit.com ([72.249.41.33]:57037 "EHLO karen.lavabit.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751177AbZH3PND (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sun, 30 Aug 2009 11:13:03 -0400
Received: from e.earth.lavabit.com (e.earth.lavabit.com [192.168.111.14])
	by karen.lavabit.com (Postfix) with ESMTP id 0F9C211B8B2
	for <linux-ext4@vger.kernel.org>; Sun, 30 Aug 2009 10:13:05 -0500 (CDT)
Received: from 78.52.134.207 (78.52.134.207)
	by lavabit.com with ESMTP id KQUORJVJTZVO
	for <linux-ext4@vger.kernel.org>; Sun, 30 Aug 2009 10:13:05 -0500
In-Reply-To: <200908301656.40866.schlick@lavabit.com>
Content-Disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

When ext4_dx_add_entry() has to split an index node, it has to ensure that
name_len of dx_node's fake_dirent is also zero, because otherwise e2fsck
won't recognise it as an intermediate htree node and consider the htree to
be corrupted.

Signed-off-by: Andreas Schlick <schlick@lavabit.com>
---
 fs/ext4/namei.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/fs/ext4/namei.c b/fs/ext4/namei.c
index 22098e1..682a488 100644
--- a/fs/ext4/namei.c
+++ b/fs/ext4/namei.c
@@ -1590,9 +1590,9 @@ static int ext4_dx_add_entry(handle_t *handle, struct dentry *dentry,
 			goto cleanup;
 		node2 = (struct dx_node *)(bh2->b_data);
 		entries2 = node2->entries;
+		memset(&node2->fake, 0, sizeof(struct fake_dirent));
 		node2->fake.rec_len = ext4_rec_len_to_disk(sb->s_blocksize,
 							   sb->s_blocksize);
-		node2->fake.inode = 0;
 		BUFFER_TRACE(frame->bh, "get_write_access");
 		err = ext4_journal_get_write_access(handle, frame->bh);
 		if (err)
-- 
1.6.4


