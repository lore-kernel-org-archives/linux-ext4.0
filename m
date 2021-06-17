Return-Path: <linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 510E6C2B9F4
	for <linux-ext4@archiver.kernel.org>; Thu, 17 Jun 2021 20:16:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 25F07611BE
	for <linux-ext4@archiver.kernel.org>; Thu, 17 Jun 2021 20:16:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232431AbhFQUSc (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Thu, 17 Jun 2021 16:18:32 -0400
Received: from outgoing-auth-1.mit.edu ([18.9.28.11]:44642 "EHLO
        outgoing.mit.edu" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S232037AbhFQUSc (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Thu, 17 Jun 2021 16:18:32 -0400
Received: from cwcc.thunk.org (pool-72-74-133-215.bstnma.fios.verizon.net [72.74.133.215])
        (authenticated bits=0)
        (User authenticated as tytso@ATHENA.MIT.EDU)
        by outgoing.mit.edu (8.14.7/8.12.4) with ESMTP id 15HKGBGN009896
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 17 Jun 2021 16:16:12 -0400
Received: by cwcc.thunk.org (Postfix, from userid 15806)
        id 2764A15C3CBA; Thu, 17 Jun 2021 16:16:11 -0400 (EDT)
Date:   Thu, 17 Jun 2021 16:16:11 -0400
From:   "Theodore Ts'o" <tytso@mit.edu>
To:     Zhang Yi <yi.zhang@huawei.com>
Cc:     linux-ext4@vger.kernel.org, adilger.kernel@dilger.ca, jack@suse.cz,
        yukuai3@huawei.com
Subject: Re: [PATCH 1/2] ext4: remove check for zero nr_to_scan in
 ext4_es_scan()
Message-ID: <YMuti1qbb9iZynje@mit.edu>
References: <20210522103045.690103-1-yi.zhang@huawei.com>
 <20210522103045.690103-2-yi.zhang@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210522103045.690103-2-yi.zhang@huawei.com>
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org

On Sat, May 22, 2021 at 06:30:44PM +0800, Zhang Yi wrote:
> After converting fs shrinkers to new scan/count API, we are no longer
> pass zero nr_to_scan parameter to detect the number of objects to free,
> just remove this check.
> 
> Fixes: 1ab6c4997e04 ("fs: convert fs shrinkers to new scan/count API")
> Cc: stable@vger.kernel.org # 3.12+
> Signed-off-by: Zhang Yi <yi.zhang@huawei.com>

Thanks, applied.

					- Ted
