From: Carlos Maiolino <cmaiolino@redhat.com>
Subject: [PATCH] ext2: Make sb magic number endianness conversion consistent
Date: Thu, 17 Oct 2013 14:24:58 -0300
Message-ID: <1382030698-8746-1-git-send-email-cmaiolino@redhat.com>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:52332 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756706Ab3JQRZG (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 17 Oct 2013 13:25:06 -0400
Received: from int-mx01.intmail.prod.int.phx2.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id r9HHP3bx002560
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-ext4@vger.kernel.org>; Thu, 17 Oct 2013 13:25:06 -0400
Received: from orion.redhat.com (ovpn-113-158.phx2.redhat.com [10.3.113.158])
	by int-mx01.intmail.prod.int.phx2.redhat.com (8.13.8/8.13.8) with ESMTP id r9HHP2fD000975
	for <linux-ext4@vger.kernel.org>; Thu, 17 Oct 2013 13:25:02 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

All ext2_super_block fields are converted from le16 to cpu when checked or
loaded into memory. Magic number check is the only field where we convert the
magic number to le16. So, make the conversion pattern consistent with the
remaining code

Signed-off-by: Carlos Maiolino <cmaiolino@redhat.com>
---
 fs/ext2/super.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/ext2/super.c b/fs/ext2/super.c
index 2885349..808f99f 100644
--- a/fs/ext2/super.c
+++ b/fs/ext2/super.c
@@ -927,7 +927,7 @@ static int ext2_fill_super(struct super_block *sb, void *data, int silent)
 		}
 		es = (struct ext2_super_block *) (((char *)bh->b_data) + offset);
 		sbi->s_es = es;
-		if (es->s_magic != cpu_to_le16(EXT2_SUPER_MAGIC)) {
+		if (le16_to_cpu(es->s_magic) != EXT2_SUPER_MAGIC) {
 			ext2_msg(sb, KERN_ERR, "error: magic mismatch");
 			goto failed_mount;
 		}
-- 
1.8.1.4

