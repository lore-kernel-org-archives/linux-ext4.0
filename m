Return-Path: <linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6F120C04A95
	for <linux-ext4@archiver.kernel.org>; Mon, 26 Sep 2022 02:20:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232377AbiIZCU1 (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Sun, 25 Sep 2022 22:20:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41848 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231176AbiIZCU0 (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Sun, 25 Sep 2022 22:20:26 -0400
Received: from szxga02-in.huawei.com (szxga02-in.huawei.com [45.249.212.188])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 31EAD2529A
        for <linux-ext4@vger.kernel.org>; Sun, 25 Sep 2022 19:20:24 -0700 (PDT)
Received: from canpemm500008.china.huawei.com (unknown [172.30.72.54])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4MbRFb6DL0zWgtX;
        Mon, 26 Sep 2022 10:16:19 +0800 (CST)
Received: from huawei.com (10.175.124.27) by canpemm500008.china.huawei.com
 (7.192.105.151) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.31; Mon, 26 Sep
 2022 10:20:22 +0800
From:   Li Jinlin <lijinlin3@huawei.com>
To:     <lijinlin3@huawei.com>
CC:     <adilger@whamcloud.com>, <linfeilong@huawei.com>,
        <linux-ext4@vger.kernel.org>, <liuzhiqiang26@huawei.com>,
        <tytso@mit.edu>
Subject: Re: [PATCH] tune2fs: exit directly when fs freed in ext2fs_run_ext3_journal
Date:   Mon, 26 Sep 2022 17:46:49 +0800
Message-ID: <20220926094649.1784658-1-lijinlin3@huawei.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220916074223.8885-1-lijinlin3@huawei.com>
References: <20220916074223.8885-1-lijinlin3@huawei.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.175.124.27]
X-ClientProxiedBy: dggems705-chm.china.huawei.com (10.3.19.182) To
 canpemm500008.china.huawei.com (7.192.105.151)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org

friendly ping ...

Thanks,
Jinlin
