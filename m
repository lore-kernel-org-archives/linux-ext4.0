Return-Path: <SRS0=VMsO=2T=vger.kernel.org=linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 61D9EC2D0CE
	for <linux-ext4@archiver.kernel.org>; Sun, 29 Dec 2019 15:03:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3926720722
	for <linux-ext4@archiver.kernel.org>; Sun, 29 Dec 2019 15:03:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726575AbfL2PDV (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Sun, 29 Dec 2019 10:03:21 -0500
Received: from out30-133.freemail.mail.aliyun.com ([115.124.30.133]:58517 "EHLO
        out30-133.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726410AbfL2PDV (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>);
        Sun, 29 Dec 2019 10:03:21 -0500
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R841e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04394;MF=xiaoguang.wang@linux.alibaba.com;NM=1;PH=DS;RN=4;SR=0;TI=SMTPD_---0TmBIwOh_1577631797;
Received: from 30.39.178.78(mailfrom:xiaoguang.wang@linux.alibaba.com fp:SMTPD_---0TmBIwOh_1577631797)
          by smtp.aliyun-inc.com(127.0.0.1);
          Sun, 29 Dec 2019 23:03:18 +0800
Subject: Re: Discussion: is it time to remove dioread_nolock?
To:     "Theodore Y. Ts'o" <tytso@mit.edu>,
        Ext4 Developers List <linux-ext4@vger.kernel.org>
Cc:     joseph.qi@linux.alibaba.com, Liu Bo <bo.liu@linux.alibaba.com>
References: <20191226153118.GA17237@mit.edu>
From:   Xiaoguang Wang <xiaoguang.wang@linux.alibaba.com>
Message-ID: <9042a8f4-985a-fc83-c059-241c9440200c@linux.alibaba.com>
Date:   Sun, 29 Dec 2019 23:03:17 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.1
MIME-Version: 1.0
In-Reply-To: <20191226153118.GA17237@mit.edu>
Content-Type: text/plain; charset=gbk; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-ext4-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org

hi,

> With inclusion of Ritesh's inode lock scalability patches[1], the
> traditional performance reasons for dioread_nolock --- namely,
> removing the need to take an exclusive lock for Direct I/O read
> operations --- has been removed.
> 
> [1] https://lore.kernel.org/r/20191212055557.11151-1-riteshh@linux.ibm.com
> 
> So... is it time to remove the code which supports dioread_nolock?
> Doing so would simplify the code base, and reduce the test matrix.
> This would also make it easier to restructure the write path when
> allocating blocks so that the extent tree is updated after writing out
> the data blocks, by clearing away the underbrush of dioread nolock
> first.
> 
> If we do this, we'd leave the dioread_nolock mount option for
> backwards compatibility, but it would be a no-op and not actually do
> anything.
> 
> Any objections before I look into ripping out dioread_nolock?
> 
> The one possible concern that I considered was for Alibaba, which was
> doing something interesting with dioread_nolock plus nodelalloc.  But
> looking at Liu Bo's explanation[2], I believe that their workload
> would be satisfied simply by using the standard ext4 mount options
> (that is, the default mode has the performance benefits when doing
> parallel DIO reads, and so the need for nodelalloc to mitigate the
> tail latency concerns which Alibaba was seeing in their workload would
> not be needed).  Could Liu or someone from Alibaba confirm, perhaps
> with some benchmarks using their workload?
Currently we don't use dioread_nolock & nodelalloc in our internal
servers, and we use dioread_nolock & delalloc widely, it works well.

The initial reason we use dioread_nolock is that it'll also allocate
unwritten extents for buffered write, and normally the corresponding
inode won't be added to jbd2 transaction's t_inode_list, so while
commiting transaction, it won't flush inodes' dirty pages, then
transaction will commit quickly, otherwise in extream case, the time
taking to flush dirty inodes will be very big, especially cgroup writeback
is enabled. A previous discussion: https://marc.info/?l=linux-fsdevel&m=151799957104768&w=2
I think this semantics hidden behind diread_nolock is also important,
so if planning to remove this mount option, we should keep same semantics.

Regards,
Xiaoguang Wang

> 
> [2] https://lore.kernel.org/linux-ext4/20181121013035.ab4xp7evjyschecy@US-160370MP2.local/
> 
>      	  	     	      	   	- Ted
> 
