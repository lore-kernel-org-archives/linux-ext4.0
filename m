Return-Path: <SRS0=QTyG=PS=vger.kernel.org=linux-ext4-owner@kernel.org>
Received: from szxga04-in.huawei.com ([45.249.212.190]:17102 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727276AbfAJGDK (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Thu, 10 Jan 2019 01:03:10 -0500
From: "zhangyi (F)" <yi.zhang@huawei.com>
To: <linux-ext4@vger.kernel.org>
CC: <tytso@mit.edu>, <adilger.kernel@dilger.ca>, <jack@suse.cz>,
        <miaoxie@huawei.com>, <yi.zhang@huawei.com>
Subject: [PATCH 0/2] ext4: fix two compile problems
Date: Thu, 10 Jan 2019 14:06:37 +0800
Message-ID: <1547100399-127915-1-git-send-email-yi.zhang@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi,

Found two compile problems when using JBUFFER_TRACE and BUFFER_TRACE.

The first patch fix two compile warnings when enabling JBUFFER_TRACE,
and the second patch fix a compile error when enabling BUFFER_TRACE.
Please review.

Thanks,
Yi.

zhangyi (F) (2):
  jbd2: fix compile warning when using JBUFFER_TRACE
  ext4: fix compile error when using BUFFER_TRACE

 fs/ext4/inode.c       |  2 +-
 fs/jbd2/transaction.c | 16 ++++++++--------
 2 files changed, 9 insertions(+), 9 deletions(-)

-- 
2.7.4
