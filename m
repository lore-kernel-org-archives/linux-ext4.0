Return-Path: <linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EF8B3C47089
	for <linux-ext4@archiver.kernel.org>; Sun,  4 Dec 2022 06:58:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229811AbiLDG6O (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Sun, 4 Dec 2022 01:58:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51390 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229801AbiLDG6N (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Sun, 4 Dec 2022 01:58:13 -0500
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:3::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 23683164B5
        for <linux-ext4@vger.kernel.org>; Sat,  3 Dec 2022 22:58:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=FaUKCWvFgbaOfjFOthZ+fxyD7ItNe+p+zLXzNPaT0SQ=; b=hn6O11pCVNRSoZ7V87KXF75Oz6
        sas9bDok5On35kg9ilyXlFdXQ8sQl7502i+/HntxJluF7IX9C42PwUVuIvQXHkJFZBHaejbd+BndR
        5cQ82u1irNP+upJOBq6T3cTJpVwsV8EAqz3OpSwbA+AORUkqNxuhxjmggU5WEAJtfCZLLxWQCO5DC
        iWDb7x7a580rul7m/168nNIIdNaiEHTmX7v4mWfxxRRY52a1GxagQT/AtsLDHe5fvts8O7wVqevMU
        tCgX6zlGG32IsxPv7ZvvbySS98wUazkfcsqNc7CYCnTKA4Ez3ci4MrOMlrzXtuL+Nn+6hBA4xHTa4
        Eu2JMu7A==;
Received: from hch by bombadil.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1p1ix0-006qUe-J0; Sun, 04 Dec 2022 06:58:10 +0000
Date:   Sat, 3 Dec 2022 22:58:10 -0800
From:   Christoph Hellwig <hch@infradead.org>
To:     Jan Kara <jack@suse.cz>
Cc:     Ted Tso <tytso@mit.edu>, linux-ext4@vger.kernel.org,
        Christoph Hellwig <hch@infradead.org>,
        Ritesh Harjani <ritesh.list@gmail.com>
Subject: Re: [PATCH v2 9/11] ext4: Switch to using write_cache_pages() for
 data=journal writeout
Message-ID: <Y4xFAk0ILz70ZtVW@infradead.org>
References: <20221202163815.22928-1-jack@suse.cz>
 <20221202183943.22640-9-jack@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221202183943.22640-9-jack@suse.cz>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org

> +static int __writepage(struct page *page, struct writeback_control *wbc,
> +		       void *data)

Can we give this a somewhat more descriptive name, e.g.
ext4_writepage_cb or so?

Otherwise looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>
