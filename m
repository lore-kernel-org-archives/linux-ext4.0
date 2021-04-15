Return-Path: <linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 83346C43462
	for <linux-ext4@archiver.kernel.org>; Thu, 15 Apr 2021 14:49:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 693F2613C5
	for <linux-ext4@archiver.kernel.org>; Thu, 15 Apr 2021 14:49:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233573AbhDOOtp (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Thu, 15 Apr 2021 10:49:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42902 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233728AbhDOOte (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Thu, 15 Apr 2021 10:49:34 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C1B9AC061574;
        Thu, 15 Apr 2021 07:49:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=Z7+Tu/cOwOD4zUSujDMlZ1cKk6U8IueYF+2Nrcr7Rpk=; b=R5h6S1tyNmZbHxJvdQgMubPVSB
        DTeZTGp1jMPNCG0srQBvRf+z0qDzeG4yVZj/KEy6gqRkwlPpujWI6LRwf2My5VNizUenOYZ9Mu9KG
        6FQDSkVfGGPlZN5wGXoj40L8fG+exL/JDAoCxDYwhsB2JIcql7FSgO766mvQVk4dzW5TD/u7OzRH8
        c83AR1fS2V70km5x4DZTmO04ZLm94DTw9sI/cI1h0Zve2oMbKR1xWKIzYn7Q5D+B6dHtdBqjW8rhg
        RAPUJSwr8vHM6AeCu3bSjrzc4yrSio1uZk3EqegbTrSqL9vR47nMz87XwyVqlWxVyYzzLj7W0D21J
        QM6z7T0Q==;
Received: from hch by casper.infradead.org with local (Exim 4.94 #2 (Red Hat Linux))
        id 1lX3ID-008gt0-EE; Thu, 15 Apr 2021 14:48:36 +0000
Date:   Thu, 15 Apr 2021 15:48:29 +0100
From:   Christoph Hellwig <hch@infradead.org>
To:     Zhang Yi <yi.zhang@huawei.com>
Cc:     linux-ext4@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        tytso@mit.edu, adilger.kernel@dilger.ca, jack@suse.cz,
        yukuai3@huawei.com
Subject: Re: [RFC PATCH v2 5/7] ext4: use RCU to protect accessing superblock
 in blkdev_releasepage()
Message-ID: <20210415144829.GC2069063@infradead.org>
References: <20210414134737.2366971-1-yi.zhang@huawei.com>
 <20210414134737.2366971-6-yi.zhang@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210414134737.2366971-6-yi.zhang@huawei.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org

On Wed, Apr 14, 2021 at 09:47:35PM +0800, Zhang Yi wrote:
> In blkdev_releasepage() we access the superblock structure directly, it
> could be raced by umount filesystem on destroy superblock in put_super(),
> and end up triggering a use after free issue.

The subject is wrong, this does not change ext4 code.

