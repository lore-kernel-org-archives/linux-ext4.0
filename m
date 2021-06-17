Return-Path: <linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 87E18C49EA2
	for <linux-ext4@archiver.kernel.org>; Thu, 17 Jun 2021 14:52:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6909161408
	for <linux-ext4@archiver.kernel.org>; Thu, 17 Jun 2021 14:52:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231674AbhFQOyq (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Thu, 17 Jun 2021 10:54:46 -0400
Received: from outgoing-auth-1.mit.edu ([18.9.28.11]:48663 "EHLO
        outgoing.mit.edu" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S230028AbhFQOyp (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Thu, 17 Jun 2021 10:54:45 -0400
Received: from cwcc.thunk.org (pool-72-74-133-215.bstnma.fios.verizon.net [72.74.133.215])
        (authenticated bits=0)
        (User authenticated as tytso@ATHENA.MIT.EDU)
        by outgoing.mit.edu (8.14.7/8.12.4) with ESMTP id 15HEqNPa006358
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 17 Jun 2021 10:52:23 -0400
Received: by cwcc.thunk.org (Postfix, from userid 15806)
        id E7E6615C3CB8; Thu, 17 Jun 2021 10:52:22 -0400 (EDT)
Date:   Thu, 17 Jun 2021 10:52:22 -0400
From:   "Theodore Ts'o" <tytso@mit.edu>
To:     Yang Yingliang <yangyingliang@huawei.com>
Cc:     linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org, adilger.kernel@dilger.ca
Subject: Re: [PATCH] ext4: return error code when ext4_fill_flex_info() fails
Message-ID: <YMthpl31g7j+fB6m@mit.edu>
References: <20210510111051.55650-1-yangyingliang@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210510111051.55650-1-yangyingliang@huawei.com>
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org

On Mon, May 10, 2021 at 07:10:51PM +0800, Yang Yingliang wrote:
> After commit c89128a00838 ("ext4: handle errors on ext4_commit_super"), 'ret' may
> be set to 0 before calling ext4_fill_flex_info(), if ext4_fill_flex_info() fails
> ext4_mount() doesn't return error code, it makes 'root' is null which causes
> crash in legacy_get_tree().
> 
> Fixes: c89128a00838 ("ext4: handle errors on ext4_commit_super")
> Reported-by: Hulk Robot <hulkci@huawei.com>
> Cc: <stable@vger.kernel.org> # v4.18+
> Signed-off-by: Yang Yingliang <yangyingliang@huawei.com>

Applied, thanks.

					- Ted
