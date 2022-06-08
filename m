Return-Path: <linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 90347C43334
	for <linux-ext4@archiver.kernel.org>; Wed,  8 Jun 2022 08:45:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232080AbiFHIpD (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Wed, 8 Jun 2022 04:45:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55466 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231588AbiFHIoV (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Wed, 8 Jun 2022 04:44:21 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:3::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6F1A22348F5;
        Wed,  8 Jun 2022 01:04:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=Lmlll0xHee/vEiVot8MaIaDnFq94X7SQmNxMGuo2kIg=; b=K99MhL27rbGpyk6oZoCQHDJStN
        ATHqNPOPl7fmyyQofTDK54G9VDdXR1JVCTiKCNsyr/ha1NjCveZwfyr+ElXb6XTm4WzMWeGZrNqoP
        5YXYRBZ/7Jh9lheCch0n+4CO+bhipsSd9uBl3meB+fpXyr3N/vuS+NureIBbTXMUob/JPzY9Ita3n
        rPGXBOz7FEXZ8SjNR69uDCDib2RwXZNJiLNaSJtWaPlbu5qnHUXq3m6OFZVDMKd1O9sq9xB+VDKM5
        Dm2DLmp0am4A0lVr3uXzeX8+FPn7RkWsYdGC0GKaalaGr3v/k6XOaJBNnhuKawVGhybCgpknzNBKc
        BwrsYkgw==;
Received: from hch by bombadil.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1nyqeh-00Bo4j-Cp; Wed, 08 Jun 2022 08:03:07 +0000
Date:   Wed, 8 Jun 2022 01:03:07 -0700
From:   Christoph Hellwig <hch@infradead.org>
To:     "Matthew Wilcox (Oracle)" <willy@infradead.org>
Cc:     linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-ext4@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net,
        linux-mm@kvack.org, linux-nilfs@vger.kernel.org
Subject: Re: [PATCH 04/10] ext4: Convert mpage_map_and_submit_buffers() to
 use filemap_get_folios()
Message-ID: <YqBXux0cF90xV80C@infradead.org>
References: <20220605193854.2371230-1-willy@infradead.org>
 <20220605193854.2371230-5-willy@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220605193854.2371230-5-willy@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org

On Sun, Jun 05, 2022 at 08:38:48PM +0100, Matthew Wilcox (Oracle) wrote:
> The called functions all use pages, so just convert back to a page.

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>
