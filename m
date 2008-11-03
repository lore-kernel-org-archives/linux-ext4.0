From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: [PATCH -V2 2/2] ext4: Convert to host order before using the values.
Date: Mon,  3 Nov 2008 13:32:15 +0530
Message-ID: <1225699335-28813-2-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
References: <1225699335-28813-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
Cc: linux-ext4@vger.kernel.org,
	"Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
To: cmm@us.ibm.com, tytso@mit.edu, sandeen@redhat.com
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e28smtp02.in.ibm.com ([59.145.155.2]:51853 "EHLO
	e28smtp02.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754536AbYKCICT (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 3 Nov 2008 03:02:19 -0500
Received: from d28relay02.in.ibm.com (d28relay02.in.ibm.com [9.184.220.59])
	by e28smtp02.in.ibm.com (8.13.1/8.13.1) with ESMTP id mA382GZF004222
	for <linux-ext4@vger.kernel.org>; Mon, 3 Nov 2008 13:32:16 +0530
Received: from d28av03.in.ibm.com (d28av03.in.ibm.com [9.184.220.65])
	by d28relay02.in.ibm.com (8.13.8/8.13.8/NCO v9.1) with ESMTP id mA382DRT1917170
	for <linux-ext4@vger.kernel.org>; Mon, 3 Nov 2008 13:32:13 +0530
Received: from d28av03.in.ibm.com (loopback [127.0.0.1])
	by d28av03.in.ibm.com (8.13.1/8.13.3) with ESMTP id mA382FLO029554
	for <linux-ext4@vger.kernel.org>; Mon, 3 Nov 2008 19:02:16 +1100
In-Reply-To: <1225699335-28813-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Use le16_to_cpu to read the s_reserved_gdt_blocks values
from super block.

Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
---
 fs/ext4/super.c |    5 ++---
 1 files changed, 2 insertions(+), 3 deletions(-)

diff --git a/fs/ext4/super.c b/fs/ext4/super.c
index 87ac84b..5bfc235 100644
--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -1464,9 +1464,8 @@ static int ext4_fill_flex_info(struct super_block *sb)
 
 	/* We allocate both existing and potentially added groups */
 	flex_group_count = ((sbi->s_groups_count + groups_per_flex - 1) +
-			    ((sbi->s_es->s_reserved_gdt_blocks +1 ) <<
-			      EXT4_DESC_PER_BLOCK_BITS(sb))) /
-			   groups_per_flex;
+			((le16_to_cpu(sbi->s_es->s_reserved_gdt_blocks) + 1) <<
+			      EXT4_DESC_PER_BLOCK_BITS(sb))) / groups_per_flex;
 	sbi->s_flex_groups = kzalloc(flex_group_count *
 				     sizeof(struct flex_groups), GFP_KERNEL);
 	if (sbi->s_flex_groups == NULL) {
-- 
1.6.0.3.514.g2f91b

