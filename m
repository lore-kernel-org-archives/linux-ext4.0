Return-Path: <SRS0=++eR=3F=vger.kernel.org=linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AB452C33CB3
	for <linux-ext4@archiver.kernel.org>; Thu, 16 Jan 2020 17:11:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 80BD624690
	for <linux-ext4@archiver.kernel.org>; Thu, 16 Jan 2020 17:11:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1579194687;
	bh=BlTZ47v3BJ2PsceNhAY7KD1vlOSX4CzRUdfkpDxBaUk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:List-ID:From;
	b=xmsTQN+hwMJDQJd1fitK/V8zT++7nfpa9D6LlMdPrRxMp9GwnC/gxcONBaFWJ0a2m
	 VpyizQp+U6IJRSwRdRgrMv8S2y7mSqBddnkvCQZa4/sag8mJYR5S7tEXdlnOsYjzqx
	 UHtjTfQc+ZUB+9aBNEBCks8HJEMbAvjoYVe+MJ54=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390233AbgAPRL0 (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Thu, 16 Jan 2020 12:11:26 -0500
Received: from mail.kernel.org ([198.145.29.99]:48638 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389964AbgAPRK1 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Thu, 16 Jan 2020 12:10:27 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 878D324686;
        Thu, 16 Jan 2020 17:10:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579194627;
        bh=BlTZ47v3BJ2PsceNhAY7KD1vlOSX4CzRUdfkpDxBaUk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=jAk+QO8aa5kx9V4uW+MgkswquXORBCfdZizwbcoNL8ut1Y+OMs0H4EG0ugwdRQgc0
         vMFBZf5G5qhDkyWB1o+n4VoaO4Wm737Me6uHc8jzxF3m6kRSgjbunZ7BeBt84WY/RH
         KzCSf0Mn1zWFgeVSDu8YBEPOgx/Jda6ayLEQh5z8=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Colin Ian King <colin.king@canonical.com>,
        Theodore Ts'o <tytso@mit.edu>, Sasha Levin <sashal@kernel.org>,
        linux-ext4@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 487/671] ext4: set error return correctly when ext4_htree_store_dirent fails
Date:   Thu, 16 Jan 2020 12:02:05 -0500
Message-Id: <20200116170509.12787-224-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200116170509.12787-1-sashal@kernel.org>
References: <20200116170509.12787-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: linux-ext4-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org

From: Colin Ian King <colin.king@canonical.com>

[ Upstream commit 7a14826ede1d714f0bb56de8167c0e519041eeda ]

Currently when the call to ext4_htree_store_dirent fails the error return
variable 'ret' is is not being set to the error code and variable count is
instead, hence the error code is not being returned.  Fix this by assigning
ret to the error return code.

Addresses-Coverity: ("Unused value")
Fixes: 8af0f0822797 ("ext4: fix readdir error in the case of inline_data+dir_index")
Signed-off-by: Colin Ian King <colin.king@canonical.com>
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ext4/inline.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/ext4/inline.c b/fs/ext4/inline.c
index 56f6e1782d5f..4572cb057951 100644
--- a/fs/ext4/inline.c
+++ b/fs/ext4/inline.c
@@ -1419,7 +1419,7 @@ int htree_inlinedir_to_tree(struct file *dir_file,
 		err = ext4_htree_store_dirent(dir_file, hinfo->hash,
 					      hinfo->minor_hash, de, &tmp_str);
 		if (err) {
-			count = err;
+			ret = err;
 			goto out;
 		}
 		count++;
-- 
2.20.1

