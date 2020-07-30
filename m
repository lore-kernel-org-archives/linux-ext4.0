Return-Path: <SRS0=oxXz=BJ=vger.kernel.org=linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2DC54C433DF
	for <linux-ext4@archiver.kernel.org>; Thu, 30 Jul 2020 01:48:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 13DD82082E
	for <linux-ext4@archiver.kernel.org>; Thu, 30 Jul 2020 01:48:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726806AbgG3Bsl (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Wed, 29 Jul 2020 21:48:41 -0400
Received: from outgoing-auth-1.mit.edu ([18.9.28.11]:35990 "EHLO
        outgoing.mit.edu" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726287AbgG3Bsl (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Wed, 29 Jul 2020 21:48:41 -0400
Received: from callcc.thunk.org (pool-96-230-252-158.bstnma.fios.verizon.net [96.230.252.158])
        (authenticated bits=0)
        (User authenticated as tytso@ATHENA.MIT.EDU)
        by outgoing.mit.edu (8.14.7/8.12.4) with ESMTP id 06U1matc026303
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 29 Jul 2020 21:48:36 -0400
Received: by callcc.thunk.org (Postfix, from userid 15806)
        id 07683420304; Wed, 29 Jul 2020 21:48:36 -0400 (EDT)
Date:   Wed, 29 Jul 2020 21:48:35 -0400
From:   tytso@mit.edu
To:     Eric Sandeen <sandeen@redhat.com>
Cc:     "linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>
Subject: Re: [PATCH 1/1] ext4: fix potential negative array index in
 do_split()
Message-ID: <20200730014835.GC44720@mit.edu>
References: <d08d63e9-8f74-b571-07c7-828b9629ce6a@redhat.com>
 <f53e246b-647c-64bb-16ec-135383c70ad7@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <f53e246b-647c-64bb-16ec-135383c70ad7@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org

On Wed, Jun 17, 2020 at 02:19:04PM -0500, Eric Sandeen wrote:
> If for any reason a directory passed to do_split() does not have enough
> active entries to exceed half the size of the block, we can end up
> iterating over all "count" entries without finding a split point.
> 
> In this case, count == move, and split will be zero, and we will
> attempt a negative index into map[].
> 
> Guard against this by detecting this case, and falling back to
> split-to-half-of-count instead; in this case we will still have
> plenty of space (> half blocksize) in each split block.
> 
> Fixes: ef2b02d3e617 ("ext34: ensure do_split leaves enough free space in both blocks")
> Signed-off-by: Eric Sandeen <sandeen@redhat.com>

Thanks, applied.

						- Ted
