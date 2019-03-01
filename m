Return-Path: <SRS0=HQ1C=RE=vger.kernel.org=linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8D6F4C10F03
	for <linux-ext4@archiver.kernel.org>; Fri,  1 Mar 2019 14:06:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5E2AA20850
	for <linux-ext4@archiver.kernel.org>; Fri,  1 Mar 2019 14:06:41 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Qq6NfDDL"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388416AbfCAOGk (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Fri, 1 Mar 2019 09:06:40 -0500
Received: from mail-pl1-f194.google.com ([209.85.214.194]:42129 "EHLO
        mail-pl1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387479AbfCAOGi (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Fri, 1 Mar 2019 09:06:38 -0500
Received: by mail-pl1-f194.google.com with SMTP id v11so6129115plg.9;
        Fri, 01 Mar 2019 06:06:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=XECY0gJFm5j4VyNmHVw+4OBNDgux0iT8vjw1kITJnmI=;
        b=Qq6NfDDLcOeiRfV/TYL8z4MznIvTuW7QOG8ns8DYvJKKO+RpWhKWFHkN7bm4HwCgek
         j/hSbTpkIgxIXrOncc5b4XnWhLIJP1eetPt+M2ZNh7xG8b55kmU0Pbx+GFWsoWsb7rv6
         6afFyCA9KUjp1T/Hpw7Gmz9uJHIUZL/C5bWEKd6qWhM+8irp9QgSSNb1GDoaoyyehBx1
         mGtUuYyxgsZdBhhTAw8uE+53v1N8XkPe5L5O4pIsbJ0NH8XEG+Y5KyuPq9tb2qHT2ELw
         d962SvzaFC8l3fQqtkmgZ3uQpKA9efAsIjxVn0gtHFO9mUnPlYIpgxEiLkD95INw/0oV
         mSWQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=XECY0gJFm5j4VyNmHVw+4OBNDgux0iT8vjw1kITJnmI=;
        b=NKyVRGdbfdIRbDwooeOhFN7HLXtyo2QFNELVc8Cupw2OYPFYc6KUaydN7BWGvg9FO5
         scB735w2wIMtcYuJi1r3y3j0n1A+QVEMZDLKSrAxaMJxLLocXJ2DDPvAWcg2L30zjy3w
         ePo4qOvdV6s4DyLA9YK/qi1MhZOQFBj2Chn/Gtrffyq5MQzCKP6qV3gBP4OOBE/EAU1Y
         mTQerTQpjnU213nfn5/H7dQvFTLZZC4wi9mNikGHQ0dKPfGPpRcQbszMQ9ldwKxVNax+
         bjXm+qJpqdi886fQ3M3C5YW4TEK55mpEEXVrvGR4JowC47n9YxuHy1bjeCkkPZzPcnZq
         E4wg==
X-Gm-Message-State: APjAAAUCisUIpxVnAwWu5XSG4QGO43l9kOAJxeegVah/tJHK65qwOlD8
        XdUGgcaTWy3Y/IpQZwIlCfT4TNjt
X-Google-Smtp-Source: APXvYqxnqxh8QuKXYIlfjRJJxWu8PlHHpau2TYS/iCg71S6w6BWV0oXRogR74HQ6Zo8txIbfSFwEvA==
X-Received: by 2002:a17:902:b402:: with SMTP id x2mr5588519plr.53.1551449197213;
        Fri, 01 Mar 2019 06:06:37 -0800 (PST)
Received: from localhost.localdomain (fs276ec80e.tkyc203.ap.nuro.jp. [39.110.200.14])
        by smtp.gmail.com with ESMTPSA id o2sm36534917pfa.76.2019.03.01.06.06.34
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 01 Mar 2019 06:06:36 -0800 (PST)
From:   Wang Shilong <wangshilong1991@gmail.com>
X-Google-Original-From: Wang Shilong <wshilong1991@gmail.com>
To:     linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org,
        linux-xfs@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net
Cc:     lixi@ddn.com, adilger@dilger.ca, Wang Shilong <wshilong@ddn.com>,
        linux-man@vger.kernel.org
Subject: [PATCH 2/2] statx.2: add project support update
Date:   Fri,  1 Mar 2019 23:06:24 +0900
Message-Id: <1551449184-7942-3-git-send-email-wshilong1991@gmail.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1551449184-7942-1-git-send-email-wshilong1991@gmail.com>
References: <1551449184-7942-1-git-send-email-wshilong1991@gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org

From: Wang Shilong <wshilong@ddn.com>

Cc: linux-man@vger.kernel.org
Signed-off-by: Wang Shilong <wshilong@ddn.com>
---
 man2/statx.2 | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/man2/statx.2 b/man2/statx.2
index 7265d8ace..6a9dede8b 100644
--- a/man2/statx.2
+++ b/man2/statx.2
@@ -82,6 +82,7 @@ struct statx {
        containing the filesystem where the file resides */
     __u32 stx_dev_major;   /* Major ID */
     __u32 stx_dev_minor;   /* Minor ID */
+    __u32 stx_projid;      /* Project ID of file */
 };
 .EE
 .in
@@ -261,6 +262,7 @@ STATX_SIZE	Want stx_size
 STATX_BLOCKS	Want stx_blocks
 STATX_BASIC_STATS	[All of the above]
 STATX_BTIME	Want stx_btime
+STATX_PROJID	Want stx_projid
 STATX_ALL	[All currently available fields]
 .TE
 .in
@@ -412,6 +414,9 @@ The device on which this file (inode) resides.
 .IR stx_rdev_major " and "  stx_rdev_minor
 The device that this file (inode) represents if the file is of block or
 character device type.
+.TP
+.I stx_projid
+The file's project ID.
 .PP
 For further information on the above fields, see
 .BR inode (7).
@@ -458,6 +463,9 @@ See
 .TP
 .B STATX_ATTR_ENCRYPTED
 A key is required for the file to be encrypted by the filesystem.
+.TP
+.B STATX_ATTR_PROJINHERIT
+Sub directories or files will inherit parent's project ID automatically.
 .SH RETURN VALUE
 On success, zero is returned.
 On error, \-1 is returned, and
-- 
2.19.1

