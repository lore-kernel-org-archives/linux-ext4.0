Return-Path: <SRS0=OaGm=Q4=vger.kernel.org=linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_MUTT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E8A3CC00319
	for <linux-ext4@archiver.kernel.org>; Thu, 21 Feb 2019 20:08:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B9D7220836
	for <linux-ext4@archiver.kernel.org>; Thu, 21 Feb 2019 20:08:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726383AbfBUUII (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Thu, 21 Feb 2019 15:08:08 -0500
Received: from ipmailnode02.adl6.internode.on.net ([150.101.137.148]:12196
        "EHLO ipmailnode02.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726220AbfBUUIH (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>);
        Thu, 21 Feb 2019 15:08:07 -0500
Received: from ppp59-167-129-252.static.internode.on.net (HELO dastard) ([59.167.129.252])
  by ipmail02.adl6.internode.on.net with ESMTP; 22 Feb 2019 06:38:03 +1030
Received: from dave by dastard with local (Exim 4.80)
        (envelope-from <david@fromorbit.com>)
        id 1gwudW-0008Ll-U7; Fri, 22 Feb 2019 07:08:03 +1100
Date:   Fri, 22 Feb 2019 07:08:02 +1100
From:   Dave Chinner <david@fromorbit.com>
To:     Keith Busch <keith.busch@intel.com>
Cc:     Ric Wheeler <ricwheeler@gmail.com>,
        lsf-pc@lists.linux-foundation.org,
        linux-xfs <linux-xfs@vger.kernel.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        linux-ext4 <linux-ext4@vger.kernel.org>,
        linux-btrfs <linux-btrfs@vger.kernel.org>,
        linux-block@vger.kernel.org
Subject: Re: [LSF/MM TOPIC] More async operations for file systems - async
 discard?
Message-ID: <20190221200802.GJ14116@dastard>
References: <92ab41f7-35bc-0f56-056f-ed88526b8ea4@gmail.com>
 <20190217210948.GB14116@dastard>
 <46540876-c222-0889-ddce-44815dcaad04@gmail.com>
 <20190220234723.GA5999@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190220234723.GA5999@localhost.localdomain>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-ext4-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org

On Wed, Feb 20, 2019 at 04:47:24PM -0700, Keith Busch wrote:
> On Sun, Feb 17, 2019 at 06:42:59PM -0500, Ric Wheeler wrote:
> > I think the variability makes life really miserable for layers above it.
> > 
> > Might be worth constructing some tooling that we can use to validate or
> > shame vendors over - testing things like a full device discard, discard of
> > fs block size and big chunks, discard against already discarded, etc.
> 
> With respect to fs block sizes, one thing making discards suck is that
> many high capacity SSDs' physical page sizes are larger than the fs block
> size, and a sub-page discard is worse than doing nothing.
> 
> We've discussed previously about supporting block size larger than
> the system's page size, but it doesn't look like that's gone anywhere.

You mean in filesystems?  Work for XFS is in progress:

https://lwn.net/Articles/770975/

But it's still only a maximum of 64k block size. Essentially, that's
a hard limit backed into the on-disk format (similar to max sector
size limits of 32k)

> Maybe it's worth revisiting since it's really inefficient if you write
> or discard at the smaller granularity.

Filesystems discard extents these days, not individual blocks. If
you free a 1MB file, they you are likely to get a 1MB discard. Or if
you use fstrim, then it's free space extent sizes (on XFS can be
hundred of GBs) and small free spaces can be ignored. So the
filesystem block size is often not an issue at all...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
