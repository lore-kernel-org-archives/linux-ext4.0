Return-Path: <linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1EAD3C19F2A
	for <linux-ext4@archiver.kernel.org>; Sun,  7 Aug 2022 23:08:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231263AbiHGXIT (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Sun, 7 Aug 2022 19:08:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59164 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229907AbiHGXIQ (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Sun, 7 Aug 2022 19:08:16 -0400
Received: from mail104.syd.optusnet.com.au (mail104.syd.optusnet.com.au [211.29.132.246])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 5DAA33891;
        Sun,  7 Aug 2022 16:08:15 -0700 (PDT)
Received: from dread.disaster.area (pa49-181-193-158.pa.nsw.optusnet.com.au [49.181.193.158])
        by mail104.syd.optusnet.com.au (Postfix) with ESMTPS id E13F762CFE2;
        Mon,  8 Aug 2022 09:08:11 +1000 (AEST)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1oKpNS-00AQOr-2N; Mon, 08 Aug 2022 09:08:10 +1000
Date:   Mon, 8 Aug 2022 09:08:10 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     Lukas Czerner <lczerner@redhat.com>
Cc:     linux-ext4@vger.kernel.org, jlayton@kernel.org, tytso@mit.edu,
        linux-fsdevel@vger.kernel.org,
        Christoph Hellwig <hch@infradead.org>, Jan Kara <jack@suse.cz>
Subject: Re: [PATCH v2 2/3] fs: record I_DIRTY_TIME even if inode already has
 I_DIRTY_INODE
Message-ID: <20220807230810.GF3861211@dread.disaster.area>
References: <20220803105340.17377-1-lczerner@redhat.com>
 <20220803105340.17377-2-lczerner@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220803105340.17377-2-lczerner@redhat.com>
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.4 cv=e9dl9Yl/ c=1 sm=1 tr=0 ts=62f045dd
        a=SeswVvpAPK2RnNNwqI8AaA==:117 a=SeswVvpAPK2RnNNwqI8AaA==:17
        a=kj9zAlcOel0A:10 a=biHskzXt2R4A:10 a=7-415B0cAAAA:8 a=JfrnYn6hAAAA:8
        a=20KFwNOVAAAA:8 a=DIIZEVAEUkBuOxPNP6QA:9 a=CjuIK1q_8ugA:10
        a=biEYGPWJfzWAr4FL6Ov7:22 a=1CNFftbPRP8L7MoqJWF3:22
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org

On Wed, Aug 03, 2022 at 12:53:39PM +0200, Lukas Czerner wrote:
> Currently the I_DIRTY_TIME will never get set if the inode already has
> I_DIRTY_INODE with assumption that it supersedes I_DIRTY_TIME.  That's
> true, however ext4 will only update the on-disk inode in
> ->dirty_inode(), not on actual writeback. As a result if the inode
> already has I_DIRTY_INODE state by the time we get to
> __mark_inode_dirty() only with I_DIRTY_TIME, the time was already filled
> into on-disk inode and will not get updated until the next I_DIRTY_INODE
> update, which might never come if we crash or get a power failure.
> 
> The problem can be reproduced on ext4 by running xfstest generic/622
> with -o iversion mount option.
> 
> Fix it by allowing I_DIRTY_TIME to be set even if the inode already has
> I_DIRTY_INODE. Also make sure that the case is properly handled in
> writeback_single_inode() as well. Additionally changes in
> xfs_fs_dirty_inode() was made to accommodate for I_DIRTY_TIME in flag.
> 
> Thanks Jan Kara for suggestions on how to make this work properly.
> 
> Cc: Dave Chinner <david@fromorbit.com>
> Cc: Christoph Hellwig <hch@infradead.org>
> Signed-off-by: Lukas Czerner <lczerner@redhat.com>
> Suggested-by: Jan Kara <jack@suse.cz>
> ---
> v2: Reworked according to suggestions from Jan

....

> diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
> index aa977c7ea370..cff05a4771b5 100644
> --- a/fs/xfs/xfs_super.c
> +++ b/fs/xfs/xfs_super.c
> @@ -658,7 +658,8 @@ xfs_fs_dirty_inode(
>  
>  	if (!(inode->i_sb->s_flags & SB_LAZYTIME))
>  		return;
> -	if (flag != I_DIRTY_SYNC || !(inode->i_state & I_DIRTY_TIME))
> +	if ((flag & ~I_DIRTY_TIME) != I_DIRTY_SYNC ||
> +	    !((inode->i_state | flag) & I_DIRTY_TIME))
>  		return;

My eyes, they bleed. The dirty time code was already a horrid
abomination, and this makes it worse.

From looking at the code, I cannot work out what the new semantics
for I_DIRTY_TIME and I_DIRTY_SYNC are supposed to be, nor can I work
out what the condition this is new code is supposed to be doing. I
*can't verify it is correct* by reading the code.

Can you please add a comment here explaining the conditions where we
don't have to log a new timestamp update?

Also, if "flag" now contains multiple flags, can you rename it
"flags"?

Cheers,

Dave.

-- 
Dave Chinner
david@fromorbit.com
