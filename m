Return-Path: <SRS0=3Woa=SR=vger.kernel.org=linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.6 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT,USER_IN_DEF_DKIM_WL
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AAC0AC10F12
	for <linux-ext4@archiver.kernel.org>; Mon, 15 Apr 2019 21:20:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 6D4162087C
	for <linux-ext4@archiver.kernel.org>; Mon, 15 Apr 2019 21:20:22 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="CKfmCqhH"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726621AbfDOVUQ (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Mon, 15 Apr 2019 17:20:16 -0400
Received: from mail-qt1-f201.google.com ([209.85.160.201]:40119 "EHLO
        mail-qt1-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727243AbfDOVUQ (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Mon, 15 Apr 2019 17:20:16 -0400
Received: by mail-qt1-f201.google.com with SMTP id z24so17252126qto.7
        for <linux-ext4@vger.kernel.org>; Mon, 15 Apr 2019 14:20:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=NhZ7goTL5H91UJ+3++ZYwoqcRHsg3U/wejpAPhk1iYk=;
        b=CKfmCqhH+W2lhxEZ5cGHcF9qhX+Gw7GILjTEpH7JVI3Apo6hgBwoF6fxUmQYitLmP+
         e0HsoSbS5D+CG8Xso7pLNRu9Kay3ZCAmRoaLZ5MvcgR3xO9TbU7JpZIhbKZPJ966DUXK
         sV4FwmULpVLUUiYpXn83c73QppDN7T7xJGoUOstxk/TTGuY302ad2DcZLQ+Y/1SiNL7P
         8z7h7kY9Zj11hWm3JG3uBQRhnrC8nh/UCKO95eJTzIuWgLGE5SqgJgWyxZUfG6rIE2eD
         udV7hv1QymWzyKvM8QTAAwLbKB3S9IL9JhZF8nKzxMGKAh5rafy09MLfDStrQAbr4yDg
         BYfQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=NhZ7goTL5H91UJ+3++ZYwoqcRHsg3U/wejpAPhk1iYk=;
        b=jZZtyCnEEXeFcZ3kpHPqNhTkuW1wKeAH9PjPl3zgjS2boqyBvejVc/h8qTldMQbD1S
         Nn6oIPi/agA58bPO2ev6AT7kjGY0IONjZHCvXHoOeIajuDwKWwVKR7waUZ92d92d9j7E
         jK4RHEfoNDI+w0m8bx5gQlSE/LGS9GYEahlwphG8Fveop6HCpSNvOHJhnB2cQqIMj/x/
         lP59gEHxmTIq3dl5/F9VtztiwaDHc03VN9xx8UhPRomPSXo9LZtHaJ2o9t72hEd8Jc33
         uyP7OYAvLJEUUnYl8gdA+TN4rFRD7IjsnLKeIWDRlXpm0O7EJahTiBj75CFq45dVhk//
         FVcA==
X-Gm-Message-State: APjAAAXWmM90t8Nqs/P/c2+qiu1U0ZzAYZtGyOLOUSdQrmMy6ZT0rUyQ
        xTzZjLh3zMeefJleDAFY3jp8qxAB
X-Google-Smtp-Source: APXvYqwvADiSshbrS4yX35CBLGPKbQ1IdXCq1Tqanlx9n4NDblO1HBtMEBEU1UvHkQkocyqn44kvM6TH
X-Received: by 2002:a0c:ad17:: with SMTP id u23mr9559639qvc.41.1555363215418;
 Mon, 15 Apr 2019 14:20:15 -0700 (PDT)
Date:   Mon, 15 Apr 2019 17:19:45 -0400
Message-Id: <20190415211945.27343-1-brho@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.21.0.392.gf8f6787159e-goog
Subject: [PATCH] ext4: fix use-after-free race with debug_want_extra_isize
From:   Barret Rhoden <brho@google.com>
To:     "Theodore Ts'o" <tytso@mit.edu>,
        Andreas Dilger <adilger.kernel@dilger.ca>
Cc:     syzbot+f584efa0ac7213c226b7@syzkaller.appspotmail.com,
        stable@vger.kernel.org, linux-ext4@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: linux-ext4-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org

When remounting with debug_want_extra_isize, we were not performing the
same checks that we do during a normal mount.  That allowed us to set a
value for s_want_extra_isize that reached outside the s_inode_size.

Reported-by: syzbot+f584efa0ac7213c226b7@syzkaller.appspotmail.com
Signed-off-by: Barret Rhoden <brho@google.com>
Cc: stable@vger.kernel.org
---

- In the current code, it looks like someone could mount with want_extra_isize
  with some value > 0 but less than the minimums in the s_es.  If that's a bug,
  I can submit a follow-on patch.

- Similarly, on a failed remount, sbi->s_want_extra_isize is changed to the
  remounted value.  I can fix that too if it's a problem.

- Is it OK to remount with a smaller s_want_extra_isize than the previous mount?
  I thought it was, but figured I'd ask while I'm looking at it.


 fs/ext4/super.c | 58 +++++++++++++++++++++++++++++--------------------
 1 file changed, 34 insertions(+), 24 deletions(-)

diff --git a/fs/ext4/super.c b/fs/ext4/super.c
index 6ed4eb81e674..184944d4d8d1 100644
--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -3513,6 +3513,37 @@ int ext4_calculate_overhead(struct super_block *sb)
 	return 0;
 }
 
+static void ext4_clamp_want_extra_isize(struct super_block *sb)
+{
+	struct ext4_sb_info *sbi = EXT4_SB(sb);
+	struct ext4_super_block *es = sbi->s_es;
+
+	/* determine the minimum size of new large inodes, if present */
+	if (sbi->s_inode_size > EXT4_GOOD_OLD_INODE_SIZE &&
+	    sbi->s_want_extra_isize == 0) {
+		sbi->s_want_extra_isize = sizeof(struct ext4_inode) -
+						     EXT4_GOOD_OLD_INODE_SIZE;
+		if (ext4_has_feature_extra_isize(sb)) {
+			if (sbi->s_want_extra_isize <
+			    le16_to_cpu(es->s_want_extra_isize))
+				sbi->s_want_extra_isize =
+					le16_to_cpu(es->s_want_extra_isize);
+			if (sbi->s_want_extra_isize <
+			    le16_to_cpu(es->s_min_extra_isize))
+				sbi->s_want_extra_isize =
+					le16_to_cpu(es->s_min_extra_isize);
+		}
+	}
+	/* Check if enough inode space is available */
+	if (EXT4_GOOD_OLD_INODE_SIZE + sbi->s_want_extra_isize >
+							sbi->s_inode_size) {
+		sbi->s_want_extra_isize = sizeof(struct ext4_inode) -
+						       EXT4_GOOD_OLD_INODE_SIZE;
+		ext4_msg(sb, KERN_INFO,
+			 "required extra inode space not available");
+	}
+}
+
 static void ext4_set_resv_clusters(struct super_block *sb)
 {
 	ext4_fsblk_t resv_clusters;
@@ -4387,30 +4418,7 @@ static int ext4_fill_super(struct super_block *sb, void *data, int silent)
 	} else if (ret)
 		goto failed_mount4a;
 
-	/* determine the minimum size of new large inodes, if present */
-	if (sbi->s_inode_size > EXT4_GOOD_OLD_INODE_SIZE &&
-	    sbi->s_want_extra_isize == 0) {
-		sbi->s_want_extra_isize = sizeof(struct ext4_inode) -
-						     EXT4_GOOD_OLD_INODE_SIZE;
-		if (ext4_has_feature_extra_isize(sb)) {
-			if (sbi->s_want_extra_isize <
-			    le16_to_cpu(es->s_want_extra_isize))
-				sbi->s_want_extra_isize =
-					le16_to_cpu(es->s_want_extra_isize);
-			if (sbi->s_want_extra_isize <
-			    le16_to_cpu(es->s_min_extra_isize))
-				sbi->s_want_extra_isize =
-					le16_to_cpu(es->s_min_extra_isize);
-		}
-	}
-	/* Check if enough inode space is available */
-	if (EXT4_GOOD_OLD_INODE_SIZE + sbi->s_want_extra_isize >
-							sbi->s_inode_size) {
-		sbi->s_want_extra_isize = sizeof(struct ext4_inode) -
-						       EXT4_GOOD_OLD_INODE_SIZE;
-		ext4_msg(sb, KERN_INFO, "required extra inode space not"
-			 "available");
-	}
+	ext4_clamp_want_extra_isize(sb);
 
 	ext4_set_resv_clusters(sb);
 
@@ -5194,6 +5202,8 @@ static int ext4_remount(struct super_block *sb, int *flags, char *data)
 		goto restore_opts;
 	}
 
+	ext4_clamp_want_extra_isize(sb);
+
 	if ((old_opts.s_mount_opt & EXT4_MOUNT_JOURNAL_CHECKSUM) ^
 	    test_opt(sb, JOURNAL_CHECKSUM)) {
 		ext4_msg(sb, KERN_ERR, "changing journal_checksum "
-- 
2.21.0.392.gf8f6787159e-goog

