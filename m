Return-Path: <SRS0=rNFB=6I=vger.kernel.org=linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DBC13C54FD0
	for <linux-ext4@archiver.kernel.org>; Fri, 24 Apr 2020 12:28:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B242020776
	for <linux-ext4@archiver.kernel.org>; Fri, 24 Apr 2020 12:28:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1587731305;
	bh=lvMF2Kf965DlYlL/TYNqQSc35y6WcqH57P/K98qb/3c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:List-ID:From;
	b=QNWukWi3Z/R4BZ5EXU2PktN7aNf3ByW79VPmAKRIGUHbVyvi2/ad6BgJL5Z0pJKtd
	 MH9asrisxl6FUqmqce0AYb8YwYq5+scg18U8DulcsS6Y0WuEcqwol+Pj3vdZ8txsFc
	 8PuBvtnIUYPzDetw7tSlFUAD7dMtcL9eRoGOUqoY=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728277AbgDXMYP (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Fri, 24 Apr 2020 08:24:15 -0400
Received: from mail.kernel.org ([198.145.29.99]:54714 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727073AbgDXMYO (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Fri, 24 Apr 2020 08:24:14 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 78E2B2166E;
        Fri, 24 Apr 2020 12:24:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1587731054;
        bh=lvMF2Kf965DlYlL/TYNqQSc35y6WcqH57P/K98qb/3c=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=gJTUAoRlGVs9so0pNiERJOPXYy2xslEfaD2zMjYSmKp2ekkb0vd6Fv9S5wGAiLWzZ
         6afgNWTVWDL3n5hjURh5srpbXA8js60v119GKrnXcraCUaa//7YzeD4n3FG5yxTkbm
         KqWkVqNbOnD6FPXntAFOdGZzRHzqbvxjq7KmEJZ0=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     yangerkun <yangerkun@huawei.com>, Theodore Ts'o <tytso@mit.edu>,
        Ritesh Harjani <riteshh@linux.ibm.com>,
        Jan Kara <jack@suse.cz>, Sasha Levin <sashal@kernel.org>,
        linux-ext4@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 15/18] ext4: use matching invalidatepage in ext4_writepage
Date:   Fri, 24 Apr 2020 08:23:52 -0400
Message-Id: <20200424122355.10453-15-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200424122355.10453-1-sashal@kernel.org>
References: <20200424122355.10453-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: linux-ext4-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org

From: yangerkun <yangerkun@huawei.com>

[ Upstream commit c2a559bc0e7ed5a715ad6b947025b33cb7c05ea7 ]

Run generic/388 with journal data mode sometimes may trigger the warning
in ext4_invalidatepage. Actually, we should use the matching invalidatepage
in ext4_writepage.

Signed-off-by: yangerkun <yangerkun@huawei.com>
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
Reviewed-by: Ritesh Harjani <riteshh@linux.ibm.com>
Reviewed-by: Jan Kara <jack@suse.cz>
Link: https://lore.kernel.org/r/20200226041002.13914-1-yangerkun@huawei.com
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ext4/inode.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index 000fa0e392787..3b1a7597af15e 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -2128,7 +2128,7 @@ static int ext4_writepage(struct page *page,
 	bool keep_towrite = false;
 
 	if (unlikely(ext4_forced_shutdown(EXT4_SB(inode->i_sb)))) {
-		ext4_invalidatepage(page, 0, PAGE_SIZE);
+		inode->i_mapping->a_ops->invalidatepage(page, 0, PAGE_SIZE);
 		unlock_page(page);
 		return -EIO;
 	}
-- 
2.20.1

