Return-Path: <linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 379AACCA47B
	for <linux-ext4@archiver.kernel.org>; Wed,  8 Jun 2022 09:04:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233996AbiFHJEp (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Wed, 8 Jun 2022 05:04:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38896 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233502AbiFHJDF (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Wed, 8 Jun 2022 05:03:05 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:3::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 474C51CA5CF;
        Wed,  8 Jun 2022 01:22:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=Cpz2dmkD6/IlhBDYO7S5JMhRau
        9fVEf3Lzxf9uPszpeqFJyME73K48PKk/ybD2zlmA3UtHerDQ9jfpO6mHpCLL+OIjpMVJ/fULN4RJZ
        GZxzr5VKIoLcLv4aCAI/06v+ClCZx8SguXOP13kVVFKQAYlluzdEe8J9WZyfBeTeQfidsF33thNUe
        je+ufCFEnbLltrsfVgnzqqY0FUi9w3I321TEMpQgHl9gXIKR8oCqaokbN5TXMMzLE/A6Ozk/TEmmH
        gqSWVvVDPTrR7Bg2BGyJvHp33jFAKJ0Cyrf0YLKBCbkJvTOxV8gjqZ1F591JinRckDC0dMC76VMOs
        GwWeQxsA==;
Received: from hch by bombadil.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1nyqco-00BnsU-Lx; Wed, 08 Jun 2022 08:01:10 +0000
Date:   Wed, 8 Jun 2022 01:01:10 -0700
From:   Christoph Hellwig <hch@infradead.org>
To:     "Matthew Wilcox (Oracle)" <willy@infradead.org>
Cc:     linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-ext4@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net,
        linux-mm@kvack.org, linux-nilfs@vger.kernel.org
Subject: Re: [PATCH 02/10] buffer: Convert clean_bdev_aliases() to use
 filemap_get_folios()
Message-ID: <YqBXRiyJtkL+V77R@infradead.org>
References: <20220605193854.2371230-1-willy@infradead.org>
 <20220605193854.2371230-3-willy@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220605193854.2371230-3-willy@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>
