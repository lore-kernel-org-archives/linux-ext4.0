Return-Path: <linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5C504C4338F
	for <linux-ext4@archiver.kernel.org>; Fri,  6 Aug 2021 15:24:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3A1E1611C6
	for <linux-ext4@archiver.kernel.org>; Fri,  6 Aug 2021 15:24:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244411AbhHFPYR (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Fri, 6 Aug 2021 11:24:17 -0400
Received: from outgoing-auth-1.mit.edu ([18.9.28.11]:46219 "EHLO
        outgoing.mit.edu" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S244335AbhHFPYP (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Fri, 6 Aug 2021 11:24:15 -0400
Received: from cwcc.thunk.org (pool-72-74-133-215.bstnma.fios.verizon.net [72.74.133.215])
        (authenticated bits=0)
        (User authenticated as tytso@ATHENA.MIT.EDU)
        by outgoing.mit.edu (8.14.7/8.12.4) with ESMTP id 176FNtfj004734
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 6 Aug 2021 11:23:56 -0400
Received: by cwcc.thunk.org (Postfix, from userid 15806)
        id 694E515C3E1B; Fri,  6 Aug 2021 11:23:55 -0400 (EDT)
Date:   Fri, 6 Aug 2021 11:23:55 -0400
From:   "Theodore Ts'o" <tytso@mit.edu>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     linux-ext4@vger.kernel.org
Subject: Re: [PATCH RESEND] tests: skip u_direct_io if losetup fails
Message-ID: <YQ1UCzIQLliQ3TAU@mit.edu>
References: <20210805154328.GB3601392@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210805154328.GB3601392@magnolia>
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org

On Thu, Aug 05, 2021 at 08:43:28AM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> This new test requires a loop device to run testing.  While it checks
> for some "obvious" parameters that might cause the test to fail such as
> not being root and no losetup executable, it doesn't actually check that
> the losetup -a call succeeds.  This causes a test regression in my
> package building container (where there is only a minimal /dev with no
> loop devices available) so I can't build debian packages.
> 
> Fix the test to skip out if we can't create a loop device.
> 
> Signed-off-by: Darrick J. Wong <djwong@kernel.org>

Applied, thanks.

					- Ted
