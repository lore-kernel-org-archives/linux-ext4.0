Return-Path: <SRS0=f4LO=SY=vger.kernel.org=linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AC37AC10F11
	for <linux-ext4@archiver.kernel.org>; Mon, 22 Apr 2019 21:01:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 67596214AE
	for <linux-ext4@archiver.kernel.org>; Mon, 22 Apr 2019 21:01:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1555966904;
	bh=pUn/j+LPNMjOd75a0dkEoh1lxnXf5AxSQuwr20msntw=;
	h=From:To:Cc:Subject:Date:List-ID:From;
	b=zcArP1L2191vRfumaeYL8WKSpozyVmoP+sbmbkiPrFV912ar1LEeHp7T+Eil7LJdk
	 bql3jH0Fno/tHJJG5lYYnaYm2nhP+GN1Dv3DKZA/F9xL+WQuqXdJYSfKWFk1m+OBYB
	 944ftVIPg/J1z39P16heRKkPFY7cghNtBxiVfJSc=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728998AbfDVVBo (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Mon, 22 Apr 2019 17:01:44 -0400
Received: from mail.kernel.org ([198.145.29.99]:34882 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726896AbfDVVBn (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Mon, 22 Apr 2019 17:01:43 -0400
Received: from ebiggers-linuxstation.mtv.corp.google.com (unknown [104.132.1.77])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E8B2520896;
        Mon, 22 Apr 2019 21:01:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1555966903;
        bh=pUn/j+LPNMjOd75a0dkEoh1lxnXf5AxSQuwr20msntw=;
        h=From:To:Cc:Subject:Date:From;
        b=tJTVP/9R/3m+/m0ggziC9rhD2XmLdDqOp5uDbCPmt5Pqwi9RaoIdMjBBBRJG0F/J8
         Q8LggdNBCyVsJTXVbCNf6ULG4W8ysDJFybN+lRo/ASm9woWOpIClEu8C5I7GC3zLNx
         d8sIfPsO5dBrAZZM5BZ/XkcM7CJ/hRrX+zGHJAK4=
From:   Eric Biggers <ebiggers@kernel.org>
To:     linux-ext4@vger.kernel.org
Cc:     Gabriel Krisman Bertazi <krisman@collabora.co.uk>
Subject: [PATCH] debugfs: fix encoding handling in dx_hash command
Date:   Mon, 22 Apr 2019 14:01:23 -0700
Message-Id: <20190422210124.181075-1-ebiggers@kernel.org>
X-Mailer: git-send-email 2.21.0.593.g511ec345e18-goog
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-ext4-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org

From: Eric Biggers <ebiggers@google.com>

Fix the following bugs:

1. 'encoding' and 'hash_flags' are not initialized, causing a segfault.

2. 'hash_flags' incorrectly uses a __bitwise type.

3. The optstring doesn't contain "c" or "e", so the -c and -e options
   aren't recognized.

4. The code that handles the -e option always returns.

Fixes: ef733f1a97ec ("debugfs: support encoding when printing the file hash")
Cc: Gabriel Krisman Bertazi <krisman@collabora.co.uk>
Signed-off-by: Eric Biggers <ebiggers@google.com>
---
 debugfs/htree.c | 13 ++++++++-----
 1 file changed, 8 insertions(+), 5 deletions(-)

diff --git a/debugfs/htree.c b/debugfs/htree.c
index 1cdb3c6a..82406d4f 100644
--- a/debugfs/htree.c
+++ b/debugfs/htree.c
@@ -310,17 +310,18 @@ errout:
 void do_dx_hash(int argc, char *argv[], int sci_idx EXT2FS_ATTR((unused)),
 		void *infop EXT2FS_ATTR((unused)))
 {
-	ext2_dirhash_t hash, minor_hash, hash_flags;
+	ext2_dirhash_t hash, minor_hash;
 	errcode_t	err;
 	int		c;
 	int		hash_version = 0;
 	__u32		hash_seed[4];
-	const struct nls_table *encoding;
+	int		hash_flags = 0;
+	const struct nls_table *encoding = NULL;
 
 	hash_seed[0] = hash_seed[1] = hash_seed[2] = hash_seed[3] = 0;
 
 	reset_getopt();
-	while ((c = getopt (argc, argv, "h:s:")) != EOF) {
+	while ((c = getopt(argc, argv, "h:s:ce:")) != EOF) {
 		switch (c) {
 		case 'h':
 			hash_version = e2p_string2hash(optarg);
@@ -335,14 +336,16 @@ void do_dx_hash(int argc, char *argv[], int sci_idx EXT2FS_ATTR((unused)),
 			}
 			break;
 		case 'c':
-			hash_flags = EXT4_CASEFOLD_FL;
+			hash_flags |= EXT4_CASEFOLD_FL;
 			break;
 		case 'e':
 			encoding = nls_load_table(e2p_str2encoding(optarg));
-			if (!encoding)
+			if (!encoding) {
 				fprintf(stderr, "Invalid encoding: %s\n",
 					optarg);
 				return;
+			}
+			break;
 		default:
 			goto print_usage;
 		}
-- 
2.21.0.593.g511ec345e18-goog

