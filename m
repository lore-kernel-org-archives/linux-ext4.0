From: Wang Shilong <wshilong@ddn.com>
Subject: RE: [PATCH 1/2] ext4, project: expand inode extra size if possible
Date: Mon, 3 Jul 2017 02:58:28 +0000
Message-ID: <3ED34739A4E85E4F894367D57617CDEFCA5978B0@LAX-EX-MB2.datadirect.datadirectnet.com>
References: <20170630035148.63305-1-wshilong@ddn.com>
 <535692b6-b000-e040-2fdc-2ef5dcbff1ab@huawei.com>
 <3ED34739A4E85E4F894367D57617CDEFCA59786E@LAX-EX-MB2.datadirect.datadirectnet.com>,<fcc6383e-a6a4-e221-e58b-b5fa2ea52e25@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Cc: "tytso@mit.edu" <tytso@mit.edu>, Li Xi <lixi@ddn.com>,
        "yi.zhang@huawei.com" <yi.zhang@huawei.com>,
        "adilger@dilger.ca" <adilger@dilger.ca>,
        Shuichi Ihara <sihara@ddn.com>
To: "miaoxie@huawei.com" <miaoxie@huawei.com>,
        Wang Shilong <wangshilong1991@gmail.com>,
        "linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from legacy.ddn.com ([64.47.133.206]:5685 "EHLO legacy.ddn.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752143AbdGCC6c (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Sun, 2 Jul 2017 22:58:32 -0400
In-Reply-To: <fcc6383e-a6a4-e221-e58b-b5fa2ea52e25@huawei.com>
Content-Language: en-US
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


________________________________________
From: Miao Xie [miaoxie@huawei.com]
Sent: Monday, July 03, 2017 10:49
>> that file is dirtied(touch etc), changing project id will
> <...SNIP...>
>
> ext4_expand_extra_isize should be invoked after ext4_reserve_inode_writ
>
> For changing projectid, we could know how many credits before start transaction..

I found most check in set_projectid is the same as ext4_mark_inode_dirty, so I think it's better
to move those checks into ext4_expand_extra_isize to avoid the reduplicated code.


---> I agreed, it could reduce dubplicated codes, but again, ioctl failure is visible to common
users, the behavior might be confusing for users? what kind of failure we should return to
userspace? EAGAIN or EOVERFLOW?

Thanks,
Shilong
