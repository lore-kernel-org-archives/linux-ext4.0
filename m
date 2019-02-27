Return-Path: <SRS0=GcgC=RC=vger.kernel.org=linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,USER_AGENT_MUTT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D3A4AC10F06
	for <linux-ext4@archiver.kernel.org>; Wed, 27 Feb 2019 23:30:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A8E4E21850
	for <linux-ext4@archiver.kernel.org>; Wed, 27 Feb 2019 23:30:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730438AbfB0XaM (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Wed, 27 Feb 2019 18:30:12 -0500
Received: from mx1.redhat.com ([209.132.183.28]:50092 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730139AbfB0XaM (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Wed, 27 Feb 2019 18:30:12 -0500
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 7CB5030842B2;
        Wed, 27 Feb 2019 23:30:11 +0000 (UTC)
Received: from ming.t460p (ovpn-8-16.pek2.redhat.com [10.72.8.16])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 7E34F5E7A3;
        Wed, 27 Feb 2019 23:29:46 +0000 (UTC)
Date:   Thu, 28 Feb 2019 07:29:41 +0800
From:   Ming Lei <ming.lei@redhat.com>
To:     Jon Hunter <jonathanh@nvidia.com>
Cc:     Marek Szyprowski <m.szyprowski@samsung.com>,
        Jens Axboe <axboe@kernel.dk>, linux-block@vger.kernel.org,
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
Subject: Re: [PATCH V15 14/18] block: enable multipage bvecs
Message-ID: <20190227232940.GA13319@ming.t460p>
References: <20190215111324.30129-1-ming.lei@redhat.com>
 <20190215111324.30129-15-ming.lei@redhat.com>
 <CGME20190221084301eucas1p11e8841a62b4b1da3cccca661b6f4c29d@eucas1p1.samsung.com>
 <6c9ae4de-c56f-a2b3-2542-da7d8b95601d@samsung.com>
 <0dbbee64-5c6b-0374-4360-6dc218c70d58@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <0dbbee64-5c6b-0374-4360-6dc218c70d58@nvidia.com>
User-Agent: Mutt/1.9.1 (2017-09-22)
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.40]); Wed, 27 Feb 2019 23:30:12 +0000 (UTC)
Sender: linux-ext4-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org

On Wed, Feb 27, 2019 at 08:47:09PM +0000, Jon Hunter wrote:
> 
> On 21/02/2019 08:42, Marek Szyprowski wrote:
> > Dear All,
> > 
> > On 2019-02-15 12:13, Ming Lei wrote:
> >> This patch pulls the trigger for multi-page bvecs.
> >>
> >> Reviewed-by: Omar Sandoval <osandov@fb.com>
> >> Signed-off-by: Ming Lei <ming.lei@redhat.com>
> > 
> > Since Linux next-20190218 I've observed problems with block layer on one
> > of my test devices (Odroid U3 with EXT4 rootfs on SD card). Bisecting
> > this issue led me to this change. This is also the first linux-next
> > release with this change merged. The issue is fully reproducible and can
> > be observed in the following kernel log:
> > 
> > sdhci: Secure Digital Host Controller Interface driver
> > sdhci: Copyright(c) Pierre Ossman
> > s3c-sdhci 12530000.sdhci: clock source 2: mmc_busclk.2 (100000000 Hz)
> > s3c-sdhci 12530000.sdhci: Got CD GPIO
> > mmc0: SDHCI controller on samsung-hsmmc [12530000.sdhci] using ADMA
> > mmc0: new high speed SDHC card at address aaaa
> > mmcblk0: mmc0:aaaa SL16G 14.8 GiB
> I have also noticed some failures when writing to an eMMC device on one
> of our Tegra boards. We have a simple eMMC write/read test and it is
> currently failing because the data written does not match the source.
> 
> I did not seem the same crash as reported here, however, in our case the
> rootfs is NFS mounted and so probably would not. However, the bisect
> points to this commit and reverting on top of -next fixes the issues.

It is sdhci, probably related with max segment size, could you test the
following patch:

https://marc.info/?l=linux-mmc&m=155128334122951&w=2

Thanks,
Ming
