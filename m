Return-Path: <linux-ext4-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7E3F7C77B7F
	for <linux-ext4@archiver.kernel.org>; Fri, 19 May 2023 04:19:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231200AbjESETO (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Fri, 19 May 2023 00:19:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47070 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230486AbjESESy (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Fri, 19 May 2023 00:18:54 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:3::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2949F19B3;
        Thu, 18 May 2023 21:18:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=rDSIqaFZxcxQMOhGyvjFM+Hjpz800Tt09CN9DXr5F48=; b=UW2XwbNI1St2kLWA0y8xeY3J/i
        ax22+ddoCMJxSYjFbOUuBKGcw07SCzngzA24pcBDGH+N3Gvge7p+blNL7LHopOwWsPfEZKdvy5Jzn
        JABycF1fY5HXy7EfgntPydynNyg2FYsLe/intqaP2JAXXLVBjQepRpVT8j8PRR+ZiweOBZ1MgjdAe
        GrYiZqmDAYvWcevydKm31tFoHU+JLGahZnNm8vUZlqnbShaT2IfMJVBZ5xxnFowN/kNFYffG7OBr6
        F9scGYwDgmYsajG6w9DqFaS9pc+5aZZLD9YYXQBVSYOlB83SaGk54wTjn0K9oPGIyNfTF71XaXT41
        xDzeVDcw==;
Received: from hch by bombadil.infradead.org with local (Exim 4.96 #2 (Red Hat Linux))
        id 1pzrZP-00F2W6-1G;
        Fri, 19 May 2023 04:18:23 +0000
Date:   Thu, 18 May 2023 21:18:23 -0700
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
        "Darrick J. Wong" <djwong@kernel.org>
Subject: Re: [PATCH v7 2/5] block: Introduce provisioning primitives
Message-ID: <ZGb4j3sjrIIKr82y@infradead.org>
References: <20230518223326.18744-1-sarthakkukreti@chromium.org>
 <20230518223326.18744-3-sarthakkukreti@chromium.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230518223326.18744-3-sarthakkukreti@chromium.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org

On Thu, May 18, 2023 at 03:33:23PM -0700, Sarthak Kukreti wrote:
> +EXPORT_SYMBOL(blkdev_issue_provision);

IFF this gets in in some form, please make sure all exports for new
block layer functionality are EXPORT_SYMBOL_GPL, thanks.
