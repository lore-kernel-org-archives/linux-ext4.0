Return-Path: <SRS0=rV8s=XP=vger.kernel.org=linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A8968C4CEC9
	for <linux-ext4@archiver.kernel.org>; Fri, 20 Sep 2019 21:31:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7348F2080F
	for <linux-ext4@archiver.kernel.org>; Fri, 20 Sep 2019 21:31:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1569015081;
	bh=LTqAzUDWUFmPs8gFg+K0lSuwV05UNkeT8pVaObHnzKY=;
	h=From:To:Subject:Date:In-Reply-To:References:List-ID:From;
	b=uM769C1g2V7r7ras5Z65uvR/ICEnfl+Fj1khJYu4YXnzETKM4hTiJPlJIDH56iuZu
	 pXDux6YfNMnWEcMkcVnq8WvoNGPPTwl2qO0wIsCbJr/5HHy044Bmzr4M86WcbExThD
	 RngdzDtlsI8vbwVgLiLXCBcpvjVqnxFaQsCsH2FA=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730227AbfITVbU (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Fri, 20 Sep 2019 17:31:20 -0400
Received: from mail.kernel.org ([198.145.29.99]:39370 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729997AbfITVbU (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Fri, 20 Sep 2019 17:31:20 -0400
Received: from ebiggers-linuxstation.mtv.corp.google.com (unknown [104.132.1.77])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3038F2086A
        for <linux-ext4@vger.kernel.org>; Fri, 20 Sep 2019 21:31:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1569015080;
        bh=LTqAzUDWUFmPs8gFg+K0lSuwV05UNkeT8pVaObHnzKY=;
        h=From:To:Subject:Date:In-Reply-To:References:From;
        b=YaEqsX608neNmkuoTzCemAyVSoMXWoJMPLvZuT6R6PEE5ML1h7N9Zp6IO9GCMdFZy
         63iIiBxixyuZ+FYi0EIYbFlNf3PkLMXXZa37FqKeKKWzFFFdjY9hZGVivdySA+uylP
         uWSvdNRzvo7v3V/wlayKbN30tiuIQzNLavSK29vw=
From:   Eric Biggers <ebiggers@kernel.org>
To:     linux-ext4@vger.kernel.org
Subject: [PATCH 1/6] ext4.5: move casefold feature to correct position
Date:   Fri, 20 Sep 2019 14:29:49 -0700
Message-Id: <20190920212954.205789-2-ebiggers@kernel.org>
X-Mailer: git-send-email 2.23.0.351.gc4317032e6-goog
In-Reply-To: <20190920212954.205789-1-ebiggers@kernel.org>
References: <20190920212954.205789-1-ebiggers@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-ext4-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org

From: Eric Biggers <ebiggers@google.com>

The features are listed in alphabetic order, so put the casefold feature
in the right place.

Signed-off-by: Eric Biggers <ebiggers@google.com>
---
 misc/ext4.5.in | 16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

diff --git a/misc/ext4.5.in b/misc/ext4.5.in
index 01dab48a..0a93c35e 100644
--- a/misc/ext4.5.in
+++ b/misc/ext4.5.in
@@ -61,6 +61,14 @@ This feature requires that the
 .B extent
 feature be enabled.
 .TP
+.B casefold
+.br
+This ext4 feature provides file system level character encoding support
+for directories with the casefold (+F) flag enabled.  This feature is
+name-preserving on the disk, but it allows applications to lookup for a
+file in the file system using an encoding equivalent version of the file
+name.
+.TP
 .B dir_index
 .br
 Use hashed b-trees to speed up name lookups in large directories.  This
@@ -151,14 +159,6 @@ can be specified using the
 .B \-G
 option.
 .TP
-.B casefold
-.br
-This ext4 feature provides file system level character encoding support
-for directories with the casefold (+F) flag enabled.  This feature is
-name-preserving on the disk, but it allows applications to lookup for a
-file in the file system using an encoding equivalent version of the file
-name.
-.TP
 .B has_journal
 .br
 Create a journal to ensure filesystem consistency even across unclean
-- 
2.23.0.351.gc4317032e6-goog

