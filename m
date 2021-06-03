Return-Path: <linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A5180C47083
	for <linux-ext4@archiver.kernel.org>; Thu,  3 Jun 2021 01:41:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 79A89613BF
	for <linux-ext4@archiver.kernel.org>; Thu,  3 Jun 2021 01:41:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229617AbhFCBnW (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Wed, 2 Jun 2021 21:43:22 -0400
Received: from outgoing-auth-1.mit.edu ([18.9.28.11]:42481 "EHLO
        outgoing.mit.edu" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S229553AbhFCBnV (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Wed, 2 Jun 2021 21:43:21 -0400
Received: from cwcc.thunk.org (pool-72-74-133-215.bstnma.fios.verizon.net [72.74.133.215])
        (authenticated bits=0)
        (User authenticated as tytso@ATHENA.MIT.EDU)
        by outgoing.mit.edu (8.14.7/8.12.4) with ESMTP id 1531fVkH009840
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 2 Jun 2021 21:41:31 -0400
Received: by cwcc.thunk.org (Postfix, from userid 15806)
        id 137FB15C3CAF; Wed,  2 Jun 2021 21:41:31 -0400 (EDT)
Date:   Wed, 2 Jun 2021 21:41:31 -0400
From:   "Theodore Ts'o" <tytso@mit.edu>
To:     Ritesh Harjani <riteshh@linux.ibm.com>
Cc:     linux-ext4@vger.kernel.org, harshadshirwadkar@gmail.com
Subject: Re: [PATCH] ext4: Fix accessing uninit percpu counter variable with
 fast_commit
Message-ID: <YLgzSwWuD4qN88+H@mit.edu>
References: <6cceb9a75c54bef8fa9696c1b08c8df5ff6169e2.1619692410.git.riteshh@linux.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6cceb9a75c54bef8fa9696c1b08c8df5ff6169e2.1619692410.git.riteshh@linux.ibm.com>
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org

On Thu, Apr 29, 2021 at 04:13:44PM +0530, Ritesh Harjani wrote:
> When running generic/527 with fast_commit configuration, below issue is
> seen on Power.
> With fast_commit, during ext4_fc_replay() (which can be called from
> ext4_fill_super()), if inode eviction happens then it can access an
> uninitialized percpu counter variable.
> 
> This patch adds the check b4 accessing the counters in ext4_free_inode() path.

Applied, thanks.

					- Ted
