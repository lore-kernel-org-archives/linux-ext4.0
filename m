Return-Path: <linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8BEE3C433F5
	for <linux-ext4@archiver.kernel.org>; Wed,  8 Sep 2021 20:54:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6FD0361167
	for <linux-ext4@archiver.kernel.org>; Wed,  8 Sep 2021 20:54:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352215AbhIHUz1 (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Wed, 8 Sep 2021 16:55:27 -0400
Received: from outgoing-auth-1.mit.edu ([18.9.28.11]:59425 "EHLO
        outgoing.mit.edu" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S235437AbhIHUz0 (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Wed, 8 Sep 2021 16:55:26 -0400
Received: from cwcc.thunk.org (pool-72-74-133-215.bstnma.fios.verizon.net [72.74.133.215])
        (authenticated bits=0)
        (User authenticated as tytso@ATHENA.MIT.EDU)
        by outgoing.mit.edu (8.14.7/8.12.4) with ESMTP id 188Krv5F014651
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 8 Sep 2021 16:53:58 -0400
Received: by cwcc.thunk.org (Postfix, from userid 15806)
        id 3A12D15C3403; Wed,  8 Sep 2021 16:53:57 -0400 (EDT)
Date:   Wed, 8 Sep 2021 16:53:57 -0400
From:   "Theodore Ts'o" <tytso@mit.edu>
To:     Christoph Hellwig <hch@lst.de>
Cc:     Gabriel Krisman Bertazi <krisman@collabora.com>,
        Shreeya Patel <shreeya.patel@collabora.com>,
        linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org,
        linux-f2fs-devel@lists.sourceforge.net
Subject: Re: [PATCH 01/11] ext4: simplify ext4_sb_read_encoding
Message-ID: <YTki5erl7fbGHVUL@mit.edu>
References: <20210818140651.17181-1-hch@lst.de>
 <20210818140651.17181-2-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210818140651.17181-2-hch@lst.de>
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org

On Wed, Aug 18, 2021 at 04:06:41PM +0200, Christoph Hellwig wrote:
> Return the encoding table as the return value instead of as an argument,
> and don't bother with the encoding flags as the caller can handle that
> trivially.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Acked-by: Theodore Ts'o <tytso@mit.edu>

Thanks,

					- Ted
