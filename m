Return-Path: <linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2D3B1C49EA5
	for <linux-ext4@archiver.kernel.org>; Thu, 24 Jun 2021 14:28:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 07FCB613F2
	for <linux-ext4@archiver.kernel.org>; Thu, 24 Jun 2021 14:28:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230296AbhFXOaU (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Thu, 24 Jun 2021 10:30:20 -0400
Received: from outgoing-auth-1.mit.edu ([18.9.28.11]:52222 "EHLO
        outgoing.mit.edu" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S230056AbhFXOaT (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Thu, 24 Jun 2021 10:30:19 -0400
Received: from cwcc.thunk.org (pool-72-74-133-215.bstnma.fios.verizon.net [72.74.133.215])
        (authenticated bits=0)
        (User authenticated as tytso@ATHENA.MIT.EDU)
        by outgoing.mit.edu (8.14.7/8.12.4) with ESMTP id 15OERjho002697
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 24 Jun 2021 10:27:45 -0400
Received: by cwcc.thunk.org (Postfix, from userid 15806)
        id 30DF115C3CD7; Thu, 24 Jun 2021 10:27:45 -0400 (EDT)
Date:   Thu, 24 Jun 2021 10:27:45 -0400
From:   "Theodore Ts'o" <tytso@mit.edu>
To:     yangerkun <yangerkun@huawei.com>
Cc:     jack@suse.com, harshadshirwadkar@gmail.com,
        linux-ext4@vger.kernel.org, yukuai3@huawei.com
Subject: Re: [PATCH] jbd2: clean up misleading comments for
 jbd2_fc_release_bufs
Message-ID: <YNSWYb0+bvfjwPNR@mit.edu>
References: <20210608141236.459441-1-yangerkun@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210608141236.459441-1-yangerkun@huawei.com>
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org

On Tue, Jun 08, 2021 at 10:12:36PM +0800, yangerkun wrote:
> This comments was for jbd2_fc_wait_bufs, not for jbd2_fc_release_bufs.
> Remove this misleading comments.
> 
> Signed-off-by: yangerkun <yangerkun@huawei.com>

Applied, thanks.

					- Ted
