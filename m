Return-Path: <SRS0=R85w=SP=vger.kernel.org=linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,UNPARSEABLE_RELAY,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 98638C10F11
	for <linux-ext4@archiver.kernel.org>; Sat, 13 Apr 2019 05:43:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 70CAC20850
	for <linux-ext4@archiver.kernel.org>; Sat, 13 Apr 2019 05:43:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726285AbfDMFnm (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Sat, 13 Apr 2019 01:43:42 -0400
Received: from bhuna.collabora.co.uk ([46.235.227.227]:37494 "EHLO
        bhuna.collabora.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726178AbfDMFnm (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Sat, 13 Apr 2019 01:43:42 -0400
Received: from [127.0.0.1] (localhost [127.0.0.1])
        (Authenticated sender: krisman)
        with ESMTPSA id 925562823DF
From:   Gabriel Krisman Bertazi <krisman@collabora.com>
To:     tytso@mit.edu
Cc:     linux-ext4@vger.kernel.org,
        Gabriel Krisman Bertazi <krisman@collabora.com>
Subject: [PATCH e2fsprogs 05/10] ext2fs: nls: Merge sparse fixes from the kernel version
Date:   Sat, 13 Apr 2019 01:43:12 -0400
Message-Id: <20190413054317.7388-6-krisman@collabora.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190413054317.7388-1-krisman@collabora.com>
References: <20190413054317.7388-1-krisman@collabora.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-ext4-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org

The sparse script complained about the following issues in the kernel
version of this script.  This patch port the fixes to the userspace
version.

sparse warnings: (new ones prefixed by >>)

>> fs/unicode/utf8-norm.c:41:24: sparse: non-ANSI function declaration
   of function 'utf8version_latest'

vim +/utf8version_latest +41 fs/unicode/utf8-norm.c

  40
> 41	int utf8version_latest()
  42	{
  43		return utf8vers;
  44		}
  45	EXPORT_SYMBOL(utf8version_latest);
  46

Signed-off-by: Gabriel Krisman Bertazi <krisman@collabora.com>
---
 lib/ext2fs/nls_utf8-norm.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/lib/ext2fs/nls_utf8-norm.c b/lib/ext2fs/nls_utf8-norm.c
index 4230b64bc586..27e530c14e4f 100644
--- a/lib/ext2fs/nls_utf8-norm.c
+++ b/lib/ext2fs/nls_utf8-norm.c
@@ -46,7 +46,7 @@ int utf8version_is_supported(uint8_t maj, uint8_t min, uint8_t rev)
 	return 0;
 }
 
-int utf8version_latest()
+int utf8version_latest(void)
 {
 	return utf8vers;
 }
-- 
2.20.1

