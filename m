From: Andreas Schlick <schlick@lavabit.com>
Subject: [PATCH 2/2] ext3: Always set dx_node's fake_dirent explicitly.
Date: Sun, 30 Aug 2009 16:58:51 +0200
Message-ID: <200908301658.51308.schlick@lavabit.com>
References: <200908301656.40866.schlick@lavabit.com> <200908301657.50561.schlick@lavabit.com>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
To: Ext4 Developers List <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from karen.lavabit.com ([72.249.41.33]:57038 "EHLO karen.lavabit.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752571AbZH3PND (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sun, 30 Aug 2009 11:13:03 -0400
Received: from e.earth.lavabit.com (e.earth.lavabit.com [192.168.111.14])
	by karen.lavabit.com (Postfix) with ESMTP id BD9BD11B8B4
	for <linux-ext4@vger.kernel.org>; Sun, 30 Aug 2009 10:13:05 -0500 (CDT)
Received: from 78.52.134.207 (78.52.134.207)
	by lavabit.com with ESMTP id H1MPJVBC6IFV
	for <linux-ext4@vger.kernel.org>; Sun, 30 Aug 2009 10:13:05 -0500
In-Reply-To: <200908301657.50561.schlick@lavabit.com>
Content-Disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

When ext3_dx_add_entry() has to split an index node, it has to ensure that
name_len of dx_node's fake_dirent is also zero, because otherwise e2fsck
won't recognise it as an intermediate htree node and consider the htree to
be corrupted.

Signed-off-by: Andreas Schlick <schlick@lavabit.com>
---
 fs/ext3/namei.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/fs/ext3/namei.c b/fs/ext3/namei.c
index 6ff7b97..877dd2b 100644
--- a/fs/ext3/namei.c
+++ b/fs/ext3/namei.c
@@ -1550,8 +1550,8 @@ static int ext3_dx_add_entry(handle_t *handle, struct dentry *dentry,
 			goto cleanup;
 		node2 = (struct dx_node *)(bh2->b_data);
 		entries2 = node2->entries;
+		memset(&node2->fake, 0, sizeof(struct fake_dirent));
 		node2->fake.rec_len = ext3_rec_len_to_disk(sb->s_blocksize);
-		node2->fake.inode = 0;
 		BUFFER_TRACE(frame->bh, "get_write_access");
 		err = ext3_journal_get_write_access(handle, frame->bh);
 		if (err)
-- 
1.6.4


