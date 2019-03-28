Return-Path: <SRS0=RF5E=R7=vger.kernel.org=linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,UNPARSEABLE_RELAY,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6B65FC43381
	for <linux-ext4@archiver.kernel.org>; Thu, 28 Mar 2019 10:05:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3686221773
	for <linux-ext4@archiver.kernel.org>; Thu, 28 Mar 2019 10:05:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726817AbfC1KFc (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Thu, 28 Mar 2019 06:05:32 -0400
Received: from out30-44.freemail.mail.aliyun.com ([115.124.30.44]:56199 "EHLO
        out30-44.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727176AbfC1KFc (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>);
        Thu, 28 Mar 2019 06:05:32 -0400
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R211e4;CH=green;DM=||false|;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e07487;MF=jiufei.xue@linux.alibaba.com;NM=1;PH=DS;RN=4;SR=0;TI=SMTPD_---0TNqom65_1553767527;
Received: from ali-186590e05fa3.local(mailfrom:jiufei.xue@linux.alibaba.com fp:SMTPD_---0TNqom65_1553767527)
          by smtp.aliyun-inc.com(127.0.0.1);
          Thu, 28 Mar 2019 18:05:28 +0800
Subject: Re: [PATCH] jbd2: check superblock mapped prior to committing
To:     Jan Kara <jack@suse.cz>
Cc:     linux-ext4@vger.kernel.org, tytso@mit.edu,
        renzhen@linux.alibaba.com
References: <20190328091814.46168-1-jiufei.xue@linux.alibaba.com>
 <20190328095954.GE22915@quack2.suse.cz>
From:   Jiufei Xue <jiufei.xue@linux.alibaba.com>
Message-ID: <7bffa4dd-106a-7ab9-00a7-cab000304a39@linux.alibaba.com>
Date:   Thu, 28 Mar 2019 18:05:27 +0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.13; rv:60.0)
 Gecko/20100101 Thunderbird/60.6.0
MIME-Version: 1.0
In-Reply-To: <20190328095954.GE22915@quack2.suse.cz>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-ext4-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org

Hi Jan,

On 2019/3/28 下午5:59, Jan Kara wrote:
> On Thu 28-03-19 17:18:14, Jiufei Xue wrote:
>> We hit a BUG at fs/buffer.c:3057 if we detached the nbd device
>> before unmounting ext4 filesystem.
>>
>> The typical chain of events leading to the BUG:
>> jbd2_write_superblock
>>   submit_bh
>>     submit_bh_wbc
>>       BUG_ON(!buffer_mapped(bh));
>>
>> The block device is removed and all the pages are invalidated. JBD2
>> was trying to write journal superblock to the block device which is
>> no longer present.
>>
>> Fix this by checking the journal superblock's buffer head prior to
>> submitting.
>>
>> Cc: stable@kernel.org
>> Reported-by: Eric Ren <renzhen@linux.alibaba.com>
>> Signed-off-by: Jiufei Xue <jiufei.xue@linux.alibaba.com>
>> ---
>>  fs/jbd2/journal.c | 3 +++
>>  1 file changed, 3 insertions(+)
>>
>> diff --git a/fs/jbd2/journal.c b/fs/jbd2/journal.c
>> index 382c030cc78b..90fd3ed0a232 100644
>> --- a/fs/jbd2/journal.c
>> +++ b/fs/jbd2/journal.c
>> @@ -1350,6 +1350,9 @@ static int jbd2_write_superblock(journal_t *journal, int write_flags)
>>  	journal_superblock_t *sb = journal->j_superblock;
>>  	int ret;
>>  
> Can you add a comment here like:
> 
> 	/* Buffer got discarded which means block device got invalidated */
> 
> to explain what's going on? Thanks! Otherwise the patch looks good to me so
> you can add:
> 
> Reviewed-by: Jan Kara <jack@suse.cz>
>

 
Thank you for your suggestion, I will add the comment and send version 2 soon.

Thanks,
Jiufei

> 								Honza
> 
>> +	if (!buffer_mapped(bh))
>> +		return -EIO;
>> +
> 
> 
>>  	trace_jbd2_write_superblock(journal, write_flags);
>>  	if (!(journal->j_flags & JBD2_BARRIER))
>>  		write_flags &= ~(REQ_FUA | REQ_PREFLUSH);
>> -- 
>> 2.19.1.856.g8858448bb
>>
