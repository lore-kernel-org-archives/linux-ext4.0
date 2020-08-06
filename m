Return-Path: <SRS0=Jip5=BQ=vger.kernel.org=linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D2234C433DF
	for <linux-ext4@archiver.kernel.org>; Thu,  6 Aug 2020 16:33:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 29308204FD
	for <linux-ext4@archiver.kernel.org>; Thu,  6 Aug 2020 16:33:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728665AbgHFQcr (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Thu, 6 Aug 2020 12:32:47 -0400
Received: from outgoing-auth-1.mit.edu ([18.9.28.11]:41065 "EHLO
        outgoing.mit.edu" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1728247AbgHFQbs (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Thu, 6 Aug 2020 12:31:48 -0400
Received: from callcc.thunk.org (pool-96-230-252-158.bstnma.fios.verizon.net [96.230.252.158])
        (authenticated bits=0)
        (User authenticated as tytso@ATHENA.MIT.EDU)
        by outgoing.mit.edu (8.14.7/8.12.4) with ESMTP id 076Ex240009804
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 6 Aug 2020 10:59:03 -0400
Received: by callcc.thunk.org (Postfix, from userid 15806)
        id 858C1420263; Thu,  6 Aug 2020 10:59:02 -0400 (EDT)
Date:   Thu, 6 Aug 2020 10:59:02 -0400
From:   "Theodore Ts'o" <tytso@mit.edu>
To:     brookxu <brookxu.cn@gmail.com>
Cc:     adilger.kernel@dilger.ca, linux-ext4@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: ext4: delete the invalid BUGON in ext4_mb_load_buddy_gfp()
Message-ID: <20200806145902.GQ7657@mit.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ad68e8a2-5ec3-5beb-537f-f3e53f55367a@gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org

On Mon, Jul 27, 2020 at 09:54:14AM +0800, brookxu wrote:
> Delete the invalid BUGON in ext4_mb_load_buddy_gfp(), the previous
> code has already judged whether page is NULL.
> 
> Signed-off-by: Chunguang Xu <brookxu@tencent.com>

Applied, but I had to manually apply your patch since it was mangled
by your mailer.

It looks like the problem may have been caused by your using gmail;
please take a look at the file Documentation/process/email-clients.rst for some hints.

							- Ted
