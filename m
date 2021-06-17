Return-Path: <linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 42E8FC2B9F4
	for <linux-ext4@archiver.kernel.org>; Thu, 17 Jun 2021 20:21:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1A70C613ED
	for <linux-ext4@archiver.kernel.org>; Thu, 17 Jun 2021 20:21:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232435AbhFQUXX (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Thu, 17 Jun 2021 16:23:23 -0400
Received: from outgoing-auth-1.mit.edu ([18.9.28.11]:45340 "EHLO
        outgoing.mit.edu" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S232382AbhFQUXW (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Thu, 17 Jun 2021 16:23:22 -0400
Received: from cwcc.thunk.org (pool-72-74-133-215.bstnma.fios.verizon.net [72.74.133.215])
        (authenticated bits=0)
        (User authenticated as tytso@ATHENA.MIT.EDU)
        by outgoing.mit.edu (8.14.7/8.12.4) with ESMTP id 15HKL6px011740
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 17 Jun 2021 16:21:07 -0400
Received: by cwcc.thunk.org (Postfix, from userid 15806)
        id BB03015C3CBA; Thu, 17 Jun 2021 16:21:06 -0400 (EDT)
Date:   Thu, 17 Jun 2021 16:21:06 -0400
From:   "Theodore Ts'o" <tytso@mit.edu>
To:     Pan Dong <pandong.peter@bytedance.com>
Cc:     adilger.kernel@dilger.ca, linux-ext4@vger.kernel.org
Subject: Re: [PATCH] ext4: fix avefreec in find_group_orlov
Message-ID: <YMuusnoh/aFe97Lt@mit.edu>
References: <20210525073656.31594-1-pandong.peter@bytedance.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210525073656.31594-1-pandong.peter@bytedance.com>
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org

On Tue, May 25, 2021 at 03:36:56PM +0800, Pan Dong wrote:
> The avefreec should be average free clusters instead
> of average free blocks, otherwize Orlov's allocator
> will not work properly when bigalloc enabled.
> 
> Signed-off-by: Pan Dong <pandong.peter@bytedance.com>

Applied, thanks.

				- Ted
