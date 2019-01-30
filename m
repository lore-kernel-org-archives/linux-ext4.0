Return-Path: <SRS0=D/JD=QG=vger.kernel.org=linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8B335C282D5
	for <linux-ext4@archiver.kernel.org>; Wed, 30 Jan 2019 06:46:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 63CAF20989
	for <linux-ext4@archiver.kernel.org>; Wed, 30 Jan 2019 06:46:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728798AbfA3GqB (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Wed, 30 Jan 2019 01:46:01 -0500
Received: from szxga05-in.huawei.com ([45.249.212.191]:3240 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727620AbfA3GqB (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Wed, 30 Jan 2019 01:46:01 -0500
Received: from DGGEMS402-HUB.china.huawei.com (unknown [172.30.72.59])
        by Forcepoint Email with ESMTP id BB88A35543C9B57A2B40;
        Wed, 30 Jan 2019 14:45:58 +0800 (CST)
Received: from huawei.com (10.90.53.225) by DGGEMS402-HUB.china.huawei.com
 (10.3.19.202) with Microsoft SMTP Server id 14.3.408.0; Wed, 30 Jan 2019
 14:45:51 +0800
From:   "zhangyi (F)" <yi.zhang@huawei.com>
To:     <linux-ext4@vger.kernel.org>
CC:     <tytso@mit.edu>, <jack@suse.cz>, <adilger.kernel@dilger.ca>,
        <yi.zhang@huawei.com>, <miaoxie@huawei.com>
Subject: [PATCH v4 0/4] ext4: fix a data corruption problem
Date:   Wed, 30 Jan 2019 14:49:36 +0800
Message-ID: <1548830980-29482-1-git-send-email-yi.zhang@huawei.com>
X-Mailer: git-send-email 2.7.4
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.90.53.225]
X-CFilter-Loop: Reflected
Sender: linux-ext4-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org

Hi:

This patch set is the forth version that want to fix a data corruption
problem. I have already fix all review comments from Jan Kara and tested
by xfstests.

Thanks,
Yi.

----------

Changes since v3:
 - Make the comment more readable in the first two patches.
 - Remove the unneeded __jbd2_journal_temp_unlink_buffer calls.
 - Add the Reviewed-by signature.

Changes since v2:
 - Change the commit log and comments in the first patch.
 - Add the three cleanup patches to remove all clean_bdev_aliases() calls
   and change the return value of ext4_ext_convert_to_initialized().

zhangyi (F) (4):
  jbd2: make sure dirty flag is cleared while revorking a buffer which
    belongs to older transaction
  jbd2: discard dirty data when forgetting an un-journalled buffer
  ext4: cleanup clean_bdev_aliases() calls
  ext4: convert ext4_split_extent() to return requested length

 fs/ext4/extents.c     | 26 +++++++----------------
 fs/ext4/inode.c       |  7 ------
 fs/ext4/page-io.c     |  4 +---
 fs/jbd2/transaction.c | 59 +++++++++++++++++++++++++++++++++++++++++++--------
 4 files changed, 59 insertions(+), 37 deletions(-)

-- 
2.7.4

