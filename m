Return-Path: <linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A1E20CCA47B
	for <linux-ext4@archiver.kernel.org>; Wed,  8 Jun 2022 09:05:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233501AbiFHJE7 (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Wed, 8 Jun 2022 05:04:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38858 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233443AbiFHJDC (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Wed, 8 Jun 2022 05:03:02 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:3::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 941CE1C5D57;
        Wed,  8 Jun 2022 01:22:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=SX9n5EnTUOKOzk0atnH01/6aCdLXi/kHksLRZ+/slrg=; b=jysUfxHITvm5qME5kby7gEknda
        NniSqrjlYB/5FZ0sOB9SGdPN609Xc7Tio/met/HczsNX9IUlMHrvgiUDv4mHlaFTvBucMZTcxWuFM
        aGqA9GeGAxtC3R6lF2w/B87y6Wk6GgZNyLeH3AxjbiUcPe9vcD+G8iLkjHXT78FVtD6XmTe1cYmlt
        ngowBhuCCZ4lWWbh04Jl3QN6dGjrZt3zoJA55lgwd6zmbPrMu2DmXkzmdU0CAIYcq9FAdHR+U6sjS
        kvj5dDbrm/lmbPQZoKx97x7Y9QNcHlDLf2o8pDHQXCZgt2fdrKxTBoK/16KCB/EAF4EZ/7y1pxpfD
        Fds+rOEQ==;
Received: from hch by bombadil.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1nyqdy-00Bnx0-Jl; Wed, 08 Jun 2022 08:02:22 +0000
Date:   Wed, 8 Jun 2022 01:02:22 -0700
From:   Christoph Hellwig <hch@infradead.org>
To:     "Matthew Wilcox (Oracle)" <willy@infradead.org>
Cc:     linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-ext4@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net,
        linux-mm@kvack.org, linux-nilfs@vger.kernel.org
Subject: Re: [PATCH 03/10] ext4: Convert mpage_release_unused_pages() to use
 filemap_get_folios()
Message-ID: <YqBXjjkRZsP8K8fO@infradead.org>
References: <20220605193854.2371230-1-willy@infradead.org>
 <20220605193854.2371230-4-willy@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220605193854.2371230-4-willy@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org

On Sun, Jun 05, 2022 at 08:38:47PM +0100, Matthew Wilcox (Oracle) wrote:
> If the folio is large, it may overlap the beginning or end of the
> unused range.  If it does, we need to avoid invalidating it.

It's never going to be larger for ext4, is it?  But either way,
those precautions looks fine.

Reviewed-by: Christoph Hellwig <hch@lst.de>
