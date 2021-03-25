Return-Path: <linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7407DC433DB
	for <linux-ext4@archiver.kernel.org>; Thu, 25 Mar 2021 14:38:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 425E161A01
	for <linux-ext4@archiver.kernel.org>; Thu, 25 Mar 2021 14:38:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230436AbhCYOiQ (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Thu, 25 Mar 2021 10:38:16 -0400
Received: from outgoing-auth-1.mit.edu ([18.9.28.11]:50876 "EHLO
        outgoing.mit.edu" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S230241AbhCYOh5 (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Thu, 25 Mar 2021 10:37:57 -0400
Received: from cwcc.thunk.org (pool-72-74-133-215.bstnma.fios.verizon.net [72.74.133.215])
        (authenticated bits=0)
        (User authenticated as tytso@ATHENA.MIT.EDU)
        by outgoing.mit.edu (8.14.7/8.12.4) with ESMTP id 12PEbrBM028826
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 25 Mar 2021 10:37:54 -0400
Received: by cwcc.thunk.org (Postfix, from userid 15806)
        id A8A8915C39CC; Thu, 25 Mar 2021 10:37:53 -0400 (EDT)
Date:   Thu, 25 Mar 2021 10:37:53 -0400
From:   "Theodore Ts'o" <tytso@mit.edu>
To:     Eric Whitney <enwlinux@gmail.com>
Cc:     linux-ext4@vger.kernel.org
Subject: Re: [PATCH v2] ext4: delete some unused tracepoint definitions
Message-ID: <YFygQUcMLjPnzrbD@mit.edu>
References: <20210216191634.20957-1-enwlinux@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210216191634.20957-1-enwlinux@gmail.com>
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org

On Tue, Feb 16, 2021 at 02:16:34PM -0500, Eric Whitney wrote:
> A number of tracepoint instances have been removed from ext4 by past
> patches but the definitions of those tracepoints have not.
> 
> All instances of ext4_ext_in_cache and ext4_ext_put_in_cache were
> removed by "ext4: remove single extent cache" (69eb33dc24dc).
> ext4_get_reserved_cluster_alloc was removed by
> "ext4: reduce reserved cluster count by number of allocated clusters"
> (b6bf9171ef5c).
> ext4_find_delalloc_range was removed by
> "ext4: reimplement ext4_find_delay_alloc_range on extent status tree"
> (7d1b1fbc95eb).
> 
> v2:  After a full review, delete two more tracepoint definitions.
> All instances of ext4_direct_IO_enter and ext4_direct_IO_exit were
> removed by "ext4: introduce direct I/O write using iomap infrastructure"
> (378f32bab371).
> 
> Signed-off-by: Eric Whitney <enwlinux@gmail.com>

Thanks, applied.

					- Ted
