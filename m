Return-Path: <linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 72A8AC43334
	for <linux-ext4@archiver.kernel.org>; Wed, 15 Jun 2022 03:54:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353478AbiFODys (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Tue, 14 Jun 2022 23:54:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36046 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1353734AbiFODyI (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Tue, 14 Jun 2022 23:54:08 -0400
Received: from szxga01-in.huawei.com (szxga01-in.huawei.com [45.249.212.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 058871178;
        Tue, 14 Jun 2022 20:53:36 -0700 (PDT)
Received: from dggpeml500021.china.huawei.com (unknown [172.30.72.56])
        by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4LNBG62YRJzjYB3;
        Wed, 15 Jun 2022 11:52:30 +0800 (CST)
Received: from huawei.com (10.175.127.227) by dggpeml500021.china.huawei.com
 (7.185.36.21) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.24; Wed, 15 Jun
 2022 11:53:34 +0800
From:   Baokun Li <libaokun1@huawei.com>
To:     <linux-ext4@vger.kernel.org>
CC:     <tytso@mit.edu>, <adilger.kernel@dilger.ca>, <jack@suse.cz>,
        <ritesh.list@gmail.com>, <lczerner@redhat.com>,
        <enwlinux@gmail.com>, <linux-kernel@vger.kernel.org>,
        <yi.zhang@huawei.com>, <yebin10@huawei.com>, <yukuai3@huawei.com>,
        <libaokun1@huawei.com>
Subject: [PATCH v2 0/4] ext4: fix use-after-free in ext4_xattr_set_entry
Date:   Wed, 15 Jun 2022 12:06:26 +0800
Message-ID: <20220615040630.808783-1-libaokun1@huawei.com>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.175.127.227]
X-ClientProxiedBy: dggems705-chm.china.huawei.com (10.3.19.182) To
 dggpeml500021.china.huawei.com (7.185.36.21)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org

This series adds a macro for whether there is space for xattr in
ext4 inode, and fixes some problems with this macro.

V1->V2:
	Split the patch to make the logic clearer.
	Rename macro to EXT4_INODE_HAVE_XATTR_SPACE.

Baokun Li (4):
  ext4: add EXT4_INODE_HAVE_XATTR_SPACE macro in xattr.h
  ext4: fix use-after-free in ext4_xattr_set_entry
  ext4: correct max_inline_xattr_value_size computing
  ext4: correct the misjudgment in ext4_iget_extra_inode

 fs/ext4/inline.c |  3 +++
 fs/ext4/inode.c  |  3 +--
 fs/ext4/xattr.c  |  6 ++++--
 fs/ext4/xattr.h  | 13 +++++++++++++
 4 files changed, 21 insertions(+), 4 deletions(-)

-- 
2.31.1

