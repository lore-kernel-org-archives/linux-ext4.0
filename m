Return-Path: <SRS0=rV8s=XP=vger.kernel.org=linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C9411C4CEC9
	for <linux-ext4@archiver.kernel.org>; Fri, 20 Sep 2019 14:37:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 946C120C01
	for <linux-ext4@archiver.kernel.org>; Fri, 20 Sep 2019 14:37:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1568990234;
	bh=5HAhAebBZoeewPB0vmMb1b3bjdyfMmVXggFjC4H9i48=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:List-ID:From;
	b=i0NaWvmSFo1NK1yBhab9u5sLwiHI7FQoFsxUrntNGL8/m5t0H105PeDrEa6XUOdAe
	 UtE3XdzkFSbzDIkzrgEle7S6VHsIO1xX1+n4PHYTgQoz0rp4AKJYxgRZNw6s2srfhJ
	 EdQQZrAfMKDy8rjVpseLb5UpO37sdGNMwpF0IHQU=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392424AbfITOge (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Fri, 20 Sep 2019 10:36:34 -0400
Received: from mail.kernel.org ([198.145.29.99]:48854 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2392393AbfITOgd (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Fri, 20 Sep 2019 10:36:33 -0400
Received: from localhost (c-67-180-165-146.hsd1.ca.comcast.net [67.180.165.146])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2CF1A20B7C;
        Fri, 20 Sep 2019 14:36:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1568990193;
        bh=5HAhAebBZoeewPB0vmMb1b3bjdyfMmVXggFjC4H9i48=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ZH3tHXmLqO1lr6eSQBTC5QZcb9FXINbLuqz8clSFgWnVtlctVx5JKUjsW0+VJyHI1
         bYGXSDBPWSfI9s82VhPTyZXFhH7dSOWySHn2tpO7sjBTBSzyrCmpymV1Ilm32TdM5d
         DRrYOso2oNPhSw5kzSwB6dis4b2dy1roXi3MG7CY=
From:   Andy Lutomirski <luto@kernel.org>
To:     Theodore Tso <tytso@google.com>
Cc:     LKML <linux-kernel@vger.kernel.org>,
        Linux API <linux-api@vger.kernel.org>,
        Kees Cook <keescook@chromium.org>,
        "Jason A. Donenfeld" <Jason@zx2c4.com>,
        "Ahmed S. Darwish" <darwish.07@gmail.com>,
        Lennart Poettering <mzxreary@0pointer.de>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        "Alexander E. Patrakov" <patrakov@gmail.com>,
        Michael Kerrisk <mtk.manpages@gmail.com>,
        Willy Tarreau <w@1wt.eu>,
        Matthew Garrett <mjg59@srcf.ucam.org>,
        Ext4 Developers List <linux-ext4@vger.kernel.org>,
        linux-man <linux-man@vger.kernel.org>,
        Andy Lutomirski <luto@kernel.org>
Subject: [PATCH v2 1/7] random: Don't wake crng_init_wait when crng_init == 1
Date:   Fri, 20 Sep 2019 07:36:23 -0700
Message-Id: <7d54ef8512b06baf396f12584f7f48a9558ecd0f.1568990048.git.luto@kernel.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <cover.1568990048.git.luto@kernel.org>
References: <cover.1568990048.git.luto@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-ext4-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org

crng_init_wait is only used to wayt for crng_init to be set to 2, so
there's no point to waking it when crng_init is set to 1.  Remove the
unnecessary wake_up_interruptible() call.

Signed-off-by: Andy Lutomirski <luto@kernel.org>
---
 drivers/char/random.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/char/random.c b/drivers/char/random.c
index 5d5ea4ce1442..d152612e08fc 100644
--- a/drivers/char/random.c
+++ b/drivers/char/random.c
@@ -946,7 +946,6 @@ static int crng_fast_load(const char *cp, size_t len)
 	if (crng_init_cnt >= CRNG_INIT_CNT_THRESH) {
 		invalidate_batched_entropy();
 		crng_init = 1;
-		wake_up_interruptible(&crng_init_wait);
 		pr_notice("random: fast init done\n");
 	}
 	return 1;
-- 
2.21.0

