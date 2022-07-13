Return-Path: <linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DB631C43334
	for <linux-ext4@archiver.kernel.org>; Wed, 13 Jul 2022 09:16:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235636AbiGMJQu (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Wed, 13 Jul 2022 05:16:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32772 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235030AbiGMJQn (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Wed, 13 Jul 2022 05:16:43 -0400
Received: from szxga03-in.huawei.com (szxga03-in.huawei.com [45.249.212.189])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DC187EF9C2;
        Wed, 13 Jul 2022 02:16:39 -0700 (PDT)
Received: from dggemv703-chm.china.huawei.com (unknown [172.30.72.56])
        by szxga03-in.huawei.com (SkyGuard) with ESMTP id 4LjX655FtjzFpy3;
        Wed, 13 Jul 2022 17:15:41 +0800 (CST)
Received: from kwepemm600010.china.huawei.com (7.193.23.86) by
 dggemv703-chm.china.huawei.com (10.3.19.46) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.24; Wed, 13 Jul 2022 17:16:37 +0800
Received: from huawei.com (10.175.127.227) by kwepemm600010.china.huawei.com
 (7.193.23.86) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.24; Wed, 13 Jul
 2022 17:16:36 +0800
From:   Sun Ke <sunke32@huawei.com>
To:     <fstests@vger.kernel.org>
CC:     <zlang@kernel.org>, <linux-ext4@vger.kernel.org>,
        <sunke32@huawei.com>
Subject: [PATCH v3 0/2] two regression tests for ext4
Date:   Wed, 13 Jul 2022 17:28:57 +0800
Message-ID: <20220713092859.3881376-1-sunke32@huawei.com>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.175.127.227]
X-ClientProxiedBy: dggems706-chm.china.huawei.com (10.3.19.183) To
 kwepemm600010.china.huawei.com (7.193.23.86)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org

two regression tests for ext4

Sun Ke (2):
  ext4: resize fs after resize_inode without e2fsck
  ext4: set 256 blocks in a block group then apply io pressure

 tests/ext4/057     | 44 ++++++++++++++++++++++++++++++++++++++++++++
 tests/ext4/057.out |  3 +++
 tests/ext4/058     | 33 +++++++++++++++++++++++++++++++++
 tests/ext4/058.out |  2 ++
 4 files changed, 82 insertions(+)
 create mode 100755 tests/ext4/057
 create mode 100644 tests/ext4/057.out
 create mode 100755 tests/ext4/058
 create mode 100644 tests/ext4/058.out

-- 
2.13.6

