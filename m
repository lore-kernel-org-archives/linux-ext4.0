Return-Path: <SRS0=Cq3/=AR=vger.kernel.org=linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.7 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DB4A8C433E1
	for <linux-ext4@archiver.kernel.org>; Mon,  6 Jul 2020 19:53:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id BFDE1207D0
	for <linux-ext4@archiver.kernel.org>; Mon,  6 Jul 2020 19:53:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725942AbgGFTxz (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Mon, 6 Jul 2020 15:53:55 -0400
Received: from zulu.geekplace.eu ([5.45.100.158]:35008 "EHLO zulu.geekplace.eu"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725892AbgGFTxy (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Mon, 6 Jul 2020 15:53:54 -0400
Received: from neo-pc.sch (55d4bc09.access.ecotel.net [85.212.188.9])
        by zulu.geekplace.eu (Postfix) with ESMTPA id D4ECD4A0DF1;
        Mon,  6 Jul 2020 21:48:11 +0200 (CEST)
From:   Florian Schmaus <flo@geekplace.eu>
To:     linux-ext4@vger.kernel.org
Cc:     Florian Schmaus <flo@geekplace.eu>
Subject: [PATCH 3/3] Clarify in e4crypt man page that -S is an optional argument
Date:   Mon,  6 Jul 2020 21:47:27 +0200
Message-Id: <20200706194727.12979-3-flo@geekplace.eu>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200706194727.12979-1-flo@geekplace.eu>
References: <20200706194727.12979-1-flo@geekplace.eu>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-ext4-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org

The Backus-Naur Form (BNF) of the synopsis of 'add_key' does currently
not state that the -S parameter takes an *mandatory* argument, while
the BNF found in the commands section of the man page does. The square
brackets around the optional parameter are also missing.

synopsis:
e4crypt add_key -S [ -k keyring ] [-v] [-q] [ -p pad ] [ path ... ]

commands:
e4crypt add_key [-vq] [-S salt ] [-k keyring ] [ -p pad ] [ path ... ]

This simply copies the add_key BNF from he commands section into the
synopsis.

Signed-off-by: Florian Schmaus <flo@geekplace.eu>
---
 misc/e4crypt.8.in | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/misc/e4crypt.8.in b/misc/e4crypt.8.in
index 32fbd444..d2d6c872 100644
--- a/misc/e4crypt.8.in
+++ b/misc/e4crypt.8.in
@@ -2,7 +2,7 @@
 .SH NAME
 e4crypt \- ext4 filesystem encryption utility
 .SH SYNOPSIS
-.B e4crypt add_key -S \fR[\fB -k \fIkeyring\fR ] [\fB-v\fR] [\fB-q\fR] \fR[\fB -p \fIpad\fR ] [ \fIpath\fR ... ]
+.B e4crypt add_key \fR[\fB-vq\fR] [\fB-S\fI salt\fR ] [\fB-k \fIkeyring\fR ] [\fB -p \fIpad\fR ] [ \fIpath\fR ... ]
 .br
 .B e4crypt new_session
 .br
-- 
2.26.2

