Return-Path: <SRS0=tfh/=RD=vger.kernel.org=linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1856BC10F00
	for <linux-ext4@archiver.kernel.org>; Thu, 28 Feb 2019 12:39:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D9DCE206DD
	for <linux-ext4@archiver.kernel.org>; Thu, 28 Feb 2019 12:39:32 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=nvidia.com header.i=@nvidia.com header.b="IbMr9pBJ"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731904AbfB1MjX (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Thu, 28 Feb 2019 07:39:23 -0500
Received: from hqemgate15.nvidia.com ([216.228.121.64]:15242 "EHLO
        hqemgate15.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731179AbfB1MjW (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Thu, 28 Feb 2019 07:39:22 -0500
Received: from hqpgpgate101.nvidia.com (Not Verified[216.228.121.13]) by hqemgate15.nvidia.com (using TLS: TLSv1.2, DES-CBC3-SHA)
        id <B5c77d6710001>; Thu, 28 Feb 2019 04:39:13 -0800
Received: from hqmail.nvidia.com ([172.20.161.6])
  by hqpgpgate101.nvidia.com (PGP Universal service);
  Thu, 28 Feb 2019 04:39:18 -0800
X-PGP-Universal: processed;
        by hqpgpgate101.nvidia.com on Thu, 28 Feb 2019 04:39:18 -0800
Received: from [10.21.132.148] (10.124.1.5) by HQMAIL101.nvidia.com
 (172.20.187.10) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Thu, 28 Feb
 2019 12:39:11 +0000
Subject: Re: [PATCH V15 14/18] block: enable multipage bvecs
To:     Marek Szyprowski <m.szyprowski@samsung.com>,
        Ming Lei <ming.lei@redhat.com>
CC:     Jens Axboe <axboe@kernel.dk>, <linux-block@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <linux-mm@kvack.org>,
        Theodore Ts'o <tytso@mit.edu>, Omar Sandoval <osandov@fb.com>,
        Sagi Grimberg <sagi@grimberg.me>,
        Dave Chinner <dchinner@redhat.com>,
        Kent Overstreet <kent.overstreet@gmail.com>,
        Mike Snitzer <snitzer@redhat.com>, <dm-devel@redhat.com>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        <linux-fsdevel@vger.kernel.org>, <linux-raid@vger.kernel.org>,
        David Sterba <dsterba@suse.com>, <linux-btrfs@vger.kernel.org>,
        "Darrick J . Wong" <darrick.wong@oracle.com>,
        <linux-xfs@vger.kernel.org>, Gao Xiang <gaoxiang25@huawei.com>,
        Christoph Hellwig <hch@lst.de>, <linux-ext4@vger.kernel.org>,
        Coly Li <colyli@suse.de>, <linux-bcache@vger.kernel.org>,
        Boaz Harrosh <ooo@electrozaur.com>,
        Bob Peterson <rpeterso@redhat.com>, <cluster-devel@redhat.com>,
        Ulf Hansson <ulf.hansson@linaro.org>,
        "linux-mmc@vger.kernel.org" <linux-mmc@vger.kernel.org>,
        'Linux Samsung SOC' <linux-samsung-soc@vger.kernel.org>,
        Krzysztof Kozlowski <krzk@kernel.org>,
        Adrian Hunter <adrian.hunter@intel.com>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        linux-tegra <linux-tegra@vger.kernel.org>
References: <20190215111324.30129-1-ming.lei@redhat.com>
 <20190215111324.30129-15-ming.lei@redhat.com>
 <CGME20190221084301eucas1p11e8841a62b4b1da3cccca661b6f4c29d@eucas1p1.samsung.com>
 <6c9ae4de-c56f-a2b3-2542-da7d8b95601d@samsung.com>
 <0dbbee64-5c6b-0374-4360-6dc218c70d58@nvidia.com>
 <20190227232940.GA13319@ming.t460p>
 <01155e88-f021-fbe2-d048-42e303fe2935@samsung.com>
From:   Jon Hunter <jonathanh@nvidia.com>
Message-ID: <83c1e25b-4aab-4374-e160-b506eea9e68f@nvidia.com>
Date:   Thu, 28 Feb 2019 12:39:10 +0000
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.4.0
MIME-Version: 1.0
In-Reply-To: <01155e88-f021-fbe2-d048-42e303fe2935@samsung.com>
X-Originating-IP: [10.124.1.5]
X-ClientProxiedBy: HQMAIL104.nvidia.com (172.18.146.11) To
 HQMAIL101.nvidia.com (172.20.187.10)
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1551357553; bh=kyaLnB1yS2uNDTq/sCdbM9/derGqD4nWTMhtRkekS5s=;
        h=X-PGP-Universal:Subject:To:CC:References:From:Message-ID:Date:
         User-Agent:MIME-Version:In-Reply-To:X-Originating-IP:
         X-ClientProxiedBy:Content-Type:Content-Language:
         Content-Transfer-Encoding;
        b=IbMr9pBJuBI/5AbD0dC5l3dawgXept/qlylzk0GIjWO3kmfIarTR/gWqLma/G6QW7
         QA1IecDz5AXvEeEa1vA8ApQJcym13C8r5dqcQJFUMSda6+U4j4lZ0V6gU4W7aamSrX
         m+JRZW58fX6DtULpWLS9BsSfa4PjeWfP/3xcaEB3c22HZyi7lEpqH4l8AWCCiQl0D7
         g8u2jtc3u01z33ZlZnGhXxk8gfT8LjZKgnLHRyeI+MxQUVwCBl4wHHBT/S1/WwV1cO
         e8wdRmwYaz3kMXRbC2iR1CDKeIJRnxvt4wP6qPVIH0DtIGLgbocKla2k/F6gPPwt7J
         oVQzg1220HnDQ==
Sender: linux-ext4-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org


On 28/02/2019 07:51, Marek Szyprowski wrote:
> Hi Ming,
> 
> On 2019-02-28 00:29, Ming Lei wrote:
>> On Wed, Feb 27, 2019 at 08:47:09PM +0000, Jon Hunter wrote:
>>> On 21/02/2019 08:42, Marek Szyprowski wrote:
>>>> On 2019-02-15 12:13, Ming Lei wrote:
>>>>> This patch pulls the trigger for multi-page bvecs.
>>>>>
>>>>> Reviewed-by: Omar Sandoval <osandov@fb.com>
>>>>> Signed-off-by: Ming Lei <ming.lei@redhat.com>
>>>> Since Linux next-20190218 I've observed problems with block layer on one
>>>> of my test devices (Odroid U3 with EXT4 rootfs on SD card). Bisecting
>>>> this issue led me to this change. This is also the first linux-next
>>>> release with this change merged. The issue is fully reproducible and can
>>>> be observed in the following kernel log:
>>>>
>>>> sdhci: Secure Digital Host Controller Interface driver
>>>> sdhci: Copyright(c) Pierre Ossman
>>>> s3c-sdhci 12530000.sdhci: clock source 2: mmc_busclk.2 (100000000 Hz)
>>>> s3c-sdhci 12530000.sdhci: Got CD GPIO
>>>> mmc0: SDHCI controller on samsung-hsmmc [12530000.sdhci] using ADMA
>>>> mmc0: new high speed SDHC card at address aaaa
>>>> mmcblk0: mmc0:aaaa SL16G 14.8 GiB
>>> I have also noticed some failures when writing to an eMMC device on one
>>> of our Tegra boards. We have a simple eMMC write/read test and it is
>>> currently failing because the data written does not match the source.
>>>
>>> I did not seem the same crash as reported here, however, in our case the
>>> rootfs is NFS mounted and so probably would not. However, the bisect
>>> points to this commit and reverting on top of -next fixes the issues.
>> It is sdhci, probably related with max segment size, could you test the
>> following patch:
>>
>> https://marc.info/?l=linux-mmc&m=155128334122951&w=2
> 
> This seems to be fixing my issue too! Thanks!

Thanks, I can confirm this fixes the issue for Tegra. So feel free to
add my ...

Tested-by: Jon Hunter <jonathanh@nvidia.com>

Cheers!
Jon

-- 
nvpublic
