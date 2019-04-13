Return-Path: <SRS0=R85w=SP=vger.kernel.org=linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,UNPARSEABLE_RELAY,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B5434C10F11
	for <linux-ext4@archiver.kernel.org>; Sat, 13 Apr 2019 19:26:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8D2A6208E3
	for <linux-ext4@archiver.kernel.org>; Sat, 13 Apr 2019 19:26:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727156AbfDMT0I (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Sat, 13 Apr 2019 15:26:08 -0400
Received: from bhuna.collabora.co.uk ([46.235.227.227]:39208 "EHLO
        bhuna.collabora.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727144AbfDMT0I (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Sat, 13 Apr 2019 15:26:08 -0400
Received: from [127.0.0.1] (localhost [127.0.0.1])
        (Authenticated sender: krisman)
        with ESMTPSA id 09C69282140
From:   Gabriel Krisman Bertazi <krisman@collabora.com>
To:     tytso@mit.edu
Cc:     linux-ext4@vger.kernel.org,
        Gabriel Krisman Bertazi <krisman@collabora.com>
Subject: [PATCH v7 07/10] MAINTAINERS: Add Unicode subsystem entry
Date:   Sat, 13 Apr 2019 15:25:30 -0400
Message-Id: <20190413192533.2549-8-krisman@collabora.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190413192533.2549-1-krisman@collabora.com>
References: <20190413192533.2549-1-krisman@collabora.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-ext4-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org

Signed-off-by: Gabriel Krisman Bertazi <krisman@collabora.com>
---
 MAINTAINERS | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/MAINTAINERS b/MAINTAINERS
index 43b36dbed48e..6ad593f913cd 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -15935,6 +15935,12 @@ F:	drivers/uwb/
 F:	include/linux/uwb.h
 F:	include/linux/uwb/
 
+UNICODE SUBSYSTEM:
+M:	Gabriel Krisman Bertazi <krisman@collabora.com>
+L:	linux-fsdevel@vger.kernel.org
+S:	Supported
+F:	fs/unicode/
+
 UNICORE32 ARCHITECTURE:
 M:	Guan Xuetao <gxt@pku.edu.cn>
 W:	http://mprc.pku.edu.cn/~guanxuetao/linux
-- 
2.20.1

