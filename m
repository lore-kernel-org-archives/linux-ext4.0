Return-Path: <linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6AFD3C433E6
	for <linux-ext4@archiver.kernel.org>; Mon, 11 Jan 2021 10:53:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2F2F522248
	for <linux-ext4@archiver.kernel.org>; Mon, 11 Jan 2021 10:53:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729551AbhAKKxM (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Mon, 11 Jan 2021 05:53:12 -0500
Received: from verein.lst.de ([213.95.11.211]:50178 "EHLO verein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729423AbhAKKxM (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Mon, 11 Jan 2021 05:53:12 -0500
Received: by verein.lst.de (Postfix, from userid 2407)
        id CB8D668AFE; Mon, 11 Jan 2021 11:52:29 +0100 (CET)
Date:   Mon, 11 Jan 2021 11:52:29 +0100
From:   Christoph Hellwig <hch@lst.de>
To:     Eric Biggers <ebiggers@kernel.org>
Cc:     linux-fsdevel@vger.kernel.org, linux-xfs@vger.kernel.org,
        linux-ext4@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net,
        Theodore Ts'o <tytso@mit.edu>, Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH v2 08/12] fs: drop redundant check from
 __writeback_single_inode()
Message-ID: <20210111105229.GC2502@lst.de>
References: <20210109075903.208222-1-ebiggers@kernel.org> <20210109075903.208222-9-ebiggers@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210109075903.208222-9-ebiggers@kernel.org>
User-Agent: Mutt/1.5.17 (2007-11-01)
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org

On Fri, Jan 08, 2021 at 11:58:59PM -0800, Eric Biggers wrote:
> From: Eric Biggers <ebiggers@google.com>
> 
> wbc->for_sync implies wbc->sync_mode == WB_SYNC_ALL, so there's no need
> to check for both.  Just check for WB_SYNC_ALL.
> 
> Signed-off-by: Eric Biggers <ebiggers@google.com>

Looks good,

Reviewed-by: Christoph Hellwig <hch@lst.de>
