Return-Path: <linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5CD93C49EA6
	for <linux-ext4@archiver.kernel.org>; Thu, 24 Jun 2021 14:56:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 391B2613DA
	for <linux-ext4@archiver.kernel.org>; Thu, 24 Jun 2021 14:56:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232196AbhFXO7R (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Thu, 24 Jun 2021 10:59:17 -0400
Received: from outgoing-auth-1.mit.edu ([18.9.28.11]:57137 "EHLO
        outgoing.mit.edu" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S230170AbhFXO7R (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Thu, 24 Jun 2021 10:59:17 -0400
Received: from cwcc.thunk.org (pool-72-74-133-215.bstnma.fios.verizon.net [72.74.133.215])
        (authenticated bits=0)
        (User authenticated as tytso@ATHENA.MIT.EDU)
        by outgoing.mit.edu (8.14.7/8.12.4) with ESMTP id 15OEuhRg016173
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 24 Jun 2021 10:56:44 -0400
Received: by cwcc.thunk.org (Postfix, from userid 15806)
        id CD08515C3CD7; Thu, 24 Jun 2021 10:56:43 -0400 (EDT)
Date:   Thu, 24 Jun 2021 10:56:43 -0400
From:   "Theodore Ts'o" <tytso@mit.edu>
To:     Zhang Yi <yi.zhang@huawei.com>
Cc:     linux-ext4@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        jack@suse.cz, adilger.kernel@dilger.ca, david@fromorbit.com,
        hch@infradead.org
Subject: Re: [RFC PATCH v4 7/8] ext4: remove bdev_try_to_free_page() callback
Message-ID: <YNSdK3puRdqwFFKm@mit.edu>
References: <20210610112440.3438139-1-yi.zhang@huawei.com>
 <20210610112440.3438139-8-yi.zhang@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210610112440.3438139-8-yi.zhang@huawei.com>
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org

On Thu, Jun 10, 2021 at 07:24:39PM +0800, Zhang Yi wrote:
> After we introduce a jbd2 shrinker to release checkpointed buffer's
> journal head, we could free buffer without bdev_try_to_free_page()
> under memory pressure. So this patch remove the whole
> bdev_try_to_free_page() callback directly. It also remove many
> use-after-free issues relate to it together.
> 
> Signed-off-by: Zhang Yi <yi.zhang@huawei.com>
> Reviewed-by: Jan Kara <jack@suse.cz>

Applied, thanks.

					- Ted
