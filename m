Return-Path: <SRS0=HQ1C=RE=vger.kernel.org=linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.3 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,UNWANTED_LANGUAGE_BODY,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EAE41C10F06
	for <linux-ext4@archiver.kernel.org>; Fri,  1 Mar 2019 14:06:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B70AE2085A
	for <linux-ext4@archiver.kernel.org>; Fri,  1 Mar 2019 14:06:07 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="bwMkidqD"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388179AbfCAOGG (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Fri, 1 Mar 2019 09:06:06 -0500
Received: from mail-pg1-f193.google.com ([209.85.215.193]:37739 "EHLO
        mail-pg1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387836AbfCAOGG (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Fri, 1 Mar 2019 09:06:06 -0500
Received: by mail-pg1-f193.google.com with SMTP id q206so11506265pgq.4;
        Fri, 01 Mar 2019 06:06:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=csWCm9wcihuFFL4oUEGmYUPt6om3ctC29q/OFYjhErk=;
        b=bwMkidqD6m5h/zOFkwkGPoK7AvAU84RKMKIz7CKeP2TRDv3BdjKH8nnRl0SVBmIFGR
         cjHWcbAMH8vCKY/SpvhD2TFi2r5/32QH4oIJgK2IxnamqlNkaqmLa2mcF4wg+5kdEeAt
         QCpbjkmDsR0LQhuYbY3CycDzsSKv04bnIQHp+TBHLuDRs55mE6nwd3Ioor3XAHR62+3e
         3ZmMEnA1QRZ01x2TPzFO8Q5JJm9NxCkEqSvjprkSzGftQAkVCXZK8VFLstIrrz1KXzOX
         zquVBGre5Qf+JK545vfw4Uvq3bBmnnG9T9cJzyP5NRCs2vrOcQOUQ5WevFiERGRjhQja
         cKtA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=csWCm9wcihuFFL4oUEGmYUPt6om3ctC29q/OFYjhErk=;
        b=YdgUE+ot128CYbWJQaEIiCYYcSTT0zOjsO2T+vcfFxyuWqU6gEkmPN4oqLy53oEmRD
         OGgmTE0uQyFq2o72ntTsyEa/YVsIBkiW/bu6Ko/psw3OUWmSdEAAn6Z+oER9IEjKEwnF
         SSkktNqlqXeQTLB894LnddDxY0XXKnIHYRP2ZQ5+anwrfzB1PloTdzWOQEWg3upjYzkH
         L6F9jms6LWElMwZrdnTCZBVAPK4lwsvjlSe+RofzGq2CD1LXqNyuri0YyLoAS2YGVnSI
         1vCeRPS7qCOItuVcunu3eJSSJ1y2yeuWaWM2UdSbujxNZbvldvWlQvWO985hDKK5KvXn
         a3CA==
X-Gm-Message-State: AHQUAubhlX+rem6fcXvM0iIyZxzPjaQ4iU7vTMk6pzuOemHRTm2bP4Zk
        F4VKWXI/yWMRJDm26bNPFJcPb4P/
X-Google-Smtp-Source: AHgI3IboBpcdD5M0lYdeSrL6Z5y9WAduUlI23iLXpgtGfPDBkrRvf+2Oz1kj+RJzL4YffpHKwpp9Kg==
X-Received: by 2002:a62:6d81:: with SMTP id i123mr5647563pfc.235.1551449164026;
        Fri, 01 Mar 2019 06:06:04 -0800 (PST)
Received: from localhost.localdomain (fs276ec80e.tkyc203.ap.nuro.jp. [39.110.200.14])
        by smtp.gmail.com with ESMTPSA id a184sm12458089pge.68.2019.03.01.06.06.01
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 01 Mar 2019 06:06:03 -0800 (PST)
From:   Wang Shilong <wangshilong1991@gmail.com>
X-Google-Original-From: Wang Shilong <wshilong1991@gmail.com>
To:     linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org,
        linux-xfs@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net
Cc:     lixi@ddn.com, adilger@dilger.ca, Wang Shilong <wshilong@ddn.com>
Subject: [PATCH 5/8] fs: add project support to statx
Date:   Fri,  1 Mar 2019 23:05:38 +0900
Message-Id: <1551449141-7884-6-git-send-email-wshilong1991@gmail.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1551449141-7884-1-git-send-email-wshilong1991@gmail.com>
References: <1551449141-7884-1-git-send-email-wshilong1991@gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org

From: Wang Shilong <wshilong@ddn.com>

From: Wang Shilong <wshilong@ddn.com>

Extend statx to support project ID and inherit attribute.

Signed-off-by: Wang Shilong <wshilong@ddn.com>
---
 fs/stat.c                       | 1 +
 include/linux/stat.h            | 2 ++
 include/uapi/linux/stat.h       | 8 ++++++--
 tools/include/uapi/linux/stat.h | 8 ++++++--
 4 files changed, 15 insertions(+), 4 deletions(-)

diff --git a/fs/stat.c b/fs/stat.c
index adbfcd86c81b..82d855c4647c 100644
--- a/fs/stat.c
+++ b/fs/stat.c
@@ -551,6 +551,7 @@ cp_statx(const struct kstat *stat, struct statx __user *buffer)
 	tmp.stx_rdev_minor = MINOR(stat->rdev);
 	tmp.stx_dev_major = MAJOR(stat->dev);
 	tmp.stx_dev_minor = MINOR(stat->dev);
+	tmp.stx_projid = (u32)from_kprojid(&init_user_ns, stat->projid);
 
 	return copy_to_user(buffer, &tmp, sizeof(tmp)) ? -EFAULT : 0;
 }
diff --git a/include/linux/stat.h b/include/linux/stat.h
index 765573dc17d6..72c9d2ab5343 100644
--- a/include/linux/stat.h
+++ b/include/linux/stat.h
@@ -18,6 +18,7 @@
 #include <linux/types.h>
 #include <linux/time.h>
 #include <linux/uidgid.h>
+#include <linux/projid.h>
 
 #define KSTAT_QUERY_FLAGS (AT_STATX_SYNC_TYPE)
 
@@ -40,6 +41,7 @@ struct kstat {
 	dev_t		rdev;
 	kuid_t		uid;
 	kgid_t		gid;
+	kprojid_t	projid;
 	loff_t		size;
 	struct timespec64 atime;
 	struct timespec64 mtime;
diff --git a/include/uapi/linux/stat.h b/include/uapi/linux/stat.h
index 7b35e98d3c58..56d35a2cbd0c 100644
--- a/include/uapi/linux/stat.h
+++ b/include/uapi/linux/stat.h
@@ -123,7 +123,9 @@ struct statx {
 	__u32	stx_dev_major;	/* ID of device containing file [uncond] */
 	__u32	stx_dev_minor;
 	/* 0x90 */
-	__u64	__spare2[14];	/* Spare space for future expansion */
+	__u32	stx_projid;	/* Project ID of file */
+	__u32	__spare1[1];
+	__u64	__spare2[13];	/* Spare space for future expansion */
 	/* 0x100 */
 };
 
@@ -148,7 +150,8 @@ struct statx {
 #define STATX_BLOCKS		0x00000400U	/* Want/got stx_blocks */
 #define STATX_BASIC_STATS	0x000007ffU	/* The stuff in the normal stat struct */
 #define STATX_BTIME		0x00000800U	/* Want/got stx_btime */
-#define STATX_ALL		0x00000fffU	/* All currently supported flags */
+#define STATX_PROJID		0x00001000U	/* Want/Got stx_projid */
+#define STATX_ALL		0x00001fffU	/* All currently supported flags */
 #define STATX__RESERVED		0x80000000U	/* Reserved for future struct statx expansion */
 
 /*
@@ -170,5 +173,6 @@ struct statx {
 
 #define STATX_ATTR_AUTOMOUNT		0x00001000 /* Dir: Automount trigger */
 
+#define STATX_ATTR_PROJINHERIT		0x00002000 /* [I] File project inherit is set */
 
 #endif /* _UAPI_LINUX_STAT_H */
diff --git a/tools/include/uapi/linux/stat.h b/tools/include/uapi/linux/stat.h
index 7b35e98d3c58..21b542b3b061 100644
--- a/tools/include/uapi/linux/stat.h
+++ b/tools/include/uapi/linux/stat.h
@@ -123,7 +123,9 @@ struct statx {
 	__u32	stx_dev_major;	/* ID of device containing file [uncond] */
 	__u32	stx_dev_minor;
 	/* 0x90 */
-	__u64	__spare2[14];	/* Spare space for future expansion */
+	__u32   stx_projid;     /* Project ID of file */
+	__u32   __spare1[1];
+	__u64   __spare2[13];   /* Spare space for future expansion */
 	/* 0x100 */
 };
 
@@ -148,7 +150,8 @@ struct statx {
 #define STATX_BLOCKS		0x00000400U	/* Want/got stx_blocks */
 #define STATX_BASIC_STATS	0x000007ffU	/* The stuff in the normal stat struct */
 #define STATX_BTIME		0x00000800U	/* Want/got stx_btime */
-#define STATX_ALL		0x00000fffU	/* All currently supported flags */
+#define STATX_PROJID		0x00001000U	/* Want/Got stx_projid */
+#define STATX_ALL		0x00001fffU	/* All currently supported flags */
 #define STATX__RESERVED		0x80000000U	/* Reserved for future struct statx expansion */
 
 /*
@@ -170,5 +173,6 @@ struct statx {
 
 #define STATX_ATTR_AUTOMOUNT		0x00001000 /* Dir: Automount trigger */
 
+#define STATX_ATTR_PROJINHERIT		0x00002000 /* [I] File project inherit is set */
 
 #endif /* _UAPI_LINUX_STAT_H */
-- 
2.19.1

