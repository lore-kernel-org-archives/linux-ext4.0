Return-Path: <linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 56E6CECAAD5
	for <linux-ext4@archiver.kernel.org>; Mon,  5 Sep 2022 05:57:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236482AbiIEF5m (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Mon, 5 Sep 2022 01:57:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43796 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236354AbiIEF47 (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Mon, 5 Sep 2022 01:56:59 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:3::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5228631EC9;
        Sun,  4 Sep 2022 22:56:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=PWjOWhcVdk5GPM4TapFAteunhK
        eigd0LPkWok89dICZQFJs+4E3wm8Cu3clJwH6WY8C1BKz/+eQgaHoM2Vf8Ns7ayihDsR7mEGTnkDI
        xs1r0aXMF5Xc8yUpw0H+teCBqpkiBmgoK8XHiChbQzPOPBemUlu16JpnydxxohrR72C51Htxw9W4F
        1IMlYX3nbDbcp7Ts1Eb7RmZESCmUyaScjROEpxEcmPM08+cWUb8JAE+1Xne/z4DBoFYBTFTrRUB6k
        DoSP4yf0t2NAlRNjSIMiS0g7t0O0i3WeNbuwIxeZrLx9NHgmvqjdbw2Ewsg99MqTSzeue+S0RjCvE
        cEIYH5Og==;
Received: from hch by bombadil.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1oV56P-00Bea7-3Y; Mon, 05 Sep 2022 05:56:57 +0000
Date:   Sun, 4 Sep 2022 22:56:57 -0700
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
Subject: Re: [PATCH v2 13/14] ext2: replace bh_submit_read() helper with
 bh_read_locked()
Message-ID: <YxWPqd+Wnpg+wQuf@infradead.org>
References: <20220901133505.2510834-1-yi.zhang@huawei.com>
 <20220901133505.2510834-14-yi.zhang@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220901133505.2510834-14-yi.zhang@huawei.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>
