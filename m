Return-Path: <SRS0=DZYj=RU=vger.kernel.org=linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7F6B1C43381
	for <linux-ext4@archiver.kernel.org>; Sun, 17 Mar 2019 20:07:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4D78921741
	for <linux-ext4@archiver.kernel.org>; Sun, 17 Mar 2019 20:07:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1552853244;
	bh=hl2rdke2dF46rBeCelfCcRBHtrXDX7oT7cNW2Sq/1uc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:List-ID:From;
	b=CPSGgQ4xhQ6K2+LtWxy6sQJHe5gZIsL1zW1SOmlB8yxHB+B5vVG5wPfLHWa+mcnCH
	 7KE9cN0igiUQRCh9iylKL351oxR4vC2O63BMkuagu6nVudkwsU+kDrdSI2cewwUd2m
	 DstmVvkhkUYq0wG6kSMkDYKlgQGkRxbwLXwP3y7s=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727505AbfCQUHX (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Sun, 17 Mar 2019 16:07:23 -0400
Received: from mail.kernel.org ([198.145.29.99]:56086 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727452AbfCQUHP (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Sun, 17 Mar 2019 16:07:15 -0400
Received: from sol.localdomain (c-107-3-167-184.hsd1.ca.comcast.net [107.3.167.184])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 17EF22184C;
        Sun, 17 Mar 2019 20:07:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1552853234;
        bh=hl2rdke2dF46rBeCelfCcRBHtrXDX7oT7cNW2Sq/1uc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=vPGW0vZyUdX3cdN0YRxvFiYGJNJj9mC/CU+whCHhyO3iIWzoUta7bNCyxL988f5w6
         UX6WZp/1OeBPTrRrBf3gWOoajvowQQDMZRi9jBnXgqNykzW4i8DnAzxYcVaF9RVyWa
         0kYOYjIDCnmUv4SdvvyTvYu7yUezgPI1nWleACP4=
From:   Eric Biggers <ebiggers@kernel.org>
To:     linux-fscrypt@vger.kernel.org
Cc:     linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org,
        linux-f2fs-devel@lists.sourceforge.net,
        linux-mtd@lists.infradead.org, linux-unionfs@vger.kernel.org,
        Sarthak Kukreti <sarthakkukreti@chromium.org>,
        Gao Xiang <gaoxiang25@huawei.com>
Subject: [PATCH 4/5] fscrypt: only set dentry_operations on ciphertext dentries
Date:   Sun, 17 Mar 2019 13:04:43 -0700
Message-Id: <20190317200444.5967-5-ebiggers@kernel.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190317200444.5967-1-ebiggers@kernel.org>
References: <20190317200444.5967-1-ebiggers@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-ext4-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org

From: Eric Biggers <ebiggers@google.com>

Plaintext dentries are always valid, so only set fscrypt_d_ops on
ciphertext dentries.

Besides marginally improved performance, this allows overlayfs to use an
fscrypt-encrypted upperdir, provided that all the following are true:

    (1) The fscrypt encryption key is placed in the keyring before
	mounting overlayfs, and remains while the overlayfs is mounted.

    (2) The workdir uses the same encryption policy.

    (3) No dentries for the ciphertext names of subdirectories have been
	created in the upperdir or workdir yet.  (Since otherwise
	d_splice_alias() will reuse the old dentry with ->d_op set.)

One potential use case is using an ephemeral encryption key to encrypt
all files created or changed by a container, so that they can be
securely erased ("crypto-shredded") after the container stops.

Signed-off-by: Eric Biggers <ebiggers@google.com>
---
 fs/crypto/hooks.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/fs/crypto/hooks.c b/fs/crypto/hooks.c
index 2e7498a821a4..9d8910e86ee5 100644
--- a/fs/crypto/hooks.c
+++ b/fs/crypto/hooks.c
@@ -115,9 +115,8 @@ int __fscrypt_prepare_lookup(struct inode *dir, struct dentry *dentry)
 		spin_lock(&dentry->d_lock);
 		dentry->d_flags |= DCACHE_ENCRYPTED_NAME;
 		spin_unlock(&dentry->d_lock);
+		d_set_d_op(dentry, &fscrypt_d_ops);
 	}
-
-	d_set_d_op(dentry, &fscrypt_d_ops);
 	return 0;
 }
 EXPORT_SYMBOL_GPL(__fscrypt_prepare_lookup);
-- 
2.21.0

