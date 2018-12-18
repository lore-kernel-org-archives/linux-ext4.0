Return-Path: <SRS0=0j4F=O3=vger.kernel.org=linux-ext4-owner@kernel.org>
Received: from szxga04-in.huawei.com ([45.249.212.190]:16599 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726556AbeLROAh (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Tue, 18 Dec 2018 09:00:37 -0500
From: "zhangyi (F)" <yi.zhang@huawei.com>
To: <linux-ext4@vger.kernel.org>
CC: <tytso@mit.edu>, <adilger.kernel@dilger.ca>, <yi.zhang@huawei.com>,
        <miaoxie@huawei.com>
Subject: [PATCH v2 0/2] ext4: fix unsafe extent initialization
Date: Tue, 18 Dec 2018 22:03:40 +0800
Message-ID: <1545141822-3082-1-git-send-email-yi.zhang@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi, Ted and Andreas

These two patches are the second version of the PATCH "ext4: fix unsafe
extent initialization". Instead of split extent in the first iteration,
it update the i_disksize if the zeroout region exceeds current
i_disksize, please review.

Thanks,
Yi.

-------
Changes since v1:
 - Add a patch to correct inode->i_size reading when converting
   initialized extent.
 - Instead of split extent, update i_disksize if necessary.

zhangyi (F) (2):
  ext4: use i_size_read() when converting initialized extent
  ext4: fix unsafe extent initialization

 fs/ext4/extents.c | 24 ++++++++++++++++++++++--
 1 file changed, 22 insertions(+), 2 deletions(-)

-- 
2.7.4
