From: Daeho Jeong <daeho.jeong@samsung.com>
Subject: RE: Re: [PATCH] ext4: change sequential discard handling on commit
 complete phase into parallel manner
Date: Wed, 31 May 2017 00:49:26 +0000
Message-ID: <20170531004926epcms1p5ea300c8e634f7a0a42af283c4df9a1b7@epcms1p5>
References: <20170530091626.GA3284@quack2.suse.cz>
        <1496113566-18899-1-git-send-email-daeho.jeong@samsung.com>
        <CGME20170530030551epcas5p327c9acbabf266842887bcc86cac43cba@epcms1p5>
Reply-To: daeho.jeong@samsung.com
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
Cc: "jack@suse.com" <jack@suse.com>,
        "hch@infradead.org" <hch@infradead.org>,
        "tytso@mit.edu" <tytso@mit.edu>,
        "linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>
To: Jan Kara <jack@suse.cz>, Daeho Jeong <daeho.jeong@samsung.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mailout2.samsung.com ([203.254.224.25]:30849 "EHLO
        mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751120AbdEaAt2 (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Tue, 30 May 2017 20:49:28 -0400
Received: from epcas1p2.samsung.com (unknown [182.195.41.46])
        by mailout2.samsung.com (KnoxPortal) with ESMTP id 20170531004926epoutp02c7304cfb6e3ad3da4bacf78faa890dce~DinwN1eup3073330733epoutp02U
        for <linux-ext4@vger.kernel.org>; Wed, 31 May 2017 00:49:26 +0000 (GMT)
In-Reply-To: <20170530091626.GA3284@quack2.suse.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi Jan,

> Hum, these games with several callbacks, lists, etc. look awkward and

> unnecessary. It think they mostly come from the fact that we call separate

> freeing callback for each extent to free which doesn't fit the needs of

> async discard well.

 

> So instead of adding post_cb_list and several callback functions, it would

> seem easier to have just one callback structure instead of one for every

> extent. Then the structure would contain a list of extents that need to be

> freed freed. So something like:

 

> struct ext4_free_data {

>         struct ext4_journal_cb_entry efd_jce;

>         struct list_head efd_extents;

> }

 

> struct ext4_freed_extent {

>         struct list_head efe_list;

>         struct rb_node efe_node;

>         ext4_group_t efe_group;

>         ext4_grpblk_t efe_start_cluster;

>         ext4_grpblk_t efe_count;

>         tid_t efe_tid;

> }

 

> When commit happens, we can just walk the efd_extents list while efe_tid is

> equal tid of the transaction for which the callback was called and submit all

> discard requests. You can use bio chaining implemented in

> __blkdev_issue_discard() which XFS already uses and so the result of all

> the discards you submit will be just one bio. Then you walk the list of

> extents again and free them in the buddy bitmaps. And finally, you wait for

> the bio to complete. All will be then happening in one function and it will

> be much easier to understand.



It's right. the patch didn't look neat because of a few callbacks and the

post callback list. I will modify the patch as your suggestion. It will

look better.



Thank you very much. :-)



 

 
