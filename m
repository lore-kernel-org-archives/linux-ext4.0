From: Tao Ma <tm@tao.ma>
Subject: [PATCH] ext4: Fix a double free in ext4_register_li_request.
Date: Mon, 28 Mar 2011 15:37:37 +0800
Message-ID: <1301297857-3839-1-git-send-email-tm@tao.ma>
Cc: stable@kernel.org
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cpoproxy1-pub.bluehost.com ([69.89.21.11]:41763 "HELO
	outbound-mail-01.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1750776Ab1C1Hhv (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>);
	Mon, 28 Mar 2011 03:37:51 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

From: Tao Ma <boyu.mt@taobao.com>

In ext4_register_li_request, we malloc a ext4_li_request and
inserts it into ext4_li_info->li_request_list. In case of any
error later, we free it in the end. But if we have some error
in ext4_run_lazyinit_thread, the whole li_request_list will be
dropped and freed in it. So we will double free this ext4_li_request.

This patch just sets elr to NULL after it is inserted to the list
so that the latter kfree won't double free it.

Cc: stable@kernel.org
Signed-off-by: Tao Ma <boyu.mt@taobao.com>
---
 fs/ext4/super.c |    6 ++++++
 1 files changed, 6 insertions(+), 0 deletions(-)

diff --git a/fs/ext4/super.c b/fs/ext4/super.c
index 22546ad..2d1378f 100644
--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -2975,6 +2975,12 @@ static int ext4_register_li_request(struct super_block *sb,
 	mutex_unlock(&ext4_li_info->li_list_mtx);
 
 	sbi->s_li_request = elr;
+	/*
+	 * set elr to NULL here since it has been inserted to
+	 * the request_list and the removal and free of it is
+	 * handled by ext4_clear_request_list from now on.
+	 */
+	elr = NULL;
 
 	if (!(ext4_li_info->li_state & EXT4_LAZYINIT_RUNNING)) {
 		ret = ext4_run_lazyinit_thread();
-- 
1.7.4

