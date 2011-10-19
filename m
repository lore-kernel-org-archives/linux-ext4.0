From: Dmitry Monakhov <dmonakhov@openvz.org>
Subject: [PATCH 1/2] ext4: Allow quota file use root reservation
Date: Wed, 19 Oct 2011 14:16:22 +0400
Message-ID: <1319019383-12603-1-git-send-email-dmonakhov@openvz.org>
Cc: Dmitry Monakhov <dmonakhov@openvz.org>
To: jack@suse.cz, linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-bw0-f46.google.com ([209.85.214.46]:42106 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751287Ab1JSKQd (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 19 Oct 2011 06:16:33 -0400
Received: by bkbzt19 with SMTP id zt19so1902899bkb.19
        for <linux-ext4@vger.kernel.org>; Wed, 19 Oct 2011 03:16:32 -0700 (PDT)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Quota file is fs's metadata, so it is reasonable  to permit use
root resevation if necessary. This patch fix 265'th xfstest failure

Signed-off-by: Dmitry Monakhov <dmonakhov@openvz.org>
---
 fs/ext4/mballoc.c |    4 ++++
 1 files changed, 4 insertions(+), 0 deletions(-)

diff --git a/fs/ext4/mballoc.c b/fs/ext4/mballoc.c
index 17a5a57..5a7b3b4 100644
--- a/fs/ext4/mballoc.c
+++ b/fs/ext4/mballoc.c
@@ -4256,6 +4256,10 @@ ext4_fsblk_t ext4_mb_new_blocks(handle_t *handle,
 
 	trace_ext4_request_blocks(ar);
 
+	/* Allow to use superuser reservation for quota file */
+	if (IS_NOQUOTA(ar->inode))
+		ar->flags |= EXT4_MB_USE_ROOT_BLOCKS;
+
 	/*
 	 * For delayed allocation, we could skip the ENOSPC and
 	 * EDQUOT check, as blocks and quotas have been already
-- 
1.7.1

