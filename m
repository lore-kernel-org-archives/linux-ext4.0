Return-Path: <linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9E3BDC43334
	for <linux-ext4@archiver.kernel.org>; Wed,  8 Jun 2022 16:33:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245720AbiFHQdA (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Wed, 8 Jun 2022 12:33:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56622 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245186AbiFHQcz (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Wed, 8 Jun 2022 12:32:55 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B96302EB6A1;
        Wed,  8 Jun 2022 09:32:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=yuOErhko23VBUcg027gdjVhvOvMdHidC/agADdmeN/Y=; b=nK+QsAgyGVY4TqcqJIoqZb6pH6
        YH1l2lYZf2/HITuH4w313bKJpwgqgeL/Ajc+m5rAf7pnUDHd5+MIIqK9hox1IXUCjje8LUpumKfOs
        QEjG/a+V60NeULTByNwEGajh4NfgcD085VL6n+uTDiZlJ4QoXsBzw1tu8Uz6cY8dMROHVuLQLYmqG
        qmgcxmIS8DTwPbCCgU89ftwLODb+/P6u3LKC47leSNnpJ713XKmla3pD/TAZxU/Z/KXlxhXOgy684
        zB+mPggGwK2XDitwHO4afJMsYTpIn0LQ8rEaDkJNUysQjD3kPC6FQJOHcCHCSsAkws+g1Sq8TP2wI
        T8qDvWvw==;
Received: from willy by casper.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1nyybi-00CnSF-VW; Wed, 08 Jun 2022 16:32:35 +0000
Date:   Wed, 8 Jun 2022 17:32:34 +0100
From:   Matthew Wilcox <willy@infradead.org>
To:     Christoph Hellwig <hch@infradead.org>
Cc:     linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-ext4@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net,
        linux-mm@kvack.org, linux-nilfs@vger.kernel.org
Subject: Re: [PATCH 08/10] vmscan: Add check_move_unevictable_folios()
Message-ID: <YqDPIv5IgNHK/pJT@casper.infradead.org>
References: <20220605193854.2371230-1-willy@infradead.org>
 <20220605193854.2371230-9-willy@infradead.org>
 <YqBYxNPu3tLiN5kI@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YqBYxNPu3tLiN5kI@infradead.org>
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org

On Wed, Jun 08, 2022 at 01:07:32AM -0700, Christoph Hellwig wrote:
> On Sun, Jun 05, 2022 at 08:38:52PM +0100, Matthew Wilcox (Oracle) wrote:
> > Change the guts of check_move_unevictable_pages() over to use folios
> > and add check_move_unevictable_pages() as a wrapper.
> 
> The changes here look fine, but please also add patches for converting
> the two callers (which looks mostly trivial to me).

I do want to get rid of pagevecs entirely, but that conversion isn't
going to happen in time for the next merge window.  for_each_sgt_page()
is a little intimidating.
