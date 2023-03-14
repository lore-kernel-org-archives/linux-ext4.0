Return-Path: <linux-ext4-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B206EC6FD1F
	for <linux-ext4@archiver.kernel.org>; Tue, 14 Mar 2023 22:48:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230299AbjCNWsC (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Tue, 14 Mar 2023 18:48:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42964 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229571AbjCNWsA (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Tue, 14 Mar 2023 18:48:00 -0400
Received: from outgoing.mit.edu (outgoing-auth-1.mit.edu [18.9.28.11])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B766F11154
        for <linux-ext4@vger.kernel.org>; Tue, 14 Mar 2023 15:47:58 -0700 (PDT)
Received: from cwcc.thunk.org (pool-173-48-120-46.bstnma.fios.verizon.net [173.48.120.46])
        (authenticated bits=0)
        (User authenticated as tytso@ATHENA.MIT.EDU)
        by outgoing.mit.edu (8.14.7/8.12.4) with ESMTP id 32EMlqvJ015862
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 14 Mar 2023 18:47:53 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=mit.edu; s=outgoing;
        t=1678834073; bh=1DglTuIQl5OwdvjLU4+wrBrYLfUBMmfq/gEOkYsmYCI=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To;
        b=GRz410iHRblk08VAJacYK1kou+fFvaPYRUL4YHaUl74GhqcjQTBw/SMOnn0SzkssC
         FBmvLSSNfsR30ipJVMY2e8P6OEsCsTecR9dY1a55IsFZzWmRoaS9UlZt4mmK/r37pq
         xjnJi2r27BVBVvUGXptk/QsKlbfLMd3yNw6i9ftIytfRknKh9hyX3yIbQascG0XnV8
         lSe74bWCisWzEeV/UdbcHP0JE19nC2WmHvIodGpyrdhHrbP6+gZ5onUOb0H2KvFHg0
         NOJUvm1Hv71EOB8Dib6eU3mcneLD8juoHIgkxsHI3zP4EF3MA0HnJqvUNj1Z/4VaiW
         9c97yvsowHxZg==
Received: by cwcc.thunk.org (Postfix, from userid 15806)
        id 2A82215C5830; Tue, 14 Mar 2023 18:47:52 -0400 (EDT)
Date:   Tue, 14 Mar 2023 18:47:52 -0400
From:   "Theodore Ts'o" <tytso@mit.edu>
To:     "Matthew Wilcox (Oracle)" <willy@infradead.org>
Cc:     Andreas Dilger <adilger.kernel@dilger.ca>,
        linux-ext4@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH 21/31] ext4: Convert __ext4_journalled_writepage() to
 take a folio
Message-ID: <20230314224752.GG860405@mit.edu>
References: <20230126202415.1682629-1-willy@infradead.org>
 <20230126202415.1682629-22-willy@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230126202415.1682629-22-willy@infradead.org>
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org

On Thu, Jan 26, 2023 at 08:24:05PM +0000, Matthew Wilcox (Oracle) wrote:
> Use the folio APIs throughout and remove a PAGE_SIZE assumption.
> 
> Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>

This patch should be obviated by Jan's "Cleanup data=journal writeback
path" patch series.


