Return-Path: <linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B9D1FECAAD5
	for <linux-ext4@archiver.kernel.org>; Mon,  5 Sep 2022 05:53:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236087AbiIEFxS (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Mon, 5 Sep 2022 01:53:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41948 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236058AbiIEFxL (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Mon, 5 Sep 2022 01:53:11 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:3::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8A30C30569;
        Sun,  4 Sep 2022 22:53:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=Dx4iopb1PtT6m9CrW137HPiOVS
        crbUQf8yqcmt/1PtFRcr7I7wBcbpU4xWI8B9Thko4B7k/yPL//28+WWNnbi0qIwkb9+x0dYyTtqor
        EHmRCvlz92e/+6uAP4NSaexbWcHB/0IR/bf9+V0JhrrXQp4QjA0xwfqLmn+E5RyL+YodpfAbPbcC8
        kTn9m/ETUH7+V+7eBtg+grnEUJUdiXBE8tsv9N8kTFp9Zub6fL9bS+dG49pWi+CIWrRpes6NFNqmh
        5wtYcti13qP22WJT1wuqXSFeCpeZ63F9caOcrn2b2uc7mJiLb+Cs7LQT5DcdF5OWFQN/ds2YChhX1
        Xr3AhUYg==;
Received: from hch by bombadil.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1oV52h-00BYHs-Jr; Mon, 05 Sep 2022 05:53:07 +0000
Date:   Sun, 4 Sep 2022 22:53:07 -0700
From:   Christoph Hellwig <hch@infradead.org>
To:     Zhang Yi <yi.zhang@huawei.com>
Cc:     linux-ext4@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, cluster-devel@redhat.com,
        ntfs3@lists.linux.dev, ocfs2-devel@oss.oracle.com,
        reiserfs-devel@vger.kernel.org, jack@suse.cz, tytso@mit.edu,
        akpm@linux-foundation.org, axboe@kernel.dk,
        viro@zeniv.linux.org.uk, rpeterso@redhat.com, agruenba@redhat.com,
        almaz.alexandrovich@paragon-software.com, mark@fasheh.com,
        dushistov@mail.ru, hch@infradead.org, chengzhihao1@huawei.com,
        yukuai3@huawei.com
Subject: Re: [PATCH v2 03/14] fs/buffer: replace ll_rw_block()
Message-ID: <YxWOw+Vt0K6qO3jF@infradead.org>
References: <20220901133505.2510834-1-yi.zhang@huawei.com>
 <20220901133505.2510834-4-yi.zhang@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220901133505.2510834-4-yi.zhang@huawei.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>
