Return-Path: <SRS0=naN3=57=vger.kernel.org=linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D8612C2BB55
	for <linux-ext4@archiver.kernel.org>; Wed, 15 Apr 2020 11:59:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id AFF5F20575
	for <linux-ext4@archiver.kernel.org>; Wed, 15 Apr 2020 11:59:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1586951968;
	bh=SQIfffQX5o8Mt9NxkBRbUKPPSH7GU2Dpva5qCWMzl8Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:List-ID:From;
	b=lsB5fKmNP83mwlUKVykoLji9Kc/MkftaUprRpGpAaKIXex8SU7glBjkB/7p5Ux549
	 NTM947v7qEwqWksBPzvfA5dNpNn5KqZ3IoF9Smbzk/rbhh2ZYAZpSsgm+pxklCMebC
	 bHLwLochqmaHyhgNASThEQwDfLY1lVaZ5qryWfi0=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2898022AbgDOL7Z (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Wed, 15 Apr 2020 07:59:25 -0400
Received: from mail.kernel.org ([198.145.29.99]:43196 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2409384AbgDOLrp (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Wed, 15 Apr 2020 07:47:45 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6C3852173E;
        Wed, 15 Apr 2020 11:47:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1586951265;
        bh=SQIfffQX5o8Mt9NxkBRbUKPPSH7GU2Dpva5qCWMzl8Q=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=wpy+TLegwUmmm7gdRrIfC/ByWnMakLqry9bq60rvJDg/uGs/zod9uUGdRGumUD2WS
         z6U/5hDRWK3cvO2DIh/S6+X7PlrFVMk+7Rkw/+eI1CvwcYBPTI5FQ7Hu0TR3m1ipDX
         vhd4lICDNzaAx3W5ZoGMkoGIYuIZSBQS0Lybq5pI=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Jan Kara <jack@suse.cz>, Randy Dunlap <rdunlap@infradead.org>,
        Sasha Levin <sashal@kernel.org>, linux-ext4@vger.kernel.org
Subject: [PATCH AUTOSEL 4.14 28/30] ext2: fix debug reference to ext2_xattr_cache
Date:   Wed, 15 Apr 2020 07:47:09 -0400
Message-Id: <20200415114711.15381-28-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200415114711.15381-1-sashal@kernel.org>
References: <20200415114711.15381-1-sashal@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: linux-ext4-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org

From: Jan Kara <jack@suse.cz>

[ Upstream commit 32302085a8d90859c40cf1a5e8313f575d06ec75 ]

Fix a debug-only build error in ext2/xattr.c:

When building without extra debugging, (and with another patch that uses
no_printk() instead of <empty> for the ext2-xattr debug-print macros,
this build error happens:

../fs/ext2/xattr.c: In function ‘ext2_xattr_cache_insert’:
../fs/ext2/xattr.c:869:18: error: ‘ext2_xattr_cache’ undeclared (first use in
this function); did you mean ‘ext2_xattr_list’?
     atomic_read(&ext2_xattr_cache->c_entry_count));

Fix the problem by removing cached entry count from the debug message
since otherwise we'd have to export the mbcache structure just for that.

Fixes: be0726d33cb8 ("ext2: convert to mbcache2")
Reported-by: Randy Dunlap <rdunlap@infradead.org>
Signed-off-by: Jan Kara <jack@suse.cz>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ext2/xattr.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/fs/ext2/xattr.c b/fs/ext2/xattr.c
index 4439bfaf1c57f..bd1d68ff3a9f8 100644
--- a/fs/ext2/xattr.c
+++ b/fs/ext2/xattr.c
@@ -839,8 +839,7 @@ ext2_xattr_cache_insert(struct mb_cache *cache, struct buffer_head *bh)
 	error = mb_cache_entry_create(cache, GFP_NOFS, hash, bh->b_blocknr, 1);
 	if (error) {
 		if (error == -EBUSY) {
-			ea_bdebug(bh, "already in cache (%d cache entries)",
-				atomic_read(&ext2_xattr_cache->c_entry_count));
+			ea_bdebug(bh, "already in cache");
 			error = 0;
 		}
 	} else
-- 
2.20.1

