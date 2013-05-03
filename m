From: Eric Sandeen <sandeen@redhat.com>
Subject: [PATCH] ext4: recalculate s_blockfile_groups during resize2fs
Date: Fri, 03 May 2013 16:06:56 -0500
Message-ID: <518426F0.1000103@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: Lachlan McIlroy <lmcilroy@redhat.com>
To: ext4 development <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:54788 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750729Ab3ECVG5 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 3 May 2013 17:06:57 -0400
Received: from int-mx02.intmail.prod.int.phx2.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id r43L6vpo021247
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-ext4@vger.kernel.org>; Fri, 3 May 2013 17:06:57 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

s_blockfile_groups is used to limit allocations for non-extent
files to block groups with block numbers less than 2^32.
However, it's not updated when the filesystem is resized online,
so the new groups are unavailable to non-extent files until a remount.

Fix this by updating the value in ext4_update_super() at
resize time.

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---

diff --git a/fs/ext4/resize.c b/fs/ext4/resize.c
index c169477..1357260 100644
--- a/fs/ext4/resize.c
+++ b/fs/ext4/resize.c
@@ -1341,6 +1341,8 @@ static void ext4_update_super(struct super_block *sb,
 
 	/* Update the global fs size fields */
 	sbi->s_groups_count += flex_gd->count;
+	sbi->s_blockfile_groups = min_t(ext4_group_t, sbi->s_groups_count,
+			(EXT4_MAX_BLOCK_FILE_PHYS / EXT4_BLOCKS_PER_GROUP(sb)));
 
 	/* Update the reserved block counts only once the new group is
 	 * active. */

