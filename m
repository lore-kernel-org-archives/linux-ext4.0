Return-Path: <linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8AE83C43334
	for <linux-ext4@archiver.kernel.org>; Wed,  8 Jun 2022 08:47:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231845AbiFHIrI (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Wed, 8 Jun 2022 04:47:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45596 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231898AbiFHIq1 (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Wed, 8 Jun 2022 04:46:27 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:3::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A8D0A17E25;
        Wed,  8 Jun 2022 01:05:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=uTkyumChc70KtIuNyLTdXxO+oQ
        borZTJd8LxTPWmuZ/XquzEzuIdedULldzBhdEHphcrLPqltCiEbceO3o0E6EgHRgLjbfCKqpBN/YC
        HwvOemZGMqxQq9dZCymr+JtoTq9TKXB3rL0p2cUrMNi3v5H4tC+9mLgqGUnCOS/7XnaJBrRSo/8uE
        RjvstYA0Pjf7/9wLnFTeLcez/E7rroZLSbW1WhhRa08Nl3JbA7x6gCvTf50o2htErpjhN1gWFEg0N
        o0q9mx7u47FLx9YJ0STZmliYZCR+4k8DYfX6RlyOLBwHoJETbCNh4FYXqK8PlLZ7uCedfHrWViZ15
        S6cFGrDQ==;
Received: from hch by bombadil.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1nyqgP-00BoR8-SP; Wed, 08 Jun 2022 08:04:53 +0000
Date:   Wed, 8 Jun 2022 01:04:53 -0700
From:   Christoph Hellwig <hch@infradead.org>
To:     "Matthew Wilcox (Oracle)" <willy@infradead.org>
Cc:     linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-ext4@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net,
        linux-mm@kvack.org, linux-nilfs@vger.kernel.org
Subject: Re: [PATCH 07/10] nilfs2: Convert nilfs_copy_back_pages() to use
 filemap_get_folios()
Message-ID: <YqBYJbOewoivkYLT@infradead.org>
References: <20220605193854.2371230-1-willy@infradead.org>
 <20220605193854.2371230-8-willy@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220605193854.2371230-8-willy@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>
