Return-Path: <linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,UNPARSEABLE_RELAY autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EF87FC4338F
	for <linux-ext4@archiver.kernel.org>; Sun,  1 Aug 2021 16:05:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D7CA0610D1
	for <linux-ext4@archiver.kernel.org>; Sun,  1 Aug 2021 16:05:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231766AbhHAQFh (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Sun, 1 Aug 2021 12:05:37 -0400
Received: from out20-110.mail.aliyun.com ([115.124.20.110]:55235 "EHLO
        out20-110.mail.aliyun.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230010AbhHAQFg (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Sun, 1 Aug 2021 12:05:36 -0400
X-Alimail-AntiSpam: AC=CONTINUE;BC=0.1035937|-1;CH=green;DM=|CONTINUE|false|;DS=CONTINUE|ham_system_inform|0.131609-0.0098807-0.858511;FP=0|0|0|0|0|-1|-1|-1;HT=ay29a033018047213;MF=guan@eryu.me;NM=1;PH=DS;RN=5;RT=5;SR=0;TI=SMTPD_---.Ktt72EQ_1627833926;
Received: from localhost(mailfrom:guan@eryu.me fp:SMTPD_---.Ktt72EQ_1627833926)
          by smtp.aliyun-inc.com(10.147.44.129);
          Mon, 02 Aug 2021 00:05:27 +0800
Date:   Mon, 2 Aug 2021 00:05:26 +0800
From:   Eryu Guan <guan@eryu.me>
To:     Ritesh Harjani <riteshh@linux.ibm.com>
Cc:     fstests@vger.kernel.org, linux-ext4@vger.kernel.org,
        Theodore Ts'o <tytso@mit.edu>,
        "Darrick J . Wong" <djwong@kernel.org>
Subject: Re: [PATCHv2 0/9] xfstests: 64K blocksize related fixes
Message-ID: <YQbGRrgd9d5y91WO@desktop>
References: <cover.1626844259.git.riteshh@linux.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1626844259.git.riteshh@linux.ibm.com>
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org

On Wed, Jul 21, 2021 at 10:57:53AM +0530, Ritesh Harjani wrote:
> Hello,
> 
> Below are the list of fixes mostly centered around 64K blocksize
> and with ext4 filesystem. Tested this with both 64K & 4K blocksize on Power
> with (ext4/ext3/ext2/xfs/btrfs).
> 
> v1 -> v2
> 1. Address comments from Ted and Darrick mentioned at [1]

Thanks for the fixes! I've applied patch 1-4 and patch 8-9. Patch 5-7
may need more discusstions.

Thanks,
Eryu

> 
> [1]: https://patchwork.kernel.org/cover/12318137
> 
> Ritesh Harjani (9):
>   ext4/003: Fix this test on 64K platform for dax config
>   ext4/027: Correct the right code of block and inode bitmap
>   ext4/306: Add -b blocksize parameter too to avoid failure with DAX config
>   ext4/022: exclude this test for dax config on 64KB pagesize platform
>   generic/031: Fix the test case for 64k blocksize config
>   common/rc: Add _mkfs_dev_blocksized functionality
>   generic/620: Use _mkfs_dev_blocksized to use 4k bs
>   common/attr: Cleanup end of line whitespaces issues
>   common/attr: Reduce MAX_ATTRS to leave some overhead for 64K blocksize
> 
>  common/attr           | 57 ++++++++++++++++++++++++++++++++++++-------
>  common/rc             | 47 +++++++++++++++++++++++++++++++++++
>  tests/ext4/003        |  3 ++-
>  tests/ext4/022        |  7 ++++--
>  tests/ext4/027        |  4 +--
>  tests/ext4/306        |  5 +++-
>  tests/generic/031     | 14 +++++++----
>  tests/generic/031.out | 16 ++++++------
>  tests/generic/620     |  4 ++-
>  9 files changed, 128 insertions(+), 29 deletions(-)
> 
> --
> 2.31.1
