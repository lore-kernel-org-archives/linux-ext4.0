Return-Path: <SRS0=VruF=ZF=vger.kernel.org=linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DE264C17441
	for <linux-ext4@archiver.kernel.org>; Wed, 13 Nov 2019 02:15:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B849021D7F
	for <linux-ext4@archiver.kernel.org>; Wed, 13 Nov 2019 02:15:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1573611322;
	bh=65esZw1aId9cAb4fmPQLAQBAEwuFCvYbnG/uf8OmSco=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:List-ID:From;
	b=F91DGRoHr4Y7tqoRL6186pHOxxx3bVFdFqoyOrW6ftQJ57NOiN31nxwI02jXDsw/H
	 KHgQ38Vuy69BfupBWBUCQL4xYBHMGtIT1njzms0X8Uq0gJR8p6LcEDs2MZ8VBJ9X6/
	 xH6SqPcj8aCQlFiXL7gmLJor3/3dYVMywjtLXxwo=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728750AbfKMCPM (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Tue, 12 Nov 2019 21:15:12 -0500
Received: from mail.kernel.org ([198.145.29.99]:49814 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728043AbfKMB47 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Tue, 12 Nov 2019 20:56:59 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C8EAC22470;
        Wed, 13 Nov 2019 01:56:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1573610218;
        bh=65esZw1aId9cAb4fmPQLAQBAEwuFCvYbnG/uf8OmSco=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=nYIRSaKaeVXCYTmMwl1gQg+c2z8vv6sJHDFv5DOBVS/9y8mL11ccSeDToJn5R1aYj
         XwPveki0BP2Nl6+qq/XrUjR5WMDTO/LL8Re18d1vuF7Un/8LbJ8yqBXDKiJdKFJGt8
         5TKx/E1wm6kjXZXfpgMoU+0+z/ciKlW0EP4R1mMg=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Gabriel Krisman Bertazi <krisman@collabora.co.uk>,
        Theodore Ts'o <tytso@mit.edu>,
        Lukas Czerner <lczerner@redhat.com>,
        Sasha Levin <sashal@kernel.org>, linux-ext4@vger.kernel.org
Subject: [PATCH AUTOSEL 4.14 025/115] ext4: fix build error when DX_DEBUG is defined
Date:   Tue, 12 Nov 2019 20:54:52 -0500
Message-Id: <20191113015622.11592-25-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191113015622.11592-1-sashal@kernel.org>
References: <20191113015622.11592-1-sashal@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: linux-ext4-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org

From: Gabriel Krisman Bertazi <krisman@collabora.co.uk>

[ Upstream commit 799578ab16e86b074c184ec5abbda0bc698c7b0b ]

Enabling DX_DEBUG triggers the build error below.  info is an attribute
of  the dxroot structure.

linux/fs/ext4/namei.c:2264:12: error: ‘info’
undeclared (first use in this function); did you mean ‘insl’?
	   	  info->indirect_levels));

Fixes: e08ac99fa2a2 ("ext4: add largedir feature")
Signed-off-by: Gabriel Krisman Bertazi <krisman@collabora.co.uk>
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
Reviewed-by: Lukas Czerner <lczerner@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ext4/namei.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/ext4/namei.c b/fs/ext4/namei.c
index 162e853dc5d65..212b01861d941 100644
--- a/fs/ext4/namei.c
+++ b/fs/ext4/namei.c
@@ -2293,7 +2293,7 @@ static int ext4_dx_add_entry(handle_t *handle, struct ext4_filename *fname,
 			dxroot->info.indirect_levels += 1;
 			dxtrace(printk(KERN_DEBUG
 				       "Creating %d level index...\n",
-				       info->indirect_levels));
+				       dxroot->info.indirect_levels));
 			err = ext4_handle_dirty_dx_node(handle, dir, frame->bh);
 			if (err)
 				goto journal_error;
-- 
2.20.1

