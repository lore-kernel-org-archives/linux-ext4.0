From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 1/2] ext4: define MKFS_EXT4_PROG and use it instead of
 "mkfs.ext4" / "mkfs -t ext4"
Date: Mon, 8 Sep 2014 22:35:28 +1000
Message-ID: <20140908123528.GK30012@dastard>
References: <20140907192110.GC1066@thunk.org>
 <1410141968-17551-1-git-send-email-tytso@mit.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: fstests@vger.kernel.org, hch@infradead.org,
	linux-ext4@vger.kernel.org, wangxg.fnst@cn.fujitsu.com,
	eguan@redhat.com
To: Theodore Ts'o <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from ipmail07.adl2.internode.on.net ([150.101.137.131]:6275 "EHLO
	ipmail07.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753901AbaIHMfn (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 8 Sep 2014 08:35:43 -0400
Content-Disposition: inline
In-Reply-To: <1410141968-17551-1-git-send-email-tytso@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sun, Sep 07, 2014 at 10:06:07PM -0400, Theodore Ts'o wrote:
> Signed-off-by: Theodore Ts'o <tytso@mit.edu>
> ---
>  common/config   | 1 +
>  common/rc       | 7 +++++--
>  tests/btrfs/012 | 1 -
>  tests/ext4/003  | 2 +-
>  tests/ext4/306  | 2 +-
>  5 files changed, 8 insertions(+), 5 deletions(-)

This throws lots of rejects with all the other patches I've already
queued up. Can you rebase it and resend it when I push out my
current tree in the morning, Ted?

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
