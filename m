Return-Path: <SRS0=qwWH=3O=vger.kernel.org=linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.7 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0CB44C2D0DB
	for <linux-ext4@archiver.kernel.org>; Sat, 25 Jan 2020 20:25:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D3CE320708
	for <linux-ext4@archiver.kernel.org>; Sat, 25 Jan 2020 20:25:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726690AbgAYUZp (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Sat, 25 Jan 2020 15:25:45 -0500
Received: from smtp-out-no.shaw.ca ([64.59.134.9]:36318 "EHLO
        smtp-out-no.shaw.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726448AbgAYUZp (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Sat, 25 Jan 2020 15:25:45 -0500
Received: from cabot.adilger.int ([70.77.216.213])
        by shaw.ca with ESMTP
        id vRzyisJvNkqGXvRzziDdFI; Sat, 25 Jan 2020 13:25:44 -0700
X-Authority-Analysis: v=2.3 cv=c/jVvi1l c=1 sm=1 tr=0
 a=BQvS1EmAg2ttxjPVUuc1UQ==:117 a=BQvS1EmAg2ttxjPVUuc1UQ==:17 a=RPJ6JBhKAAAA:8
 a=_CvfgrRZgBlTxnZNDbMA:9 a=fa_un-3J20JGBB2Tu-mn:22
From:   Andreas Dilger <adilger@dilger.ca>
To:     tytso@mit.edu
Cc:     linux-ext4@vger.kernel.org, Andreas Dilger <adilger@dilger.ca>
Subject: [PATCH] ext4: don't assume that mmp_nodename/bdevname have NUL
Date:   Sat, 25 Jan 2020 13:25:42 -0700
Message-Id: <1579983942-11927-1-git-send-email-adilger@dilger.ca>
X-Mailer: git-send-email 1.8.0
X-CMAE-Envelope: MS4wfMHlIp+RiMhlSWRAiX58bb02uwmPWC9QHnxRVzJ2wHkykifLXnsNDbjBRgDcZFkNhZO2B3K8IK4shr3h96BycgWRLtJWSEwgQmt4YUG05FrhLuCcM+CY
 jpysTbHHwBLTXHg7evm68VK3X+0ayzHKj/iy+L54LmMQg7xRvEYKbtTWQMwMtB/O95KKZ8sMb/YI3UXe8esAqF58Xzm9iDLpfxK8VAgJGDuaEVWohdhO7kfR
Sender: linux-ext4-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org

Don't assume that the mmp_nodename and mmp_bdevname strings are NUL
terminated, since they are filled in by snprintf(), which is not
guaranteed to do so.

Signed-off-by: Andreas Dilger <adilger@dilger.ca>
---
 fs/ext4/mmp.c | 11 ++++++-----
 1 file changed, 6 insertions(+), 5 deletions(-)

diff --git a/fs/ext4/mmp.c b/fs/ext4/mmp.c
index 2305b43..612476e 100644
--- a/fs/ext4/mmp.c
+++ b/fs/ext4/mmp.c
@@ -120,10 +120,10 @@ void __dump_mmp_msg(struct super_block *sb, struct mmp_struct *mmp,
 {
 	__ext4_warning(sb, function, line, "%s", msg);
 	__ext4_warning(sb, function, line,
-		       "MMP failure info: last update time: %llu, last update "
-		       "node: %s, last update device: %s",
-		       (long long unsigned int) le64_to_cpu(mmp->mmp_time),
-		       mmp->mmp_nodename, mmp->mmp_bdevname);
+		       "MMP failure info: last update time: %llu, last update node: %.*s, last update device: %.*s",
+		       (long long unsigned int)le64_to_cpu(mmp->mmp_time),
+		       sizeof(mmp->mmp_nodename), mmp->mmp_nodename,
+		       sizeof(mmp->mmp_bdevname), mmp->mmp_bdevname);
 }
 
 /*
@@ -375,7 +375,8 @@ int ext4_multi_mount_protect(struct super_block *sb,
 	/*
 	 * Start a kernel thread to update the MMP block periodically.
 	 */
-	EXT4_SB(sb)->s_mmp_tsk = kthread_run(kmmpd, mmpd_data, "kmmpd-%s",
+	EXT4_SB(sb)->s_mmp_tsk = kthread_run(kmmpd, mmpd_data, "kmmpd-%.*s",
+					     sizeof(mmp->mmp_bdevname),
 					     bdevname(bh->b_bdev,
 						      mmp->mmp_bdevname));
 	if (IS_ERR(EXT4_SB(sb)->s_mmp_tsk)) {
-- 
1.8.0

