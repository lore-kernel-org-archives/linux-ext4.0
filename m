From: Miao Xie <miaoxie@huawei.com>
Subject: Re: [PATCH 1/2] ext4, project: expand inode extra size if possible
Date: Mon, 3 Jul 2017 10:49:29 +0800
Message-ID: <fcc6383e-a6a4-e221-e58b-b5fa2ea52e25@huawei.com>
References: <20170630035148.63305-1-wshilong@ddn.com>
 <535692b6-b000-e040-2fdc-2ef5dcbff1ab@huawei.com>
 <3ED34739A4E85E4F894367D57617CDEFCA59786E@LAX-EX-MB2.datadirect.datadirectnet.com>
Reply-To: <miaoxie@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: 7bit
Cc: "tytso@mit.edu" <tytso@mit.edu>, Li Xi <lixi@ddn.com>,
        "yi.zhang@huawei.com" <yi.zhang@huawei.com>,
        "adilger@dilger.ca" <adilger@dilger.ca>,
        Shuichi Ihara <sihara@ddn.com>
To: Wang Shilong <wshilong@ddn.com>,
        Wang Shilong <wangshilong1991@gmail.com>,
        "linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from szxga03-in.huawei.com ([45.249.212.189]:8417 "EHLO
        szxga03-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752143AbdGCCuX (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Sun, 2 Jul 2017 22:50:23 -0400
In-Reply-To: <3ED34739A4E85E4F894367D57617CDEFCA59786E@LAX-EX-MB2.datadirect.datadirectnet.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>



on 2017/7/3 at 9:16, Wang Shilong wrote:
> 
> ________________________________________
> From: Miao Xie [miaoxie@huawei.com]
> Sent: Friday, June 30, 2017 16:48
> To: Wang Shilong; linux-ext4@vger.kernel.org
> Cc: tytso@mit.edu; Li Xi; yi.zhang@huawei.com; adilger@dilger.ca; Wang Shilong; Shuichi Ihara
> Subject: Re: [PATCH 1/2] ext4, project: expand inode extra size if possible
> 
> on 2017/6/30 at 11:51, Wang Shilong wrote:
>> when upgrading from old format, try to set project id
>> to old file first time, it will return EOVERFLOW, but if
>> that file is dirtied(touch etc), changing project id will
> <...SNIP...>
> 
> ext4_expand_extra_isize should be invoked after ext4_reserve_inode_write.
> 
> And I think it is better to restructure ext4_expand_extra_isize by moving NO_EXPAND check,
> nojournal check and journal credits extend into it, and then we just if i_projid is in
> 
> ---->I agreed we could move NO_EXPAND check, but i don't think it good idea to move journal
> credits extend to it, jbd2_extend_journal() might fail, and we'd better avoid it.
> 
> For changing projectid, we could know how many credits before start transaction..

I found most check in set_projectid is the same as ext4_mark_inode_dirty, so I think it's better
to move those checks into ext4_expand_extra_isize to avoid the reduplicated code.

And I don't think jbd2_journal_extend's failure is a big problem, because we just invoke it once
most of the time, and even if we fail to extend the inode because of jbd2_journal_extend's failure,
the metadata is still safe, so it is unnecessary to change many codes in set_projectid, or
we will impact readability of the code.

> 
> the inode or not, if not, invoke ext4_expand_extra_isize. (don't forget to do cleanup for
> ext4_mark_inode_dirty), And then we can remove many check in the above code.
> 
> 
> ---->what do you mean cleanup for ext4_mark_inode_dirty()? I supposed you mean don't
> call ext4_mark_iloc_dirty() if extend fail? i think that is expected, even inode extend fail,
> if ext4_mark_inode_dirty() is called, it means inode is dirtied already before we call the
> function.

I means if we move the checks into ext4_expand_extra_isize, we should do cleanup for ext4_mark_inode_dirty.
(ext4_mark_iloc_dirty() shoud be invoked even if extend fail, because we need update the on-disk inode)

Thanks
Miao

> Thanks,
> Shilong
> 
> 
> .
> 
