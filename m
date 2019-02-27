Return-Path: <SRS0=GcgC=RC=vger.kernel.org=linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0262BC43381
	for <linux-ext4@archiver.kernel.org>; Wed, 27 Feb 2019 20:47:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C329921850
	for <linux-ext4@archiver.kernel.org>; Wed, 27 Feb 2019 20:47:33 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=nvidia.com header.i=@nvidia.com header.b="X0dP0ili"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730190AbfB0UrY (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Wed, 27 Feb 2019 15:47:24 -0500
Received: from hqemgate14.nvidia.com ([216.228.121.143]:2174 "EHLO
        hqemgate14.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729291AbfB0UrY (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Wed, 27 Feb 2019 15:47:24 -0500
Received: from hqpgpgate101.nvidia.com (Not Verified[216.228.121.13]) by hqemgate14.nvidia.com (using TLS: TLSv1.2, DES-CBC3-SHA)
        id <B5c76f7630000>; Wed, 27 Feb 2019 12:47:31 -0800
Received: from hqmail.nvidia.com ([172.20.161.6])
  by hqpgpgate101.nvidia.com (PGP Universal service);
  Wed, 27 Feb 2019 12:47:22 -0800
X-PGP-Universal: processed;
        by hqpgpgate101.nvidia.com on Wed, 27 Feb 2019 12:47:22 -0800
Received: from [10.26.11.186] (10.124.1.5) by HQMAIL101.nvidia.com
 (172.20.187.10) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Wed, 27 Feb
 2019 20:47:12 +0000
Subject: Re: [PATCH V15 14/18] block: enable multipage bvecs
To:     Marek Szyprowski <m.szyprowski@samsung.com>,
        Ming Lei <ming.lei@redhat.com>, Jens Axboe <axboe@kernel.dk>
CC:     <linux-block@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-mm@kvack.org>, Theodore Ts'o <tytso@mit.edu>,
        Omar Sandoval <osandov@fb.com>,
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
From:   Jon Hunter <jonathanh@nvidia.com>
Message-ID: <0dbbee64-5c6b-0374-4360-6dc218c70d58@nvidia.com>
Date:   Wed, 27 Feb 2019 20:47:09 +0000
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.4.0
MIME-Version: 1.0
In-Reply-To: <6c9ae4de-c56f-a2b3-2542-da7d8b95601d@samsung.com>
X-Originating-IP: [10.124.1.5]
X-ClientProxiedBy: HQMAIL105.nvidia.com (172.20.187.12) To
 HQMAIL101.nvidia.com (172.20.187.10)
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1551300451; bh=fysy4W1JsLJNGtNiqBcR+gaIGLkCCRdCGseNbvSiG5A=;
        h=X-PGP-Universal:Subject:To:CC:References:From:Message-ID:Date:
         User-Agent:MIME-Version:In-Reply-To:X-Originating-IP:
         X-ClientProxiedBy:Content-Type:Content-Language:
         Content-Transfer-Encoding;
        b=X0dP0iliVFercVqWdMyW/NR2Nhm0eLApUzdqUyISSWUx2H+DKhUu/OKtqWe2+3ZuT
         au4eOklUFmE4Gr2obXchzT8IXOfMhcyX4FkEsLxzHW0xgKT/h6CV7784HRm5efp90O
         La7tft6R64o+psxbqoi6GCRY4KpDinbyuM578z8ZIBlOABzOuvOkGz6q77lXYGVw0F
         i4IUbygeJkCCpZ0U5/kCdyLBwxOPIqZvceHCPKG8aMbmcU8ubwJyoq9ClYgVHYmDHM
         dxcWgdcM3oW54O+MFPY5/ZPt1Zh31nOGXIQBPU0L01WBNStNQbbLPLk/T1RrJziyxj
         hseLr65aHTomg==
Sender: linux-ext4-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org


On 21/02/2019 08:42, Marek Szyprowski wrote:
> Dear All,
> 
> On 2019-02-15 12:13, Ming Lei wrote:
>> This patch pulls the trigger for multi-page bvecs.
>>
>> Reviewed-by: Omar Sandoval <osandov@fb.com>
>> Signed-off-by: Ming Lei <ming.lei@redhat.com>
> 
> Since Linux next-20190218 I've observed problems with block layer on one
> of my test devices (Odroid U3 with EXT4 rootfs on SD card). Bisecting
> this issue led me to this change. This is also the first linux-next
> release with this change merged. The issue is fully reproducible and can
> be observed in the following kernel log:
> 
> sdhci: Secure Digital Host Controller Interface driver
> sdhci: Copyright(c) Pierre Ossman
> s3c-sdhci 12530000.sdhci: clock source 2: mmc_busclk.2 (100000000 Hz)
> s3c-sdhci 12530000.sdhci: Got CD GPIO
> mmc0: SDHCI controller on samsung-hsmmc [12530000.sdhci] using ADMA
> mmc0: new high speed SDHC card at address aaaa
> mmcblk0: mmc0:aaaa SL16G 14.8 GiB
I have also noticed some failures when writing to an eMMC device on one
of our Tegra boards. We have a simple eMMC write/read test and it is
currently failing because the data written does not match the source.

I did not seem the same crash as reported here, however, in our case the
rootfs is NFS mounted and so probably would not. However, the bisect
points to this commit and reverting on top of -next fixes the issues.

Cheers
Jon

-- 
nvpublic
