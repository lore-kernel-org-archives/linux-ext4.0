Return-Path: <SRS0=naN3=57=vger.kernel.org=linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 93E12C2BA19
	for <linux-ext4@archiver.kernel.org>; Wed, 15 Apr 2020 12:55:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 73498206D5
	for <linux-ext4@archiver.kernel.org>; Wed, 15 Apr 2020 12:55:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1586955359;
	bh=mHI9eyVLwiMuBtKcYBlu4Th72kzE+NJHQ4mxUFyM80E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:List-ID:From;
	b=XhN1MreKN5Lzlz9JB3wVO//DP9SpAHXgwgzw1IG4bIQPDH7Zb+Yx1KOEiSqj42zPl
	 suG+SAS3+fuTzq0Co+Hm1tJH1XgHjK19kSkzZzECbmj4Qw66vDz1tdIdwu7s2EThcq
	 dz9lhD/cQOj5HD8C94gH+85R67aSBv2eYn286IXQ=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2441331AbgDOMzp (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Wed, 15 Apr 2020 08:55:45 -0400
Received: from mail.kernel.org ([198.145.29.99]:56808 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2897195AbgDOLhC (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Wed, 15 Apr 2020 07:37:02 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0FA58214AF;
        Wed, 15 Apr 2020 11:36:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1586950620;
        bh=mHI9eyVLwiMuBtKcYBlu4Th72kzE+NJHQ4mxUFyM80E=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=vNNl+w1Men6gwm4cxW1jRk5T2Yp/LA4HryIvMizzKlWve6bWva0xqAkFOFnf3qHVs
         A5aHuGD3rgL/lOSGSOq61FJppHth5s7fhD9s0YrcTuW66Uiryv6aR/+PqdjbohyINx
         aLnaJJkdPAzwN5kKYB+LQjwNxK0lEhLcz2D3Ze6A=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Randy Dunlap <rdunlap@infradead.org>, Jan Kara <jack@suse.com>,
        linux-ext4@vger.kernel.org, Jan Kara <jack@suse.cz>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 5.6 112/129] ext2: fix empty body warnings when -Wextra is used
Date:   Wed, 15 Apr 2020 07:34:27 -0400
Message-Id: <20200415113445.11881-112-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200415113445.11881-1-sashal@kernel.org>
References: <20200415113445.11881-1-sashal@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: linux-ext4-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org

From: Randy Dunlap <rdunlap@infradead.org>

[ Upstream commit 44a52022e7f15cbaab957df1c14f7a4f527ef7cf ]

When EXT2_ATTR_DEBUG is not defined, modify the 2 debug macros
to use the no_printk() macro instead of <nothing>.
This fixes gcc warnings when -Wextra is used:

../fs/ext2/xattr.c:252:42: warning: suggest braces around empty body in an ‘if’ statement [-Wempty-body]
../fs/ext2/xattr.c:258:42: warning: suggest braces around empty body in an ‘if’ statement [-Wempty-body]
../fs/ext2/xattr.c:330:42: warning: suggest braces around empty body in an ‘if’ statement [-Wempty-body]
../fs/ext2/xattr.c:872:45: warning: suggest braces around empty body in an ‘else’ statement [-Wempty-body]

I have verified that the only object code change (with gcc 7.5.0) is
the reversal of some instructions from 'cmp a,b' to 'cmp b,a'.

Link: https://lore.kernel.org/r/e18a7395-61fb-2093-18e8-ed4f8cf56248@infradead.org
Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
Cc: Jan Kara <jack@suse.com>
Cc: linux-ext4@vger.kernel.org
Signed-off-by: Jan Kara <jack@suse.cz>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ext2/xattr.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/fs/ext2/xattr.c b/fs/ext2/xattr.c
index 0456bc990b5ee..b91f99d9482e9 100644
--- a/fs/ext2/xattr.c
+++ b/fs/ext2/xattr.c
@@ -56,6 +56,7 @@
 
 #include <linux/buffer_head.h>
 #include <linux/init.h>
+#include <linux/printk.h>
 #include <linux/slab.h>
 #include <linux/mbcache.h>
 #include <linux/quotaops.h>
@@ -84,8 +85,8 @@
 		printk("\n"); \
 	} while (0)
 #else
-# define ea_idebug(f...)
-# define ea_bdebug(f...)
+# define ea_idebug(inode, f...)	no_printk(f)
+# define ea_bdebug(bh, f...)	no_printk(f)
 #endif
 
 static int ext2_xattr_set2(struct inode *, struct buffer_head *,
-- 
2.20.1

