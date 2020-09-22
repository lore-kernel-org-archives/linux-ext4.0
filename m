Return-Path: <SRS0=H0Ep=C7=vger.kernel.org=linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-14.6 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1D829C2D0E2
	for <linux-ext4@archiver.kernel.org>; Tue, 22 Sep 2020 16:25:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C475423A1E
	for <linux-ext4@archiver.kernel.org>; Tue, 22 Sep 2020 16:25:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1600791947;
	bh=TYZYFsETxKQokJa5RQ1ZT+XnfW77zUGnkWfO/996T6c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:List-ID:From;
	b=fGoedbLyEFrDG0O4WD1Uy537/XJRcqVJ1olINixw27pqG147CAgboDgsp0aBSbk7p
	 MJK8gDXg2t46cfQJT6mYWkztV0XotkKo17STr+bZ8dcfoVwW1RTa5PFcHJ5qK7FCxd
	 b7d+/ANKogxVgtrANBJq7p/EGDcIw7QiYQy1TyCQ=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726682AbgIVQZq (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Tue, 22 Sep 2020 12:25:46 -0400
Received: from mail.kernel.org ([198.145.29.99]:52628 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726566AbgIVQZq (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Tue, 22 Sep 2020 12:25:46 -0400
Received: from sol.attlocal.net (172-10-235-113.lightspeed.sntcca.sbcglobal.net [172.10.235.113])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0173A23A1B;
        Tue, 22 Sep 2020 16:25:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1600791946;
        bh=TYZYFsETxKQokJa5RQ1ZT+XnfW77zUGnkWfO/996T6c=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=N6DyX9BvrTxWtntNUaLSrdcUAqIFDIgsKU0dDH2YUBI6/tUe1klJvijggIGn+R6ZV
         5DAddRWtDHwZbZY5fRAWkMjfWPUL+19EutKm/M4cYj+ll0P7spobZpu+IgikKPbmrZ
         XP6/Y4Rbt/ahLXyf2uulWDAOMPSITmkAU+qYq8S0=
From:   Eric Biggers <ebiggers@kernel.org>
To:     linux-ext4@vger.kernel.org, Theodore Ts'o <tytso@mit.edu>
Cc:     syzkaller-bugs@googlegroups.com, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org,
        syzbot+9f864abad79fae7c17e1@syzkaller.appspotmail.com
Subject: [PATCH] ext4: fix leaking sysfs kobject after failed mount
Date:   Tue, 22 Sep 2020 09:24:56 -0700
Message-Id: <20200922162456.93657-1-ebiggers@kernel.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <000000000000443d8a05afcff2b5@google.com>
References: <000000000000443d8a05afcff2b5@google.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org

From: Eric Biggers <ebiggers@google.com>

ext4_unregister_sysfs() only deletes the kobject.  The reference to it
needs to be put separately, like ext4_put_super() does.

This addresses the syzbot report
"memory leak in kobject_set_name_vargs (3)"
(https://syzkaller.appspot.com/bug?extid=9f864abad79fae7c17e1).

Reported-by: syzbot+9f864abad79fae7c17e1@syzkaller.appspotmail.com
Fixes: 72ba74508b28 ("ext4: release sysfs kobject when failing to enable quotas on mount")
Cc: stable@vger.kernel.org
Signed-off-by: Eric Biggers <ebiggers@google.com>
---
 fs/ext4/super.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/fs/ext4/super.c b/fs/ext4/super.c
index ea425b49b345..41953b86ffe3 100644
--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -4872,6 +4872,7 @@ static int ext4_fill_super(struct super_block *sb, void *data, int silent)
 
 failed_mount8:
 	ext4_unregister_sysfs(sb);
+	kobject_put(&sbi->s_kobj);
 failed_mount7:
 	ext4_unregister_li_request(sb);
 failed_mount6:

base-commit: ba4f184e126b751d1bffad5897f263108befc780
-- 
2.28.0

