Return-Path: <linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-14.2 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 63399C4338F
	for <linux-ext4@archiver.kernel.org>; Tue, 24 Aug 2021 03:49:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2F57E61265
	for <linux-ext4@archiver.kernel.org>; Tue, 24 Aug 2021 03:49:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234107AbhHXDuX (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Mon, 23 Aug 2021 23:50:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42616 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232605AbhHXDuU (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Mon, 23 Aug 2021 23:50:20 -0400
Received: from mail-pg1-x52c.google.com (mail-pg1-x52c.google.com [IPv6:2607:f8b0:4864:20::52c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F0712C061575;
        Mon, 23 Aug 2021 20:49:34 -0700 (PDT)
Received: by mail-pg1-x52c.google.com with SMTP id r2so18541171pgl.10;
        Mon, 23 Aug 2021 20:49:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:mime-version:content-disposition
         :content-transfer-encoding:user-agent;
        bh=5XhERRnYu/DuBhvBYP0AnQbv2TXqBtKHcBR7KzXaAy0=;
        b=ZetcpJogvvQRdfWAugp/yv5EMphT9hDaBrMEYX6AScYY0N4L0GI07NJNg/PcOFdH6T
         moZJf2b3sCOOtWZvoUMeM4OFJNgKgU3e9nCplEXnETAX1pxyEAy0JSz01JUA/iVxLTPT
         OjWb6NnCisJTbyHzwxaDlLEzaiTe9NbOduJa1pTCIKCx97jtIaXbpTihKDpZ9E/eV/2z
         0bkAmSx1JVRaEezV8Yee8YQZJKCSoR/w4XNsOl3gkK5S/zVxAo7HzhPi0RMGyMDlvJJQ
         ZSXcZ2ctc0f/ojHvRLN6HK8CAs9nC3P3MpFBEMOU22elPmMj0kNG6BbDknYQgSyMjXMB
         srbg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:mime-version
         :content-disposition:content-transfer-encoding:user-agent;
        bh=5XhERRnYu/DuBhvBYP0AnQbv2TXqBtKHcBR7KzXaAy0=;
        b=QOSnzlWaNtWKhnYlRa/pAGA8cskFABvCC5xMbHskZ0HjcYAJ9NRDGX0Tyug5nfjY5Q
         aBa95epYYwDzbQ+ZTT0p+wqCO3dSeqSqJ77dS1624WoQUMPHXuW7aFgEpdQOfWHinLqA
         5Nxo94x3HuzUXDi9Q6JuhT0f39LizKdE9uu6wQWknRvsdOCugXE1JMJPY9vanaDZ5rOs
         9Ems9AKTkxLf0X9e30UnAvt70zMEhXG2HK7hX8horBkOTK3bFLtJqO8sTok+bwZUPDK7
         aC/h0eG1+rw7BASFCupdobT8jCyJwz4UoZzpeR2AdZWGlqYOew7Z8Ozno8RByWfs8sYz
         cyzg==
X-Gm-Message-State: AOAM532UO9mWhUqyAm2xSSebgKc5jROSb3Z6dI6tybt0b+8KS51Vuua6
        o5kRYXu0tP4ahwNsSipfzso=
X-Google-Smtp-Source: ABdhPJzmUR8F7yUUBeJ99QbiQ6Er9mRfNCirqCXozcaJh8cyNxqSXRLdjEzFPRe9K2bgfwzGJyubDA==
X-Received: by 2002:a63:1209:: with SMTP id h9mr34426295pgl.106.1629776974193;
        Mon, 23 Aug 2021 20:49:34 -0700 (PDT)
Received: from raspberrypi ([210.183.35.240])
        by smtp.gmail.com with ESMTPSA id c15sm657720pjr.22.2021.08.23.20.49.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 23 Aug 2021 20:49:33 -0700 (PDT)
Date:   Tue, 24 Aug 2021 04:49:29 +0100
From:   Austin Kim <austindh.kim@gmail.com>
To:     tytso@mit.edu, adilger.kernel@dilger.ca
Cc:     linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org,
        austin.kim@lge.com
Subject: [PATCH] ext4: remove an unused variable warning with CONFIG_QUOTA=n
Message-ID: <20210824034929.GA13415@raspberrypi>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org

The 'enable_quota' variable is only used in an CONFIG_QUOTA.
With CONFIG_QUOTA=n, compiler causes a harmless warning:

fs/ext4/super.c: In function ‘ext4_remount’:
fs/ext4/super.c:5840:6: warning: variable ‘enable_quota’ set but not used
  [-Wunused-but-set-variable]
  int enable_quota = 0;
              ^~~~~

Move 'enable_quota' into the same #ifdef CONFIG_QUOTA block
to remove an unused variable warning.

Signed-off-by: Austin Kim <austindh.kim@gmail.com>
---
 fs/ext4/super.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/fs/ext4/super.c b/fs/ext4/super.c
index 6b03e4281f6f..6adb570f4b31 100644
--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -5845,10 +5845,10 @@ static int ext4_remount(struct super_block *sb, int *flags, char *data)
 	struct ext4_sb_info *sbi = EXT4_SB(sb);
 	unsigned long old_sb_flags, vfs_flags;
 	struct ext4_mount_options old_opts;
-	int enable_quota = 0;
 	ext4_group_t g;
 	int err = 0;
 #ifdef CONFIG_QUOTA
+	int enable_quota = 0;
 	int i, j;
 	char *to_free[EXT4_MAXQUOTAS];
 #endif
@@ -6053,7 +6053,9 @@ static int ext4_remount(struct super_block *sb, int *flags, char *data)
 					err = -EROFS;
 					goto restore_opts;
 				}
+#ifdef CONFIG_QUOTA
 			enable_quota = 1;
+#endif
 		}
 	}
 
-- 
2.20.1

