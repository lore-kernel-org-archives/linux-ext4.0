Return-Path: <SRS0=R85w=SP=vger.kernel.org=linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,UNPARSEABLE_RELAY,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AE512C10F14
	for <linux-ext4@archiver.kernel.org>; Sat, 13 Apr 2019 05:43:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 821A520850
	for <linux-ext4@archiver.kernel.org>; Sat, 13 Apr 2019 05:43:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726932AbfDMFn7 (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Sat, 13 Apr 2019 01:43:59 -0400
Received: from bhuna.collabora.co.uk ([46.235.227.227]:37510 "EHLO
        bhuna.collabora.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726480AbfDMFn6 (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Sat, 13 Apr 2019 01:43:58 -0400
Received: from [127.0.0.1] (localhost [127.0.0.1])
        (Authenticated sender: krisman)
        with ESMTPSA id B40B02823E1
From:   Gabriel Krisman Bertazi <krisman@collabora.com>
To:     tytso@mit.edu
Cc:     linux-ext4@vger.kernel.org,
        Gabriel Krisman Bertazi <krisman@collabora.com>
Subject: [PATCH e2fsprogs 10/10] ext4.5.in: Document design changes on the casefold attribute
Date:   Sat, 13 Apr 2019 01:43:17 -0400
Message-Id: <20190413054317.7388-11-krisman@collabora.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190413054317.7388-1-krisman@collabora.com>
References: <20190413054317.7388-1-krisman@collabora.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-ext4-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org

Document the fact that the encoding support is only used by directories
with the +F attribute.

Signed-off-by: Gabriel Krisman Bertazi <krisman@collabora.com>
---
 misc/ext4.5.in | 10 ++++------
 1 file changed, 4 insertions(+), 6 deletions(-)

diff --git a/misc/ext4.5.in b/misc/ext4.5.in
index ee5e170979a1..2a8ce1e2f8e8 100644
--- a/misc/ext4.5.in
+++ b/misc/ext4.5.in
@@ -154,12 +154,10 @@ option.
 .B fname_encoding
 .br
 This ext4 feature provides file system level character encoding support
-for files and directories name.  This feature is name-preserving on the
-disk, but it allows applications to lookup for a file in the file system
-using any encoding equivalent version of the file name.
-
-This feature is required to perform in-kernel case-insensitive file
-name lookups.
+for directories with the casefold (+F) flag enabled.  This feature is
+name-preserving on the disk, but it allows applications to lookup for a
+file in the file system using an encoding equivalent version of the file
+name.
 .TP
 .B has_journal
 .br
-- 
2.20.1

