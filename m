Return-Path: <SRS0=4fm1=EE=vger.kernel.org=linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2CBA4C55179
	for <linux-ext4@archiver.kernel.org>; Thu, 29 Oct 2020 07:23:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D2B312223F
	for <linux-ext4@archiver.kernel.org>; Thu, 29 Oct 2020 07:23:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726099AbgJ2HVR (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Thu, 29 Oct 2020 03:21:17 -0400
Received: from outgoing-auth-1.mit.edu ([18.9.28.11]:37982 "EHLO
        outgoing.mit.edu" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1725961AbgJ2HUv (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Thu, 29 Oct 2020 03:20:51 -0400
Received: from callcc.thunk.org (pool-72-74-133-215.bstnma.fios.verizon.net [72.74.133.215])
        (authenticated bits=0)
        (User authenticated as tytso@ATHENA.MIT.EDU)
        by outgoing.mit.edu (8.14.7/8.12.4) with ESMTP id 09T4CxoH020931
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 29 Oct 2020 00:12:59 -0400
Received: by callcc.thunk.org (Postfix, from userid 15806)
        id 2CB19420107; Thu, 29 Oct 2020 00:12:59 -0400 (EDT)
Date:   Thu, 29 Oct 2020 00:12:59 -0400
From:   "Theodore Y. Ts'o" <tytso@mit.edu>
To:     Daniel Rosenberg <drosen@google.com>
Cc:     Andreas Dilger <adilger.kernel@dilger.ca>,
        linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org,
        kernel-team@android.com, Eric Biggers <ebiggers@google.com>
Subject: Re: [PATCH] ext4: Use generic casefolding support
Message-ID: <20201029041259.GS5691@mit.edu>
References: <20201028050820.1636571-1-drosen@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201028050820.1636571-1-drosen@google.com>
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org

On Wed, Oct 28, 2020 at 05:08:20AM +0000, Daniel Rosenberg wrote:
> This switches ext4 over to the generic support provided in libfs.
> 
> Since casefolded dentries behave the same in ext4 and f2fs, we decrease
> the maintenance burden by unifying them, and any optimizations will
> immediately apply to both.
> 
> Signed-off-by: Daniel Rosenberg <drosen@google.com>
> Reviewed-by: Eric Biggers <ebiggers@google.com>

Applied, thanks.

					- Ted
