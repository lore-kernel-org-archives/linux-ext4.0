Return-Path: <SRS0=honO=CQ=vger.kernel.org=linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.1 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 65F2AC43461
	for <linux-ext4@archiver.kernel.org>; Mon,  7 Sep 2020 16:24:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2F4FA20757
	for <linux-ext4@archiver.kernel.org>; Mon,  7 Sep 2020 16:24:11 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20150623.gappssmtp.com header.i=@kernel-dk.20150623.gappssmtp.com header.b="0AE+6gwe"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730505AbgIGQYJ (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Mon, 7 Sep 2020 12:24:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60874 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729988AbgIGQYD (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Mon, 7 Sep 2020 12:24:03 -0400
Received: from mail-pf1-x441.google.com (mail-pf1-x441.google.com [IPv6:2607:f8b0:4864:20::441])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2DA79C061575
        for <linux-ext4@vger.kernel.org>; Mon,  7 Sep 2020 09:24:03 -0700 (PDT)
Received: by mail-pf1-x441.google.com with SMTP id c196so3376962pfc.0
        for <linux-ext4@vger.kernel.org>; Mon, 07 Sep 2020 09:24:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=4YsnN1303DLyqvh22K/u/PKzYPbQQRqVlMMHZW3C9us=;
        b=0AE+6gwetZYIhZkP/Gn/AbnsMQFQJXBsA2WB6QCghlw0FcJWNQJA1qs4qh5J42bl1p
         pGhd6WQ/1r1vyg9aXGVG1TrnqpDlQ9tMVlDqMVGdNSLLfcvhuegRgHvXecypW09fh9n0
         suXHGxAfp93zhwMKmeTUPzS/Vm6nTDf9/hHhkvAIHzr9kLIMVmBifDJDrcZ4KiR4tHYy
         +N1xNNq7iFsQhL8RbxevbOYzrzsZKDwMIiHTwkCemNcV02Z6tzGqeS0Dt+bOsuzhX6Uz
         ptshVA0CiE1SnNMUyXI0mVCaHShXOnDZ7KeG3WF1/T8snIoDJwwEA0wn15P0EkchJCku
         9GfQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=4YsnN1303DLyqvh22K/u/PKzYPbQQRqVlMMHZW3C9us=;
        b=NhPbP0MmT9m1LLB8FDo7yoD9vTBvNRrnYMkzbsmqIo/EN8bOSVNntj0cydtzTLfjKg
         NZC+1pWpNjFYI09pcv551gZT+WnjDwshgyfMiiRItwBOdBZEN2xDTbPc/ZhV+13WY4Ui
         gn4MriApqYB/QniyJoZB74IcSQ5OfKEgbAVKXRTaaPGKq3IXqiYdPn34AuhRUrjBmNhF
         Ed3h4VzLc5QdFQ+IW8hJnq4hjHDKzWoCrKNdm3BcVlGKyqtTEOfD1PVWEe9ZY0eW7EKT
         6nUUb/VxIYYNlNs5QZexa5sGx7py2UvhDM4/tDVmfU4Ov/ox6KqBq2H2dOqzQtzJqs5j
         5B/A==
X-Gm-Message-State: AOAM531KM4iHH3yugUtoylaJD3ch/uH44G5ww+5mj7ZWKohZNN0AiP4i
        ObAu6pu6j48MCSuzb1y8/a1KkQ==
X-Google-Smtp-Source: ABdhPJyf5lAcbJjqkGAPLEJQb7OQRjLOQ1ubkkJGzJM97V4uSwDx153D5PuXUiROK9hbytjzCGMh2Q==
X-Received: by 2002:a62:6845:0:b029:13e:dcd:75bd with SMTP id d66-20020a6268450000b029013e0dcd75bdmr8381274pfc.12.1599495842666;
        Mon, 07 Sep 2020 09:24:02 -0700 (PDT)
Received: from [192.168.1.182] ([66.219.217.173])
        by smtp.gmail.com with ESMTPSA id nu14sm12450081pjb.19.2020.09.07.09.24.01
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 07 Sep 2020 09:24:02 -0700 (PDT)
Subject: Re: [PATCH 0/2 v2] bdev: Avoid discarding buffers under a filesystem
To:     Jan Kara <jack@suse.cz>, linux-fsdevel@vger.kernel.org
Cc:     linux-ext4@vger.kernel.org, linux-block@vger.kernel.org,
        Christoph Hellwig <hch@infradead.org>,
        yebin <yebin10@huawei.com>, Andreas Dilger <adilger@dilger.ca>
References: <20200904085852.5639-1-jack@suse.cz>
 <20200907103549.GA20428@quack2.suse.cz>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <2e287fe0-b963-0143-2a3f-617f32a67f76@kernel.dk>
Date:   Mon, 7 Sep 2020 10:24:01 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20200907103549.GA20428@quack2.suse.cz>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-ext4-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org

On 9/7/20 4:35 AM, Jan Kara wrote:
> Hello!
> 
> On Fri 04-09-20 10:58:50, Jan Kara wrote:
>> this patch set fixes problems when buffer heads are discarded under a
>> live filesystem (which can lead to all sorts of issues like crashes in case
>> of ext4). Patch 1 drops some stale buffer invalidation code, patch 2
>> temporarily gets exclusive access to the block device for the duration of
>> buffer cache handling to avoid interfering with other exclusive bdev user.
>> The patch fixes the problems for me and pass xfstests for ext4.
>>
>> Changes since v1:
>> * Check for exclusive access to the bdev instead of for the presence of
>>   superblock
> 
> Jens, now that Christoph has reviewed the patches (thanks Christoph!), can
> you pick up the patches to your tree please? Thanks!

Yep, I applied them for 5.10. Thanks!

-- 
Jens Axboe

