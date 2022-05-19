Return-Path: <linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 409FEC433EF
	for <linux-ext4@archiver.kernel.org>; Thu, 19 May 2022 11:32:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236165AbiESLc3 (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Thu, 19 May 2022 07:32:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56656 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229483AbiESLcZ (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Thu, 19 May 2022 07:32:25 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E2C4EA7E00
        for <linux-ext4@vger.kernel.org>; Thu, 19 May 2022 04:32:23 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 99190B823E2
        for <linux-ext4@vger.kernel.org>; Thu, 19 May 2022 11:32:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 58262C385AA;
        Thu, 19 May 2022 11:32:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1652959941;
        bh=WSNgrScdYVOb8PdRhLZZOPUGsXRXWVNeSAmafVM+6aI=;
        h=Date:Subject:From:To:Cc:References:In-Reply-To:From;
        b=UGmFtSrBgYjFe/4zU7wHMc7NBG/UIVMQHNY2OXI++U9C+jtLXDxSco1laf133iBu0
         RU3/xC/xBgohjg3CY/eLKJRfhoPxKmPad3eA1wxTyW0IgfxsS285p9TWtizGSvNTWK
         /Eo++nJC+o9M6L3MTt9vp5L8jziYRQ3zN7th50lg4yMIbvS3kqwAdpVJVIHQjWjEfp
         7ZaD2tPkycWVEfQnoVD6yI/K2CJJjdMCJBtlOpoMwumx0qoP90YK2BjSewtslPh0/+
         ZiNZE7mz7gE611OFqnqErVlJApOnLu90Q2v+2KMhrP3yxCH76l0OHY1nwccbBOFEUz
         Y1Lxm5if0EOPA==
Message-ID: <86fa68bb-e80d-7fc1-a96e-18595e02247d@kernel.org>
Date:   Thu, 19 May 2022 19:32:17 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.9.0
Subject: Re: [f2fs-dev] [PATCH v5 2/8] f2fs: Simplify the handling of cached
 insensitive names
Content-Language: en-US
From:   Chao Yu <chao@kernel.org>
To:     Gabriel Krisman Bertazi <krisman@collabora.com>, tytso@mit.edu,
        adilger.kernel@dilger.ca, jaegeuk@kernel.org, ebiggers@kernel.org
Cc:     linux-ext4@vger.kernel.org, kernel@collabora.com,
        linux-f2fs-devel@lists.sourceforge.net
References: <20220518172320.333617-1-krisman@collabora.com>
 <20220518172320.333617-3-krisman@collabora.com>
 <fb8aaa09-7bfd-7e2a-4cb1-de691fdb6408@kernel.org>
In-Reply-To: <fb8aaa09-7bfd-7e2a-4cb1-de691fdb6408@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org

On 2022/5/19 19:27, Chao Yu wrote:
> On 2022/5/19 1:23, Gabriel Krisman Bertazi wrote:
>> Keeping it as qstr avoids the unnecessary conversion in f2fs_match
>>
>> Signed-off-by: Gabriel Krisman Bertazi <krisman@collabora.com>
> 
> Reviewed-by: Chao Yu <chao@kernel.org>

Oh, this should be replied to v6, sorry.

Thanks,

> 
> Thanks,
> 
> 
> _______________________________________________
> Linux-f2fs-devel mailing list
> Linux-f2fs-devel@lists.sourceforge.net
> https://lists.sourceforge.net/lists/listinfo/linux-f2fs-devel
