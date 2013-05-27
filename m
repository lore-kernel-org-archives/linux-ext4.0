From: Jan Kara <jack@suse.cz>
Subject: Re: delayed allocation blocks not flushed?
Date: Mon, 27 May 2013 22:35:01 +0200
Message-ID: <20130527203501.GA21682@quack.suse.cz>
References: <51A31052.4030507@amplidata.com>
 <51A31125.1070100@amplidata.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org,
	Bastiaan Stougie <bstougie@amplidata.com>
To: Bert De Jonghe <Bert.DeJonghe@amplidata.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:42561 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757261Ab3E0UfE (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 27 May 2013 16:35:04 -0400
Content-Disposition: inline
In-Reply-To: <51A31125.1070100@amplidata.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

  Hello,

On Mon 27-05-13 09:54:13, Bert De Jonghe wrote:
> On an otherwise idle system, create an ext4 filesystem on /dev/sdi,
> mount it and wait more than dirty_writeback_centisecs.
  What kernel version are you using?

> Then create a small file (echo something > file);  wait
> (dirty_expire_centisecs x 2), expect delayed_allocation_blocks to
> fall to zero but it remains at 2 over here.
> 
> Create another small file (echo something_else > file2); again wait
> (dirty_expire_centisecs x 2); check delayed_allocation_blocks which
> is now at 4.
>
> Wait a weekend more:
> 
>    # date; cat /sys/fs/ext4/sdi/delayed_allocation_blocks
>    Fri May 24 15:33:21 UTC 2013
>    4
> 
>    # date; cat /sys/fs/ext4/sdi/delayed_allocation_blocks
>    Mon May 27 07:14:30 UTC 2013
>    4
> 
> Doing a manual sync flushes out all blocks, also adding a sync after
> mounting solves the not flushing behaviour (possible patch
> attached).
> 
> Has anyone noticed this before and is this expected behaviour? It
> looks like these blocks are not flushed out to disk thus remain in
> memory and will be lost upon power failure?
  This would be a bug. I have tried to recreate this with my 3.7.10 kernel
but I failed. File gets flushed to disk after 30s or so. What kernel
version are you using?

Also I don't see why syncing after mount would help to resolve the problem
that files are not flushed to disk in a timely manner...

								Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
