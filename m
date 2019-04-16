Return-Path: <SRS0=X8xt=SS=vger.kernel.org=linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 54615C10F14
	for <linux-ext4@archiver.kernel.org>; Tue, 16 Apr 2019 14:34:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 220F020656
	for <linux-ext4@archiver.kernel.org>; Tue, 16 Apr 2019 14:34:29 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="SzQEQNR3"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729482AbfDPOe2 (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Tue, 16 Apr 2019 10:34:28 -0400
Received: from mail-pg1-f194.google.com ([209.85.215.194]:47095 "EHLO
        mail-pg1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729512AbfDPOeX (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Tue, 16 Apr 2019 10:34:23 -0400
Received: by mail-pg1-f194.google.com with SMTP id q1so10426822pgv.13
        for <linux-ext4@vger.kernel.org>; Tue, 16 Apr 2019 07:34:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=HvjoW1gRF8rN8dZ5eYfX9dZyfEK7SLJjEDLpqRNCQsc=;
        b=SzQEQNR3hA5CrLnV1xa0nXsr0TA3+gHh8O7a306KFnYq0G7SuEgEHo9bO5aQ6DJj2I
         hkSpP2KysSv7+6hIplY3Vg07h4evYYtZNNT4iGjh35GREu/poguvm5i7bK5jIs/gOH2r
         MNkCa/DYjvH5RboxBSHQxHK9z/kH73kUk4/70eT+AuJb+Z/q+VsQDkFtyX81hCZ+7HjK
         sU92YySouJe07n5sFHppFYmQqfpwJ2BuezrcbMqNk6qCuEJUvLIDElDH86hSaDqmkDUP
         /sozx+seukcqCeKrjvHJoAzGHJ26ltyClEIZLccGxuoKzEKG4cHMOlxhSu/0Q55aUvOP
         sRUQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=HvjoW1gRF8rN8dZ5eYfX9dZyfEK7SLJjEDLpqRNCQsc=;
        b=LktCnVjggcHPzneBuSmQYz4Ah0/UaCaFUEEMi8IK4lGDFQPvXshvK0dd8rP4pbsagI
         +EVVXH8OUC2VAys1023l6xAw2Y8ZFJZaXy5fnV2oZ82rB71a3HKfpO7D6jYAhVanbo8k
         o55c6JDsReQgKXn56OZIxA9/TZCZ5UQTO3Eqt5SGnp+GJ7rp7HXWWLrMd2DRyRWnK5Ce
         ihwK58kB//WVwJlwulq6K2okytsYuMse+W04t2/Ex3c8lxLZLK0ObNbtb9UdwL8oZXjc
         2dJGeqnZYuWvr+cHlWHXh3lWW+I3hM8Nso8Vnj0hRFBoafPUvSVZ4ZNXapD20GfHkfKb
         5zYw==
X-Gm-Message-State: APjAAAU8qn2TVScDvJd6E7idzm5xYoIR1Mxy7IrL+Dj1gbn/eI//vsTX
        D9Ke/8fprXceSoHtUYsU+A0=
X-Google-Smtp-Source: APXvYqy2moYHI3H8jYF0wU0NqGZL4UrA8Uf7hmm3srC5oWh8JbHE+l3lNvtt2BTb8vGOlCqm2j0JvA==
X-Received: by 2002:aa7:87c5:: with SMTP id i5mr77854575pfo.20.1555425262597;
        Tue, 16 Apr 2019 07:34:22 -0700 (PDT)
Received: from deepa-ubuntu.lan (c-98-234-52-230.hsd1.ca.comcast.net. [98.234.52.230])
        by smtp.gmail.com with ESMTPSA id r87sm121457716pfa.71.2019.04.16.07.34.21
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 16 Apr 2019 07:34:22 -0700 (PDT)
From:   Deepa Dinamani <deepa.kernel@gmail.com>
To:     arnd@arndb.de
Cc:     "Theodore Ts'o" <tytso@mit.edu>,
        Andreas Dilger <adilger.kernel@dilger.ca>,
        linux-ext4@vger.kernel.org
Subject: [PATCH 2/4] ext4: Initialize timestamps limits
Date:   Tue, 16 Apr 2019 07:34:14 -0700
Message-Id: <20190416143416.3856-2-deepa.kernel@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190416143416.3856-1-deepa.kernel@gmail.com>
References: <20190416143416.3856-1-deepa.kernel@gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org

ext4 has different overflow limits for max filesystem
timestamps based on the extra bytes available.

The timestamp limits are calculated according to the
encoding table in
a4dad1ae24f85i(ext4: Fix handling of extended tv_sec):

* extra  msb of                         adjust for signed
* epoch  32-bit                         32-bit tv_sec to
* bits   time    decoded 64-bit tv_sec  64-bit tv_sec      valid time range
* 0 0    1    -0x80000000..-0x00000001  0x000000000   1901-12-13..1969-12-31
* 0 0    0    0x000000000..0x07fffffff  0x000000000   1970-01-01..2038-01-19
* 0 1    1    0x080000000..0x0ffffffff  0x100000000   2038-01-19..2106-02-07
* 0 1    0    0x100000000..0x17fffffff  0x100000000   2106-02-07..2174-02-25
* 1 0    1    0x180000000..0x1ffffffff  0x200000000   2174-02-25..2242-03-16
* 1 0    0    0x200000000..0x27fffffff  0x200000000   2242-03-16..2310-04-04
* 1 1    1    0x280000000..0x2ffffffff  0x300000000   2310-04-04..2378-04-22
* 1 1    0    0x300000000..0x37fffffff  0x300000000   2378-04-22..2446-05-10

Note that the time limits are not correct for deletion times.

Signed-off-by: Deepa Dinamani <deepa.kernel@gmail.com>
Cc: "Theodore Ts'o" <tytso@mit.edu>
Cc: Andreas Dilger <adilger.kernel@dilger.ca>
Cc: linux-ext4@vger.kernel.org
---
 fs/ext4/ext4.h  |  4 ++++
 fs/ext4/super.c | 16 ++++++++++++++--
 2 files changed, 18 insertions(+), 2 deletions(-)

diff --git a/fs/ext4/ext4.h b/fs/ext4/ext4.h
index 82ffdacdc7fa..2bec3eb15d08 100644
--- a/fs/ext4/ext4.h
+++ b/fs/ext4/ext4.h
@@ -1617,6 +1617,10 @@ static inline void ext4_clear_state_flags(struct ext4_inode_info *ei)
 
 #define EXT4_GOOD_OLD_INODE_SIZE 128
 
+#define EXT4_EXTRA_TIMESTAMP_MAX	(((s64)1 << 34) - 1  + S32_MIN)
+#define EXT4_NON_EXTRA_TIMESTAMP_MAX	S32_MAX
+#define EXT4_TIMESTAMP_MIN		S32_MIN
+
 /*
  * Feature set definitions
  */
diff --git a/fs/ext4/super.c b/fs/ext4/super.c
index f5b828bf1299..3a63a23219a8 100644
--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -3930,8 +3930,20 @@ static int ext4_fill_super(struct super_block *sb, void *data, int silent)
 			       sbi->s_inode_size);
 			goto failed_mount;
 		}
-		if (sbi->s_inode_size > EXT4_GOOD_OLD_INODE_SIZE)
-			sb->s_time_gran = 1 << (EXT4_EPOCH_BITS - 2);
+		/* i_atime_extra is the last extra field available for [acm]times in
+		 * struct ext4_inode. Checking for that field should suffice to ensure
+		 * we have extra spaces for all three.
+		 */
+		if (sbi->s_inode_size >= offsetof(struct ext4_inode, i_atime_extra) +
+			sizeof(((struct ext4_inode *)0)->i_atime_extra)) {
+			sb->s_time_gran = 1;
+			sb->s_time_max = EXT4_EXTRA_TIMESTAMP_MAX;
+		} else {
+			sb->s_time_gran = 0;
+			sb->s_time_max = EXT4_NON_EXTRA_TIMESTAMP_MAX;
+		}
+
+		sb->s_time_min = EXT4_TIMESTAMP_MIN;
 	}
 
 	sbi->s_desc_size = le16_to_cpu(es->s_desc_size);
-- 
2.17.1

