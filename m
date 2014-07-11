From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH] mke2fs: add support to align hugefiles relative to
 beginning of the disk
Date: Fri, 11 Jul 2014 15:37:33 -0400
Message-ID: <20140711193733.GC1304@thunk.org>
References: <1404866691-23148-1-git-send-email-tytso@mit.edu>
 <20140711182558.GG10417@birch.djwong.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Ext4 Developers List <linux-ext4@vger.kernel.org>
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:58836 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755251AbaGKThr (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 11 Jul 2014 15:37:47 -0400
Content-Disposition: inline
In-Reply-To: <20140711182558.GG10417@birch.djwong.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, Jul 11, 2014 at 11:25:58AM -0700, Darrick J. Wong wrote:
> The third argument is the maximum number of bytes to concatenate from the
> second argument ("/start").  Though it's unlikely that we'll ever find anything
> in /sys/block approaching 255 characters, we might as well guard against stack
> corruption:
> 
> 	if (strlen(path) > SYSFS_PATH_LEN - strlen("/start") - 1)
> 		return 0;
> 	strcat(path, "/start");
> 
> Oh, I guess coverity is complaining about this too.
> 
> Though FWIW, "find /sys | while read f; do echo "$f" | wc -c; done | sort -g |
> tail -n 5" spits out "133" as the longest sysfs path ever.  I guess that could
> be much longer on some multi-node NUMA box or whatever.
> 
> <shrug> /me codes up a fix, tosses it on the patch pile.

Already fixed on the maint branch.

Cheers,

						- Ted
