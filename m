Return-Path: <SRS0=bGTj=RK=vger.kernel.org=linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D6160C43381
	for <linux-ext4@archiver.kernel.org>; Thu,  7 Mar 2019 11:49:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A57B820643
	for <linux-ext4@archiver.kernel.org>; Thu,  7 Mar 2019 11:49:50 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="V7oNFghJ"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726358AbfCGLtu (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Thu, 7 Mar 2019 06:49:50 -0500
Received: from mail-it1-f194.google.com ([209.85.166.194]:54166 "EHLO
        mail-it1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726224AbfCGLtt (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Thu, 7 Mar 2019 06:49:49 -0500
Received: by mail-it1-f194.google.com with SMTP id v2so14766381ith.3
        for <linux-ext4@vger.kernel.org>; Thu, 07 Mar 2019 03:49:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=C0WDnz2+UGO3VxJel8ajdgi7YK8zDeHM+Tjv9opAPo8=;
        b=V7oNFghJFvh24JSZ0EgVVwQdXz8qtCd+lOF6QGeQsVETvaQUnYuaKRoD5WRohnwxL4
         NgQ7dsYHcIDsNBB61hU0FrRaUi+e166nMs3+NEnfhvkvjAnPc+5WXhArrXrPdmlQ/vH5
         3fwg+eb/hmjNvAH1imylEUYVoHcBjXfc2/PNX5uZMQKw/rqnHAZBKqiCOmwjeQP3iXei
         M13yfcOzfc62KzDNT0YBbL96gSr+n3+l4nipxr2ZzeY4gYS76/H30jvMaaT2io+72BGj
         6ni+hMPqRd7sGr+ilCyaLuWZKeucmaCUTLMxK+csP4rQ0EpxqtyjGkd2aCmZPHYqU5v/
         YfgA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=C0WDnz2+UGO3VxJel8ajdgi7YK8zDeHM+Tjv9opAPo8=;
        b=lFD2GKGoXLq6RSWK9uRV8QOzXvf1WKfBtkW7bLx0IRu27c0ysSBdMclxQMiWVEq2PX
         T+iYNaR2+FHPS3/CubQycFh6cSd3dmG6YWILFw+jHlkCnWu+mt4+jekRdfUS8zuk+OZZ
         H2RyPh5rstmz/rtHKMYnxoE2NuEr3yvuvi22ibWcP/DkKROcg2OaRuULZC2xp9RaEP5p
         g2TnFCvUDZfmI6HSuN+Anbu4sUHIbKc1Qa9NTPD9pImcT+SRxzn4YNINwSfgelQ4CpuE
         7Xxi2ID/sq2x1V06unb+TH7EXW9tX6wV+luSbzgSryQH6UVIbBAi46BkaWer6IWATUiC
         14Lg==
X-Gm-Message-State: APjAAAUhLho8O96oM7qsaF2bWb7tt2ghLbn6IZROJO/AWDaKJV0ANS76
        HyDjJaROLbmwzsRd6OvddgFUWuhBel0=
X-Google-Smtp-Source: APXvYqyCAwAvpNew3YcdgSou5WHjAomBkVABMTZmfGLnk6VpwYie3bpVwODAdn2qS7oOY6lcxC9HHA==
X-Received: by 2002:a05:6638:348:: with SMTP id x8mr7393154jap.79.1551959388956;
        Thu, 07 Mar 2019 03:49:48 -0800 (PST)
Received: from C02TN4C6HTD6.us.cray.com (chippewa-nat.cray.com. [136.162.34.1])
        by smtp.gmail.com with ESMTPSA id b21sm2331608itd.37.2019.03.07.03.49.43
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 07 Mar 2019 03:49:47 -0800 (PST)
From:   Artem Blagodarenko <artem.blagodarenko@gmail.com>
X-Google-Original-From: Artem Blagodarenko <c17828@cray.com>
To:     linux-ext4@vger.kernel.org
Cc:     adilger.kernel@dilger.ca, alexey.lyashkov@gmail.com
Subject: [PATCH] ext4: check if group has free space
Date:   Thu,  7 Mar 2019 14:49:14 +0300
Message-Id: <20190307114914.86453-1-c17828@cray.com>
X-Mailer: git-send-email 2.14.3
Sender: linux-ext4-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org

Regular allocator make four groups processing loops to
find good group to allocate blocks. On 4th loop it accept any
group, even if there is no free space at all.

This patch adds group free space check to skip full groups.

Sigend-off-by: Artem Blagodarenko <c17828@cray.com>
---
 fs/ext4/mballoc.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/fs/ext4/mballoc.c b/fs/ext4/mballoc.c
index e2248083cdca..4e6c36ff1d55 100644
--- a/fs/ext4/mballoc.c
+++ b/fs/ext4/mballoc.c
@@ -2087,7 +2087,8 @@ static int ext4_mb_good_group(struct ext4_allocation_context *ac,
 			return 1;
 		break;
 	case 3:
-		return 1;
+		/* Skip group without any free space */
+		return free ? 1 : 0;
 	default:
 		BUG();
 	}
-- 
2.14.3

