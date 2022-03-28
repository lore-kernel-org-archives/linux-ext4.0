Return-Path: <linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9EB29C433EF
	for <linux-ext4@archiver.kernel.org>; Mon, 28 Mar 2022 16:12:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241535AbiC1QOM (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Mon, 28 Mar 2022 12:14:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39152 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238518AbiC1QOL (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Mon, 28 Mar 2022 12:14:11 -0400
Received: from mail-pf1-x42f.google.com (mail-pf1-x42f.google.com [IPv6:2607:f8b0:4864:20::42f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 53D2762123
        for <linux-ext4@vger.kernel.org>; Mon, 28 Mar 2022 09:12:30 -0700 (PDT)
Received: by mail-pf1-x42f.google.com with SMTP id s11so13059957pfu.13
        for <linux-ext4@vger.kernel.org>; Mon, 28 Mar 2022 09:12:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=OYF/jvStaXgJs+lPLO95DLgpFNQWTZE9eUToA1rRs6g=;
        b=e+BGZaz9UF7wurI72M/5D45ULqW3ey6hXKY/Ts68ZgJK+22nFqMUvhRnEdRnUBpuvl
         qPQCU0In4ULU6FrtL4iIXhYl3zMBK19R+WUV7DTPh5cvUw6eRFk7AhjuMWBOTqlyWtQC
         nJKNVvqCmiJ+2LNK54Aq7rTRVFsfPFfRB/v6VG5I9BgHJXzNoHViwd1UmQgMDaSWQXpp
         2CS5wZFjeU2yLm1azU7lY7IbkgKzdX1RwEucQh4Bj2ntyML4fmuRyUdWr6bNzZXduSsv
         B679isvImDqKin6vhmJQq3ouLNW2MPfA9u+B75y+vagvE5heMpuBBBY2due9oOaT3xWM
         w8Ww==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=OYF/jvStaXgJs+lPLO95DLgpFNQWTZE9eUToA1rRs6g=;
        b=uU5fJgrwfn/+IS2XLJfIHBYirRRPc+0YQBqIwCibYaA/nHGoavNx3pvuwsbgVQiEGu
         +tOutwe7ldtVc+3JZovou4YHsx8koDHOia6KTgq09Ps+MNjfMchJLiKJsQLrRz7Mpct3
         RxPLfRhmnOJZa3spMsjNshCKmTm8CriVWylILQ9bngK7OPzOH5SH810xPg/4of31kDVk
         ENJmR1hoq+TwM6mNlo8VRkcYjnlOXfSblFo3gwHauiO5KEoLQuAcW/B5PAyQjvXbBORv
         uipcFgS4nSZ38UY46TIC5g1r93zmYALsS/MZSTSSDpvxppYpcjP0wpVPJ2pllWhxNpka
         uuxQ==
X-Gm-Message-State: AOAM532l7INkSaHsLPfN2XdNFcjXF8K48WyfIriGdhkmfosE5iKQBN8o
        f0/wnDflBDiTHy/djV4Z/q7o6nNmtKnsbaEP
X-Google-Smtp-Source: ABdhPJwufdTEwBp0S3JduRuquBjA87WlSM0qhzSDEaHQGglV4NKMddG55IsfZm3xx1Hl90qslp+rzw==
X-Received: by 2002:a63:3fcc:0:b0:398:ae5:6905 with SMTP id m195-20020a633fcc000000b003980ae56905mr10471109pga.463.1648483949404;
        Mon, 28 Mar 2022 09:12:29 -0700 (PDT)
Received: from [192.168.254.17] ([50.39.160.154])
        by smtp.gmail.com with ESMTPSA id z12-20020aa7888c000000b004f3fc6d95casm16878011pfe.20.2022.03.28.09.12.28
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 28 Mar 2022 09:12:28 -0700 (PDT)
Message-ID: <21f3fd84-2de9-646c-4d0c-94007a996c70@linaro.org>
Date:   Mon, 28 Mar 2022 09:12:27 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.7.0
Subject: Re: [PATCH v2] ext4: check if offset+length is valid in fallocate
Content-Language: en-US
To:     linux-ext4@vger.kernel.org
Cc:     Andreas Dilger <adilger.kernel@dilger.ca>,
        Ritesh Harjani <riteshh@linux.ibm.com>, stable@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        syzbot+7a806094edd5d07ba029@syzkaller.appspotmail.com,
        tytso@mit.edu
References: <20220315215439.269122-1-tadeusz.struk@linaro.org>
From:   Tadeusz Struk <tadeusz.struk@linaro.org>
In-Reply-To: <20220315215439.269122-1-tadeusz.struk@linaro.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org

On 3/15/22 14:54, Tadeusz Struk wrote:
> Syzbot found an issue [1] in ext4_fallocate().
> The C reproducer [2] calls fallocate(), passing size 0xffeffeff000ul,
> and offset 0x1000000ul, which, when added together exceed the disk size,
> and trigger a BUG in ext4_ind_remove_space() [3].
> According to the comment doc in ext4_ind_remove_space() the 'end' block
> parameter needs to be one block after the last block to remove.
> In the case when the BUG is triggered it points to the last block on
> a 4GB virtual disk image. This is calculated in
> ext4_ind_remove_space() in [4].
> This patch adds a check that ensure the length + offest to be
> within the valid range and returns -ENOSPC error code in case
> it is invalid.

Hi,
Any feedback on this?

-- 
Thanks,
Tadeusz
