Return-Path: <SRS0=gd00=QI=vger.kernel.org=linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,UNPARSEABLE_RELAY autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AAE65C169C4
	for <linux-ext4@archiver.kernel.org>; Fri,  1 Feb 2019 03:08:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 80A1120870
	for <linux-ext4@archiver.kernel.org>; Fri,  1 Feb 2019 03:08:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726278AbfBADI5 (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Thu, 31 Jan 2019 22:08:57 -0500
Received: from out30-44.freemail.mail.aliyun.com ([115.124.30.44]:33667 "EHLO
        out30-44.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725854AbfBADI5 (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>);
        Thu, 31 Jan 2019 22:08:57 -0500
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R181e4;CH=green;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e01406;MF=xiaoguang.wang@linux.alibaba.com;NM=1;PH=DS;RN=2;SR=0;TI=SMTPD_---0TJMAqFw_1548990532;
Received: from 30.7.9.25(mailfrom:xiaoguang.wang@linux.alibaba.com fp:SMTPD_---0TJMAqFw_1548990532)
          by smtp.aliyun-inc.com(127.0.0.1);
          Fri, 01 Feb 2019 11:08:53 +0800
Subject: Re: question about ext4 backup block group descriptors
To:     Andreas Dilger <adilger@dilger.ca>
Cc:     linux-ext4@vger.kernel.org
References: <4fc3271a-3098-afcd-24c1-e2e130e1e86a@linux.alibaba.com>
 <B510E1BD-618E-4E26-88B1-8D70F78C9EEF@dilger.ca>
From:   Xiaoguang Wang <xiaoguang.wang@linux.alibaba.com>
Message-ID: <806e62a9-07a1-0a29-05a3-65257f98a741@linux.alibaba.com>
Date:   Fri, 1 Feb 2019 11:08:52 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.5.0
MIME-Version: 1.0
In-Reply-To: <B510E1BD-618E-4E26-88B1-8D70F78C9EEF@dilger.ca>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-ext4-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org

hi,

> On Jan 31, 2019, at 1:07 AM, Xiaoguang Wang <xiaoguang.wang@linux.alibaba.com> wrote:
>>
>> Anyone can help answer when ext4's backup block group descriptors are updated?
>> I had used blktrace to track the corresponding backup block group descriptor
>> block, but didn't find that any backup blocks were written.
>> Thanks in advance.
> 
> The ext4 kernel code never updates the backup block group descriptors.  That is only
> done by e2fsck.
I see, thanks very much.

Regards,
Xiaoguang Wang

> 
> Cheers, Andreas
> 
> 
> 
> 
> 
