Return-Path: <SRS0=R85w=SP=vger.kernel.org=linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,UNPARSEABLE_RELAY,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8C35AC10F11
	for <linux-ext4@archiver.kernel.org>; Sat, 13 Apr 2019 05:43:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 650E020850
	for <linux-ext4@archiver.kernel.org>; Sat, 13 Apr 2019 05:43:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726277AbfDMFni (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Sat, 13 Apr 2019 01:43:38 -0400
Received: from bhuna.collabora.co.uk ([46.235.227.227]:37492 "EHLO
        bhuna.collabora.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726178AbfDMFni (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Sat, 13 Apr 2019 01:43:38 -0400
Received: from [127.0.0.1] (localhost [127.0.0.1])
        (Authenticated sender: krisman)
        with ESMTPSA id DF81D2823DF
From:   Gabriel Krisman Bertazi <krisman@collabora.com>
To:     tytso@mit.edu
Cc:     linux-ext4@vger.kernel.org,
        Gabriel Krisman Bertazi <krisman@collabora.com>
Subject: [PATCH e2fsprogs 04/10] ext2fs: nls: Fix potential null dereference in utf8nlookup
Date:   Sat, 13 Apr 2019 01:43:11 -0400
Message-Id: <20190413054317.7388-5-krisman@collabora.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190413054317.7388-1-krisman@collabora.com>
References: <20190413054317.7388-1-krisman@collabora.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-ext4-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org

Delay the access of data->offset until after the null check.  This was
reported by 0-day on the kernel version of the script.

Signed-off-by: Gabriel Krisman Bertazi <krisman@collabora.com>
---
 lib/ext2fs/nls_utf8-norm.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/lib/ext2fs/nls_utf8-norm.c b/lib/ext2fs/nls_utf8-norm.c
index 5a91573f766f..4230b64bc586 100644
--- a/lib/ext2fs/nls_utf8-norm.c
+++ b/lib/ext2fs/nls_utf8-norm.c
@@ -335,7 +335,7 @@ utf8hangul(const char *str, unsigned char *hangul)
 static utf8leaf_t *utf8nlookup(const struct utf8data *data,
 			       unsigned char *hangul, const char *s, size_t len)
 {
-	utf8trie_t	*trie = utf8data + data->offset;
+	utf8trie_t	*trie = NULL;
 	int		offlen;
 	int		offset;
 	int		mask;
@@ -345,6 +345,8 @@ static utf8leaf_t *utf8nlookup(const struct utf8data *data,
 		return NULL;
 	if (len == 0)
 		return NULL;
+
+	trie = utf8data + data->offset;
 	node = 1;
 	while (node) {
 		offlen = (*trie & OFFLEN) >> OFFLEN_SHIFT;
-- 
2.20.1

