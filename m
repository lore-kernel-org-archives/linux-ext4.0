Return-Path: <linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F205DECAAD3
	for <linux-ext4@archiver.kernel.org>; Sat, 17 Sep 2022 09:27:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229550AbiIQJ1R (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Sat, 17 Sep 2022 05:27:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45738 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229471AbiIQJ1Q (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Sat, 17 Sep 2022 05:27:16 -0400
Received: from szxga08-in.huawei.com (szxga08-in.huawei.com [45.249.212.255])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B6C4A45981;
        Sat, 17 Sep 2022 02:27:14 -0700 (PDT)
Received: from canpemm500010.china.huawei.com (unknown [172.30.72.57])
        by szxga08-in.huawei.com (SkyGuard) with ESMTP id 4MV58G4lZYz14QPC;
        Sat, 17 Sep 2022 17:23:10 +0800 (CST)
Received: from huawei.com (10.175.127.227) by canpemm500010.china.huawei.com
 (7.192.105.118) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.31; Sat, 17 Sep
 2022 17:27:11 +0800
From:   Ye Bin <yebin10@huawei.com>
To:     <tytso@mit.edu>, <adilger.kernel@dilger.ca>,
        <linux-ext4@vger.kernel.org>
CC:     <linux-kernel@vger.kernel.org>, <jack@suse.cz>,
        Ye Bin <yebin10@huawei.com>
Subject: [PATCH -next] jbd2: add miss release buffer head in fc_do_one_pass()
Date:   Sat, 17 Sep 2022 17:38:05 +0800
Message-ID: <20220917093805.1782845-1-yebin10@huawei.com>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.175.127.227]
X-ClientProxiedBy: dggems703-chm.china.huawei.com (10.3.19.180) To
 canpemm500010.china.huawei.com (7.192.105.118)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org

In fc_do_one_pass() miss release buffer head after use which will lead
to reference count leak.

Signed-off-by: Ye Bin <yebin10@huawei.com>
---
 fs/jbd2/recovery.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/fs/jbd2/recovery.c b/fs/jbd2/recovery.c
index 1f878c315b03..8286a9ec122f 100644
--- a/fs/jbd2/recovery.c
+++ b/fs/jbd2/recovery.c
@@ -261,6 +261,7 @@ static int fc_do_one_pass(journal_t *journal,
 		err = journal->j_fc_replay_callback(journal, bh, pass,
 					next_fc_block - journal->j_fc_first,
 					expected_commit_id);
+		brelse(bh);
 		next_fc_block++;
 		if (err < 0 || err == JBD2_FC_REPLAY_STOP)
 			break;
-- 
2.31.1

