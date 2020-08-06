Return-Path: <SRS0=Jip5=BQ=vger.kernel.org=linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D977BC433E0
	for <linux-ext4@archiver.kernel.org>; Thu,  6 Aug 2020 11:01:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C91052250E
	for <linux-ext4@archiver.kernel.org>; Thu,  6 Aug 2020 11:01:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726073AbgHFFRt (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Thu, 6 Aug 2020 01:17:49 -0400
Received: from outgoing-auth-1.mit.edu ([18.9.28.11]:46672 "EHLO
        outgoing.mit.edu" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1725440AbgHFFRs (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Thu, 6 Aug 2020 01:17:48 -0400
Received: from callcc.thunk.org (pool-96-230-252-158.bstnma.fios.verizon.net [96.230.252.158])
        (authenticated bits=0)
        (User authenticated as tytso@ATHENA.MIT.EDU)
        by outgoing.mit.edu (8.14.7/8.12.4) with ESMTP id 0765HfOX026385
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 6 Aug 2020 01:17:41 -0400
Received: by callcc.thunk.org (Postfix, from userid 15806)
        id 0303D420263; Thu,  6 Aug 2020 01:17:40 -0400 (EDT)
Date:   Thu, 6 Aug 2020 01:17:40 -0400
From:   tytso@mit.edu
To:     Eric Biggers <ebiggers@kernel.org>
Cc:     linux-ext4@vger.kernel.org
Subject: Re: [PATCH] ext4: don't hardcode bit values in EXT4_FL_USER_*
Message-ID: <20200806051740.GI7657@mit.edu>
References: <20200713031012.192440-1-ebiggers@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200713031012.192440-1-ebiggers@kernel.org>
Sender: linux-ext4-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org

On Sun, Jul 12, 2020 at 08:10:12PM -0700, Eric Biggers wrote:
> From: Eric Biggers <ebiggers@google.com>
> 
> Define the EXT4_FL_USER_* constants by OR-ing together the appropriate
> flags, rather than hard-coding a numeric value.  This makes it much
> easier to see which flags are listed.
> 
> No change in the actual values.
> 
> Signed-off-by: Eric Biggers <ebiggers@google.com>

Thanks, applied.

					- Ted
