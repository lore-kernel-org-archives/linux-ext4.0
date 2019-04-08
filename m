Return-Path: <SRS0=EtEF=SK=vger.kernel.org=linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C093FC282DE
	for <linux-ext4@archiver.kernel.org>; Mon,  8 Apr 2019 08:22:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9092E208E3
	for <linux-ext4@archiver.kernel.org>; Mon,  8 Apr 2019 08:22:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726403AbfDHIWh (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Mon, 8 Apr 2019 04:22:37 -0400
Received: from lithops.sigma-star.at ([195.201.40.130]:34920 "EHLO
        lithops.sigma-star.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726005AbfDHIWh (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Mon, 8 Apr 2019 04:22:37 -0400
Received: from localhost (localhost [127.0.0.1])
        by lithops.sigma-star.at (Postfix) with ESMTP id E08EC6083252;
        Mon,  8 Apr 2019 10:22:34 +0200 (CEST)
Received: from lithops.sigma-star.at ([127.0.0.1])
        by localhost (lithops.sigma-star.at [127.0.0.1]) (amavisd-new, port 10032)
        with ESMTP id w3da_GCxnbQ0; Mon,  8 Apr 2019 10:22:34 +0200 (CEST)
Received: from localhost (localhost [127.0.0.1])
        by lithops.sigma-star.at (Postfix) with ESMTP id 96BEE6083257;
        Mon,  8 Apr 2019 10:22:34 +0200 (CEST)
Received: from lithops.sigma-star.at ([127.0.0.1])
        by localhost (lithops.sigma-star.at [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP id 1M5MoThCE2A4; Mon,  8 Apr 2019 10:22:34 +0200 (CEST)
Received: from blindfold.localnet (unknown [195.149.217.187])
        by lithops.sigma-star.at (Postfix) with ESMTPSA id B94A86083252;
        Mon,  8 Apr 2019 10:22:33 +0200 (CEST)
From:   Richard Weinberger <richard@nod.at>
To:     Eric Biggers <ebiggers@kernel.org>
Cc:     linux-fscrypt@vger.kernel.org, Miklos Szeredi <miklos@szeredi.hu>,
        linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org,
        linux-f2fs-devel@lists.sourceforge.net,
        linux-mtd@lists.infradead.org, linux-unionfs@vger.kernel.org,
        Sarthak Kukreti <sarthakkukreti@chromium.org>,
        Gao Xiang <gaoxiang25@huawei.com>
Subject: Re: [PATCH v2 0/5] fscrypt: d_revalidate fixes and cleanups
Date:   Mon, 08 Apr 2019 10:22:32 +0200
Message-ID: <1872467.qaoHDzFeKg@blindfold>
In-Reply-To: <20190401171119.GC131675@gmail.com>
References: <20190320183913.12686-1-ebiggers@kernel.org> <20190401171119.GC131675@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-ext4-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org

Am Montag, 1. April 2019, 19:11:21 CEST schrieb Eric Biggers:
 > Any more comments on these patches?  I'd like to apply them to the fscrypt tree
> for 5.2.  Richard, can you check whether these solve your overlayfs use case?
> Also, patch 5 could use Acks from ext4, f2fs, and ubifs people.

Will check this week, traveling right now.

Thanks,
//richard



