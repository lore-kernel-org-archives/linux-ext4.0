From: Wang Shilong <wshilong@ddn.com>
Subject: RE: [PATCH 1/2] ext4, project: expand inode extra size if possible
Date: Mon, 3 Jul 2017 01:16:15 +0000
Message-ID: <3ED34739A4E85E4F894367D57617CDEFCA59786E@LAX-EX-MB2.datadirect.datadirectnet.com>
References: <20170630035148.63305-1-wshilong@ddn.com>,<535692b6-b000-e040-2fdc-2ef5dcbff1ab@huawei.com>
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
Received: from legacy.ddn.com ([64.47.133.206]:17444 "EHLO legacy.ddn.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752121AbdGCBQS (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Sun, 2 Jul 2017 21:16:18 -0400
In-Reply-To: <535692b6-b000-e040-2fdc-2ef5dcbff1ab@huawei.com>
Content-Language: en-US
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


________________________________________
From: Miao Xie [miaoxie@huawei.com]
Sent: Friday, June 30, 2017 16:48
To: Wang Shilong; linux-ext4@vger.kernel.org
Cc: tytso@mit.edu; Li Xi; yi.zhang@huawei.com; adilger@dilger.ca; Wang Shilong; Shuichi Ihara
Subject: Re: [PATCH 1/2] ext4, project: expand inode extra size if possible

on 2017/6/30 at 11:51, Wang Shilong wrote:
> when upgrading from old format, try to set project id
> to old file first time, it will return EOVERFLOW, but if
> that file is dirtied(touch etc), changing project id will
<...SNIP...>

ext4_expand_extra_isize should be invoked after ext4_reserve_inode_write.

And I think it is better to restructure ext4_expand_extra_isize by moving NO_EXPAND check,
nojournal check and journal credits extend into it, and then we just if i_projid is in

---->I agreed we could move NO_EXPAND check, but i don't think it good idea to move journal
credits extend to it, jbd2_extend_journal() might fail, and we'd better avoid it.

For changing projectid, we could know how many credits before start transaction..

the inode or not, if not, invoke ext4_expand_extra_isize. (don't forget to do cleanup for
ext4_mark_inode_dirty), And then we can remove many check in the above code.


---->what do you mean cleanup for ext4_mark_inode_dirty()? I supposed you mean don't
call ext4_mark_iloc_dirty() if extend fail? i think that is expected, even inode extend fail,
if ext4_mark_inode_dirty() is called, it means inode is dirtied already before we call the
function.

Thanks,
Shilong
