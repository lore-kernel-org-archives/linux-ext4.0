Return-Path: <linux-ext4-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8243FEB64DA
	for <linux-ext4@archiver.kernel.org>; Fri, 30 Jun 2023 16:31:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232983AbjF3Qbk (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Fri, 30 Jun 2023 12:31:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41696 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232601AbjF3QbY (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Fri, 30 Jun 2023 12:31:24 -0400
Received: from mail-wm1-x32e.google.com (mail-wm1-x32e.google.com [IPv6:2a00:1450:4864:20::32e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 17B723C2D;
        Fri, 30 Jun 2023 09:30:42 -0700 (PDT)
Received: by mail-wm1-x32e.google.com with SMTP id 5b1f17b1804b1-3fbc587febfso11904305e9.2;
        Fri, 30 Jun 2023 09:30:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1688142635; x=1690734635;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=8AwnYMQCKgvWHKEeqF4b8y7/KfT7y0eWsPAWzULZUOM=;
        b=JI6HEIh4WomaJysav1ufm2uXTOKqRa1rMcOac5mwpwgiGGpjqspwQpQAoPq7FErWqe
         2rg8L/pOjKVjtuX1yyjVaKAcGo6kqUGUPEWFSVESt8nyL3StX+Qc3XTvXvsv0D29guR6
         iDmB2I4DhIeX3w0BH6A+5lY+FO9Mhst0QyRshr/aY4UNFa/mSdN8740yuQ94Yq2+HQ6f
         xfUR5x9YbNe7COYXfbWey7pOaKsS5PabwpbVxPGgjmHWoKanO5YoaqqUKlqm3ibeArA0
         s56t1EWhecboMOQgrUnn77JE8pF7k8m97LFCdhXPQmtlqD8q16jlFphECxSvhWhqUt10
         /PcA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1688142635; x=1690734635;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=8AwnYMQCKgvWHKEeqF4b8y7/KfT7y0eWsPAWzULZUOM=;
        b=O4az+hWQuXaJrFTTbRFgYXD2FtNPgwgG5ObTY37bA3vXKZAgM5SR2g3P6SwI7OZfyw
         b37FISP5SVArDS0+PubTsGRAtchJn5JOWMeqoKW7rPK97DGqt08U3lmHE4XsN0nzs0Ur
         AnPNdkakP2dWRXiQXwEWkbum4Ch5WN2jFF2cpbs4OPaAIL9Kn6FHdNauW/1m+cQBXTVA
         Jt69hED7eMAvKm3BKsUetXCRqLusbDGTj5D26ca+kXixkhj+BH4jmX/Dnqc/HU3EiWk3
         zBUR7DsogI68Id7i/RLs112xmZzZniWdS++6P3pZXvCk3UFn5HlnPF7vQIPmHxGz1rCA
         nR4g==
X-Gm-Message-State: AC+VfDxXV5UCeUuD5IUiHFFwzAo9QDIN07lkqNeYvxePvoQ1WdljhhJX
        tw/uXtZM+clGgboLYbfB/3k=
X-Google-Smtp-Source: ACHHUZ5wDb9cpTmnUOmcrdS5VPP1C/Sighk60M0/m2tWn4veGVTigS5eZjp26qJ5O5DD3cBU+lx0kQ==
X-Received: by 2002:a7b:cb95:0:b0:3fb:b53c:1a32 with SMTP id m21-20020a7bcb95000000b003fbb53c1a32mr2177453wmi.34.1688142634925;
        Fri, 30 Jun 2023 09:30:34 -0700 (PDT)
Received: from localhost (cpc154979-craw9-2-0-cust193.16-3.cable.virginm.net. [80.193.200.194])
        by smtp.gmail.com with ESMTPSA id x19-20020a1c7c13000000b003fbb0c01d4bsm7451834wmc.16.2023.06.30.09.30.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 30 Jun 2023 09:30:34 -0700 (PDT)
From:   Colin Ian King <colin.i.king@gmail.com>
To:     Jan Kara <jack@suse.com>, linux-ext4@vger.kernel.org
Cc:     kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH][next] ext2: remove redundant assignment to variable desc
Date:   Fri, 30 Jun 2023 17:30:33 +0100
Message-Id: <20230630163033.165326-1-colin.i.king@gmail.com>
X-Mailer: git-send-email 2.39.2
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org

Variable desc is being assigned a value that is never read, the exit
via label found immeditely returns with no access to desc. The
assignment is redundant and can be removed. Cleans up clang scan
muild warning:

fs/ext2/ialloc.c:297:4: warning: Value stored to 'desc' is never
read [deadcode.DeadStores]

Signed-off-by: Colin Ian King <colin.i.king@gmail.com>
---
 fs/ext2/ialloc.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/fs/ext2/ialloc.c b/fs/ext2/ialloc.c
index a4e1d7a9c544..f50beb77d6ba 100644
--- a/fs/ext2/ialloc.c
+++ b/fs/ext2/ialloc.c
@@ -294,7 +294,6 @@ static int find_group_orlov(struct super_block *sb, struct inode *parent)
 			best_desc = desc;
 		}
 		if (best_group >= 0) {
-			desc = best_desc;
 			group = best_group;
 			goto found;
 		}
-- 
2.39.2

