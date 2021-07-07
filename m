Return-Path: <linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 47979C07E96
	for <linux-ext4@archiver.kernel.org>; Wed,  7 Jul 2021 02:28:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1F14F61C9C
	for <linux-ext4@archiver.kernel.org>; Wed,  7 Jul 2021 02:28:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229919AbhGGCbX (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Tue, 6 Jul 2021 22:31:23 -0400
Received: from outgoing-auth-1.mit.edu ([18.9.28.11]:44056 "EHLO
        outgoing.mit.edu" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S229894AbhGGCbX (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Tue, 6 Jul 2021 22:31:23 -0400
Received: from cwcc.thunk.org (pool-72-74-133-215.bstnma.fios.verizon.net [72.74.133.215])
        (authenticated bits=0)
        (User authenticated as tytso@ATHENA.MIT.EDU)
        by outgoing.mit.edu (8.14.7/8.12.4) with ESMTP id 1672Scb3024433
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 6 Jul 2021 22:28:39 -0400
Received: by cwcc.thunk.org (Postfix, from userid 15806)
        id A451315C3CC6; Tue,  6 Jul 2021 22:28:38 -0400 (EDT)
Date:   Tue, 6 Jul 2021 22:28:38 -0400
From:   "Theodore Ts'o" <tytso@mit.edu>
To:     Jan Kara <jack@suse.cz>
Cc:     linux-ext4@vger.kernel.org
Subject: Re: [PATCH] tune2fs: Update overhead when toggling journal feature
Message-ID: <YOURVgGENH0O+avb@mit.edu>
References: <20210614212830.20207-1-jack@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210614212830.20207-1-jack@suse.cz>
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org

On Mon, Jun 14, 2021 at 11:28:30PM +0200, Jan Kara wrote:
> When adding or removing journal from a filesystem, we also need to add /
> remove journal blocks from overhead stored in the superblock.  Otherwise
> total number of blocks in the filesystem as reported by statfs(2) need
> not match reality and could lead to odd results like negative number of
> used blocks reported by df(1).
> 
> Signed-off-by: Jan Kara <jack@suse.cz>

Applied thanks.

					- Ted
