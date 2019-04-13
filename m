Return-Path: <SRS0=R85w=SP=vger.kernel.org=linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,UNPARSEABLE_RELAY,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F2567C10F11
	for <linux-ext4@archiver.kernel.org>; Sat, 13 Apr 2019 05:43:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id CB54520850
	for <linux-ext4@archiver.kernel.org>; Sat, 13 Apr 2019 05:43:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726918AbfDMFns (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Sat, 13 Apr 2019 01:43:48 -0400
Received: from bhuna.collabora.co.uk ([46.235.227.227]:37502 "EHLO
        bhuna.collabora.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726480AbfDMFns (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Sat, 13 Apr 2019 01:43:48 -0400
Received: from [127.0.0.1] (localhost [127.0.0.1])
        (Authenticated sender: krisman)
        with ESMTPSA id 585282823E1
From:   Gabriel Krisman Bertazi <krisman@collabora.com>
To:     tytso@mit.edu
Cc:     linux-ext4@vger.kernel.org,
        Gabriel Krisman Bertazi <krisman@collabora.com>
Subject: [PATCH e2fsprogs 07/10] ext2fs: Don't normalize names on -F directories
Date:   Sat, 13 Apr 2019 01:43:14 -0400
Message-Id: <20190413054317.7388-8-krisman@collabora.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190413054317.7388-1-krisman@collabora.com>
References: <20190413054317.7388-1-krisman@collabora.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-ext4-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org

As agreed on the new design, even if fname_encoding is enabled,
directories entries who aren't owned by a +F directory will not be
normalized.

Signed-off-by: Gabriel Krisman Bertazi <krisman@collabora.com>
---
 lib/ext2fs/dirhash.c | 8 ++------
 1 file changed, 2 insertions(+), 6 deletions(-)

diff --git a/lib/ext2fs/dirhash.c b/lib/ext2fs/dirhash.c
index f1e7734d3865..b9afb599c0fa 100644
--- a/lib/ext2fs/dirhash.c
+++ b/lib/ext2fs/dirhash.c
@@ -281,15 +281,11 @@ errcode_t ext2fs_dirhash2(int version, const char *name, int len,
 	int dlen;
 	unsigned char *buff;
 
-	if (len && charset) {
+	if (len && charset && (hash_flags & EXT4_CASEFOLD_FL)) {
 		char buff[PATH_MAX];
 
-		if (hash_flags & EXT4_CASEFOLD_FL)
-			dlen = charset->ops->casefold(charset, name, len, buff,
+		dlen = charset->ops->casefold(charset, name, len, buff,
 						      sizeof(buff));
-		else
-			dlen = charset->ops->normalize(charset, name, len, buff,
-						       sizeof(buff));
 		if (dlen < 0) {
 			if (dlen == -EINVAL)
 				goto opaque_seq;
-- 
2.20.1

