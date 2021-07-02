Return-Path: <linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 030F9C11F6A
	for <linux-ext4@archiver.kernel.org>; Fri,  2 Jul 2021 13:15:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D429D6109D
	for <linux-ext4@archiver.kernel.org>; Fri,  2 Jul 2021 13:15:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232338AbhGBNRs (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Fri, 2 Jul 2021 09:17:48 -0400
Received: from outgoing-auth-1.mit.edu ([18.9.28.11]:40896 "EHLO
        outgoing.mit.edu" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S231718AbhGBNRs (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Fri, 2 Jul 2021 09:17:48 -0400
Received: from cwcc.thunk.org (pool-72-74-133-215.bstnma.fios.verizon.net [72.74.133.215])
        (authenticated bits=0)
        (User authenticated as tytso@ATHENA.MIT.EDU)
        by outgoing.mit.edu (8.14.7/8.12.4) with ESMTP id 162DF6gM002762
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 2 Jul 2021 09:15:06 -0400
Received: by cwcc.thunk.org (Postfix, from userid 15806)
        id EBA5F15C3CE4; Fri,  2 Jul 2021 09:15:05 -0400 (EDT)
Date:   Fri, 2 Jul 2021 09:15:05 -0400
From:   "Theodore Ts'o" <tytso@mit.edu>
To:     Jon Hunter <jonathanh@nvidia.com>
Cc:     Zhang Yi <yi.zhang@huawei.com>, linux-kernel@vger.kernel.org,
        linux-ext4@vger.kernel.org,
        linux-tegra <linux-tegra@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [GIT PULL] ext4 updates for v5.14
Message-ID: <YN8RWbzwcmScC4Gi@mit.edu>
References: <YNzY12HgR4UViC4/@mit.edu>
 <87ade24e-08f2-5fb1-7616-e6032af399a3@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87ade24e-08f2-5fb1-7616-e6032af399a3@nvidia.com>
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org

On Fri, Jul 02, 2021 at 10:57:37AM +0100, Jon Hunter wrote:
> 
> I have noticed that with next-20210701 that one of our eMMC tests
> started failing on all our ARM and ARM64 platforms and bisect is
> pointing to commit 4ba3fcdde7e3 ("jbd2,ext4: add a shrinker to
> release checkpointed buffers"). Today I am seeing the same failure
> on the mainline.

Yes, this was noted as a problem on Power as well.  I'll be sending a
fix for this shortly...

Apologies for not catching this, but for some reason it's not causing
problems on x86_64.

					- Ted
