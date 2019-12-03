Return-Path: <SRS0=K1lC=ZZ=vger.kernel.org=linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 63DD6C33C9A
	for <linux-ext4@archiver.kernel.org>; Tue,  3 Dec 2019 09:06:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 460082068E
	for <linux-ext4@archiver.kernel.org>; Tue,  3 Dec 2019 09:06:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726139AbfLCJGz (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Tue, 3 Dec 2019 04:06:55 -0500
Received: from szxga07-in.huawei.com ([45.249.212.35]:32968 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725773AbfLCJGy (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Tue, 3 Dec 2019 04:06:54 -0500
Received: from DGGEMS411-HUB.china.huawei.com (unknown [172.30.72.59])
        by Forcepoint Email with ESMTP id D6BCE349C0354685C63D;
        Tue,  3 Dec 2019 17:06:52 +0800 (CST)
Received: from huawei.com (10.175.124.28) by DGGEMS411-HUB.china.huawei.com
 (10.3.19.211) with Microsoft SMTP Server id 14.3.439.0; Tue, 3 Dec 2019
 17:06:44 +0800
From:   "zhangyi (F)" <yi.zhang@huawei.com>
To:     <linux-ext4@vger.kernel.org>
CC:     <jack@suse.com>, <tytso@mit.edu>, <adilger.kernel@dilger.ca>,
        <yi.zhang@huawei.com>, <liangyun2@huawei.com>,
        <luoshijie1@huawei.com>
Subject: [PATCH v2 0/4] ext4, jbd2: improve aborting progress
Date:   Tue, 3 Dec 2019 17:27:52 +0800
Message-ID: <20191203092756.26129-1-yi.zhang@huawei.com>
X-Mailer: git-send-email 2.17.2
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.175.124.28]
X-CFilter-Loop: Reflected
Sender: linux-ext4-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org

Hi,

This series originally aim to fix ext4_handle_error() and ext4_abort()
cannot panic because of we invoke __jbd2_journal_abort_hard() when we
failed to submit commit record without setting JBD2_REC_ERR flag.

I add patch 1 and patch 4 to switch to use jbd2_journal_abort() and do
some cleanup job at this iteration as Jan suggested. I also add patch 3
to partially revert commit 818d276ceb8 "ext4: Add the journal checksum
feature" because it seems unnecessary, but I am not quite sure. please
revirew this series and give some suggestions.

Thanks,
Yi.

zhangyi (F) (4):
  jbd2: switch to use jbd2_journal_abort() when failed to submit the
    commit record
  ext4, jbd2: ensure panic when journal aborting with zero errno
  Partially revert "ext4: pass -ESHUTDOWN code to jbd2 layer"
  jbd2: clean __jbd2_journal_abort_hard() and __journal_abort_soft()

 fs/ext4/ioctl.c      |   4 +-
 fs/ext4/super.c      |   4 +-
 fs/jbd2/commit.c     |   4 +-
 fs/jbd2/journal.c    | 108 +++++++++++++++----------------------------
 include/linux/jbd2.h |   4 +-
 5 files changed, 45 insertions(+), 79 deletions(-)

-- 
2.17.2

