Return-Path: <linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E83D0C433EF
	for <linux-ext4@archiver.kernel.org>; Mon,  6 Sep 2021 14:37:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C96AF60232
	for <linux-ext4@archiver.kernel.org>; Mon,  6 Sep 2021 14:37:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243549AbhIFOi5 (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Mon, 6 Sep 2021 10:38:57 -0400
Received: from szxga03-in.huawei.com ([45.249.212.189]:15297 "EHLO
        szxga03-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243274AbhIFOi4 (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Mon, 6 Sep 2021 10:38:56 -0400
Received: from dggeme754-chm.china.huawei.com (unknown [172.30.72.53])
        by szxga03-in.huawei.com (SkyGuard) with ESMTP id 4H39wK5dZbz8snj;
        Mon,  6 Sep 2021 22:37:21 +0800 (CST)
Received: from huawei.com (10.175.127.227) by dggeme754-chm.china.huawei.com
 (10.3.19.100) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2308.8; Mon, 6 Sep
 2021 22:37:49 +0800
From:   Ye Bin <yebin10@huawei.com>
To:     <tytso@mit.edu>, <adilger.kernel@dilger.ca>,
        <linux-ext4@vger.kernel.org>
CC:     <linux-kernel@vger.kernel.org>, <jack@suse.cz>,
        Ye Bin <yebin10@huawei.com>
Subject: [PATCH -next 0/6] Fix some issues about mmp
Date:   Mon, 6 Sep 2021 22:47:48 +0800
Message-ID: <20210906144754.2601607-1-yebin10@huawei.com>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.175.127.227]
X-ClientProxiedBy: dggems705-chm.china.huawei.com (10.3.19.182) To
 dggeme754-chm.china.huawei.com (10.3.19.100)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org

I test mmp function as follow steps:
1. Inject delay 5s in ext4_multi_mount_protect function after
"skip:" label.
2. Share HostA block device(sda) with HostB(nbd0) by NBD.
3. Enable mmp feature when mkfs.ext4 sda.
4. Mount sda and nbd0 at the same time.

I found kmmpd never trigger detect multi-mount. Reason is as follow:
1. Kmmpd init seq with 0, if two host have same nodename, will lead to
detect confliction very slow, even never detect confliction.
2. When detect confliction in kmmpd, we get 'check_bh' is same with 'bh'.
so we compare data with itself.
3. We only trigger detect when ”diff > mmp_check_interval * HZ“,
'mmp_check_interval' is double of 'mmp_update_interval', 'diff' is
about 'mmp_update_interval'. So 'diff' is little than 'mmp_check_interval * HZ'
normaly.

And i also found that 'check_interval' value store in disk  is not sure
after umount.

Ye Bin (6):
  ext4: init seq with random value in kmmpd
  ext4: introduce last_check_time record previous check time
  ext4: compare to local seq and nodename when check conflict
  ext4: avoid to re-read mmp check data get from page cache
  ext4: avoid to double free s_mmp_bh
  ext4: fix possible store wrong check interval value in disk when
    umount

 fs/ext4/mmp.c | 77 ++++++++++++++++++++++++++++-----------------------
 1 file changed, 43 insertions(+), 34 deletions(-)

-- 
2.31.1

