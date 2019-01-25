Return-Path: <SRS0=p9Mw=QB=vger.kernel.org=linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 62E59C282C6
	for <linux-ext4@archiver.kernel.org>; Fri, 25 Jan 2019 12:27:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 325532085B
	for <linux-ext4@archiver.kernel.org>; Fri, 25 Jan 2019 12:27:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727665AbfAYM1V (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Fri, 25 Jan 2019 07:27:21 -0500
Received: from szxga07-in.huawei.com ([45.249.212.35]:36098 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726111AbfAYM1V (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Fri, 25 Jan 2019 07:27:21 -0500
Received: from DGGEMS411-HUB.china.huawei.com (unknown [172.30.72.58])
        by Forcepoint Email with ESMTP id CCAF72AE8BF7EBAFDBA3;
        Fri, 25 Jan 2019 20:27:19 +0800 (CST)
Received: from huawei.com (10.90.53.225) by DGGEMS411-HUB.china.huawei.com
 (10.3.19.211) with Microsoft SMTP Server id 14.3.408.0; Fri, 25 Jan 2019
 20:27:10 +0800
From:   "zhangyi (F)" <yi.zhang@huawei.com>
To:     <linux-ext4@vger.kernel.org>
CC:     <tytso@mit.edu>, <jack@suse.cz>, <adilger.kernel@dilger.ca>,
        <yi.zhang@huawei.com>, <miaoxie@huawei.com>
Subject: [PATCH v3 0/4] ext4: fix a data corruption problem
Date:   Fri, 25 Jan 2019 20:30:52 +0800
Message-ID: <1548419456-4331-1-git-send-email-yi.zhang@huawei.com>
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

This patch set is the third version which want to fix a data corruption,
have been testd by xfstests.

 - The first patch fix the data corruption problem we captured. The root
   case is that we forgot to clear dirty flag when revorking a buffer
   belongs to older transaction.
 - The second and third patches are cleanup patches which remove
   clean_bdev_aliases() related calls and move the logic to
   jbd2_journal_forget() when forgetting metadata (suggested by Jan Kara).
 - The last patch change the return value of ext4_ext_convert_to_initialized().

Please review.

Thanks,
Yi.

----------

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

 fs/ext4/extents.c     | 26 +++++++---------------
 fs/ext4/inode.c       |  7 ------
 fs/ext4/page-io.c     |  4 +---
 fs/jbd2/transaction.c | 60 +++++++++++++++++++++++++++++++++++++++++++--------
 4 files changed, 60 insertions(+), 37 deletions(-)

-- 
2.7.4

