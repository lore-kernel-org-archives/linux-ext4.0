Return-Path: <SRS0=18j+=WH=vger.kernel.org=linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E6DAFC32757
	for <linux-ext4@archiver.kernel.org>; Sun, 11 Aug 2019 21:37:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B6B8F2173B
	for <linux-ext4@archiver.kernel.org>; Sun, 11 Aug 2019 21:37:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1565559434;
	bh=p/SZRYcADvPD/FuvRi8uPfjTa+Ri4JfMVG7sxvqkbAc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:List-ID:From;
	b=hTIK9ZrMJLS7etKmOEvWfzyxjKz8cME2fqr/wppiZz1YXWnurrYRz0FpTNfidp2lC
	 +OItAFQzh5IWer+1rPuj29HGD8WGUU0WI/mupGFvS1s+ig/+CzfUXZppHT4w5HhpU+
	 OP9kyQWOt7SW/goVF00qU/mzEQhQb1i0hw6V7lWc=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726538AbfHKVhO (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Sun, 11 Aug 2019 17:37:14 -0400
Received: from mail.kernel.org ([198.145.29.99]:33516 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726527AbfHKVhO (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Sun, 11 Aug 2019 17:37:14 -0400
Received: from sol.localdomain (c-24-5-143-220.hsd1.ca.comcast.net [24.5.143.220])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6E842216F4;
        Sun, 11 Aug 2019 21:37:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1565559433;
        bh=p/SZRYcADvPD/FuvRi8uPfjTa+Ri4JfMVG7sxvqkbAc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=xzkZzx7MZETwgWv7D7aFx91csOHB28dyd6s+TrD52+T1/aASBZcbWvrg4J5chjSfr
         CUKVkJv1IaQYj7PXsiKRu2IpxBRYzEmPfdaQO6yA0mNU+XUJLEg9jvbGPH95m3DegH
         ZzFpHKz0y61SdzkGZTEyCxSofY5+xsab/e2wYfG8=
From:   Eric Biggers <ebiggers@kernel.org>
To:     linux-fscrypt@vger.kernel.org
Cc:     linux-ext4@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net
Subject: [PATCH 5/6] ext4: fix comment in ext4_end_enable_verity()
Date:   Sun, 11 Aug 2019 14:35:56 -0700
Message-Id: <20190811213557.1970-6-ebiggers@kernel.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190811213557.1970-1-ebiggers@kernel.org>
References: <20190811213557.1970-1-ebiggers@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-ext4-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org

From: Eric Biggers <ebiggers@google.com>

Signed-off-by: Eric Biggers <ebiggers@google.com>
---
 fs/ext4/verity.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/ext4/verity.c b/fs/ext4/verity.c
index bb0a3b8e6ea71..d0d8a9795dd62 100644
--- a/fs/ext4/verity.c
+++ b/fs/ext4/verity.c
@@ -196,7 +196,7 @@ static int ext4_end_enable_verity(struct file *filp, const void *desc,
 				  size_t desc_size, u64 merkle_tree_size)
 {
 	struct inode *inode = file_inode(filp);
-	const int credits = 2; /* superblock and inode for ext4_orphan_add() */
+	const int credits = 2; /* superblock and inode for ext4_orphan_del() */
 	handle_t *handle;
 	int err = 0;
 	int err2;
-- 
2.22.0

