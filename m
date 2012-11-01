From: "George Spelvin" <linux@horizon.com>
Subject: Re: ext4: fix metadata checksum calculation for the superblock
Date: 1 Nov 2012 03:07:31 -0400
Message-ID: <20121101070731.21349.qmail@science.horizon.com>
References: <20121101064942.GF19576@blackbox.djwong.org>
Cc: linux-ext4@vger.kernel.org, tm@tao.ma, tytso@mit.edu
To: darrick.wong@oracle.com, linux@horizon.com
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from science.horizon.com ([71.41.210.146]:16706 "HELO
	science.horizon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752003Ab2KAHHc (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 1 Nov 2012 03:07:32 -0400
In-Reply-To: <20121101064942.GF19576@blackbox.djwong.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

> Yes, it would be useful to know what's going on with this directory file,
> since it seems to fallback to linear scan, yet e2fsck -D doesn't fix it.
> What I was /going/ for was that the kernel would notice a bad directory
> and flag it for fsck on reboot.  Upon reboot, fsck would be run, notice
> the bad dir, and feed it to the directory rebuilder to get it fixed
> for good.  However, there doesn't seem to be any real checksum mismatch,
> so the rebuild doesn't happen.

That's what confuses me.  I had already run e2fsck -D (which I assume
rebuilds all directories, even if unnecessary) before observing the
problem.  The other odd clue is that it's always nfsd that chokes;
other accesses to the directory (ls -U, ls -lU, grep -r) don't produce
the message.

> Also ... refresh my memory -- some files have disappeared as a result of this
> happening?

I haven't observed it, no.  But the nature of the symptoms suggests it
might be happening.
