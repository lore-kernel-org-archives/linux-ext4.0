Return-Path: <linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3C74DC432BE
	for <linux-ext4@archiver.kernel.org>; Wed, 18 Aug 2021 14:58:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 28E76610E5
	for <linux-ext4@archiver.kernel.org>; Wed, 18 Aug 2021 14:58:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239504AbhHRO6h (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Wed, 18 Aug 2021 10:58:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57158 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238872AbhHRO6e (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Wed, 18 Aug 2021 10:58:34 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 119B0C061764;
        Wed, 18 Aug 2021 07:58:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=2g9pHgPWd8S7JZggCdeaLifcdNQhzjXv9Us4Fn7c/eI=; b=N8qRgySgPaN8uFwsK80Yh+8FUX
        VR3QrfrKBDWlRNxVfoy9ZZH7x4PzD/Rq9q7K3Vsq+YSfsxbfK8mYMQf8gQhKILSXrkva9jhbPHmwt
        1epA5C+rpKIVUWfFLqSiEv34+yfGAeHpn0xDEacnhYKKdNG5rRurcqZGU8EqLTW+zIxJ3a/5wg2mq
        dR6pbhupiIJ/Mx6b7er3EtvyWEyzZ7JJn74hIKTJAcOpWkz6LiKTGiysweRIs3APr6/wBZAMAfAMk
        CFPtXiU94BMz6MAOVwCPFqoPvSsbkPuDsURTCJzG/g1if/amVJWLIofqClORmA2pEiStrDVmNAWsX
        fNUatxHw==;
Received: from willy by casper.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1mGMzz-003xBU-UN; Wed, 18 Aug 2021 14:57:08 +0000
Date:   Wed, 18 Aug 2021 15:56:59 +0100
From:   Matthew Wilcox <willy@infradead.org>
To:     Christoph Hellwig <hch@lst.de>
Cc:     Gabriel Krisman Bertazi <krisman@collabora.com>,
        Shreeya Patel <shreeya.patel@collabora.com>,
        linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org,
        linux-f2fs-devel@lists.sourceforge.net
Subject: Re: [PATCH 11/11] unicode: only export internal symbols for the
 selftests
Message-ID: <YR0fuyqe7NS+mCf9@casper.infradead.org>
References: <20210818140651.17181-1-hch@lst.de>
 <20210818140651.17181-12-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210818140651.17181-12-hch@lst.de>
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org

On Wed, Aug 18, 2021 at 04:06:51PM +0200, Christoph Hellwig wrote:
> The exported symbols in utf8-norm.c are not needed for normal
> file system consumers, so move them to conditional _GPL exports
> just for the selftest.

Would it be better to use EXPORT_SYMBOL_NS_GPL()?

