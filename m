Return-Path: <linux-ext4-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5A2EDC77B60
	for <linux-ext4@archiver.kernel.org>; Fri, 28 Apr 2023 03:16:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345057AbjD1DQp (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Thu, 27 Apr 2023 23:16:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53276 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345046AbjD1DQf (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Thu, 27 Apr 2023 23:16:35 -0400
Received: from outgoing.mit.edu (outgoing-auth-1.mit.edu [18.9.28.11])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 23D003A88
        for <linux-ext4@vger.kernel.org>; Thu, 27 Apr 2023 20:16:34 -0700 (PDT)
Received: from cwcc.thunk.org (pool-173-48-120-46.bstnma.fios.verizon.net [173.48.120.46])
        (authenticated bits=0)
        (User authenticated as tytso@ATHENA.MIT.EDU)
        by outgoing.mit.edu (8.14.7/8.12.4) with ESMTP id 33S3GHK9012406
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 27 Apr 2023 23:16:18 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=mit.edu; s=outgoing;
        t=1682651779; bh=+qkRyg5P9f/YwoBtaTsIpadPVUlpTuKfHUHDodu4vLA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References;
        b=b5+qsvP+DUXvs6zvt8oXN5CLRiMJnFl3zR4IBCHe2uypv61uSfgoGCJTMe+qvz38Z
         HKI9lpcryTXvsX5RflvZsbrNKphgghOXtZcrG13aXwIMdvPBdXStbSnIaPg0ze6xNx
         Hu92vQtlQz4WGtIL2/XUF8MAG+0z53If+jqbhmj7/+rjOMHTwQ0jD5O9Pj2CCMQh1e
         jxkQpAkgcaeMDZXo1kUqOoKu8HUNzlblCTdFPYYwnQR9D/ZjbjEBnA/IAqVjxJ4UdG
         eSTBjjjA1MOieqh8O9KFDJyKust8WaIO+ULNradTxX5gBhpDeH9ErxeCSW5jWxcQeM
         UWsUcrSEsfLTA==
Received: by cwcc.thunk.org (Postfix, from userid 15806)
        id 5149215C3AC5; Thu, 27 Apr 2023 23:16:17 -0400 (EDT)
From:   "Theodore Ts'o" <tytso@mit.edu>
To:     Ext4 Developers List <linux-ext4@vger.kernel.org>
Cc:     Andreas Dilger <adilger@dilger.ca>,
        Jason Yan <yanaijie@huawei.com>,
        "Theodore Ts'o" <tytso@mit.edu>,
        syzbot+bbf0f9a213c94f283a5c@syzkaller.appspotmail.com
Subject: [PATCH 1/3] ext4: fix lost error code reporting in __ext4_fill_super()
Date:   Thu, 27 Apr 2023 23:16:00 -0400
Message-Id: <20230428031602.242297-2-tytso@mit.edu>
X-Mailer: git-send-email 2.31.0
In-Reply-To: <20230428031602.242297-1-tytso@mit.edu>
References: <20230428031602.242297-1-tytso@mit.edu>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org

When code was factored out of __ext4_fill_super() into
ext4_percpu_param_init() the error return was discard.  This meant
that it was possible for __ext4_fill_super() to return zero,
indicating success, without the struct super getting completely filled
in, leading to a potential NULL pointer dereference.

Reported-by: syzbot+bbf0f9a213c94f283a5c@syzkaller.appspotmail.com
Fixes: 1f79467c8a6b ("ext4: factor out ext4_percpu_param_init() ...")
Cc: Jason Yan <yanaijie@huawei.com>
Link: https://syzkaller.appspot.com/bug?id=6dac47d5e58af770c0055f680369586ec32e144c
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
---
 fs/ext4/super.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/fs/ext4/super.c b/fs/ext4/super.c
index 403cc0e6cd65..b11907e1fab2 100644
--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -5503,7 +5503,8 @@ static int __ext4_fill_super(struct fs_context *fc, struct super_block *sb)
 		sbi->s_journal->j_commit_callback =
 			ext4_journal_commit_callback;
 
-	if (ext4_percpu_param_init(sbi))
+	err = ext4_percpu_param_init(sbi);
+	if (err)
 		goto failed_mount6;
 
 	if (ext4_has_feature_flex_bg(sb))
-- 
2.31.0

