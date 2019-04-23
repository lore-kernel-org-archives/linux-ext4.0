Return-Path: <SRS0=E3Xq=SZ=vger.kernel.org=linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.6 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT,USER_IN_DEF_DKIM_WL
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DE65CC282DD
	for <linux-ext4@archiver.kernel.org>; Tue, 23 Apr 2019 21:13:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id AB910218B0
	for <linux-ext4@archiver.kernel.org>; Tue, 23 Apr 2019 21:13:41 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="qmZvYj6N"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727793AbfDWVNh (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Tue, 23 Apr 2019 17:13:37 -0400
Received: from mail-qt1-f201.google.com ([209.85.160.201]:54169 "EHLO
        mail-qt1-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726599AbfDWVNh (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Tue, 23 Apr 2019 17:13:37 -0400
Received: by mail-qt1-f201.google.com with SMTP id 18so15895197qtw.20
        for <linux-ext4@vger.kernel.org>; Tue, 23 Apr 2019 14:13:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=bZHDbK/yobdrFPeL2PgeVHLRSaUhrYBQOSZn6iUwvTc=;
        b=qmZvYj6Nysn00Bh5NGtig1mPn1MbVI94aImSuXSzZT/xC5CFCOhyYLNlvuKGHcb2/P
         xXS95WKixbGhNh+QWqEWmIXeBK/oRgHPxyvtANerGfeiKCiFGiWU2yoWIqP4u77SyQC+
         RapzuvAOPSppkNLFJNsKId0XkriwvoDYHYdAR2uu80wARk9gV5U0bhytfvdfiHmGpLeh
         UtYhSQ9UdDgowoVppEH+5wKICBfUChAoozXkix5pYg9v9N0vWaUoXxu5IpOC+XDEDqT9
         vI+dakC9enOeyuHi0Tp53/VbrIdOS03v+t0xmVWAyji6Ha9bUjCmTpesyiuiZ9J5jDQ9
         DCDw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=bZHDbK/yobdrFPeL2PgeVHLRSaUhrYBQOSZn6iUwvTc=;
        b=ql+wByH/xmcxxKUstDFCQKJR5Bj+EG4INZTNpBJ6B4zkBPnlDOEsz3kTTrDjXcMhN6
         TrMqfjkzc8Dwqh9vxBaVRRQp/FgHjhSF9FaPeZKlnyrTcfGx4LibiQNRCiDCj3RqK88Q
         jYGDFcS7rBS6YUVj6htFBXbSAQ62RFLcd6pKyxV3KO6lyYp69FXwPRAOnHP+PwmVJrwc
         FI9OlxDPyrbjlKZIbUCqF2ycBdrS1v9VE1I5H/yEnb98kwaiUsYiaZ20NkCfk75qBqcf
         oiQdO3WC3BdZeAEpdk+ClxxNakejJEVkEIoZyXiRkXtVq687OpHMi+aynqbu2n3DJTVy
         yFMw==
X-Gm-Message-State: APjAAAU5O5ojBbQyqpgOMmGQyoY/NqTNzW67Awr+pgXGv8v7eMdugNhX
        6GqgQM5ahspHuZxsGmujyMW2jEhOiHc=
X-Google-Smtp-Source: APXvYqzRDe5K3B29b0tQOgxz9p2HqITP+PMWi9qlWqF+2DE1V558vAOD2DwKQ6iYA9d7OPyAcEUshCgfyIU=
X-Received: by 2002:a0c:ae04:: with SMTP id y4mr22674010qvc.49.1556054016351;
 Tue, 23 Apr 2019 14:13:36 -0700 (PDT)
Date:   Tue, 23 Apr 2019 14:13:29 -0700
In-Reply-To: <CACGdZYLCi+Or=afmBK8hbP3Ay8x8Oaqnp0Yr+jf1PoQiMc7_DQ@mail.gmail.com>
Message-Id: <20190423211329.149642-1-khazhy@google.com>
Mime-Version: 1.0
References: <CACGdZYLCi+Or=afmBK8hbP3Ay8x8Oaqnp0Yr+jf1PoQiMc7_DQ@mail.gmail.com>
X-Mailer: git-send-email 2.21.0.593.g511ec345e18-goog
Subject: [PATCH v2] ext4: cond_resched in work-heavy group loops
From:   Khazhismel Kumykov <khazhy@google.com>
To:     tytso@mit.edu, adilger.kernel@dilger.ca
Cc:     linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org,
        jack@suse.cz, Khazhismel Kumykov <khazhy@google.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-ext4-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org

These functions may take a long time looping over many groups, which
may cause issues for non-preempt kernels.
ext4_mb_init_backend()
ext4_setup_system_zone()
ext4_mb_release()

Signed-off-by: Khazhismel Kumykov <khazhy@google.com>
---
v2: 
 - a few other places that in testing showed to be slow

 fs/ext4/block_validity.c | 1 +
 fs/ext4/mballoc.c        | 2 ++
 2 files changed, 3 insertions(+)

diff --git a/fs/ext4/block_validity.c b/fs/ext4/block_validity.c
index 913061c0de1b..16134469ea3c 100644
--- a/fs/ext4/block_validity.c
+++ b/fs/ext4/block_validity.c
@@ -155,6 +155,7 @@ int ext4_setup_system_zone(struct super_block *sb)
 		return 0;
 
 	for (i=0; i < ngroups; i++) {
+		cond_resched();
 		if (ext4_bg_has_super(sb, i) &&
 		    ((i < 5) || ((i % flex_size) == 0)))
 			add_system_zone(sbi, ext4_group_first_block_no(sb, i),
diff --git a/fs/ext4/mballoc.c b/fs/ext4/mballoc.c
index 8ef5f12bbee2..99ba720dbb7a 100644
--- a/fs/ext4/mballoc.c
+++ b/fs/ext4/mballoc.c
@@ -2490,6 +2490,7 @@ static int ext4_mb_init_backend(struct super_block *sb)
 	sbi->s_buddy_cache->i_ino = EXT4_BAD_INO;
 	EXT4_I(sbi->s_buddy_cache)->i_disksize = 0;
 	for (i = 0; i < ngroups; i++) {
+		cond_resched();
 		desc = ext4_get_group_desc(sb, i, NULL);
 		if (desc == NULL) {
 			ext4_msg(sb, KERN_ERR, "can't read descriptor %u", i);
@@ -2705,6 +2706,7 @@ int ext4_mb_release(struct super_block *sb)
 
 	if (sbi->s_group_info) {
 		for (i = 0; i < ngroups; i++) {
+			cond_resched();
 			grinfo = ext4_get_group_info(sb, i);
 #ifdef DOUBLE_CHECK
 			kfree(grinfo->bb_bitmap);
-- 
2.21.0.593.g511ec345e18-goog

