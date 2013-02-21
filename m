From: Lukas Czerner <lczerner@redhat.com>
Subject: [PATCH] ext4: fix free clusters calculation in bigalloc filesystem
Date: Thu, 21 Feb 2013 09:01:05 +0100
Message-ID: <1361433665-16880-1-git-send-email-lczerner@redhat.com>
Cc: Lukas Czerner <lczerner@redhat.com>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:50313 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751782Ab3BUIBM (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 21 Feb 2013 03:01:12 -0500
Received: from int-mx01.intmail.prod.int.phx2.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id r1L81C94020460
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-ext4@vger.kernel.org>; Thu, 21 Feb 2013 03:01:12 -0500
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

ext4_has_free_clusters() should tell us whether there is enough free
clusters to allocate, however number of free clusters in the file system
is converted to blocks using EXT4_C2B() which is not only wrong use of
the macro (we should have used EXT4_NUM_B2C) but it's also completely
wrong concept since everything else is in cluster units.

Moreover when calculating number of root clusters we should be using
macro EXT4_NUM_B2C() instead of EXT4_C2B() otherwise the result will
usually be off by one.

As a result number of free clusters is much bigger than it should have
been and ext4_has_free_clusters() would return 1 even if there is really
not enough free clusters available.

Fix this by removing the EXT4_C2B() conversion of free clusters and
using EXT4_NUM_B2C() when calculating number of root clusters. This bug
affects number of xfstests tests covering file system ENOSPC situation
handling. With this patch most of the ENOSPC problems with bigalloc file
system disappear, especially the errors caused by delayed allocation not
having enough space when the actual allocation is finally requested.

Signed-off-by: Lukas Czerner <lczerner@redhat.com>
---
 fs/ext4/balloc.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/ext4/balloc.c b/fs/ext4/balloc.c
index cf18217..9f4302a 100644
--- a/fs/ext4/balloc.c
+++ b/fs/ext4/balloc.c
@@ -482,11 +482,11 @@ static int ext4_has_free_clusters(struct ext4_sb_info *sbi,
 
 	free_clusters  = percpu_counter_read_positive(fcc);
 	dirty_clusters = percpu_counter_read_positive(dcc);
-	root_clusters = EXT4_B2C(sbi, ext4_r_blocks_count(sbi->s_es));
+	root_clusters = EXT4_NUM_B2C(sbi, ext4_r_blocks_count(sbi->s_es));
 
 	if (free_clusters - (nclusters + root_clusters + dirty_clusters) <
 					EXT4_FREECLUSTERS_WATERMARK) {
-		free_clusters  = EXT4_C2B(sbi, percpu_counter_sum_positive(fcc));
+		free_clusters  = percpu_counter_sum_positive(fcc);
 		dirty_clusters = percpu_counter_sum_positive(dcc);
 	}
 	/* Check whether we have space after accounting for current
-- 
1.7.7.6

