Return-Path: <linux-ext4-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5923EC6FA99
	for <linux-ext4@archiver.kernel.org>; Fri, 10 Mar 2023 06:37:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229722AbjCJGhR (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Fri, 10 Mar 2023 01:37:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54586 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229522AbjCJGhQ (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Fri, 10 Mar 2023 01:37:16 -0500
Received: from out30-133.freemail.mail.aliyun.com (out30-133.freemail.mail.aliyun.com [115.124.30.133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4D57D104AC5;
        Thu,  9 Mar 2023 22:37:15 -0800 (PST)
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R271e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=ay29a033018045176;MF=hsiangkao@linux.alibaba.com;NM=1;PH=DS;RN=7;SR=0;TI=SMTPD_---0VdWGjYw_1678430231;
Received: from 30.97.48.46(mailfrom:hsiangkao@linux.alibaba.com fp:SMTPD_---0VdWGjYw_1678430231)
          by smtp.aliyun-inc.com;
          Fri, 10 Mar 2023 14:37:12 +0800
Message-ID: <85434b6a-e7bd-d0c0-654f-233e56112cd0@linux.alibaba.com>
Date:   Fri, 10 Mar 2023 14:37:11 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.6.1
Subject: Re: [PATCH] ext4: convert to DIV_ROUND_UP() in
 mpage_process_page_bufs()
From:   Gao Xiang <hsiangkao@linux.alibaba.com>
To:     Yangtao Li <frank.li@vivo.com>, tytso@mit.edu,
        adilger.kernel@dilger.ca
Cc:     linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org,
        viro@zeniv.linux.org.uk, linux-erofs@lists.ozlabs.org
References: <ZArLbO1ckmcXwQf0@sol.localdomain>
 <20230310062738.69663-1-frank.li@vivo.com>
 <b47f5003-c7ad-da27-dab6-077f57aaae18@linux.alibaba.com>
In-Reply-To: <b47f5003-c7ad-da27-dab6-077f57aaae18@linux.alibaba.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org



On 2023/3/10 14:35, Gao Xiang wrote:
> 
> 
> On 2023/3/10 14:27, Yangtao Li wrote:
>>> Please don't do this.  This makes the code compile down to a division, which is
>>> far less efficient.  I've verified this by checking the assembly generated.
>>
>> How much is the performance impact? So should the following be modified as shift operations as well?
>>
>> fs/erofs/namei.c:92:    int head = 0, back = DIV_ROUND_UP(dir->i_size, EROFS_BLKSIZ) - 1;
>> fs/erofs/zmap.c:252:    const unsigned int totalidx = DIV_ROUND_UP(inode->i_size, EROFS_BLKSIZ);
>> fs/erofs/decompressor.c:14:#define LZ4_MAX_DISTANCE_PAGES       (DIV_ROUND_UP(LZ4_DISTANCE_MAX, PAGE_SIZE) + 1)
>> fs/erofs/decompressor.c:56:                                     DIV_ROUND_UP(distance, PAGE_SIZE) + 1 :
>> fs/erofs/decompressor.c:70:     unsigned long bounced[DIV_ROUND_UP(LZ4_MAX_DISTANCE_PAGES,
>> fs/erofs/data.c:84:     nblocks = DIV_ROUND_UP(inode->i_size, EROFS_BLKSIZ);
> 
> Please stop taking EROFS as example on ext4 patches
> and they will all be changed due to subpage support.

Here EROFS_BLKSIZ == PAGE_SIZE is a constant, so no difference
to use shift or division.

> 
>>
>> Thx,
>> Yangtao
