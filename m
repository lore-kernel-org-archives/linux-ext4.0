Return-Path: <linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B0BD3C11F67
	for <linux-ext4@archiver.kernel.org>; Thu,  1 Jul 2021 20:56:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 90D29613F4
	for <linux-ext4@archiver.kernel.org>; Thu,  1 Jul 2021 20:56:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234317AbhGAU7E (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Thu, 1 Jul 2021 16:59:04 -0400
Received: from outgoing-auth-1.mit.edu ([18.9.28.11]:52242 "EHLO
        outgoing.mit.edu" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S232637AbhGAU7E (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Thu, 1 Jul 2021 16:59:04 -0400
Received: from cwcc.thunk.org (pool-72-74-133-215.bstnma.fios.verizon.net [72.74.133.215])
        (authenticated bits=0)
        (User authenticated as tytso@ATHENA.MIT.EDU)
        by outgoing.mit.edu (8.14.7/8.12.4) with ESMTP id 161KuS2p012228
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 1 Jul 2021 16:56:29 -0400
Received: by cwcc.thunk.org (Postfix, from userid 15806)
        id 87E7815C3CE1; Thu,  1 Jul 2021 16:56:28 -0400 (EDT)
Date:   Thu, 1 Jul 2021 16:56:28 -0400
From:   "Theodore Ts'o" <tytso@mit.edu>
To:     Ritesh Harjani <riteshh@linux.ibm.com>
Cc:     linux-ext4@vger.kernel.org
Subject: Re: [PATCH 0/9] kvmxfstests: Add 64K related configs for Power
Message-ID: <YN4r/DYfSc4uJVG2@mit.edu>
References: <cover.1624007533.git.riteshh@linux.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1624007533.git.riteshh@linux.ibm.com>
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org

On Fri, Jun 18, 2021 at 04:39:51PM +0530, Ritesh Harjani wrote:
> Hello,
> 
> These patches adds and/or fixes configs for 64K blocksize/pagesize related
> platform (e.g. Power). This series adds some new configs for btrfs and 64K
> related configs for ext4/xfs/btrfs.
> 
> There are also some fixes related to dax and related to SCRATCH_DEV_POOL
> env variable is used by btrfs.
> 
> Then the last patch adds some extra packages which many a times are useful while
> manual debugging/testing.

Applied, thanks!

					- Ted
