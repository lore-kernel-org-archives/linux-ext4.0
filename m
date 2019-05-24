Return-Path: <SRS0=IuoM=TY=vger.kernel.org=linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7D6FAC282E1
	for <linux-ext4@archiver.kernel.org>; Fri, 24 May 2019 22:41:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 59F792175B
	for <linux-ext4@archiver.kernel.org>; Fri, 24 May 2019 22:41:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730134AbfEXWlg (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Fri, 24 May 2019 18:41:36 -0400
Received: from bhuna.collabora.co.uk ([46.235.227.227]:46960 "EHLO
        bhuna.collabora.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727113AbfEXWlf (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Fri, 24 May 2019 18:41:35 -0400
Received: from [127.0.0.1] (localhost [127.0.0.1])
        (Authenticated sender: krisman)
        with ESMTPSA id 99374265E40
From:   Gabriel Krisman Bertazi <krisman@collabora.com>
To:     tytso@mit.edu
Cc:     linux-ext4@vger.kernel.org,
        Gabriel Krisman Bertazi <krisman@collabora.com>
Subject: [PATCH] ext4: Fix dcache lookup of !casefolded directories
Date:   Fri, 24 May 2019 18:41:29 -0400
Message-Id: <20190524224129.28525-1-krisman@collabora.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-ext4-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org

Found by visual inspection, this wasn't caught by my xfstest, since it's
effect is ignoring positive dentries in the cache the fallback just goes
to the disk.  it was introduced in the last iteration of the
case-insensitive patch.

d_compare should return 0 when the entries match, so make sure we are
correctly comparing the entire string if the encoding feature is set and
we are on a case-INsensitive directory.

Fixes: b886ee3e778e ("ext4: Support case-insensitive file name lookups")
Signed-off-by: Gabriel Krisman Bertazi <krisman@collabora.com>
---
 fs/ext4/dir.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/ext4/dir.c b/fs/ext4/dir.c
index 884a6e776809..c7843b149a1e 100644
--- a/fs/ext4/dir.c
+++ b/fs/ext4/dir.c
@@ -671,7 +671,7 @@ static int ext4_d_compare(const struct dentry *dentry, unsigned int len,
 	if (!IS_CASEFOLDED(dentry->d_parent->d_inode)) {
 		if (len != name->len)
 			return -1;
-		return !memcmp(str, name, len);
+		return memcmp(str, name->name, len);
 	}
 
 	return ext4_ci_compare(dentry->d_parent->d_inode, name, &qstr);
-- 
2.20.1

