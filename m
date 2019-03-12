Return-Path: <SRS0=vuM7=RP=vger.kernel.org=linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,UNPARSEABLE_RELAY
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 32D33C43381
	for <linux-ext4@archiver.kernel.org>; Tue, 12 Mar 2019 11:00:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id F39F0206DF
	for <linux-ext4@archiver.kernel.org>; Tue, 12 Mar 2019 11:00:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726534AbfCLLAd (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Tue, 12 Mar 2019 07:00:33 -0400
Received: from out30-130.freemail.mail.aliyun.com ([115.124.30.130]:55065 "EHLO
        out30-130.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726434AbfCLLAd (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>);
        Tue, 12 Mar 2019 07:00:33 -0400
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R201e4;CH=green;DM=||false|;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01f04392;MF=jiufei.xue@linux.alibaba.com;NM=1;PH=DS;RN=3;SR=0;TI=SMTPD_---0TMYD4Uo_1552388429;
Received: from ali-186590e05fa3.local(mailfrom:jiufei.xue@linux.alibaba.com fp:SMTPD_---0TMYD4Uo_1552388429)
          by smtp.aliyun-inc.com(127.0.0.1);
          Tue, 12 Mar 2019 19:00:30 +0800
Subject: Re: [PATCH] ext4: fix NULL pointer dereference while journal is
 aborted
To:     Joseph Qi <joseph.qi@linux.alibaba.com>,
        linux-ext4@vger.kernel.org, tytso@mit.edu
References: <20190311063528.112996-1-jiufei.xue@linux.alibaba.com>
 <82869475-fc3b-441e-e87b-866e9aa1d93b@linux.alibaba.com>
From:   Jiufei Xue <jiufei.xue@linux.alibaba.com>
Message-ID: <600cf315-b3bc-75f4-5816-757eef4d6689@linux.alibaba.com>
Date:   Tue, 12 Mar 2019 19:00:29 +0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.13; rv:60.0)
 Gecko/20100101 Thunderbird/60.3.3
MIME-Version: 1.0
In-Reply-To: <82869475-fc3b-441e-e87b-866e9aa1d93b@linux.alibaba.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-ext4-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org

Hi Ted,

Would you please review this patch?

Thanks,
Jiufei

On 2019/3/11 下午2:45, Joseph Qi wrote:
> 
> 
> On 19/3/11 14:35, Jiufei Xue wrote:
>> We see the following NULL pointer dereference while running xfstests
>> generic/475:
>> BUG: unable to handle kernel NULL pointer dereference at 0000000000000008
>> PGD 8000000c84bad067 P4D 8000000c84bad067 PUD c84e62067 PMD 0
>> Oops: 0000 [#1] SMP PTI
>> CPU: 7 PID: 9886 Comm: fsstress Kdump: loaded Not tainted 5.0.0-rc8 #10
>> RIP: 0010:ext4_do_update_inode+0x4ec/0x760
>> ...
>> Call Trace:
>> ? jbd2_journal_get_write_access+0x42/0x50
>> ? __ext4_journal_get_write_access+0x2c/0x70
>> ? ext4_truncate+0x186/0x3f0
>> ext4_mark_iloc_dirty+0x61/0x80
>> ext4_mark_inode_dirty+0x62/0x1b0
>> ext4_truncate+0x186/0x3f0
>> ? unmap_mapping_pages+0x56/0x100
>> ext4_setattr+0x817/0x8b0
>> notify_change+0x1df/0x430
>> do_truncate+0x5e/0x90
>> ? generic_permission+0x12b/0x1a0
>>
>> This is triggered because the NULL pointer handle->h_transaction was
>> dereferenced in function ext4_update_inode_fsync_trans().
>> I found that the h_transaction was set to NULL in jbd2__journal_restart
>> but failed to attached to a new transaction while the journal is aborted.
>>
>> Fix this by checking the handle before updating the inode.
>>
>> Signed-off-by: Jiufei Xue <jiufei.xue@linux.alibaba.com>
> 
> Looks good.
> Reviewed-by: Joseph Qi <joseph.qi@linux.alibaba.com>
> 
>> ---
>>  fs/ext4/ext4_jbd2.h | 2 +-
>>  1 file changed, 1 insertion(+), 1 deletion(-)
>>
>> diff --git a/fs/ext4/ext4_jbd2.h b/fs/ext4/ext4_jbd2.h
>> index a1ac7e9245ec..75a5309f2231 100644
>> --- a/fs/ext4/ext4_jbd2.h
>> +++ b/fs/ext4/ext4_jbd2.h
>> @@ -384,7 +384,7 @@ static inline void ext4_update_inode_fsync_trans(handle_t *handle,
>>  {
>>  	struct ext4_inode_info *ei = EXT4_I(inode);
>>  
>> -	if (ext4_handle_valid(handle)) {
>> +	if (ext4_handle_valid(handle) && !is_handle_aborted(handle)) {
>>  		ei->i_sync_tid = handle->h_transaction->t_tid;
>>  		if (datasync)
>>  			ei->i_datasync_tid = handle->h_transaction->t_tid;
>>
> 
