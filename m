Return-Path: <linux-ext4-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C0718C6FA99
	for <linux-ext4@archiver.kernel.org>; Fri, 10 Mar 2023 12:52:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230237AbjCJMw6 (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Fri, 10 Mar 2023 07:52:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41952 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230104AbjCJMwz (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Fri, 10 Mar 2023 07:52:55 -0500
Received: from szxga02-in.huawei.com (szxga02-in.huawei.com [45.249.212.188])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 479DE10D773;
        Fri, 10 Mar 2023 04:52:52 -0800 (PST)
Received: from kwepemm600013.china.huawei.com (unknown [172.30.72.53])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4PY5VG3Kb4zSkkd;
        Fri, 10 Mar 2023 20:49:42 +0800 (CST)
Received: from huawei.com (10.175.127.227) by kwepemm600013.china.huawei.com
 (7.193.23.68) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.21; Fri, 10 Mar
 2023 20:52:49 +0800
From:   Zhihao Cheng <chengzhihao1@huawei.com>
To:     <tytso@mit.edu>, <adilger.kernel@dilger.ca>, <jack@suse.com>
CC:     <linux-ext4@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <chengzhihao1@huawei.com>, <yi.zhang@huawei.com>
Subject: [PATCH 0/5] ext4: Fix stale buffer loading from last failed
Date:   Fri, 10 Mar 2023 20:52:01 +0800
Message-ID: <20230310125206.2867822-1-chengzhihao1@huawei.com>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.175.127.227]
X-ClientProxiedBy: dggems704-chm.china.huawei.com (10.3.19.181) To
 kwepemm600013.china.huawei.com (7.193.23.68)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org

Patch 1 fixes reusing stale buffer heads from last failed mounting.
Patch 2~4 reconstructs 'j_format_version' initialization and checking
in loading process.

Zhang Yi (4):
  jbd2: remove unused feature macros
  jbd2: switch to check format version in superblock directly
  jbd2: factor out journal initialization from journal_get_superblock()
  jbd2: remove j_format_version

Zhihao Cheng (1):
  ext4: Fix reusing stale buffer heads from last failed mounting

 fs/ext4/super.c      | 15 +++++------
 fs/jbd2/journal.c    | 59 +++++++++++++++-----------------------------
 include/linux/jbd2.h | 33 +++++++++++--------------
 3 files changed, 42 insertions(+), 65 deletions(-)

-- 
2.31.1

