Return-Path: <linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4065DCCA483
	for <linux-ext4@archiver.kernel.org>; Wed,  8 Jun 2022 09:04:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232659AbiFHJER (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Wed, 8 Jun 2022 05:04:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38860 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233464AbiFHJC6 (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Wed, 8 Jun 2022 05:02:58 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:3::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AE11E1C2041;
        Wed,  8 Jun 2022 01:22:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=FHe9QWtfqKLPf3liBV9b4YYysNdz6TJZPv2RlJSFNxo=; b=rE8eAy8BnhO/uz/cOPnx8UhjAN
        oMvGKU56FernoImgpfLlk3BQh/CFcJRA4pawK69Hf0XfMgy7iNdxfJX1EO/aZC0ILffliqDfLrcv1
        mK9DeJH7OGatXD2YCTu+PsPPGT0W70LT5ii/RbRa1Jdfc1XZU8eOfnFRyejMASzpxhKqQnWsphP9b
        T+QQZKswmqu4Y84dTJy0wevs5sCY40Lii8Swq45uCU+6S053j8cyNLCKL3jVIYDAQThxi54ACP5g+
        ft1Jg5kECbmCdG40aX933ZgsA1UwamOP4geUlHX/USfvpuQaaqivpAgnSN89ea/zPtqMOGHXjCFx6
        OVoTk0Lg==;
Received: from hch by bombadil.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1nyqiy-00BpKC-SU; Wed, 08 Jun 2022 08:07:32 +0000
Date:   Wed, 8 Jun 2022 01:07:32 -0700
From:   Christoph Hellwig <hch@infradead.org>
To:     "Matthew Wilcox (Oracle)" <willy@infradead.org>
Cc:     linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-ext4@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net,
        linux-mm@kvack.org, linux-nilfs@vger.kernel.org
Subject: Re: [PATCH 08/10] vmscan: Add check_move_unevictable_folios()
Message-ID: <YqBYxNPu3tLiN5kI@infradead.org>
References: <20220605193854.2371230-1-willy@infradead.org>
 <20220605193854.2371230-9-willy@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220605193854.2371230-9-willy@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org

On Sun, Jun 05, 2022 at 08:38:52PM +0100, Matthew Wilcox (Oracle) wrote:
> Change the guts of check_move_unevictable_pages() over to use folios
> and add check_move_unevictable_pages() as a wrapper.

The changes here look fine, but please also add patches for converting
the two callers (which looks mostly trivial to me).

