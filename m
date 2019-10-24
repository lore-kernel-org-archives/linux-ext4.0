Return-Path: <SRS0=Lfng=YR=vger.kernel.org=linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 17153CA9EBC
	for <linux-ext4@archiver.kernel.org>; Thu, 24 Oct 2019 10:30:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E9A492166E
	for <linux-ext4@archiver.kernel.org>; Thu, 24 Oct 2019 10:30:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2405551AbfJXKak (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Thu, 24 Oct 2019 06:30:40 -0400
Received: from mx2.suse.de ([195.135.220.15]:41766 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2404801AbfJXKak (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Thu, 24 Oct 2019 06:30:40 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id AB1CBBF14;
        Thu, 24 Oct 2019 10:30:38 +0000 (UTC)
Received: by quack2.suse.cz (Postfix, from userid 1000)
        id 492A61E4AA6; Thu, 24 Oct 2019 12:30:38 +0200 (CEST)
Date:   Thu, 24 Oct 2019 12:30:38 +0200
From:   Jan Kara <jack@suse.cz>
To:     "Theodore Y. Ts'o" <tytso@mit.edu>
Cc:     Jan Kara <jack@suse.cz>, linux-ext4@vger.kernel.org,
        stable@vger.kernel.org
Subject: Re: [PATCH 04/22] ext4: Fix credit estimate for final inode freeing
Message-ID: <20191024103038.GN31271@quack2.suse.cz>
References: <20191003215523.7313-1-jack@suse.cz>
 <20191003220613.10791-4-jack@suse.cz>
 <20191021010723.GB6799@mit.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191021010723.GB6799@mit.edu>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-ext4-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org

On Sun 20-10-19 21:07:23, Theodore Y. Ts'o wrote:
> On Fri, Oct 04, 2019 at 12:05:50AM +0200, Jan Kara wrote:
> > Estimate for the number of credits needed for final freeing of inode in
> > ext4_evict_inode() was to small. We may modify 4 blocks (inode & sb for
> > orphan deletion, bitmap & group descriptor for inode freeing) and not
> > just 3.
> 
> The modification for the inode should already be included in the
> calculation for ext4_blocks_for_truncate(), no?  So we only need 3
> extra blocks (sb, inode bitmap, and bg descriptor for the inode).

Yes, but 'extra_credits' is also passed to ext4_xattr_delete_inode() and if
that needs to restart a transaction, it needs to reserve enough for inode
modification in that new transaction. This patch is actually a result of
assertion checks I was getting with more accurate transaction restart
handling implemented later in this series...

I agree we can actually subtract 3 from
ext4_blocks_for_truncate(inode)+extra_credits when starting the initial
transaction as inode changes get double-accounted there. I can do that
and I'll also update the changelog to explain this better.

								Honza
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
