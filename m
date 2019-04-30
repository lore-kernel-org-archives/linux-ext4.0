Return-Path: <SRS0=jspb=TA=vger.kernel.org=linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.3 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_MUTT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4396DC43219
	for <linux-ext4@archiver.kernel.org>; Tue, 30 Apr 2019 00:27:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0752B2147A
	for <linux-ext4@archiver.kernel.org>; Tue, 30 Apr 2019 00:27:54 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="YTefPEPM"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729590AbfD3A1x (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Mon, 29 Apr 2019 20:27:53 -0400
Received: from bombadil.infradead.org ([198.137.202.133]:35874 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729214AbfD3A1x (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Mon, 29 Apr 2019 20:27:53 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=rnbpRN3dar3hMqFtw7MpyRrExSiExRk5urYTkAAt6BU=; b=YTefPEPMxTD/ZjtLJweKoH7Qa
        KisDhWLCjoqjsnKTFZL7mG8uHi9ur/swxe9/kB/6bJmaC6arTAVM07YTec63b4wB6XHKH2RHz/9iY
        JJQG4AhrwPrIzaUyenGidF/lz4OLc8Kawg8pEYvgLKyWljW03YYJ0IKTb3rOmg5dey1nSi1nFwKCN
        BLGkJMbnvAYQVTHPthFxH/CKcXnc7ljSGx6pNJLDPjjhijY1n40Qr+4NzEig2HPslInl0XmBnF2+R
        nCvhNz3Ayja7QMoVtNQfR9Bn3R1B7PlCUll27UmZwwoac7aFWosyxMrqWrddTN40je59GwxJqTo91
        tV0VTaCrg==;
Received: from willy by bombadil.infradead.org with local (Exim 4.90_1 #2 (Red Hat Linux))
        id 1hLGci-0007mB-5o; Tue, 30 Apr 2019 00:27:52 +0000
Date:   Mon, 29 Apr 2019 17:27:51 -0700
From:   Matthew Wilcox <willy@infradead.org>
To:     Chandan Rajendra <chandan@linux.ibm.com>
Cc:     linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org,
        linux-f2fs-devel@lists.sourceforge.net,
        linux-fscrypt@vger.kernel.org, tytso@mit.edu,
        adilger.kernel@dilger.ca, ebiggers@kernel.org, jaegeuk@kernel.org,
        yuchao0@huawei.com, hch@infradead.org
Subject: Re: [PATCH V2 00/13] Consolidate FS read I/O callbacks code
Message-ID: <20190430002751.GB13796@bombadil.infradead.org>
References: <20190428043121.30925-1-chandan@linux.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190428043121.30925-1-chandan@linux.ibm.com>
User-Agent: Mutt/1.9.2 (2017-12-15)
Sender: linux-ext4-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org

On Sun, Apr 28, 2019 at 10:01:08AM +0530, Chandan Rajendra wrote:
> With these changes in place, the patchset changes Ext4 to use
> mpage_readpage[s] instead of its own custom ext4_readpage[s]()
> functions. This is done to reduce duplicity of code across

FYI, "duplicity" means "lying".  You meant "duplication".
