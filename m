Return-Path: <SRS0=m8G5=5F=vger.kernel.org=linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6AD97C4332D
	for <linux-ext4@archiver.kernel.org>; Fri, 20 Mar 2020 15:49:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3E5CB20787
	for <linux-ext4@archiver.kernel.org>; Fri, 20 Mar 2020 15:49:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1584719390;
	bh=Uz+GOfTY3xVPYbPvmBj0Q46/bG8WiXLabIZgP/U3PuA=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:List-ID:From;
	b=LZHQzeZmmbAsUpvHF1ob0q3A3rNeQyiNRTvDR57dFa5/PKtyf1qnSR1UpE/cfh1iF
	 JK+i8+cwAUMtM2E6sqAcfEdBhWijEgxADK9yy3wMwnCmNll8s/DQcbSwcYqD85JGiN
	 b2zUj7DNwhQWRNgDACu5MC/Pgtz4AlzBGNMdB8bQ=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727211AbgCTPtt (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Fri, 20 Mar 2020 11:49:49 -0400
Received: from mail.kernel.org ([198.145.29.99]:40802 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727092AbgCTPtt (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Fri, 20 Mar 2020 11:49:49 -0400
Received: from sol.localdomain (c-107-3-166-239.hsd1.ca.comcast.net [107.3.166.239])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B6F6D20709;
        Fri, 20 Mar 2020 15:49:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1584719388;
        bh=Uz+GOfTY3xVPYbPvmBj0Q46/bG8WiXLabIZgP/U3PuA=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=ZNJKwF3S/8xjDQE0c9QfVDZ7VmIbpmiT3XYz8EKVJdjKJSFVC9GqjDwywiw70PUex
         l3OPhTGMP1ByEOb6ZayrsPKyxNzggfVBRyNk7dqQs7Dh5dZ8iZtsBXDVvxKoiuWppB
         u1W2Q6vJUPPxEOpPW+X5/hJ2DERCRqxtZ8bcN+us=
Date:   Fri, 20 Mar 2020 08:49:47 -0700
From:   Eric Biggers <ebiggers@kernel.org>
To:     Matthew Wilcox <willy@infradead.org>
Cc:     linux-ext4@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net,
        Theodore Ts'o <tytso@mit.edu>,
        Jaegeuk Kim <jaegeuk@kernel.org>, Chao Yu <yuchao0@huawei.com>
Subject: Re: [f2fs-dev] Fwd: Add page_cache_readahead_unbounded
Message-ID: <20200320154947.GA851@sol.localdomain>
References: <20200320142932.GA4971@bombadil.infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200320142932.GA4971@bombadil.infradead.org>
Sender: linux-ext4-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org

Hi Matthew,

On Fri, Mar 20, 2020 at 07:29:32AM -0700, Matthew Wilcox wrote:
> 
> I'm a little disappointed to have received no feedback on these patches
> from those who were involved with creating the ugly situation in the
> first place.
> 
> There are other ext4/f2fs patches in this patch series for which it
> would also be nice to get reviewed-by tags.
> 
> ----- Forwarded message from Matthew Wilcox <willy@infradead.org> -----
> 
> Date: Fri, 20 Mar 2020 07:22:19 -0700
> From: Matthew Wilcox <willy@infradead.org>
> To: Andrew Morton <akpm@linux-foundation.org>
> Cc: "Matthew Wilcox (Oracle)" <willy@infradead.org>,
> 	linux-fsdevel@vger.kernel.org, linux-mm@kvack.org,
> 	linux-kernel@vger.kernel.org, linux-btrfs@vger.kernel.org,
> 	linux-erofs@lists.ozlabs.org, linux-ext4@vger.kernel.org,
> 	linux-f2fs-devel@lists.sourceforge.net, cluster-devel@redhat.com,
> 	ocfs2-devel@oss.oracle.com, linux-xfs@vger.kernel.org, Christoph
> 	Hellwig <hch@lst.de>, William Kucharski <william.kucharski@oracle.com>
> Subject: [PATCH v9 13/25] mm: Add page_cache_readahead_unbounded
> X-Mailer: git-send-email 2.21.1
> 
> From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
> 
> ext4 and f2fs have duplicated the guts of the readahead code so
> they can read past i_size.  Instead, separate out the guts of the
> readahead code so they can call it directly.
> 
> Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
> Reviewed-by: Christoph Hellwig <hch@lst.de>
> Reviewed-by: William Kucharski <william.kucharski@oracle.com>

I actually did look at this patch last month and it looked fine.  Thanks for
doing this.

To be clear, we'd be fine with maintaining filesystem-specific code that does
the setup necessary to call ext4_mpage_readpages() and f2fs_mpage_readpages()
properly.  And that was the original intent, so that nothing would leak into the
VFS.  But I understand that the new readahead calling convention is different
and a bit more complex, and it's annoying to have multiple callers.  So if
page_cache_readahead_unbounded() makes things easier for you, it's fine with me.

I'll take a closer look at your v9 series today and provide Reviewed-by on this
patch and others.  Sorry for not doing so earlier.

Thanks!

- Eric
