Return-Path: <SRS0=rGJk=55=vger.kernel.org=linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9E2D7C2BA19
	for <linux-ext4@archiver.kernel.org>; Mon, 13 Apr 2020 04:24:31 +0000 (UTC)
Received: from vger.kernel.org (unknown [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5E7F920663
	for <linux-ext4@archiver.kernel.org>; Mon, 13 Apr 2020 04:24:31 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="J4K05H60"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 5E7F920663
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=gmail.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-ext4-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728672AbgDMEYa (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Mon, 13 Apr 2020 00:24:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.18]:59346 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725775AbgDMEYa (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Mon, 13 Apr 2020 00:24:30 -0400
Received: from mail-pg1-x544.google.com (mail-pg1-x544.google.com [IPv6:2607:f8b0:4864:20::544])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 46099C0A3BE0
        for <linux-ext4@vger.kernel.org>; Sun, 12 Apr 2020 21:24:30 -0700 (PDT)
Received: by mail-pg1-x544.google.com with SMTP id r4so3965422pgg.4
        for <linux-ext4@vger.kernel.org>; Sun, 12 Apr 2020 21:24:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=AOwB89TYL1Yz2wdCqd16VAfNqCa2VnemMSYfm1/y0CM=;
        b=J4K05H60JpJVxxQqhtMQE6nxxGFfwG6MQbQ8iymrUcjav9Bq6hODt9h3QK0bR95lpc
         XxhBQxEC10pPLm58EX+02M+moJRPbjpPSdv8Nb1Edg+krci1ndfPZ+s7B2+BXNKK8DjC
         9uL2e042lKyg+jKdYlgaMbHY3xWblZSMov39l0v424k1R7jyvmcdTpN7GdvwLDrwGSFt
         YawBTqVAmG7lhfSqlVlNA+FaUzKclEmyHDedFXMrqvWkiI/N/gUVIcGBhOU/VQ0ZmC37
         OTkRuS+ZOEB6TBp17o3Gto+v95orwLNqv1X/5qmxELrEJr78FQxFOnkveN0o7DQApbS9
         yNbA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=AOwB89TYL1Yz2wdCqd16VAfNqCa2VnemMSYfm1/y0CM=;
        b=SvGtGa5MN59lfXCSGoN1sD4sUBEH26nx1uY/DIb4pFxCGjcgzus9wp7dP2xc73V+Yc
         wFfyXJogdMyZtHY9WMzvNVF8J8rJNH9sNJ4F57ub0pp5E8miHeKM9SQnhdvs+04EgUVD
         FEWEEJaW1BddGKBrc9NyUq1u8JZIPDu8kd4x+79pRh8rMj6LlpFFq/usE98aP868SE4l
         svByZHOaLAPEAtxx/iMV/o40EmQIpV9FpwUCobxGdS0gUzpnNvzg0YjeL0ebI+3b81bT
         LsN4jDRQ+xVkYagxokE3cVD6D8xEfKOTPfLgI0qixybazHB4xCQP7bkY7SbSPVQSwsq+
         aPPQ==
X-Gm-Message-State: AGi0PuZtR3iuK9/dJsCWCx7B1qRU6ZfcfzX2vdYCBBvKlntstwPXE/w+
        IuTPDPLe0gAe8ma91wMnyT229JU=
X-Google-Smtp-Source: APiQypKVYYWBhihRXZzO8Btu6LeS5NR7cqWfPeBD+tSjZaTerWxZujHNxrIn/2GqodH0xRGiYOGBzg==
X-Received: by 2002:a62:18c8:: with SMTP id 191mr8978679pfy.255.1586751869667;
        Sun, 12 Apr 2020 21:24:29 -0700 (PDT)
Received: from he-cluster.localdomain ([67.216.221.250])
        by smtp.gmail.com with ESMTPSA id t103sm7973034pjb.46.2020.04.12.21.24.28
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Sun, 12 Apr 2020 21:24:29 -0700 (PDT)
From:   xiakaixu1987@gmail.com
X-Google-Original-From: kaixuxia@tencent.com
To:     linux-ext4@vger.kernel.org
Cc:     tytso@mit.edu, adilger.kernel@dilger.ca,
        Kaixu Xia <kaixuxia@tencent.com>
Subject: [PATCH] ext4: remove unnecessary test_opt for DIOREAD_NOLOCK
Date:   Mon, 13 Apr 2020 12:24:22 +0800
Message-Id: <1586751862-19437-1-git-send-email-kaixuxia@tencent.com>
X-Mailer: git-send-email 1.8.3.1
Sender: linux-ext4-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org

From: Kaixu Xia <kaixuxia@tencent.com>

The DIOREAD_NOLOCK flag has been cleared when doing the test_opt
that is meaningless, so remove the unnecessary test_opt for DIOREAD_NOLOCK.

Signed-off-by: Kaixu Xia <kaixuxia@tencent.com>
---
 fs/ext4/super.c | 6 +-----
 1 file changed, 1 insertion(+), 5 deletions(-)

diff --git a/fs/ext4/super.c b/fs/ext4/super.c
index 9728e7b0e84f..855874ea4b29 100644
--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -3973,17 +3973,13 @@ static int ext4_fill_super(struct super_block *sb, void *data, int silent)
 
 	if (test_opt(sb, DATA_FLAGS) == EXT4_MOUNT_JOURNAL_DATA) {
 		printk_once(KERN_WARNING "EXT4-fs: Warning: mounting with data=journal disables delayed allocation, dioread_nolock, and O_DIRECT support!\n");
+		/* can't mount with both data=journal and dioread_nolock. */
 		clear_opt(sb, DIOREAD_NOLOCK);
 		if (test_opt2(sb, EXPLICIT_DELALLOC)) {
 			ext4_msg(sb, KERN_ERR, "can't mount with "
 				 "both data=journal and delalloc");
 			goto failed_mount;
 		}
-		if (test_opt(sb, DIOREAD_NOLOCK)) {
-			ext4_msg(sb, KERN_ERR, "can't mount with "
-				 "both data=journal and dioread_nolock");
-			goto failed_mount;
-		}
 		if (test_opt(sb, DAX)) {
 			ext4_msg(sb, KERN_ERR, "can't mount with "
 				 "both data=journal and dax");
-- 
2.20.0

