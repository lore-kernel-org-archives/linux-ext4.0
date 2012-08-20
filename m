From: Wang Sheng-Hui <shhuiw@gmail.com>
Subject: [PATCH] ext4: change the debug description in ext4_mb_cleanup_pa
Date: Mon, 20 Aug 2012 16:07:40 +0800
Message-ID: <5031F04C.60808@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
To: Theodore Ts'o <tytso@mit.edu>,
	Andreas Dilger <adilger.kernel@dilger.ca>,
	ext4 development <linux-ext4@vger.kernel.org>,
	linux-kernel@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-pz0-f46.google.com ([209.85.210.46]:45364 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754102Ab2HTIHz (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 20 Aug 2012 04:07:55 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

The count records the PAs freed, not left.
Change the debug description.

Signed-off-by: Wang Sheng-Hui <shhuiw@gmail.com>
---
 fs/ext4/mballoc.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/fs/ext4/mballoc.c b/fs/ext4/mballoc.c
index 8eae947..f83b145 100644
--- a/fs/ext4/mballoc.c
+++ b/fs/ext4/mballoc.c
@@ -2510,7 +2510,7 @@ static void ext4_mb_cleanup_pa(struct ext4_group_info *grp)
 		kmem_cache_free(ext4_pspace_cachep, pa);
 	}
 	if (count)
-		mb_debug(1, "mballoc: %u PAs left\n", count);
+		mb_debug(1, "mballoc: %u PAs freed\n", count);
 
 }
 
-- 
1.7.1

