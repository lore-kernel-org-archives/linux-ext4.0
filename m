Return-Path: <linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 69298C433F5
	for <linux-ext4@archiver.kernel.org>; Tue, 11 Oct 2022 11:23:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229885AbiJKLXp (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Tue, 11 Oct 2022 07:23:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53034 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229862AbiJKLXm (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Tue, 11 Oct 2022 07:23:42 -0400
Received: from out30-43.freemail.mail.aliyun.com (out30-43.freemail.mail.aliyun.com [115.124.30.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 81A4274B9E;
        Tue, 11 Oct 2022 04:23:37 -0700 (PDT)
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R211e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=ay29a033018046050;MF=cuibixuan@linux.alibaba.com;NM=1;PH=DS;RN=8;SR=0;TI=SMTPD_---0VRxIyWq_1665487410;
Received: from 30.221.148.143(mailfrom:cuibixuan@linux.alibaba.com fp:SMTPD_---0VRxIyWq_1665487410)
          by smtp.aliyun-inc.com;
          Tue, 11 Oct 2022 19:23:32 +0800
Message-ID: <9ac447b9-0cb5-2b03-12b5-9c3f1cc7e5fe@linux.alibaba.com>
Date:   Tue, 11 Oct 2022 19:23:30 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.11.0
Subject: Re: [PATCH -next] jbd2: use the correct print format
To:     Jason Yan <yanaijie@huawei.com>, rostedt@goodmis.org,
        mhiramat@kernel.org, bvanassche@acm.org, axboe@kernel.dk,
        tytso@mit.edu, linux-kernel@vger.kernel.org,
        linux-ext4@vger.kernel.org
References: <1665389343-35572-1-git-send-email-cuibixuan@linux.alibaba.com>
 <c30377f7-f9b8-5774-b509-a4285210b40f@huawei.com>
From:   Bixuan Cui <cuibixuan@linux.alibaba.com>
In-Reply-To: <c30377f7-f9b8-5774-b509-a4285210b40f@huawei.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org


在 2022/10/10 22:35, Jason Yan 写道:
> While you are at it, can you make all the tid tracing consistent. Some 
> tracing points using unsigned long such as:
>
> TRACE_EVENT(jbd2_handle_extend,
>     TP_PROTO(dev_t dev, unsigned long tid, unsigned int type,
>          unsigned int line_no, int buffer_credits,
>          int requested_blocks),
>
>     TP_ARGS(dev, tid, type, line_no, buffer_credits, requested_blocks),
>
>
> and the caller passing transaction->t_tid which is tid_t(unsigned int).
>
>     trace_jbd2_handle_extend(journal->j_fs_dev->bd_dev,
>                  transaction->t_tid,
>                  handle->h_type, handle->h_line_no,
>                  handle->h_total_credits,
>                  nblocks); 

Ok, I'll send another patch to fix this problem.


Thanks

Bixuan Cui

