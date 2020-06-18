Return-Path: <SRS0=1QBP=77=vger.kernel.org=linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 04D48C433DF
	for <linux-ext4@archiver.kernel.org>; Thu, 18 Jun 2020 07:02:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id CBEE2217A0
	for <linux-ext4@archiver.kernel.org>; Thu, 18 Jun 2020 07:02:52 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="DoRGetgf"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727845AbgFRHCw (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Thu, 18 Jun 2020 03:02:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42686 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727109AbgFRHCv (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Thu, 18 Jun 2020 03:02:51 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B0216C06174E;
        Thu, 18 Jun 2020 00:02:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=QeWZYFyZPeVYUVgtMVuAQSchGJrX+PQLlP9RVpSQLEw=; b=DoRGetgf8ZarSqISlgBkVxVPmM
        +UXlVruWXwoQCs/muSfz3cAJeAjhoPmI24K2xNassrzlsX2y/PzxZyYrE009ao32j2jMfpGtBUwGO
        lgt4pX9uzkwf1XcNivEhmHmTo9nzSWv6F8xNMte4XQn9W+94mqM0z457MXiz0HecgWx/gj7P/U4ap
        VOdfiT4k3KTPFOzAYZ1MSxoAT4gv1UaJ3vDHcvlpAxIlSmbbJUh5pDrquAbzxAR6TJI917RqfZHM0
        XOVw3Ziogo+Kq7dNU8vCpmBt7h8eUJD+YHhblBAI0yPQ0pGIj0BhnShMa++cKXPHsrtza6SXtFrsX
        9ORZ+fgA==;
Received: from hch by bombadil.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jloZX-0004Hh-8q; Thu, 18 Jun 2020 07:02:51 +0000
Date:   Thu, 18 Jun 2020 00:02:51 -0700
From:   Christoph Hellwig <hch@infradead.org>
To:     "zhangyi (F)" <yi.zhang@huawei.com>
Cc:     linux-ext4@vger.kernel.org, tytso@mit.edu, jack@suse.cz,
        adilger.kernel@dilger.ca, zhangxiaoxu5@huawei.com,
        linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH v2 1/5] fs: add bdev writepage hook to block device
Message-ID: <20200618070251.GA16046@infradead.org>
References: <20200617115947.836221-1-yi.zhang@huawei.com>
 <20200617115947.836221-2-yi.zhang@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200617115947.836221-2-yi.zhang@huawei.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-ext4-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org

On Wed, Jun 17, 2020 at 07:59:43PM +0800, zhangyi (F) wrote:
> Add a new bdev_write_page hook into struct super_operations and called
> by bdev_writepage(), which could be used by filesystem to propagate
> private handlers.

Sorry. but no.  We've been trying to get the fs decoupled from the whole
buffer_head crap for quite a while, and this just makes it much worse.
Please don't add layering violations like this.
