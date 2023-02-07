Return-Path: <linux-ext4-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E31E2C05027
	for <linux-ext4@archiver.kernel.org>; Mon,  6 Feb 2023 07:05:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229854AbjBFHFV (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Mon, 6 Feb 2023 02:05:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59530 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229571AbjBFHFU (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Mon, 6 Feb 2023 02:05:20 -0500
Received: from mail.nfschina.com (unknown [42.101.60.237])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7EBFB6582;
        Sun,  5 Feb 2023 23:05:18 -0800 (PST)
Received: from localhost (unknown [127.0.0.1])
        by mail.nfschina.com (Postfix) with ESMTP id 64DD81A00A26;
        Mon,  6 Feb 2023 15:05:46 +0800 (CST)
X-Virus-Scanned: amavisd-new at nfschina.com
Received: from mail.nfschina.com ([127.0.0.1])
        by localhost (localhost.localdomain [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id KhHkGqyEvT8U; Mon,  6 Feb 2023 15:05:44 +0800 (CST)
Received: from localhost.localdomain (unknown [219.141.250.2])
        (Authenticated sender: kunyu@nfschina.com)
        by mail.nfschina.com (Postfix) with ESMTPA id 6F59C1A00A0A;
        Mon,  6 Feb 2023 15:05:44 +0800 (CST)
From:   Li kunyu <kunyu@nfschina.com>
To:     tytso@mit.edu, adilger.kernel@dilger.ca
Cc:     linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org,
        Li kunyu <kunyu@nfschina.com>
Subject: [PATCH] ext4: ialloc: Remove variables defined more than once in a function
Date:   Wed,  8 Feb 2023 07:36:32 +0800
Message-Id: <20230207233632.4723-1-kunyu@nfschina.com>
X-Mailer: git-send-email 2.18.2
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org

The grp pointer variable has been defined at the beginning of the
function. It is not necessary to define it here, so remove the variable
definition here.

Signed-off-by: Li kunyu <kunyu@nfschina.com>
---
 fs/ext4/ialloc.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/fs/ext4/ialloc.c b/fs/ext4/ialloc.c
index 63f9bb6e8851..be9f742f9415 100644
--- a/fs/ext4/ialloc.c
+++ b/fs/ext4/ialloc.c
@@ -1181,7 +1181,6 @@ struct inode *__ext4_new_inode(struct user_namespace *mnt_userns,
 	/* Update the relevant bg descriptor fields */
 	if (ext4_has_group_desc_csum(sb)) {
 		int free;
-		struct ext4_group_info *grp = NULL;
 
 		if (!(sbi->s_mount_state & EXT4_FC_REPLAY)) {
 			grp = ext4_get_group_info(sb, group);
-- 
2.18.2

