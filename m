Return-Path: <SRS0=tfh/=RD=vger.kernel.org=linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 16BBBC43381
	for <linux-ext4@archiver.kernel.org>; Thu, 28 Feb 2019 07:51:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C6D4C21850
	for <linux-ext4@archiver.kernel.org>; Thu, 28 Feb 2019 07:51:48 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="OEitEhmg"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726127AbfB1Hvs (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Thu, 28 Feb 2019 02:51:48 -0500
Received: from mailout2.w1.samsung.com ([210.118.77.12]:49506 "EHLO
        mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725896AbfB1Hvr (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Thu, 28 Feb 2019 02:51:47 -0500
Received: from eucas1p1.samsung.com (unknown [182.198.249.206])
        by mailout2.w1.samsung.com (KnoxPortal) with ESMTP id 20190228075144euoutp029d66d76c4cb628d9849010dfb9eff93c~Hd8mjFpb81598015980euoutp02o;
        Thu, 28 Feb 2019 07:51:44 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout2.w1.samsung.com 20190228075144euoutp029d66d76c4cb628d9849010dfb9eff93c~Hd8mjFpb81598015980euoutp02o
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1551340304;
        bh=lK4OWNOVuPptmombO8Le5QI8Xei5HzbQ63F3nd2QMuE=;
        h=Subject:To:Cc:From:Date:In-Reply-To:References:From;
        b=OEitEhmg6xm1xNGq9a7lMWdvcdbmRpoQQlTTyaQVBnLfPiRLhoGVtK/nqSMWe5150
         PJBorZxXTTIxw0xi+1zpGEvRd1cdPD+EhmV9Y84INkhrRwxuPAELK5mCIkOBW/U/Nj
         4nQd9yMaV3lsz6H0KInKfTkJggkU/aZOp/P5ToZ0=
Received: from eusmges3new.samsung.com (unknown [203.254.199.245]) by
        eucas1p2.samsung.com (KnoxPortal) with ESMTP id
        20190228075144eucas1p2ab4f16e339afc9266c8ccf636ad7aab2~Hd8mGHZii1866118661eucas1p2i;
        Thu, 28 Feb 2019 07:51:44 +0000 (GMT)
Received: from eucas1p2.samsung.com ( [182.198.249.207]) by
        eusmges3new.samsung.com (EUCPMTA) with SMTP id D9.7B.04806.F03977C5; Thu, 28
        Feb 2019 07:51:43 +0000 (GMT)
Received: from eusmtrp1.samsung.com (unknown [182.198.249.138]) by
        eucas1p1.samsung.com (KnoxPortal) with ESMTPA id
        20190228075142eucas1p1e9d84ec53a10294a72316b3c43235949~Hd8lE3fPQ0079100791eucas1p1r;
        Thu, 28 Feb 2019 07:51:42 +0000 (GMT)
Received: from eusmgms2.samsung.com (unknown [182.198.249.180]) by
        eusmtrp1.samsung.com (KnoxPortal) with ESMTP id
        20190228075142eusmtrp1554cde5ac094e3de6c2ada0b657d9b94~Hd8kzAFzc0177101771eusmtrp1E;
        Thu, 28 Feb 2019 07:51:42 +0000 (GMT)
X-AuditID: cbfec7f5-34dff700000012c6-5d-5c77930f4636
Received: from eusmtip1.samsung.com ( [203.254.199.221]) by
        eusmgms2.samsung.com (EUCPMTA) with SMTP id 1E.57.04128.E03977C5; Thu, 28
        Feb 2019 07:51:42 +0000 (GMT)
Received: from [106.116.147.30] (unknown [106.116.147.30]) by
        eusmtip1.samsung.com (KnoxPortal) with ESMTPA id
        20190228075141eusmtip192f07709203f64ab50824324fb4ec67b~Hd8jbN6SF2947929479eusmtip1P;
        Thu, 28 Feb 2019 07:51:41 +0000 (GMT)
Subject: Re: [PATCH V15 14/18] block: enable multipage bvecs
To:     Ming Lei <ming.lei@redhat.com>, Jon Hunter <jonathanh@nvidia.com>
Cc:     Jens Axboe <axboe@kernel.dk>, linux-block@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        Theodore Ts'o <tytso@mit.edu>, Omar Sandoval <osandov@fb.com>,
        Sagi Grimberg <sagi@grimberg.me>,
        Dave Chinner <dchinner@redhat.com>,
        Kent Overstreet <kent.overstreet@gmail.com>,
        Mike Snitzer <snitzer@redhat.com>, dm-devel@redhat.com,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        linux-fsdevel@vger.kernel.org, linux-raid@vger.kernel.org,
        David Sterba <dsterba@suse.com>, linux-btrfs@vger.kernel.org,
        "Darrick J . Wong" <darrick.wong@oracle.com>,
        linux-xfs@vger.kernel.org, Gao Xiang <gaoxiang25@huawei.com>,
        Christoph Hellwig <hch@lst.de>, linux-ext4@vger.kernel.org,
        Coly Li <colyli@suse.de>, linux-bcache@vger.kernel.org,
        Boaz Harrosh <ooo@electrozaur.com>,
        Bob Peterson <rpeterso@redhat.com>, cluster-devel@redhat.com,
        Ulf Hansson <ulf.hansson@linaro.org>,
        "linux-mmc@vger.kernel.org" <linux-mmc@vger.kernel.org>,
        'Linux Samsung SOC' <linux-samsung-soc@vger.kernel.org>,
        Krzysztof Kozlowski <krzk@kernel.org>,
        Adrian Hunter <adrian.hunter@intel.com>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        linux-tegra <linux-tegra@vger.kernel.org>
From:   Marek Szyprowski <m.szyprowski@samsung.com>
Message-ID: <01155e88-f021-fbe2-d048-42e303fe2935@samsung.com>
Date:   Thu, 28 Feb 2019 08:51:40 +0100
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:60.0) Gecko/20100101
        Thunderbird/60.5.1
MIME-Version: 1.0
In-Reply-To: <20190227232940.GA13319@ming.t460p>
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-Brightmail-Tracker: H4sIAAAAAAAAA01SbUxTZxjde7/b7LJrZeGd+8rqRqZkAplkTzIkLnHJTcyWZX8MjmWr46Y4
        aSW9ApP9AYoCpaDCFssFp4NEKVQYRBFrS2b56CqSqxIcEsCFj23SlMYNt5E41Pbixr/zPuec
        9zkneTjS8CuzidtvPSTZrKZ8I6OneodX1LeeayjOSZtyp0No3sNAx/QxBrpdXTSEOuYYOFmm
        sjAdvUTD6OIpFvxLTTTc+KeMgOXVcRrcHUMEVCgtFAyWl4Cq/sDCcO9tAvyTKXBrro2Fxu+m
        GPD5QxSMeZsZmPE8omHw0TEElae9CFxqPwHVywoD3od9LAQa7AT8Hk6GgZlxChxNRxjoDEcp
        ONr9AMER5woLwfN7QP03SO/cLHYuu2jxhH2JFS8r06yoznRTYsVghBZbffcIcWy0UOxpr2bE
        nj/qWXHqto8Rr9wpZcTy60OkWGtfYsT7C5OUGO0fZ8S6C+3oo8S9+sxcKX9/kWRLzfpcn2e/
        28oWDAlfTazW0KWoj3cgHYeF7bjj4jDhQHrOILQhHDo1R8QIg7CMsNqdoRF/Inzv5xHmqaN/
        oYzSROcQPvvTZk0URXjiaoSMERuFTDx71oMciOUShffxbHZMQgpuHfYHFuJeRkjHjogj/icv
        ZOFvr6hPMMdRwhu4rjEzBp8XcnCgtUhTbMChxvm4Uyek4cv33SiGSeFVfCnSTGo4CU/On453
        wcKADlcHZtYi78K+651reCNeDF5gNfwSHmlwUprBjnClS2G1hxPhi819a4538UDwJh1LRApb
        cJc3VRu/h7/3d8XHWEjAE5ENWogEXN97ktTGPK46atDUyVgJdv639uqNW+RxZFTWVVPW1VHW
        1VH+33sGUe0oSSqULWZJftsqFW+TTRa50Gre9sVBSw96cv0jq8EHfaj/4b4AEjhkfJZ/01mU
        Y6BNRfJhSwBhjjQm8t6q4hwDn2s6XCLZDn5mK8yX5AB6kaOMSfzXz/zyiUEwmw5JBySpQLI9
        ZQlOt6kUbffs1V+rWDLzv1V0fUiW/+Uubf3SnNFTlzn9cpsnOfxOFfPj8X0E/YrrblN+8Zh7
        9sBNqaYJMhK+Mf/9aaVl+INs0p+yS9pJVIW31OZad+eJltGP66WsEX7KecfX8lrJorNAplN3
        rNSm1MDWa69nO6MvhFfOB3ZPnGlJOzEKRiMl55nSt5I22fQYCAgPtvkDAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA02Se0xTdxTH87vvktVcC4ZfGMlmjW7RrFIq64GwxmSa/NSYmJhsETHayU0h
        o63pbXGwxJSHOjvmi6hQVJYBKk+lM4IILOMhaRi5C6SEEYtbhUVUYCLGkWG10Jnw3yfnfD/n
        5CRHoDX/sQlCjs0pOWzmXC0XwwyE+4OfrCo7mpkU+GUD+CcaOWgInuGgpfwmC/6GRxxcKlR4
        CM62sjD45AoPnTOVLPz+byEF8+EAC3UNfRSUeH9ioLeoABTlFg/374xQ0Dm2CYYe3eCh4uoD
        Djo6/QwMt1/mYLzxDQu9b84gOFnVjqBc6aLg1LyXg/bFNh66y4opePx0A/SMBxjwVB7noPnp
        LAMnWl4iOF66wEN/05egvO5nt64jzfPlLDlXPMOTu94gT5TxFoaU9E6zpLpjiiLDgy7iqz/F
        Ed/ceZ48GOngyL0/3Bwp+q2PJj8Uz3Dk+eQYQ2a7Ahw5fbse7YnL0KU77C6n9GG2XXZ+pt2v
        h2SdPhV0yVtSdXqD8UBacop2syk9S8rNyZMcm02HdNnFD6v5I33iN6Ph71k3alN7kErA4hbc
        NVnIeFCMoBFrEfZeDzHRRiL2X3SzUY7FiyMeLhqaRrjmwmO01IgV03HoWmOEeSFO3I5D+5Yi
        tNikwqEbQTqaH6Dw3LW/l4dyoh57ppcGqQS1aMIX7ikRFgRGXI9PV6QvldeImfif4CgVjazG
        /oqJZVUlJuG7z+uW19LiR3jx6hAd5Q9w6/Tl/zkej01UUWeRxrtC965QvCsU7wrlR8TUozjJ
        JVstVjlZJ5utsstm0R22W30o8nh37i/cbkOemb3dSBSQ9j31x6V5mRrWnCfnW7sRFmhtnLr9
        u6OZGnWWOb9ActgPOly5ktyNUiK3naMT1hy2R97Y5jyoT9EbIVVvNBgNn4I2Xq0k5WdoRIvZ
        KX0tSUckxzuPElQJblT2ctjeZTj2ouXzQ4uu+Gc7/9xWn7Vx9NvrnolxqiqALSlTQ09Sf64Y
        +Kvm7ENlt6VhR2l41r0glbxIdIQ0Te8/q2t9tYvUlDf7fv3Kn/Yqls+otpl6Bk1SQm58QYex
        cpNT3bNVGEurCTDzJYaptb7EnOov1oVjJmuLdMdqz++b0zJytlm/kXbI5reoanrQjgMAAA==
X-CMS-MailID: 20190228075142eucas1p1e9d84ec53a10294a72316b3c43235949
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-RootMTR: 20190221084301eucas1p11e8841a62b4b1da3cccca661b6f4c29d
X-EPHeader: CA
CMS-TYPE: 201P
X-CMS-RootMailID: 20190221084301eucas1p11e8841a62b4b1da3cccca661b6f4c29d
References: <20190215111324.30129-1-ming.lei@redhat.com>
        <20190215111324.30129-15-ming.lei@redhat.com>
        <CGME20190221084301eucas1p11e8841a62b4b1da3cccca661b6f4c29d@eucas1p1.samsung.com>
        <6c9ae4de-c56f-a2b3-2542-da7d8b95601d@samsung.com>
        <0dbbee64-5c6b-0374-4360-6dc218c70d58@nvidia.com>
        <20190227232940.GA13319@ming.t460p>
Sender: linux-ext4-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org

Hi Ming,

On 2019-02-28 00:29, Ming Lei wrote:
> On Wed, Feb 27, 2019 at 08:47:09PM +0000, Jon Hunter wrote:
>> On 21/02/2019 08:42, Marek Szyprowski wrote:
>>> On 2019-02-15 12:13, Ming Lei wrote:
>>>> This patch pulls the trigger for multi-page bvecs.
>>>>
>>>> Reviewed-by: Omar Sandoval <osandov@fb.com>
>>>> Signed-off-by: Ming Lei <ming.lei@redhat.com>
>>> Since Linux next-20190218 I've observed problems with block layer on one
>>> of my test devices (Odroid U3 with EXT4 rootfs on SD card). Bisecting
>>> this issue led me to this change. This is also the first linux-next
>>> release with this change merged. The issue is fully reproducible and can
>>> be observed in the following kernel log:
>>>
>>> sdhci: Secure Digital Host Controller Interface driver
>>> sdhci: Copyright(c) Pierre Ossman
>>> s3c-sdhci 12530000.sdhci: clock source 2: mmc_busclk.2 (100000000 Hz)
>>> s3c-sdhci 12530000.sdhci: Got CD GPIO
>>> mmc0: SDHCI controller on samsung-hsmmc [12530000.sdhci] using ADMA
>>> mmc0: new high speed SDHC card at address aaaa
>>> mmcblk0: mmc0:aaaa SL16G 14.8 GiB
>> I have also noticed some failures when writing to an eMMC device on one
>> of our Tegra boards. We have a simple eMMC write/read test and it is
>> currently failing because the data written does not match the source.
>>
>> I did not seem the same crash as reported here, however, in our case the
>> rootfs is NFS mounted and so probably would not. However, the bisect
>> points to this commit and reverting on top of -next fixes the issues.
> It is sdhci, probably related with max segment size, could you test the
> following patch:
>
> https://marc.info/?l=linux-mmc&m=155128334122951&w=2

This seems to be fixing my issue too! Thanks!

It also fixed the boot issue from USB stick (Exynos EHCI / Mass
Storage), but I suspect that reading the partition table from the sd
card (which hold the bootloader and thus must be present to boot the
device) was enough to trash memory/page cache and break the boot process.

Best regards
-- 
Marek Szyprowski, PhD
Samsung R&D Institute Poland

