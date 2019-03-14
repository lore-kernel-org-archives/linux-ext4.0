Return-Path: <SRS0=Ur5Y=RR=vger.kernel.org=linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CC40FC43381
	for <linux-ext4@archiver.kernel.org>; Thu, 14 Mar 2019 13:04:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9B3F820854
	for <linux-ext4@archiver.kernel.org>; Thu, 14 Mar 2019 13:04:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727173AbfCNNEV (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Thu, 14 Mar 2019 09:04:21 -0400
Received: from szxga04-in.huawei.com ([45.249.212.190]:4681 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727059AbfCNNEU (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Thu, 14 Mar 2019 09:04:20 -0400
Received: from DGGEMS405-HUB.china.huawei.com (unknown [172.30.72.58])
        by Forcepoint Email with ESMTP id 54CAAC913EC30ECEEEC8;
        Thu, 14 Mar 2019 21:04:16 +0800 (CST)
Received: from [127.0.0.1] (10.177.244.145) by DGGEMS405-HUB.china.huawei.com
 (10.3.19.205) with Microsoft SMTP Server id 14.3.408.0; Thu, 14 Mar 2019
 21:04:09 +0800
Subject: Re: [PATCH] ext4: brelse all indirect buffers in
 ext4_ind_remove_space()
To:     Jan Kara <jack@suse.cz>
References: <1552137547-115352-1-git-send-email-yi.zhang@huawei.com>
 <20190313173437.GL9108@quack2.suse.cz>
 <cab559a2-c2e7-f283-1069-2c308b1a7a2a@huawei.com>
 <20190314095428.GE16658@quack2.suse.cz>
CC:     <linux-ext4@vger.kernel.org>, <tytso@mit.edu>,
        <adilger.kernel@dilger.ca>, <miaoxie@huawei.com>
From:   "zhangyi (F)" <yi.zhang@huawei.com>
Message-ID: <ca88b751-becd-6bab-8b95-71f916c098eb@huawei.com>
Date:   Thu, 14 Mar 2019 21:04:08 +0800
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:45.0) Gecko/20100101
 Thunderbird/45.4.0
MIME-Version: 1.0
In-Reply-To: <20190314095428.GE16658@quack2.suse.cz>
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.177.244.145]
X-CFilter-Loop: Reflected
Sender: linux-ext4-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org

On 2019/3/14 17:54, Jan Kara Wrote:
> On Thu 14-03-19 10:19:35, zhangyi (F) wrote:
>> On 2019/3/14 1:34, Jan Kara Wrote:
>>> On Sat 09-03-19 21:19:07, zhangyi (F) wrote:
>>>> All indirect buffers get by ext4_find_shared() should be released no
>>>> mater the branch should be freed or not. But now, we forget to release
>>>> the lower depth indirect buffers when removing space from the same
>>>> higher depth indirect block. It will lead to buffer leak and futher
>>>> more, it may lead to quota information corruption when using old quota,
>>>> consider the following case.
>>>>
>>>>  - Create and mount an empty ext4 filesystem without extent and quota
>>>>    features,
>>>>  - quotacheck and enable the user & group quota,
>>>>  - Create some files and write some data to them, and then punch hole
>>>>    to some files of them, it may trigger the buffer leak problem
>>>>    mentioned above.
>>>>  - Disable quota and run quotacheck again, it will create two new
>>>>    aquota files and write the checked quota information to them, which
>>>>    probably may reuse the freed indirect block(the buffer and page
>>>>    cache was not freed) as data block.
>>>>  - Enable quota again, it will invoke
>>>>    vfs_load_quota_inode()->invalidate_bdev() to try to clean unused
>>>>    buffers and pagecache. Unfortunately, because of the buffer of quota
>>>>    data block is still referenced, quota code cannot read the up to date
>>>>    quota info from the device and lead to quota information corruption.
>>>>
>>>> This problem can be reproduced by xfstests generic/231 on ext3 file
>>>> system or ext4 filesystem without extent and quota feature.
>>>>
>>>> This patch fix this problem by brelse all indirect buffers, and also
>>>> do some cleanup of the brelse code in ext4_ind_remove_space().
>>>>
>>>> Reported-by: Hulk Robot <hulkci@huawei.com>
>>>> Signed-off-by: zhangyi (F) <yi.zhang@huawei.com>
>>>
>>> Thanks for the report and the patch! I think it is correct but I'd find it
>>> simpler (not only the patch as such but also the resulting code in the
>>> function) to just fix that one place that seems to leak bh references.
>>> Something like:
>>>
>>>                 if (partial > chain && partial2 > chain2 &&
>>>                     partial->bh->b_blocknr == partial2->bh->b_blocknr) {
>>>                         /*
>>>                          * We've converged on the same block. Clear the range,
>>>                          * then we're done.
>>>                          */
>>>                         ext4_free_branches(handle, inode, partial->bh,
>>>                                            partial->p + 1,
>>>                                            partial2->p,
>>>                                            (chain+n-1) - partial);
>>> -                       BUFFER_TRACE(partial->bh, "call brelse");
>>> -                       brelse(partial->bh);
>>> -                       BUFFER_TRACE(partial2->bh, "call brelse");
>>> -                       brelse(partial2->bh);
>>> +			while (partial > chain) {
>>> +				BUFFER_TRACE(partial->bh, "call brelse");
>>> +				brelse(partial->bh);
>>> +			}
>>> +			while (partial2 > chain2) {
>>> +				BUFFER_TRACE(partial2->bh, "call brelse");
>>> +				brelse(partial2->bh);
>>> +			}
>>>                         return 0;
>>>                 }
>>>
>>> Or is there some other problem I miss?
>>>
>>
>> Hi Jan, thanks for your suggestion. There are no other problems, and the
>> code you suggest can fix this bh references leak correctly.
>>
>> But now we put the release code everywhere in ext4_ind_remove_space(), I
>> think it's fragile and hard to read & maintain, so I not only want to fix
>> this problem but also do some cleanup in this patch(maybe split to a single
>> patch will be better). Suggestions?
> 
> Yes, I understood that you also wanted to cleanup stuff. Firstly, it would
> be good to separate the real fix from the cleanup as you mention (to make
> backports easier although in this case it's not a huge deal). Second, I'm
> not convinced that the new code is that easier to verify - previously we've
> released bh whenever we were done with it (so that we don't leave any
> unreleased bh's beyond 'partial'), with your cleanup we postpone all the
> releasing to the end. Both options are fine with me and I don't find either
> strictly better than the other. But you can submit that cleanup as a separate
> patch and Ted can decide whether he likes it or not.
> 

Thanks for your suggestion, I will split this patch and post v2.

Thanks,
Yi.

>>
>>>> ---
>>>>  fs/ext4/indirect.c | 43 ++++++++++++++++++++++---------------------
>>>>  1 file changed, 22 insertions(+), 21 deletions(-)
>>>>
>>>> diff --git a/fs/ext4/indirect.c b/fs/ext4/indirect.c
>>>> index bf7fa15..6f3f7d5 100644
>>>> --- a/fs/ext4/indirect.c
>>>> +++ b/fs/ext4/indirect.c
>>>> @@ -1219,6 +1219,7 @@ int ext4_ind_remove_space(handle_t *handle, struct inode *inode,
>>>>  	ext4_lblk_t offsets[4], offsets2[4];
>>>>  	Indirect chain[4], chain2[4];
>>>>  	Indirect *partial, *partial2;
>>>> +	Indirect *p = NULL, *p2 = NULL;
>>>>  	ext4_lblk_t max_block;
>>>>  	__le32 nr = 0, nr2 = 0;
>>>>  	int n = 0, n2 = 0;
>>>> @@ -1260,7 +1261,7 @@ int ext4_ind_remove_space(handle_t *handle, struct inode *inode,
>>>>  		}
>>>>  
>>>>  
>>>> -		partial = ext4_find_shared(inode, n, offsets, chain, &nr);
>>>> +		partial = p = ext4_find_shared(inode, n, offsets, chain, &nr);
>>>>  		if (nr) {
>>>>  			if (partial == chain) {
>>>>  				/* Shared branch grows from the inode */
>>>> @@ -1285,13 +1286,11 @@ int ext4_ind_remove_space(handle_t *handle, struct inode *inode,
>>>>  				partial->p + 1,
>>>>  				(__le32 *)partial->bh->b_data+addr_per_block,
>>>>  				(chain+n-1) - partial);
>>>> -			BUFFER_TRACE(partial->bh, "call brelse");
>>>> -			brelse(partial->bh);
>>>>  			partial--;
>>>>  		}
>>>>  
>>>>  end_range:
>>>> -		partial2 = ext4_find_shared(inode, n2, offsets2, chain2, &nr2);
>>>> +		partial2 = p2 = ext4_find_shared(inode, n2, offsets2, chain2, &nr2);
>>>>  		if (nr2) {
>>>>  			if (partial2 == chain2) {
>>>>  				/*
>>>> @@ -1321,16 +1320,14 @@ int ext4_ind_remove_space(handle_t *handle, struct inode *inode,
>>>>  					   (__le32 *)partial2->bh->b_data,
>>>>  					   partial2->p,
>>>>  					   (chain2+n2-1) - partial2);
>>>> -			BUFFER_TRACE(partial2->bh, "call brelse");
>>>> -			brelse(partial2->bh);
>>>>  			partial2--;
>>>>  		}
>>>>  		goto do_indirects;
>>>>  	}
>>>>  
>>>>  	/* Punch happened within the same level (n == n2) */
>>>> -	partial = ext4_find_shared(inode, n, offsets, chain, &nr);
>>>> -	partial2 = ext4_find_shared(inode, n2, offsets2, chain2, &nr2);
>>>> +	partial = p = ext4_find_shared(inode, n, offsets, chain, &nr);
>>>> +	partial2 = p2 = ext4_find_shared(inode, n2, offsets2, chain2, &nr2);
>>>>  
>>>>  	/* Free top, but only if partial2 isn't its subtree. */
>>>>  	if (nr) {
>>>> @@ -1387,11 +1384,7 @@ int ext4_ind_remove_space(handle_t *handle, struct inode *inode,
>>>>  					   partial->p + 1,
>>>>  					   partial2->p,
>>>>  					   (chain+n-1) - partial);
>>>> -			BUFFER_TRACE(partial->bh, "call brelse");
>>>> -			brelse(partial->bh);
>>>> -			BUFFER_TRACE(partial2->bh, "call brelse");
>>>> -			brelse(partial2->bh);
>>>> -			return 0;
>>>> +			goto clean_up;
>>>>  		}
>>>>  
>>>>  		/*
>>>> @@ -1406,8 +1399,6 @@ int ext4_ind_remove_space(handle_t *handle, struct inode *inode,
>>>>  					   partial->p + 1,
>>>>  					   (__le32 *)partial->bh->b_data+addr_per_block,
>>>>  					   (chain+n-1) - partial);
>>>> -			BUFFER_TRACE(partial->bh, "call brelse");
>>>> -			brelse(partial->bh);
>>>>  			partial--;
>>>>  		}
>>>>  		if (partial2 > chain2 && depth2 <= depth) {
>>>> @@ -1415,11 +1406,21 @@ int ext4_ind_remove_space(handle_t *handle, struct inode *inode,
>>>>  					   (__le32 *)partial2->bh->b_data,
>>>>  					   partial2->p,
>>>>  					   (chain2+n2-1) - partial2);
>>>> -			BUFFER_TRACE(partial2->bh, "call brelse");
>>>> -			brelse(partial2->bh);
>>>>  			partial2--;
>>>>  		}
>>>>  	}
>>>> +
>>>> +clean_up:
>>>> +	while (p && p > chain) {
>>>> +		BUFFER_TRACE(p->bh, "call brelse");
>>>> +		brelse(p->bh);
>>>> +		p--;
>>>> +	}
>>>> +	while (p2 && p2 > chain2) {
>>>> +		BUFFER_TRACE(p2->bh, "call brelse");
>>>> +		brelse(p2->bh);
>>>> +		p2--;
>>>> +	}
>>>>  	return 0;
>>>>  
>>>>  do_indirects:
>>>> @@ -1427,7 +1428,7 @@ int ext4_ind_remove_space(handle_t *handle, struct inode *inode,
>>>>  	switch (offsets[0]) {
>>>>  	default:
>>>>  		if (++n >= n2)
>>>> -			return 0;
>>>> +			break;
>>>>  		nr = i_data[EXT4_IND_BLOCK];
>>>>  		if (nr) {
>>>>  			ext4_free_branches(handle, inode, NULL, &nr, &nr+1, 1);
>>>> @@ -1435,7 +1436,7 @@ int ext4_ind_remove_space(handle_t *handle, struct inode *inode,
>>>>  		}
>>>>  	case EXT4_IND_BLOCK:
>>>>  		if (++n >= n2)
>>>> -			return 0;
>>>> +			break;
>>>>  		nr = i_data[EXT4_DIND_BLOCK];
>>>>  		if (nr) {
>>>>  			ext4_free_branches(handle, inode, NULL, &nr, &nr+1, 2);
>>>> @@ -1443,7 +1444,7 @@ int ext4_ind_remove_space(handle_t *handle, struct inode *inode,
>>>>  		}
>>>>  	case EXT4_DIND_BLOCK:
>>>>  		if (++n >= n2)
>>>> -			return 0;
>>>> +			break;
>>>>  		nr = i_data[EXT4_TIND_BLOCK];
>>>>  		if (nr) {
>>>>  			ext4_free_branches(handle, inode, NULL, &nr, &nr+1, 3);
>>>> @@ -1452,5 +1453,5 @@ int ext4_ind_remove_space(handle_t *handle, struct inode *inode,
>>>>  	case EXT4_TIND_BLOCK:
>>>>  		;
>>>>  	}
>>>> -	return 0;
>>>> +	goto clean_up;
>>>>  }
>>>> -- 
>>>> 2.7.4
>>>>
>>

