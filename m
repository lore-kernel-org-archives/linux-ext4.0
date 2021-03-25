Return-Path: <linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-19.2 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E7671C433E9
	for <linux-ext4@archiver.kernel.org>; Thu, 25 Mar 2021 11:35:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C0C5B61A23
	for <linux-ext4@archiver.kernel.org>; Thu, 25 Mar 2021 11:35:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230509AbhCYLfF (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Thu, 25 Mar 2021 07:35:05 -0400
Received: from mail.kernel.org ([198.145.29.99]:41320 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230478AbhCYLdE (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Thu, 25 Mar 2021 07:33:04 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 56D3161A81;
        Thu, 25 Mar 2021 11:28:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1616671714;
        bh=fk9QduYSwiKkapdVA2+fzoirhsw/ghmQIFXqvZuYu6c=;
        h=From:To:Cc:Subject:Date:From;
        b=CvA/kC0Ft2Zi/iKi709ipd+UUxu689We36U+Si+naBu4xS+OtjWwYELc7u4kQFUEg
         nycS7U7l8CspIhonTTOyNYAUziHJUcQ1LaNV1IndT0bD+nTA+IFsN2EY2M5f/JV2oE
         rfOzEgmKtVQsFtOFcBlSYOovOfE/dMLpliW/vm8EuoTfrFk4BNjk48en2YJulgEty4
         +T2wSSXEj7pA+IePNySFjV/ulwAcVIlGSwRHpXFtrIkO/heeP+kX34V3GEjzriKqwo
         BYwsUQy6R0wk2My6tSXIfB+d064FTq4yMQ1ewmYY6ycc+WdtsNV82xk5E6amaMz3PJ
         JPSUVl8CBPNYQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Zhaolong Zhang <zhangzl2013@126.com>,
        Theodore Ts'o <tytso@mit.edu>, Sasha Levin <sashal@kernel.org>,
        linux-ext4@vger.kernel.org
Subject: [PATCH AUTOSEL 4.4 01/10] ext4: fix bh ref count on error paths
Date:   Thu, 25 Mar 2021 07:28:22 -0400
Message-Id: <20210325112832.1928898-1-sashal@kernel.org>
X-Mailer: git-send-email 2.30.1
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org

From: Zhaolong Zhang <zhangzl2013@126.com>

[ Upstream commit c915fb80eaa6194fa9bd0a4487705cd5b0dda2f1 ]

__ext4_journalled_writepage should drop bhs' ref count on error paths

Signed-off-by: Zhaolong Zhang <zhangzl2013@126.com>
Link: https://lore.kernel.org/r/1614678151-70481-1-git-send-email-zhangzl2013@126.com
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ext4/inode.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index 881601691bd4..336e5c8f423e 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -1825,13 +1825,13 @@ static int __ext4_journalled_writepage(struct page *page,
 	if (!ret)
 		ret = err;
 
-	if (!ext4_has_inline_data(inode))
-		ext4_walk_page_buffers(NULL, page_bufs, 0, len,
-				       NULL, bput_one);
 	ext4_set_inode_state(inode, EXT4_STATE_JDATA);
 out:
 	unlock_page(page);
 out_no_pagelock:
+	if (!inline_data && page_bufs)
+		ext4_walk_page_buffers(NULL, page_bufs, 0, len,
+				       NULL, bput_one);
 	brelse(inode_bh);
 	return ret;
 }
-- 
2.30.1

