Return-Path: <SRS0=7ScE=O4=vger.kernel.org=linux-ext4-owner@kernel.org>
Received: from szxga05-in.huawei.com ([45.249.212.191]:16157 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726917AbeLSDfZ (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Tue, 18 Dec 2018 22:35:25 -0500
Subject: Re: [PATCH 1/2] ext4: fix race when setting the bitmap corrupted flag
 again
To: Wang Shilong <wshilong@ddn.com>,
        "linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>
References: <1545134401-104523-1-git-send-email-yi.zhang@huawei.com>
 <0861E7C3-E642-464F-8987-B7094EFD1B2B@ddn.com>
CC: "tytso@mit.edu" <tytso@mit.edu>,
        "adilger.kernel@dilger.ca" <adilger.kernel@dilger.ca>,
        "miaoxie@huawei.com" <miaoxie@huawei.com>
From: "zhangyi (F)" <yi.zhang@huawei.com>
Message-ID: <3e2b94e8-935e-b4bb-f40d-19aa3cce1d24@huawei.com>
Date: Wed, 19 Dec 2018 11:35:12 +0800
MIME-Version: 1.0
In-Reply-To: <0861E7C3-E642-464F-8987-B7094EFD1B2B@ddn.com>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 2018/12/18 22:25, Wang Shilong Wrote:
> Hi,
> 
> ﻿在 2018/12/18 下午7:57，“zhangyi (F)”<yi.zhang@huawei.com> 写入:
> 
>     Commit 9af0b3d12577 "ext4: fix race when setting the bitmap corrupted
>     flag" want to fix race between setting inode/block bitmap corrupted
>     flag and reducing free group inodes/clusters counter to prevent
>     multiple frees. But ext4_test_and_set_bit() will invoke
>     __test_and_set_bit() which is non-atomic, so the race is still there.
>     Fix this by invoke test_and_set_bit() instead.
>    
>     Fixes: 9af0b3d12577 ("ext4: fix race when setting the bitmap corrupted flag")
>     Signed-off-by: zhangyi (F) <yi.zhang@huawei.com>
> 
> Thanks for fixing this!, I was not aware of __test_and_set_bit() is not non-atomic operation before.
> 
> Reviewed-by: Wang Shilong <wshilong@ddn.com>
> 
> Btw for a stable process question, commit 9af0b3d12577 had CC tag to Stable kernel, should we
> add it again here or with 'Fixes' tag, it will be included automatically?
> 
Thank you for reminding me of the CC stable tag, I missed this tag and I'm not sure it
will be added automatically or not. Anyway, I will add this tag in the next iteration.

Thanks,
Yi.
