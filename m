Return-Path: <linux-ext4-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A6562C77B7F
	for <linux-ext4@archiver.kernel.org>; Fri, 19 May 2023 04:09:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229909AbjESEJg (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Fri, 19 May 2023 00:09:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43304 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229922AbjESEJf (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Fri, 19 May 2023 00:09:35 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:3::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 05645170F;
        Thu, 18 May 2023 21:09:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=xzy+7KhOHTYSA4CtafhLIF5YC3n5rnuXXYt0z/SE3Pg=; b=bAI/XGsMPM6Nx5XdWERnAHXqt7
        bL9E5Ls4MDgM7CQztyiTznJoDJZElD7xm6gzy7rLlDnyq43U+6H9FlB3zGUwDDo2Y2lnucwCpX5jW
        XfQHKTmOMMGEDRUKboc54I1Ul6MvU2DpSJ0XeqQxx51XYFrfHBjAGeyFRBreVbiZs5BGWpwebbHJQ
        nLNwKxtYde3hAHNLGKRWCf+KAuw1YcxTtxIYCRNNfOrWIzMkKT1joQOopLAT+DNTvp1qtXlFxIHlK
        cVw8ZvrSyd59Hjd9t9RUU2XhQ8hiVHNj3vY0J3XGJcDiTfkdzKls82lJC1ch6M4zXOf0US/Fi9v4A
        eXWQmbjA==;
Received: from hch by bombadil.infradead.org with local (Exim 4.96 #2 (Red Hat Linux))
        id 1pzrQo-00F1Rp-2E;
        Fri, 19 May 2023 04:09:30 +0000
Date:   Thu, 18 May 2023 21:09:30 -0700
From:   Christoph Hellwig <hch@infradead.org>
To:     Sarthak Kukreti <sarthakkukreti@chromium.org>
Cc:     dm-devel@redhat.com, linux-block@vger.kernel.org,
        linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, Jens Axboe <axboe@kernel.dk>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        Stefan Hajnoczi <stefanha@redhat.com>,
        Alasdair Kergon <agk@redhat.com>,
        Mike Snitzer <snitzer@kernel.org>,
        Christoph Hellwig <hch@infradead.org>,
        Brian Foster <bfoster@redhat.com>,
        Theodore Ts'o <tytso@mit.edu>,
        Andreas Dilger <adilger.kernel@dilger.ca>,
        Bart Van Assche <bvanassche@google.com>,
        "Darrick J. Wong" <djwong@kernel.org>, stable@vger.kernel.org
Subject: Re: [PATCH v7 1/5] block: Don't invalidate pagecache for invalid
 falloc modes
Message-ID: <ZGb2ej6H12hFogPM@infradead.org>
References: <20230518223326.18744-1-sarthakkukreti@chromium.org>
 <20230518223326.18744-2-sarthakkukreti@chromium.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230518223326.18744-2-sarthakkukreti@chromium.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org

On Thu, May 18, 2023 at 03:33:22PM -0700, Sarthak Kukreti wrote:
> Only call truncate_bdev_range() if the fallocate mode is
> supported. This fixes a bug where data in the pagecache
> could be invalidated if the fallocate() was called on the
> block device with an invalid mode.
> 
> Fixes: 25f4c41415e5 ("block: implement (some of) fallocate for block devices")
> Cc: stable@vger.kernel.org
> Reported-by: Darrick J. Wong <djwong@kernel.org>
> Signed-off-by: Sarthak Kukreti <sarthakkukreti@chromium.org>

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>
