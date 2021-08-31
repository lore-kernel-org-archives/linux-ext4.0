Return-Path: <linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 97930C432BE
	for <linux-ext4@archiver.kernel.org>; Tue, 31 Aug 2021 03:05:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7C7AE61004
	for <linux-ext4@archiver.kernel.org>; Tue, 31 Aug 2021 03:05:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231944AbhHaDF5 (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Mon, 30 Aug 2021 23:05:57 -0400
Received: from outgoing-auth-1.mit.edu ([18.9.28.11]:52594 "EHLO
        outgoing.mit.edu" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S229723AbhHaDF5 (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Mon, 30 Aug 2021 23:05:57 -0400
Received: from cwcc.thunk.org (pool-72-74-133-215.bstnma.fios.verizon.net [72.74.133.215])
        (authenticated bits=0)
        (User authenticated as tytso@ATHENA.MIT.EDU)
        by outgoing.mit.edu (8.14.7/8.12.4) with ESMTP id 17V34s6x029667
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 30 Aug 2021 23:04:54 -0400
Received: by cwcc.thunk.org (Postfix, from userid 15806)
        id 1755A15C3E7E; Mon, 30 Aug 2021 23:04:54 -0400 (EDT)
Date:   Mon, 30 Aug 2021 23:04:53 -0400
From:   "Theodore Ts'o" <tytso@mit.edu>
To:     Zhang Yi <yi.zhang@huawei.com>
Cc:     linux-ext4@vger.kernel.org, adilger.kernel@dilger.ca, jack@suse.cz,
        yukuai3@huawei.com
Subject: Re: [PATCH v4 3/6] ext4: make the updating inode data procedure
 atomic
Message-ID: <YS2cVW+34ZYcZvab@mit.edu>
References: <20210826130412.3921207-1-yi.zhang@huawei.com>
 <20210826130412.3921207-4-yi.zhang@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210826130412.3921207-4-yi.zhang@huawei.com>
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org

On Thu, Aug 26, 2021 at 09:04:09PM +0800, Zhang Yi wrote:
> Now that ext4_do_update_inode() return error before filling the whole
> inode data if we fail to set inode blocks in ext4_inode_blocks_set().
> This error should never happen in theory since sb->s_maxbytes should not
> have allowed this, we have already init sb->s_maxbytes according to this
> feature in ext4_fill_super(). So even through that could only happen due
> to the filesystem corruption, we'd better to return after we finish
> updating the inode because it may left an uninitialized buffer and we
> could read this buffer later in "errors=continue" mode.
> 
> This patch make the updating inode data procedure atomic, call
> EXT4_ERROR_INODE() after we dropping i_raw_lock after something bad
> happened, make sure that the inode is integrated, and also drop a BUG_ON
> and do some small cleanups.
> 
> Signed-off-by: Zhang Yi <yi.zhang@huawei.com>
> Reviewed-by: Jan Kara <jack@suse.cz>

Thanks, applied.

					- Ted
					
