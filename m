Return-Path: <linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1D8BBC433E0
	for <linux-ext4@archiver.kernel.org>; Wed, 20 Jan 2021 16:57:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id CF99423358
	for <linux-ext4@archiver.kernel.org>; Wed, 20 Jan 2021 16:57:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391238AbhATQ4k (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Wed, 20 Jan 2021 11:56:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48882 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2403975AbhATQVd (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Wed, 20 Jan 2021 11:21:33 -0500
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8D1D2C061575;
        Wed, 20 Jan 2021 08:21:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=+TyaprsFFpe4D2IdPtCe/vGt+ZyBDLNGMTqOEUV0Y0Y=; b=ktIh2yT5awX/xT5bRccUykitbs
        zgufB8WSm9bC+xgIIJPaJjx3/ouKSRW3nr/780xlRnnsuVhmezcnEKPSCnUf6NgrDm1i8C9IyVjoe
        7oN5VPb5AgfWo7DAV0yXTMSXo83+Chdgpq5voEK9+OvpiytpbBq4cDbpWzYwyPIIfrh8NPIRtcasX
        IdwcjrCl/q/UWPa2RP/B/Z5UOv0F/Uz7DvSTBayM8ImJyTMLoL/46+7yxjhhEIamoJqbq6PL3l4EE
        DSyKwogLbgvVPII5ePApUKii8KrZcUepI/RCyxl9cvXpGs0Dvc/qunL0M5/Yo9X99iONsZNQCHSdh
        QMoIJrwA==;
Received: from hch by casper.infradead.org with local (Exim 4.94 #2 (Red Hat Linux))
        id 1l2GDB-00FuBN-2r; Wed, 20 Jan 2021 16:20:12 +0000
Date:   Wed, 20 Jan 2021 16:20:01 +0000
From:   Christoph Hellwig <hch@infradead.org>
To:     Jan Kara <jack@suse.cz>
Cc:     linux-fsdevel@vger.kernel.org,
        Matthew Wilcox <willy@infradead.org>,
        linux-ext4@vger.kernel.org
Subject: Re: [PATCH 2/3] mm: Provide address_space operation for filling
 pages for read
Message-ID: <20210120162001.GB3790454@infradead.org>
References: <20210120160611.26853-1-jack@suse.cz>
 <20210120160611.26853-3-jack@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210120160611.26853-3-jack@suse.cz>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org

On Wed, Jan 20, 2021 at 05:06:10PM +0100, Jan Kara wrote:
> Provide an address_space operation for filling pages needed for read
> into page cache. Filesystems can use this operation to seriealize
> page cache filling with e.g. hole punching properly.

Besides the impending rewrite of the area - having another indirection
here is just horrible for performance.  If we want locking in this area
it should be in core code and common for multiple file systems.
