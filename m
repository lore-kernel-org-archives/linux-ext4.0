Return-Path: <SRS0=QItb=SB=vger.kernel.org=linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E08C3C4360F
	for <linux-ext4@archiver.kernel.org>; Sat, 30 Mar 2019 01:04:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id AA0F1206DD
	for <linux-ext4@archiver.kernel.org>; Sat, 30 Mar 2019 01:04:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1553907858;
	bh=ijo4EvYM3HuiSUgVvme9ei7VgavrUuFyV+ucPmMbVl0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:List-ID:From;
	b=xTzLhs0/HzOGyl86C9vPzjpWeIdcBA/+gK91OmRZYkhHLTaM2uYTJXPYTKBIiWZO/
	 fZNsOsvn1RO/VIGh/qiUcfBLyIR0+pHT/WURsZOZz9C3zL51itkrj4fYuUdrtOzSd7
	 CweLsq8dalc5NcD+i2ePEqiP++WNUtrwJ+07Zt/w=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731615AbfC3Ayu (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Fri, 29 Mar 2019 20:54:50 -0400
Received: from mail.kernel.org ([198.145.29.99]:33924 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731609AbfC3Ayt (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Fri, 29 Mar 2019 20:54:49 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D3D6D218CD;
        Sat, 30 Mar 2019 00:54:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1553907288;
        bh=ijo4EvYM3HuiSUgVvme9ei7VgavrUuFyV+ucPmMbVl0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=yj6uYhxkgQHf1C4qCBkMRKfy63UDT3o3g/B8qaO1HEEWvpksWWWwMS6yGmSZY0loj
         AA39XCFLZ11bPLNIABTIMRkkG7FAE2Pgxd6b575+DQyhkh0nUt4mfVKoez3PhzNSr0
         4jBBbrZzzhWXtk/TDVMrFo8iw96hg0bh4LmcIsBU=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Lukas Czerner <lczerner@redhat.com>, Theodore Ts'o <tytso@mit.edu>,
        Sasha Levin <sashal@kernel.org>, linux-ext4@vger.kernel.org
Subject: [PATCH AUTOSEL 4.14 05/37] ext4: report real fs size after failed resize
Date:   Fri, 29 Mar 2019 20:54:06 -0400
Message-Id: <20190330005441.27540-5-sashal@kernel.org>
X-Mailer: git-send-email 2.19.1
In-Reply-To: <20190330005441.27540-1-sashal@kernel.org>
References: <20190330005441.27540-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: linux-ext4-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org

From: Lukas Czerner <lczerner@redhat.com>

[ Upstream commit 6c7328400e0488f7d49e19e02290ba343b6811b2 ]

Currently when the file system resize using ext4_resize_fs() fails it
will report into log that "resized filesystem to <requested block
count>".  However this may not be true in the case of failure.  Use the
current block count as returned by ext4_blocks_count() to report the
block count.

Additionally, report a warning that "error occurred during file system
resize"

Signed-off-by: Lukas Czerner <lczerner@redhat.com>
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ext4/resize.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/fs/ext4/resize.c b/fs/ext4/resize.c
index fb9fbf993e22..333fba05e1a5 100644
--- a/fs/ext4/resize.c
+++ b/fs/ext4/resize.c
@@ -2049,6 +2049,10 @@ int ext4_resize_fs(struct super_block *sb, ext4_fsblk_t n_blocks_count)
 		free_flex_gd(flex_gd);
 	if (resize_inode != NULL)
 		iput(resize_inode);
-	ext4_msg(sb, KERN_INFO, "resized filesystem to %llu", n_blocks_count);
+	if (err)
+		ext4_warning(sb, "error (%d) occurred during "
+			     "file system resize", err);
+	ext4_msg(sb, KERN_INFO, "resized filesystem to %llu",
+		 ext4_blocks_count(es));
 	return err;
 }
-- 
2.19.1

