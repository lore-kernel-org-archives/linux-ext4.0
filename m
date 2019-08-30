Return-Path: <SRS0=0750=W2=vger.kernel.org=linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D9B20C3A59B
	for <linux-ext4@archiver.kernel.org>; Fri, 30 Aug 2019 15:35:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B543822CE9
	for <linux-ext4@archiver.kernel.org>; Fri, 30 Aug 2019 15:35:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727938AbfH3PfV (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Fri, 30 Aug 2019 11:35:21 -0400
Received: from mx2.suse.de ([195.135.220.15]:43700 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727434AbfH3PfV (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Fri, 30 Aug 2019 11:35:21 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 9F91DABB2;
        Fri, 30 Aug 2019 15:35:20 +0000 (UTC)
Received: by quack2.suse.cz (Postfix, from userid 1000)
        id 0FABE1E43A8; Fri, 30 Aug 2019 17:35:20 +0200 (CEST)
Date:   Fri, 30 Aug 2019 17:35:20 +0200
From:   Jan Kara <jack@suse.cz>
To:     Andreas Dilger <adilger@dilger.ca>
Cc:     Jan Kara <jack@suse.cz>, Dave Chinner <david@fromorbit.com>,
        Joseph Qi <joseph.qi@linux.alibaba.com>,
        Theodore Ts'o <tytso@mit.edu>, linux-ext4@vger.kernel.org
Subject: Re: [PATCH 0/3] Revert parallel dio reads
Message-ID: <20190830153520.GB25069@quack2.suse.cz>
References: <1566871552-60946-1-git-send-email-joseph.qi@linux.alibaba.com>
 <20190827115118.GY7777@dread.disaster.area>
 <20190829105858.GA22939@quack2.suse.cz>
 <8C1DC2C7-4389-446D-8233-EEDAAD38C398@dilger.ca>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <8C1DC2C7-4389-446D-8233-EEDAAD38C398@dilger.ca>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-ext4-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org

On Thu 29-08-19 13:06:22, Andreas Dilger wrote:
> On Aug 29, 2019, at 4:58 AM, Jan Kara <jack@suse.cz> wrote:
> > 
> > On Tue 27-08-19 21:51:18, Dave Chinner wrote:
> >> On Tue, Aug 27, 2019 at 10:05:49AM +0800, Joseph Qi wrote:
> >>> This patch set is trying to revert parallel dio reads feature at present
> >>> since it causes significant performance regression in mixed random
> >>> read/write scenario.
> >>> 
> >>> Joseph Qi (3):
> >>>  Revert "ext4: remove EXT4_STATE_DIOREAD_LOCK flag"
> >>>  Revert "ext4: fix off-by-one error when writing back pages before dio
> >>>    read"
> >>>  Revert "ext4: Allow parallel DIO reads"
> >>> 
> >>> fs/ext4/ext4.h        | 17 +++++++++++++++++
> >>> fs/ext4/extents.c     | 19 ++++++++++++++-----
> >>> fs/ext4/inode.c       | 47 +++++++++++++++++++++++++++++++----------------
> >>> fs/ext4/ioctl.c       |  4 ++++
> >>> fs/ext4/move_extent.c |  4 ++++
> >>> fs/ext4/super.c       | 12 +++++++-----
> >>> 6 files changed, 77 insertions(+), 26 deletions(-)
> >> 
> >> Before doing this, you might want to have a chat and co-ordinate
> >> with the folks that are currently trying to port the ext4 direct IO
> >> code to use the iomap infrastructure:
> >> 
> >> https://lore.kernel.org/linux-ext4/20190827095221.GA1568@poseidon.bobrowski.net/T/#t
> >> 
> >> That is going to need the shared locking on read and will work just
> >> fine with shared locking on write, too (it's the code that XFS uses
> >> for direct IO). So it might be best here if you work towards shared
> >> locking on the write side rather than just revert the shared locking
> >> on the read side....
> > 
> > Yeah, after converting ext4 DIO path to iomap infrastructure, using shared
> > inode lock for all aligned non-extending DIO writes will be easy so I'd
> > prefer if we didn't have to redo the iomap conversion patches due to these
> > reverts.
> 
> But if the next kernel is LTS and the iomap implementation isn't in the
> current merge window (very unlikely) then we're stuck with this performance
> hit for LTS.  It is also unlikely that LTS will take the revert patches if
> they have not been landed to master.

I agree this is not great but the regression is there for 3 years, it has
been released in major distribution kernels quite a long time ago, and only
now someone complained. So it doesn't seem many people care about
performance of mixed RW workload when mounted with dioread_nolock (note
that the patches actually improve performance of read-only DIO workload
when not using dioread_nolock as for that case, exclusive lock is replaced
with a shared one).

									Honza
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
