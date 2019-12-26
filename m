Return-Path: <SRS0=CWHP=2Q=vger.kernel.org=linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 00700C2D0DA
	for <linux-ext4@archiver.kernel.org>; Thu, 26 Dec 2019 15:39:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C759C206A4
	for <linux-ext4@archiver.kernel.org>; Thu, 26 Dec 2019 15:39:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1577374782;
	bh=p9zKn/41L5nDfI/gqqK4Ty/IGWKYg6d9TuZ8CBGTEQg=;
	h=From:To:Subject:Date:List-ID:From;
	b=1z/tv+NbAwjiYhPnqXkvx4NaYabL7wCVhkfXMJXjJy5Kzk7A+iDqr9bffG1s2eRAU
	 PAX/6t93LcyOZCCEDO2jjCAr//Dl9sMzAGVlE0G5k8L30R3p/Op2e4QZc/ku23hTqX
	 zbl50dCAm+fOvIHgAn7VViFmwe+glByKi3KkDHcw=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726513AbfLZPjm (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Thu, 26 Dec 2019 10:39:42 -0500
Received: from mail.kernel.org ([198.145.29.99]:46948 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726236AbfLZPjm (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Thu, 26 Dec 2019 10:39:42 -0500
Received: from zzz.tds (h75-100-12-111.burkwi.broadband.dynamic.tds.net [75.100.12.111])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9597C206A4
        for <linux-ext4@vger.kernel.org>; Thu, 26 Dec 2019 15:39:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1577374781;
        bh=p9zKn/41L5nDfI/gqqK4Ty/IGWKYg6d9TuZ8CBGTEQg=;
        h=From:To:Subject:Date:From;
        b=ZKrbkPWSXvn87XKUftDn1Oa6k1i1wd6wak6EOyLsLwHg0/ROqcRdHYZP1gDheGr7O
         Qt9pp17cIDnIC8xEkoUUt8f91iIpKjt51xlq3pFt7Gai5xdOMzQuMAHvvQFND46WxQ
         7JVV1eD+c5aL1K8br5625qKqkxLhPbE7qu5ROZdo=
From:   Eric Biggers <ebiggers@kernel.org>
To:     linux-ext4@vger.kernel.org
Subject: [PATCH] ext4: remove unnecessary selections from EXT3_FS
Date:   Thu, 26 Dec 2019 09:39:20 -0600
Message-Id: <20191226153920.4466-1-ebiggers@kernel.org>
X-Mailer: git-send-email 2.24.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-ext4-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org

From: Eric Biggers <ebiggers@google.com>

Since EXT3_FS already selects EXT4_FS, there's no reason for it to
redundantly select all the selections of EXT4_FS -- notwithstanding the
comments that claim otherwise.

Remove these redundant selections to avoid confusion.

Signed-off-by: Eric Biggers <ebiggers@google.com>
---
 fs/ext4/Kconfig | 6 ------
 1 file changed, 6 deletions(-)

diff --git a/fs/ext4/Kconfig b/fs/ext4/Kconfig
index ef42ab040905..5841fd8aa706 100644
--- a/fs/ext4/Kconfig
+++ b/fs/ext4/Kconfig
@@ -4,12 +4,7 @@
 # kernels after the removal of ext3 driver.
 config EXT3_FS
 	tristate "The Extended 3 (ext3) filesystem"
-	# These must match EXT4_FS selects...
 	select EXT4_FS
-	select JBD2
-	select CRC16
-	select CRYPTO
-	select CRYPTO_CRC32C
 	help
 	  This config option is here only for backward compatibility. ext3
 	  filesystem is now handled by the ext4 driver.
@@ -33,7 +28,6 @@ config EXT3_FS_SECURITY
 
 config EXT4_FS
 	tristate "The Extended 4 (ext4) filesystem"
-	# Please update EXT3_FS selects when changing these
 	select JBD2
 	select CRC16
 	select CRYPTO
-- 
2.24.1

