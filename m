Return-Path: <linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C9568C4338F
	for <linux-ext4@archiver.kernel.org>; Fri, 23 Jul 2021 11:33:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A8170608FE
	for <linux-ext4@archiver.kernel.org>; Fri, 23 Jul 2021 11:33:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234231AbhGWKw7 (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Fri, 23 Jul 2021 06:52:59 -0400
Received: from outgoing-auth-1.mit.edu ([18.9.28.11]:56372 "EHLO
        outgoing.mit.edu" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S233315AbhGWKw6 (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Fri, 23 Jul 2021 06:52:58 -0400
Received: from cwcc.thunk.org (pool-72-74-133-215.bstnma.fios.verizon.net [72.74.133.215])
        (authenticated bits=0)
        (User authenticated as tytso@ATHENA.MIT.EDU)
        by outgoing.mit.edu (8.14.7/8.12.4) with ESMTP id 16NBXOCa017152
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 23 Jul 2021 07:33:24 -0400
Received: by cwcc.thunk.org (Postfix, from userid 15806)
        id DD57515C37C0; Fri, 23 Jul 2021 07:33:23 -0400 (EDT)
Date:   Fri, 23 Jul 2021 07:33:23 -0400
From:   "Theodore Ts'o" <tytso@mit.edu>
To:     Guoqing Jiang <guoqing.jiang@linux.dev>
Cc:     adilger.kernel@dilger.ca, linux-ext4@vger.kernel.org
Subject: Re: [PATCH] ext4: remove conflict comment from __ext4_forget
Message-ID: <YPqpA6ElBkwUvD7i@mit.edu>
References: <20210714055940.1553705-1-guoqing.jiang@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210714055940.1553705-1-guoqing.jiang@linux.dev>
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org

On Wed, Jul 14, 2021 at 01:59:40PM +0800, Guoqing Jiang wrote:
> From: Guoqing Jiang <jiangguoqing@kylinos.cn>
> 
> We do a bforget and return for no journal case, so let's remove this
> conflict comment.
> 
> Reviewed-by: Jan Kara <jack@suse.cz>
> Signed-off-by: Guoqing Jiang <jiangguoqing@kylinos.cn>

Thanks, applied.

					- Ted
