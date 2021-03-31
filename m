Return-Path: <linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5083AC433C1
	for <linux-ext4@archiver.kernel.org>; Wed, 31 Mar 2021 03:12:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 07557619EF
	for <linux-ext4@archiver.kernel.org>; Wed, 31 Mar 2021 03:12:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233288AbhCaDLe (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Tue, 30 Mar 2021 23:11:34 -0400
Received: from szxga05-in.huawei.com ([45.249.212.191]:14969 "EHLO
        szxga05-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232874AbhCaDLW (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Tue, 30 Mar 2021 23:11:22 -0400
Received: from DGGEMS405-HUB.china.huawei.com (unknown [172.30.72.58])
        by szxga05-in.huawei.com (SkyGuard) with ESMTP id 4F9B9m14MFzyNMg;
        Wed, 31 Mar 2021 11:09:16 +0800 (CST)
Received: from [10.174.176.202] (10.174.176.202) by
 DGGEMS405-HUB.china.huawei.com (10.3.19.205) with Microsoft SMTP Server id
 14.3.498.0; Wed, 31 Mar 2021 11:11:11 +0800
Subject: Re: [BUG && Question] question of SB_ACTIVE flag in
 ext4_orphan_cleanup()
To:     Jan Kara <jack@suse.cz>
CC:     "Theodore Y. Ts'o" <tytso@mit.edu>,
        Ext4 Developers List <linux-ext4@vger.kernel.org>,
        yangerkun <yangerkun@huawei.com>, <linfeilong@huawei.com>
References: <8a6864dd-7e6c-5268-2b5b-1010f99d2a1b@huawei.com>
 <20210322172551.GJ31783@quack2.suse.cz>
 <b1a05885-1d7b-b9d1-80da-785633cbfc6a@huawei.com>
 <20210330150229.GC30749@quack2.suse.cz>
From:   Zhang Yi <yi.zhang@huawei.com>
Message-ID: <99cce8ca-e4a0-7301-840f-2ace67c551f3@huawei.com>
Date:   Wed, 31 Mar 2021 11:11:10 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.3.1
MIME-Version: 1.0
In-Reply-To: <20210330150229.GC30749@quack2.suse.cz>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.174.176.202]
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org

On 2021/3/30 23:02, Jan Kara wrote:
> On Mon 29-03-21 17:20:35, Zhang Yi wrote:
>> On 2021/3/23 1:25, Jan Kara wrote:
>>> Hi!
>>>
>>> On Mon 22-03-21 23:24:23, Zhang Yi wrote:
>>>> We find a use after free problem when CONFIG_QUOTA is enabled, the detail of
>>>> this problem is below.
>>>>
>>>> mount_bdev()
>>>> 	ext4_fill_super()
>>>> 		sb->s_root = d_make_root(root);
>>>> 		ext4_orphan_cleanup()
>>>> 			sb->s_flags |= SB_ACTIVE; <--- 1. mark sb active
>>>> 			ext4_orphan_get()
>>>> 			ext4_truncate()
>>>> 				ext4_block_truncate_page()
>>>> 					mark_buffer_dirty <--- 2. dirty inode
>>>> 			iput()
>>>> 				iput_final  <--- 3. put into lru list
>>>> 		ext4_mark_recovery_complete  <--- 4. failed and return error
>>>> 		sb->s_root = NULL;
>>>> 	deactivate_locked_super()
>>>> 		kill_block_super()
>>>> 			generic_shutdown_super()
>>>> 				<--- 5. did not evict_inodes
>>>> 		put_super()
>>>> 			__put_super()
>>>> 				<--- 6. put super block
>>>>
>>>> Because of the truncated inodes was dirty and will write them back later, it
>>>> will trigger use after free problem. Now the question is why we need to set
>>>> SB_ACTIVE bit when enable CONFIG_QUOTA below?
>>>>
>>>>   #ifdef CONFIG_QUOTA
>>>>           /* Needed for iput() to work correctly and not trash data */
>>>>           sb->s_flags |= SB_ACTIVE;
>>>>
>>>> This code was merged long long ago in v2.6.6, IIUC, it may not affect
>>>> the quota statistics it we evict inode directly in the last iput.
>>>> In order to slove this UAF problem, I'm not sure is there any side effect
>>>> if we just remove this code, or remove SB_ACTIVE and call evict_inodes()
>>>> in the error path of ext4_fill_super().
>>>>
>>>> Could you give some suggestions?
>>>
>>> That's a very good question. I do remember that I've added this code back
>>> then because otherwise orphan cleanup was loosing updates to quota files.
>>> But you're right that now I don't see how that could be happening and it
>>> would be nice if we could get rid of this hack (and even better if it also
>>> fixes the problem you've found). I guess I'll just try and test this change
>>> with various quota configurations to see whether something still breaks or
>>> not. Thanks report!
>>>
>>
>> Thanks for taking time to look at this, is this change OK under your various
>> quota test cases?
> 
> Yes, I did tests both with journalled quotas and with ext4 quota feature
> and the quota accounting was correct after orphan recovery. So just
> removing the SB_ACTIVE setting is fine AFAICT. Will you send a patch or
> should I do it?
> 

Thanks for testing this change, I will send a patch.

Yi.
