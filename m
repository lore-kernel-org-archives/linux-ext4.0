Return-Path: <linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AA8D3ECAAD4
	for <linux-ext4@archiver.kernel.org>; Tue, 30 Aug 2022 11:53:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229874AbiH3LxE (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Tue, 30 Aug 2022 07:53:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50972 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229635AbiH3LxD (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Tue, 30 Aug 2022 07:53:03 -0400
Received: from szxga08-in.huawei.com (szxga08-in.huawei.com [45.249.212.255])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7B87A9A98C
        for <linux-ext4@vger.kernel.org>; Tue, 30 Aug 2022 04:53:02 -0700 (PDT)
Received: from canpemm500004.china.huawei.com (unknown [172.30.72.53])
        by szxga08-in.huawei.com (SkyGuard) with ESMTP id 4MH5FG6YfFz1N7gV;
        Tue, 30 Aug 2022 19:49:22 +0800 (CST)
Received: from huawei.com (10.175.127.227) by canpemm500004.china.huawei.com
 (7.192.104.92) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.24; Tue, 30 Aug
 2022 19:52:59 +0800
From:   Jason Yan <yanaijie@huawei.com>
To:     <tytso@mit.edu>, <adilger.kernel@dilger.ca>, <jack@suse.cz>,
        <ritesh.list@gmail.com>, <lczerner@redhat.com>,
        <linux-ext4@vger.kernel.org>
CC:     Jason Yan <yanaijie@huawei.com>
Subject: [PATCH 00/13] some refactor of __ext4_fill_super()
Date:   Tue, 30 Aug 2022 20:03:58 +0800
Message-ID: <20220830120411.2371968-1-yanaijie@huawei.com>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.175.127.227]
X-ClientProxiedBy: dggems702-chm.china.huawei.com (10.3.19.179) To
 canpemm500004.china.huawei.com (7.192.104.92)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org

This function is maybe the longest function I have seen in the kernel.
It has more than one thousand lines. This makes us not easy to read and
understand the code. So I made some refactors. The first two patches did
some preparation to the goto labels so that we can factor out some
functions easily.

After this refactor this function is about 500 lines shorter. I did not
go further because I'm not sure if people like this kind of change. If
there is any bad side effects, please let me know. If you strongly
dislike it, I am ok to stop this refactor.

Thansk.

Jason Yan (13):
  ext4: goto right label 'failed_mount3a'
  ext4: remove cantfind_ext4 error handler
  ext4: factor out ext4_set_def_opts()
  ext4: factor out ext4_handle_clustersize()
  ext4: factor out ext4_fast_commit_init()
  ext4: factor out ext4_inode_info_init()
  ext4: factor out ext4_encoding_init()
  ext4: factor out ext4_handle_csum()
  ext4: factor out ext4_compat_feature_check()
  ext4: factor out ext4_geometry_check()
  ext4: factor out ext4_group_desc_init() and ext4_group_desc_free()
  ext4: factor out ext4_load_and_init_journal()
  ext4: factor out ext4_journal_data_check()

 fs/ext4/super.c | 1070 ++++++++++++++++++++++++++---------------------
 1 file changed, 599 insertions(+), 471 deletions(-)

-- 
2.31.1

