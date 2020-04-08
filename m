Return-Path: <SRS0=dDCy=5Y=vger.kernel.org=linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F3AE1C2BA1A
	for <linux-ext4@archiver.kernel.org>; Wed,  8 Apr 2020 10:46:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C819A20747
	for <linux-ext4@archiver.kernel.org>; Wed,  8 Apr 2020 10:46:25 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="WEpgVESF"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728268AbgDHKqZ (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Wed, 8 Apr 2020 06:46:25 -0400
Received: from mail-pl1-f194.google.com ([209.85.214.194]:43482 "EHLO
        mail-pl1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728250AbgDHKqZ (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Wed, 8 Apr 2020 06:46:25 -0400
Received: by mail-pl1-f194.google.com with SMTP id z6so882210plk.10
        for <linux-ext4@vger.kernel.org>; Wed, 08 Apr 2020 03:46:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=q0g/zyyg3cWNQoMPaaZkiDSHcWfec0cZrjPhzZaKF2I=;
        b=WEpgVESF1tELt8bIVgSAiStyuydvQd013mG9Wo6+nmpVX2omz9d+PACB+YMcKVMrts
         7GNMHAq/d1VBRSedoEQxqHW/OQUxzSeiGI6FkXnqaQertLV56MJur7Jr2ZepQlE6JEm4
         kj0zxjLhEohV8qtt52sVRQ+AddwOYnBDQCk1Z/4gZQdfIhcDz3YZ8EgOmmkOOILJalbY
         60myYCs9CGoWS0bsE6BgI7fVzmbAQeHdWdCJfgj+PJHmjKlbV3v1rFCgwgoIbkmfgyLu
         vFArI5kZPQVNOnXIOU8oQVr4jNoTSwiiSHBOHDLbepP7ZfnXZBV8PuXJ64gNJsoEBBl9
         ONdw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=q0g/zyyg3cWNQoMPaaZkiDSHcWfec0cZrjPhzZaKF2I=;
        b=mPh8WKGDhJuuU+/S6H04H2ohhTOKQWIVg4lHZkeJwm/51ByFGrBgQ4OhLqvWVuqs2G
         6kRBNzE3YrrgsvLxhPVkcnZPXD6hoobgyNx5JwS/r0yckZH9i280/XpGOzxFlvVl9FnV
         YlQClLeTloyQ6fKQ6iLGXQ8rsQuWfLOZkJYHxvevwhcqFLcyTwKEQSFpEdOQS1f+Rngg
         6CH21jLmDs8Xu5A71GzKPTwoQA3Tf79H0Z1e68B0bl7j4gNAayODJYdDtpGPB10CGdR9
         NCIgzBqDSfOOn2Ba+chGA+dEXETzO7M3FMvlODUnb4kJmu0u1u1VXIZ3y91CewByjiJY
         GQmg==
X-Gm-Message-State: AGi0PuY1xTOv7DZa9M183NIGa+NSosimptoEye1NrsO1Kkp51xH3uKCg
        7DFwAXcDsn7o8SA6LqYcvMI8nNVhL6Q=
X-Google-Smtp-Source: APiQypI24txSJ5VGpbi+IijhkfEIiR428oglxXRqRo/NpXeqi6IWTJqyEV0Olzew8lOQuEuM/bw2xA==
X-Received: by 2002:a17:90b:1901:: with SMTP id mp1mr4630395pjb.196.1586342784280;
        Wed, 08 Apr 2020 03:46:24 -0700 (PDT)
Received: from localhost.localdomain (ftp.datadirectnet.jp. [182.171.80.51])
        by smtp.gmail.com with ESMTPSA id y17sm16177024pfl.104.2020.04.08.03.46.22
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 08 Apr 2020 03:46:23 -0700 (PDT)
From:   Wang Shilong <wangshilong1991@gmail.com>
To:     linux-ext4@vger.kernel.org
Cc:     lixi@ddn.com, adilger@dilger.ca, sihara@ddn.com,
        Wang Shilong <wshilong@ddn.com>
Subject: [RFC PATCH 24/46] e2fsck: add debug codes for multiple threds
Date:   Wed,  8 Apr 2020 19:44:52 +0900
Message-Id: <1586342714-12536-25-git-send-email-wangshilong1991@gmail.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1586342714-12536-1-git-send-email-wangshilong1991@gmail.com>
References: <1586342714-12536-1-git-send-email-wangshilong1991@gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org

From: Li Xi <lixi@ddn.com>

These debug codes are added to run the multiple pass1 check
thread one by one in order. If all the codes are correct,
fsck of multiple threads should have exactly the same outcome
with single thread.

Signed-off-by: Li Xi <lixi@ddn.com>
Signed-off-by: Wang Shilong <wshilong@ddn.com>
---
 e2fsck/e2fsck.h | 14 ++++++++++++++
 e2fsck/pass1.c  | 31 ++++++++++++++++++++++++++++++-
 2 files changed, 44 insertions(+), 1 deletion(-)

diff --git a/e2fsck/e2fsck.h b/e2fsck/e2fsck.h
index f8e98f73..61761684 100644
--- a/e2fsck/e2fsck.h
+++ b/e2fsck/e2fsck.h
@@ -451,6 +451,17 @@ struct e2fsck_struct {
 
 };
 
+#ifdef DEBUG_THREADS
+/*
+ * Enabling DEBUG_THREADS would cause the parall fsck threads run sequentially
+ */
+struct e2fsck_thread_debug {
+	pthread_mutex_t	etd_mutex;
+	pthread_cond_t	etd_cond;
+	int		etd_finished_threads;
+};
+#endif
+
 struct e2fsck_thread_info {
 	/* ID returned by pthread_create() */
 	pthread_t		 eti_thread_id;
@@ -460,6 +471,9 @@ struct e2fsck_thread_info {
 	int			 eti_started;
 	/* Context used for this thread */
 	e2fsck_t		 eti_thread_ctx;
+#ifdef DEBUG_THREADS
+	struct e2fsck_thread_debug	*eti_debug;
+#endif
 };
 
 /* Data structures to evaluate whether an extent tree needs rebuilding. */
diff --git a/e2fsck/pass1.c b/e2fsck/pass1.c
index 1f47cbff..f8115679 100644
--- a/e2fsck/pass1.c
+++ b/e2fsck/pass1.c
@@ -1210,7 +1210,8 @@ void _e2fsck_pass1(e2fsck_t ctx)
 		ctx->readahead_kb = e2fsck_guess_readahead(ctx->fs);
 	pass1_readahead(ctx, &ra_group, &ino_threshold);
 
-	if (!(ctx->options & E2F_OPT_PREEN))
+	if (!(ctx->options & E2F_OPT_PREEN) &&
+	    ((!ctx->global_ctx) || (ctx->thread_info.et_thread_index == 0)))
 		fix_problem(ctx, PR_1_PASS_HEADER, &pctx);
 
 	if (ext2fs_has_feature_dir_index(fs->super) &&
@@ -2635,6 +2636,17 @@ static void *e2fsck_pass1_thread(void *arg)
 {
 	struct e2fsck_thread_info	*info = arg;
 	e2fsck_t			 thread_ctx = info->eti_thread_ctx;
+#ifdef DEBUG_THREADS
+	struct e2fsck_thread_debug	*thread_debug = info->eti_debug;
+#endif
+
+#ifdef DEBUG_THREADS
+	pthread_mutex_lock(&thread_debug->etd_mutex);
+	while (info->eti_thread_index > thread_debug->etd_finished_threads) {
+		pthread_cond_wait(&thread_debug->etd_cond, &thread_debug->etd_mutex);
+	}
+	pthread_mutex_unlock(&thread_debug->etd_mutex);
+#endif
 
 #ifdef HAVE_SETJMP_H
 	/*
@@ -2659,6 +2671,14 @@ out:
 			thread_ctx->thread_info.et_group_start,
 			thread_ctx->thread_info.et_group_end,
 			thread_ctx->thread_info.et_inode_number);
+
+#ifdef DEBUG_THREADS
+	pthread_mutex_lock(&thread_debug->etd_mutex);
+	thread_debug->etd_finished_threads++;
+	pthread_cond_broadcast(&thread_debug->etd_cond);
+	pthread_mutex_unlock(&thread_debug->etd_mutex);
+#endif
+	 
 	return NULL;
 }
 
@@ -2672,6 +2692,12 @@ static int e2fsck_pass1_threads_start(struct e2fsck_thread_info **pinfo,
 	struct e2fsck_thread_info	*tmp_pinfo;
 	int				 i;
 	e2fsck_t			 thread_ctx;
+#ifdef DEBUG_THREADS
+	struct e2fsck_thread_debug	 thread_debug =
+		{PTHREAD_MUTEX_INITIALIZER, PTHREAD_COND_INITIALIZER, 0};
+
+	thread_debug.etd_finished_threads = 0;
+#endif
 
 	retval = pthread_attr_init(&attr);
 	if (retval) {
@@ -2692,6 +2718,9 @@ static int e2fsck_pass1_threads_start(struct e2fsck_thread_info **pinfo,
 	for (i = 0; i < num_threads; i++) {
 		tmp_pinfo = &infos[i];
 		tmp_pinfo->eti_thread_index = i;
+#ifdef DEBUG_THREADS
+		tmp_pinfo->eti_debug = &thread_debug;
+#endif
 		retval = e2fsck_pass1_thread_prepare(global_ctx, &thread_ctx,
 						     i, num_threads);
 		if (retval) {
-- 
2.25.2

