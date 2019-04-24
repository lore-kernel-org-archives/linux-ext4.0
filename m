Return-Path: <SRS0=cG1U=S2=vger.kernel.org=linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.3 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_MUTT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 62832C10F11
	for <linux-ext4@archiver.kernel.org>; Wed, 24 Apr 2019 05:35:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2C5CB2089F
	for <linux-ext4@archiver.kernel.org>; Wed, 24 Apr 2019 05:35:47 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="tToxiGC9"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729244AbfDXFfq (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Wed, 24 Apr 2019 01:35:46 -0400
Received: from bombadil.infradead.org ([198.137.202.133]:35098 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725919AbfDXFfq (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Wed, 24 Apr 2019 01:35:46 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=GdRz6mpnyndaqfDnE4AywZamrCucF5y5+WikrxK/Qlc=; b=tToxiGC9vPGKDVe4m/dtOhWqd
        Pa1yeE41pR37tZqbZGDnA7B7adt2HvXO82K0S56SzXS/5jbo3rRWvFKNi8KPZmvG46UcBPWNv1INJ
        OwgdMcFllUmDKAZhvAVHUvMDYut9TVNOfJv0IH930tzPka9BjaMHvuIlKRcUZ9z8Y8oOGx4WvdlNI
        Lde1od2DvBDHyQQ4xFt65CWGiJFmn5ywyu4wfM5AOQX9K2VzkeojJ86S8l5rThjQYiIa5n8sXDX6f
        26sMFrF5aEAvwLCZg4WJFasS2zQO4ckoCsRZ9s0PDXWz4qNk6uNWCJsRGUd2lAsxqPCi5n64Bi/he
        5CyS93GOQ==;
Received: from hch by bombadil.infradead.org with local (Exim 4.90_1 #2 (Red Hat Linux))
        id 1hJAZN-0004OR-3N; Wed, 24 Apr 2019 05:35:45 +0000
Date:   Tue, 23 Apr 2019 22:35:44 -0700
From:   Christoph Hellwig <hch@infradead.org>
To:     Chandan Rajendra <chandan@linux.ibm.com>
Cc:     linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org,
        linux-f2fs-devel@lists.sourceforge.net,
        linux-fscrypt@vger.kernel.org, tytso@mit.edu,
        adilger.kernel@dilger.ca, ebiggers@kernel.org, jaegeuk@kernel.org,
        yuchao0@huawei.com
Subject: Re: [PATCH V1 02/14] Consolidate "post read processing" into a new
 file
Message-ID: <20190424053544.GA12092@infradead.org>
References: <20190424043730.13683-1-chandan@linux.ibm.com>
 <20190424043730.13683-3-chandan@linux.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190424043730.13683-3-chandan@linux.ibm.com>
User-Agent: Mutt/1.9.2 (2017-12-15)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-ext4-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org

On Wed, Apr 24, 2019 at 10:07:18AM +0530, Chandan Rajendra wrote:
> +ifeq (y, $(firstword $(filter y,$(CONFIG_FS_ENCRYPTION) $(CONFIG_FS_VERITY))))
> +obj-y +=	post_read_process.o
> +endif

Please just add a new config option selected by the users.

Also I find the file name rather cumbersome.  Maybe just
read-callbacks.[co] ?
