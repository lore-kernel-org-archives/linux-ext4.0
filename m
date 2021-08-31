Return-Path: <linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DE031C432BE
	for <linux-ext4@archiver.kernel.org>; Tue, 31 Aug 2021 03:04:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B25F960FED
	for <linux-ext4@archiver.kernel.org>; Tue, 31 Aug 2021 03:04:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239476AbhHaDFV (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Mon, 30 Aug 2021 23:05:21 -0400
Received: from outgoing-auth-1.mit.edu ([18.9.28.11]:52517 "EHLO
        outgoing.mit.edu" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S239460AbhHaDFV (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Mon, 30 Aug 2021 23:05:21 -0400
Received: from cwcc.thunk.org (pool-72-74-133-215.bstnma.fios.verizon.net [72.74.133.215])
        (authenticated bits=0)
        (User authenticated as tytso@ATHENA.MIT.EDU)
        by outgoing.mit.edu (8.14.7/8.12.4) with ESMTP id 17V34GBR029510
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 30 Aug 2021 23:04:16 -0400
Received: by cwcc.thunk.org (Postfix, from userid 15806)
        id DACC015C3E7E; Mon, 30 Aug 2021 23:04:15 -0400 (EDT)
Date:   Mon, 30 Aug 2021 23:04:15 -0400
From:   "Theodore Ts'o" <tytso@mit.edu>
To:     Zhang Yi <yi.zhang@huawei.com>
Cc:     linux-ext4@vger.kernel.org, adilger.kernel@dilger.ca, jack@suse.cz,
        yukuai3@huawei.com
Subject: Re: [PATCH v4 1/6] ext4: move inode eio simulation behind io
 completeion
Message-ID: <YS2cL2p0P1Jz5BcX@mit.edu>
References: <20210826130412.3921207-1-yi.zhang@huawei.com>
 <20210826130412.3921207-2-yi.zhang@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210826130412.3921207-2-yi.zhang@huawei.com>
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org

On Thu, Aug 26, 2021 at 09:04:07PM +0800, Zhang Yi wrote:
> No EIO simulation is required if the buffer is uptodate, so move the
> simulation behind read bio completeion just like inode/block bitmap
> simulation does.
> 
> Signed-off-by: Zhang Yi <yi.zhang@huawei.com>
> Reviewed-by: Jan Kara <jack@suse.cz>

Thanks, applied.

					- Ted
