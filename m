From: Chandan Rajendra <chandan@linux.vnet.ibm.com>
Subject: [PATCH] ext4: ext4_mb_seq_groups_show: Fix stack memory corruption
Date: Mon,  7 Nov 2016 12:15:41 +0530
Message-ID: <1478501141-15651-1-git-send-email-chandan@linux.vnet.ibm.com>
Cc: Chandan Rajendra <chandan@linux.vnet.ibm.com>, tytso@mit.edu,
        jack@suse.cz, adilger@dilger.ca
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:36155 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1751226AbcKGGpv (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Mon, 7 Nov 2016 01:45:51 -0500
Received: from pps.filterd (m0098413.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.17/8.16.0.17) with SMTP id uA76hund117604
        for <linux-ext4@vger.kernel.org>; Mon, 7 Nov 2016 01:45:51 -0500
Received: from e36.co.us.ibm.com (e36.co.us.ibm.com [32.97.110.154])
        by mx0b-001b2d01.pphosted.com with ESMTP id 26j5qvntrc-1
        (version=TLSv1.2 cipher=AES256-SHA bits=256 verify=NOT)
        for <linux-ext4@vger.kernel.org>; Mon, 07 Nov 2016 01:45:50 -0500
Received: from localhost
        by e36.co.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <linux-ext4@vger.kernel.org> from <chandan@linux.vnet.ibm.com>;
        Sun, 6 Nov 2016 23:45:50 -0700
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

The number of 'counters' elements needed in 'struct sg' is
super_block->s_blocksize_bits + 2. Presently we have 16 'counters'
elements in the array. This is insufficient for block sizes >= 32k. In
such cases the memcpy operation performed in ext4_mb_seq_groups_show()
would cause stack memory corruption.

Signed-off-by: Chandan Rajendra <chandan@linux.vnet.ibm.com>
---
 fs/ext4/mballoc.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/ext4/mballoc.c b/fs/ext4/mballoc.c
index a937ac7..67e6fcb 100644
--- a/fs/ext4/mballoc.c
+++ b/fs/ext4/mballoc.c
@@ -2287,7 +2287,7 @@ static int ext4_mb_seq_groups_show(struct seq_file *seq, void *v)
 	struct ext4_group_info *grinfo;
 	struct sg {
 		struct ext4_group_info info;
-		ext4_grpblk_t counters[16];
+		ext4_grpblk_t counters[16 + 2];
 	} sg;
 
 	group--;
-- 
2.5.5

