Return-Path: <SRS0=5TFS=QV=vger.kernel.org=linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CB5CAC10F04
	for <linux-ext4@archiver.kernel.org>; Thu, 14 Feb 2019 10:01:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9ED28222A1
	for <linux-ext4@archiver.kernel.org>; Thu, 14 Feb 2019 10:01:18 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=osandov-com.20150623.gappssmtp.com header.i=@osandov-com.20150623.gappssmtp.com header.b="dIvXE9h0"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2438178AbfBNKBQ (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Thu, 14 Feb 2019 05:01:16 -0500
Received: from mail-pg1-f195.google.com ([209.85.215.195]:41994 "EHLO
        mail-pg1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2438170AbfBNKBN (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Thu, 14 Feb 2019 05:01:13 -0500
Received: by mail-pg1-f195.google.com with SMTP id d72so2803678pga.9
        for <linux-ext4@vger.kernel.org>; Thu, 14 Feb 2019 02:01:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=osandov-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=/zlJMQVShzJL9k1uGmTZzqfsPZnaTknAh/i9pkCAsy4=;
        b=dIvXE9h0N0Wd3Td0GE339/VChq1N0CIZ1uionCe/SPLS1PbzR9f6SK5wdW6s6X7VZz
         25gaDoZM4cK2531I1SsAxO9Yq7hNvXPEbQCC8zHufjfEcWTE8hVvCbWKFGa/tWTOJzgD
         NKIDgmGYeAuvMiTJYnJgd2d2zUoNd9gQAWoj/0Qss21ZPbgJwMfUI87n/91CtYaLVPBV
         rhIwEzXUs8rdVQos+PZVhf2eFw8fU60YlornbozjACLJzSOGD0zVOHKdBcxFj+c9IDtf
         ufG55FGueD3JfbVpi2hNOF16JU6dZLzkWAfgNFN3vRTcG9DQhZRFApFTaNq/woZsnrXL
         3SWQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=/zlJMQVShzJL9k1uGmTZzqfsPZnaTknAh/i9pkCAsy4=;
        b=U7IC40fcCC9jnCHWEf0I+omeELf94rQl9PET9M6udZVZBpcWne2gpSkOM2Lnzm2TW+
         5fgIESa6yG0xW63uzTd3jMZT1U9qHmS7Mu4tsJBPsAW7Ns267qnvqSzo62iA/jqnEWId
         qUWf0PzoWqws4BmW7rDcMbNUolCtGcSFnnyNUgyPB5IOFgCZmgbD/mxGY3dbV6uv670u
         HyaMt6pcRo4C4U2I3Qp4Vj7rFbCX2qKRdxQ581Hho+kXHSY162f6MtJj8rXQ9DGa4nCw
         sxY1Sojezvuxc3rJLbJb1/gAWGIIkLI2WZskyrd/hVxqaWxGp8K75V6bx+jq64ekNdUY
         DEGA==
X-Gm-Message-State: AHQUAuamUQHzYrk3mekykHeoujoPAUAfDk2hFuO+3krvSj/da2XHMme4
        arfaOaUjhor8AZDdGoBTFGN9fQ==
X-Google-Smtp-Source: AHgI3IaoJoQ7v0RWU/FxKUBpUH++Bh+NK6gVEVHdFAhRL/3vNVOxPJkKlHtZWDXsogFQG78EfoG2CQ==
X-Received: by 2002:a65:46cf:: with SMTP id n15mr2975477pgr.187.1550138471684;
        Thu, 14 Feb 2019 02:01:11 -0800 (PST)
Received: from vader.thefacebook.com ([2620:10d:c090:180::1:5849])
        by smtp.gmail.com with ESMTPSA id i184sm2686952pfc.41.2019.02.14.02.01.10
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 14 Feb 2019 02:01:10 -0800 (PST)
From:   Omar Sandoval <osandov@osandov.com>
To:     linux-fsdevel@vger.kernel.org, Al Viro <viro@zeniv.linux.org.uk>
Cc:     kernel-team@fb.com, linux-api@vger.kernel.org,
        linux-btrfs@vger.kernel.org, linux-ext4@vger.kernel.org,
        linux-f2fs-devel@lists.sourceforge.net, linux-xfs@vger.kernel.org
Subject: [PATCH] xfs_io: add AT_UTIME_BTIME support
Date:   Thu, 14 Feb 2019 02:00:16 -0800
Message-Id: <347edcff487b59d56844f51eb74a42220fac64c9.1550138137.git.osandov@fb.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <cover.1550136164.git.osandov@fb.com>
References: <cover.1550136164.git.osandov@fb.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-ext4-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org

From: Omar Sandoval <osandov@fb.com>

In order to test updating btime, make the utimes command optionally take
the btime timestamp.

Signed-off-by: Omar Sandoval <osandov@fb.com>
---
 io/utimes.c       | 41 +++++++++++++++++++++++++++++++----------
 man/man8/xfs_io.8 |  5 +++--
 2 files changed, 34 insertions(+), 12 deletions(-)

diff --git a/io/utimes.c b/io/utimes.c
index 40117472..72ce68f3 100644
--- a/io/utimes.c
+++ b/io/utimes.c
@@ -4,11 +4,18 @@
  * All Rights Reserved.
  */
 
+#include <fcntl.h>
+#include <sys/syscall.h>
+
 #include "command.h"
 #include "input.h"
 #include "init.h"
 #include "io.h"
 
+#ifndef AT_UTIME_BTIME
+#define AT_UTIME_BTIME 0x8000
+#endif
+
 static cmdinfo_t utimes_cmd;
 
 static void
@@ -16,9 +23,10 @@ utimes_help(void)
 {
 	printf(_(
 "\n"
-" Update file atime and mtime of the current file with nansecond precision.\n"
+" Update file atime, mtime, and optionally btime of the current file with\n"
+" nansecond precision.\n"
 "\n"
-" Usage: utimes atime_sec atime_nsec mtime_sec mtime_nsec.\n"
+" Usage: utimes atime_sec atime_nsec mtime_sec mtime_nsec [btime_sec btime_nsec]\n"
 " *_sec: Seconds elapsed since 1970-01-01 00:00:00 UTC.\n"
 " *_nsec: Nanoseconds since the corresponding *_sec.\n"
 "\n"));
@@ -29,9 +37,13 @@ utimes_f(
 	int		argc,
 	char		**argv)
 {
-	struct timespec t[2];
+	struct timespec t[3];
+	int flags = 0;
 	int result;
 
+	if (argc == 6)
+		return command_usage(&utimes_cmd);
+
 	/* Get the timestamps */
 	result = timespec_from_string(argv[1], argv[2], &t[0]);
 	if (result) {
@@ -43,13 +55,22 @@ utimes_f(
 		fprintf(stderr, "Bad value for mtime\n");
 		return 0;
 	}
-
-	/* Call futimens to update time. */
-	if (futimens(file->fd, t)) {
-		perror("futimens");
-		return 0;
+	if (argc == 7) {
+		result = timespec_from_string(argv[5], argv[6], &t[2]);
+		if (result) {
+			fprintf(stderr, "Bad value for btime\n");
+			return 0;
+		}
+		flags |= AT_UTIME_BTIME;
 	}
 
+	/*
+	 * Use syscall() because the glibc wrapper for utimensat() disallows a
+	 * NULL pathname.
+	 */
+	if (syscall(SYS_utimensat, file->fd, NULL, t, flags))
+		perror("utimensat");
+
 	return 0;
 }
 
@@ -59,9 +80,9 @@ utimes_init(void)
 	utimes_cmd.name = "utimes";
 	utimes_cmd.cfunc = utimes_f;
 	utimes_cmd.argmin = 4;
-	utimes_cmd.argmax = 4;
+	utimes_cmd.argmax = 6;
 	utimes_cmd.flags = CMD_NOMAP_OK | CMD_FOREIGN_OK;
-	utimes_cmd.args = _("atime_sec atime_nsec mtime_sec mtime_nsec");
+	utimes_cmd.args = _("atime_sec atime_nsec mtime_sec mtime_nsec [btime_sec btime_nsec]");
 	utimes_cmd.oneline = _("Update file times of the current file");
 	utimes_cmd.help = utimes_help;
 
diff --git a/man/man8/xfs_io.8 b/man/man8/xfs_io.8
index fbf50df5..dbf8098b 100644
--- a/man/man8/xfs_io.8
+++ b/man/man8/xfs_io.8
@@ -827,8 +827,9 @@ verbose output will be printed.
 .RE
 .PD
 .TP
-.BI utimes " atime_sec atime_nsec mtime_sec mtime_nsec"
-The utimes command changes the atime and mtime of the current file.
+.BI utimes " atime_sec atime_nsec mtime_sec mtime_nsec [btime_sec btime_nsec]"
+The utimes command changes the atime, mtime, and optionally btime of the
+current file.
 sec uses UNIX timestamp notation and is the seconds elapsed since
 1970-01-01 00:00:00 UTC.
 nsec is the nanoseconds since the sec. This value needs to be in
-- 
2.20.1

