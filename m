From: Brian Foster <bfoster@redhat.com>
Subject: [PATCH] ext4: do not enable delalloc by default for ext2
Date: Tue, 27 Mar 2012 09:46:27 -0400
Message-ID: <4F71C4B3.9090402@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: Eric Sandeen <esandeen@redhat.com>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:25158 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753872Ab2C0Nqh (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 27 Mar 2012 09:46:37 -0400
Received: from int-mx12.intmail.prod.int.phx2.redhat.com (int-mx12.intmail.prod.int.phx2.redhat.com [10.5.11.25])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id q2RDkbpb006109
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-ext4@vger.kernel.org>; Tue, 27 Mar 2012 09:46:37 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Use traditional ext2 mount options. Do not enable delalloc by default for ext2.

Signed-off-by: Brian Foster <bfoster@redhat.com>
---
 fs/ext4/super.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/fs/ext4/super.c b/fs/ext4/super.c
index 9339009..b08a547 100644
--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -3229,7 +3229,7 @@ static int ext4_fill_super(struct super_block *sb, void *data, int silent)
 	 * enable delayed allocation by default
 	 * Use -o nodelalloc to turn it off
 	 */
-	if (!IS_EXT3_SB(sb) &&
+	if (!IS_EXT3_SB(sb) && !IS_EXT2_SB(sb) &&
 	    ((def_mount_opts & EXT4_DEFM_NODELALLOC) == 0))
 		set_opt(sb, DELALLOC);
 
-- 
1.7.7.6

