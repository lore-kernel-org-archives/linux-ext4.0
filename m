Return-Path: <linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 00021C4338F
	for <linux-ext4@archiver.kernel.org>; Thu, 19 Aug 2021 06:46:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C9312610E5
	for <linux-ext4@archiver.kernel.org>; Thu, 19 Aug 2021 06:46:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231336AbhHSGrM (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Thu, 19 Aug 2021 02:47:12 -0400
Received: from szxga08-in.huawei.com ([45.249.212.255]:14232 "EHLO
        szxga08-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230483AbhHSGrM (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Thu, 19 Aug 2021 02:47:12 -0400
Received: from dggeme752-chm.china.huawei.com (unknown [172.30.72.56])
        by szxga08-in.huawei.com (SkyGuard) with ESMTP id 4GqwJx2Msyz1CYQg;
        Thu, 19 Aug 2021 14:46:09 +0800 (CST)
Received: from huawei.com (10.175.127.227) by dggeme752-chm.china.huawei.com
 (10.3.19.98) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2176.2; Thu, 19
 Aug 2021 14:46:34 +0800
From:   Zhang Yi <yi.zhang@huawei.com>
To:     <linux-ext4@vger.kernel.org>
CC:     <tytso@mit.edu>, <adilger.kernel@dilger.ca>, <jack@suse.cz>,
        <yi.zhang@huawei.com>, <yukuai3@huawei.com>
Subject: [PATCH v2 0/4] ext4: fix a inode checksum error
Date:   Thu, 19 Aug 2021 14:57:00 +0800
Message-ID: <20210819065704.1248402-1-yi.zhang@huawei.com>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.175.127.227]
X-ClientProxiedBy: dggems704-chm.china.huawei.com (10.3.19.181) To
 dggeme752-chm.china.huawei.com (10.3.19.98)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org

We find a checksum error and a inode corruption problem while doing
stress test, this 4 patches address to fix them. The first patch is
relate to the error simulation, and the second & third patch are
prepare to do the fix. The last patch fix these two issue.

 - Checksum error

    EXT4-fs error (device sda): ext4_lookup:1784: inode #131074: comm cat: iget: checksum invalid

 - Inode corruption

    e2fsck 1.46.0 (29-Jan-2020)
    Pass 1: Checking inodes, blocks, and sizes
    Pass 2: Checking directory structure
    Entry 'foo' in / (2) has deleted/unused inode 17.  Clear<y>? yes
    Pass 3: Checking directory connectivity
    Pass 4: Checking reference counts
    Pass 5: Checking group summary information
    Inode bitmap differences:  -17
    Fix<y>? yes
    Free inodes count wrong for group #0 (32750, counted=32751).
    Fix<y>? yes
    Free inodes count wrong (32750, counted=32751).
    Fix<y>? yes

Change since v1:
 - Add a patch to prevent ext4_do_update_inode() return before filling
   the inode buffer.
 - Do not use BH_New flag to indicate the empty buffer, postpone the
   zero and uptodate logic into ext4_do_update_inode() before filling
   the inode buffer.

Thanks,
Yi.


Zhang Yi (4):
  ext4: move inode eio simulation behind io completeion
  ext4: remove an unnecessary if statement in __ext4_get_inode_loc()
  ext4: don't return error if huge_file feature mismatch
  ext4: prevent getting empty inode buffer

 fs/ext4/inode.c | 206 +++++++++++++++++++++++++-----------------------
 1 file changed, 109 insertions(+), 97 deletions(-)

-- 
2.31.1

