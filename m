Return-Path: <linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 06DB5ECAAA1
	for <linux-ext4@archiver.kernel.org>; Mon,  5 Sep 2022 05:55:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236281AbiIEFzA (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Mon, 5 Sep 2022 01:55:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43068 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236168AbiIEFym (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Mon, 5 Sep 2022 01:54:42 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:3::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2C1F719034;
        Sun,  4 Sep 2022 22:54:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=rtrlNCFpQu+oE5HQvbd8NN8bYF
        F043Oh7qVBPRQtttPRVbjuB7FhHrkI/gHK0hUupHM+5p8gCaIgYvxF581AlCz22YyrI6PhM5SLP1q
        KeJ/E92INwjEUS/10ygwNmxkjfpAK+VVz55V50dUqzY+BItd5S2pUoqJUXeTqCCWH9ra3b/KF/ifx
        7VLtq36s4Ao1ARUmeQENRm009UWJjoosM6JLpPhN9gD+ET+QjPsvBVXW0fOOzSj7JduRgyIhw/uJd
        tjuAmRlh1DRamI4HtHmqUR6NpGYN9sMygbVSfoADCzM3TfPIJLMZhRMR72+3pudT+aPYfrtjINvI+
        1qvsl/yQ==;
Received: from hch by bombadil.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1oV54C-00Ba9Y-0I; Mon, 05 Sep 2022 05:54:40 +0000
Date:   Sun, 4 Sep 2022 22:54:39 -0700
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
Subject: Re: [PATCH v2 06/14] jbd2: replace ll_rw_block()
Message-ID: <YxWPH5Y31xPhMiFT@infradead.org>
References: <20220901133505.2510834-1-yi.zhang@huawei.com>
 <20220901133505.2510834-7-yi.zhang@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220901133505.2510834-7-yi.zhang@huawei.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>
