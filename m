Return-Path: <linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 49A5CC2B9F4
	for <linux-ext4@archiver.kernel.org>; Thu, 17 Jun 2021 09:49:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 311A0613DB
	for <linux-ext4@archiver.kernel.org>; Thu, 17 Jun 2021 09:49:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231852AbhFQJvS (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Thu, 17 Jun 2021 05:51:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57402 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231846AbhFQJvR (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Thu, 17 Jun 2021 05:51:17 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2BF5DC061574;
        Thu, 17 Jun 2021 02:49:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=CCe4wGQmt+DcJSX7ruaZ54fGay
        1e4dYoWPG0Mw5fcojKpGp4qbcg+BQsmKjHXIAOlmgc1N1XPadJ6H/ci5e0xbIVKKQScBaDveMwHdc
        AJ2kjCbudTJ37Cc8dh5KSShQdoZkNjwWN820xVIBvoNfkQZ/1BoDMbwjbq15pfxhW4L8RUTt+xfM3
        9LDXJd5LlbG/zPq90KpOuGUGQ1TEB8SJBSPYuclszhh5OCWt9opPCo1gMn361MlZstEXTFj5+hXnx
        z1ml1kp5M4bnWYC0WDPhuhEil4PHIUopl6ddOqTRgiSQGVlpuzNtU+z9/MGd0aRywahbUycEgtZbL
        H0VTgAxg==;
Received: from hch by casper.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1ltodl-008yxv-Gf; Thu, 17 Jun 2021 09:48:53 +0000
Date:   Thu, 17 Jun 2021 10:48:49 +0100
From:   Christoph Hellwig <hch@infradead.org>
To:     Zhang Yi <yi.zhang@huawei.com>
Cc:     linux-ext4@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        jack@suse.cz, tytso@mit.edu, adilger.kernel@dilger.ca,
        david@fromorbit.com, hch@infradead.org
Subject: Re: [RFC PATCH v4 0/8] ext4, jbd2: fix 3 issues about
 bdev_try_to_free_page()
Message-ID: <YMsagbQqxJo4y2FR@infradead.org>
References: <20210610112440.3438139-1-yi.zhang@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210610112440.3438139-1-yi.zhang@huawei.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>
