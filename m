From: Chandan Rajendra <chandan@linux.vnet.ibm.com>
Subject: [PATCH V2] ext4: ext4_mb_seq_groups_show: Fix stack memory corruption
Date: Thu, 10 Nov 2016 11:16:04 +0530
Message-ID: <1478756764-4459-1-git-send-email-chandan@linux.vnet.ibm.com>
Cc: Chandan Rajendra <chandan@linux.vnet.ibm.com>, tytso@mit.edu,
        jack@suse.cz, adilger@dilger.ca
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:44098 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751476AbcKJFqW (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>);
        Thu, 10 Nov 2016 00:46:22 -0500
Received: from pps.filterd (m0098394.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.17/8.16.0.17) with SMTP id uAA5haNo018672
        for <linux-ext4@vger.kernel.org>; Thu, 10 Nov 2016 00:46:21 -0500
Received: from e17.ny.us.ibm.com (e17.ny.us.ibm.com [129.33.205.207])
        by mx0a-001b2d01.pphosted.com with ESMTP id 26mhm46y1h-1
        (version=TLSv1.2 cipher=AES256-SHA bits=256 verify=NOT)
        for <linux-ext4@vger.kernel.org>; Thu, 10 Nov 2016 00:46:21 -0500
Received: from localhost
        by e17.ny.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <linux-ext4@vger.kernel.org> from <chandan@linux.vnet.ibm.com>;
        Thu, 10 Nov 2016 00:46:20 -0500
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

The number of 'counters' elements needed in 'struct sg' is
super_block->s_blocksize_bits + 2. Presently we have 16 'counters'
elements in the array. This is insufficient for block sizes >= 32k. In
such cases the memcpy operation performed in ext4_mb_seq_groups_show()
would cause stack memory corruption.

Signed-off-by: Chandan Rajendra <chandan@linux.vnet.ibm.com>
---
Changelog: 
v1->v2: Use EXT4_MAX_BLOCK_LOG_SIZE instead of the integer constant 16.

 fs/ext4/mballoc.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/ext4/mballoc.c b/fs/ext4/mballoc.c
index a937ac7..7ae43c5 100644
--- a/fs/ext4/mballoc.c
+++ b/fs/ext4/mballoc.c
@@ -2287,7 +2287,7 @@ static int ext4_mb_seq_groups_show(struct seq_file *seq, void *v)
 	struct ext4_group_info *grinfo;
 	struct sg {
 		struct ext4_group_info info;
-		ext4_grpblk_t counters[16];
+		ext4_grpblk_t counters[EXT4_MAX_BLOCK_LOG_SIZE + 2];
 	} sg;
 
 	group--;
-- 
2.5.5

