Return-Path: <SRS0=NyoO=QE=vger.kernel.org=linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,UNPARSEABLE_RELAY,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 52F3CC3E8A4
	for <linux-ext4@archiver.kernel.org>; Mon, 28 Jan 2019 21:32:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 296DD2177E
	for <linux-ext4@archiver.kernel.org>; Mon, 28 Jan 2019 21:32:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728234AbfA1Vcx (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Mon, 28 Jan 2019 16:32:53 -0500
Received: from bhuna.collabora.co.uk ([46.235.227.227]:58192 "EHLO
        bhuna.collabora.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727156AbfA1Vcw (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Mon, 28 Jan 2019 16:32:52 -0500
Received: from [127.0.0.1] (localhost [127.0.0.1])
        (Authenticated sender: krisman)
        with ESMTPSA id A819527FB80
From:   Gabriel Krisman Bertazi <krisman@collabora.com>
To:     tytso@mit.edu
Cc:     linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org,
        sfrench@samba.org, darrick.wong@oracle.com,
        samba-technical@lists.samba.org, jlayton@kernel.org,
        bfields@fieldses.org, paulus@samba.org,
        Gabriel Krisman Bertazi <krisman@collabora.com>
Subject: [PATCH RFC v5 07/11] MAINTAINERS: Add Unicode subsystem entry
Date:   Mon, 28 Jan 2019 16:32:19 -0500
Message-Id: <20190128213223.31512-8-krisman@collabora.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190128213223.31512-1-krisman@collabora.com>
References: <20190128213223.31512-1-krisman@collabora.com>
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
index 380e43f585d3..ab1f04436ea2 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -15337,6 +15337,12 @@ F:	drivers/uwb/
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

