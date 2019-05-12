Return-Path: <SRS0=+gwa=TM=vger.kernel.org=linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 054C0C04A6B
	for <linux-ext4@archiver.kernel.org>; Sun, 12 May 2019 08:58:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D4BE021019
	for <linux-ext4@archiver.kernel.org>; Sun, 12 May 2019 08:58:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726441AbfELI6E (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Sun, 12 May 2019 04:58:04 -0400
Received: from outgoing-auth-1.mit.edu ([18.9.28.11]:49055 "EHLO
        outgoing.mit.edu" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1725934AbfELI6E (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Sun, 12 May 2019 04:58:04 -0400
Received: from callcc.thunk.org ([91.207.175.60])
        (authenticated bits=0)
        (User authenticated as tytso@ATHENA.MIT.EDU)
        by outgoing.mit.edu (8.14.7/8.12.4) with ESMTP id x4C8vv7A014751
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Sun, 12 May 2019 04:58:00 -0400
Received: by callcc.thunk.org (Postfix, from userid 15806)
        id 683D9420024; Sun, 12 May 2019 04:57:56 -0400 (EDT)
From:   "Theodore Ts'o" <tytso@mit.edu>
To:     Ext4 Developers List <linux-ext4@vger.kernel.org>
Cc:     "Theodore Ts'o" <tytso@mit.edu>,
        Gabriel Krisman Bertazi <krisman@collabora.com>
Subject: [PATCH] unicode: add missing check for an error return from utf8lookup()
Date:   Sun, 12 May 2019 04:57:52 -0400
Message-Id: <20190512085752.1791-1-tytso@mit.edu>
X-Mailer: git-send-email 2.19.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-ext4-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org

Signed-off-by: Theodore Ts'o <tytso@mit.edu>
Cc: Gabriel Krisman Bertazi <krisman@collabora.com>
---
 fs/unicode/utf8-norm.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/fs/unicode/utf8-norm.c b/fs/unicode/utf8-norm.c
index 20d440c3f2db..801ed6d2ea37 100644
--- a/fs/unicode/utf8-norm.c
+++ b/fs/unicode/utf8-norm.c
@@ -714,6 +714,8 @@ int utf8byte(struct utf8cursor *u8c)
 			}
 
 			leaf = utf8lookup(u8c->data, u8c->hangul, u8c->s);
+			if (!leaf)
+				return -1;
 			ccc = LEAF_CCC(leaf);
 		}
 
-- 
2.19.1

