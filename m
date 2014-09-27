From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 1/2] ext4: define MKFS_EXT4_PROG and use it instead of
 "mkfs.ext4" / "mkfs -t ext4"
Date: Sat, 27 Sep 2014 10:11:41 +1000
Message-ID: <20140927001141.GI4758@dastard>
References: <20140907192110.GC1066@thunk.org>
 <1410141968-17551-1-git-send-email-tytso@mit.edu>
 <20140908123528.GK30012@dastard>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: fstests@vger.kernel.org, hch@infradead.org,
	linux-ext4@vger.kernel.org, wangxg.fnst@cn.fujitsu.com,
	eguan@redhat.com
To: Theodore Ts'o <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from ipmail06.adl2.internode.on.net ([150.101.137.129]:9492 "EHLO
	ipmail06.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755944AbaI0ALo (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>);
	Fri, 26 Sep 2014 20:11:44 -0400
Content-Disposition: inline
In-Reply-To: <20140908123528.GK30012@dastard>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Sep 08, 2014 at 10:35:28PM +1000, Dave Chinner wrote:
> On Sun, Sep 07, 2014 at 10:06:07PM -0400, Theodore Ts'o wrote:
> > Signed-off-by: Theodore Ts'o <tytso@mit.edu>
> > ---
> >  common/config   | 1 +
> >  common/rc       | 7 +++++--
> >  tests/btrfs/012 | 1 -
> >  tests/ext4/003  | 2 +-
> >  tests/ext4/306  | 2 +-
> >  5 files changed, 8 insertions(+), 5 deletions(-)
> 
> This throws lots of rejects with all the other patches I've already
> queued up. Can you rebase it and resend it when I push out my
> current tree in the morning, Ted?

Hi Ted,

Can you send an update for this patch if you still need it?

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
