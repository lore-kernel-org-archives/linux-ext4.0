From: Jan Kara <jack@suse.cz>
Subject: Re: RFC Per group orphan list
Date: Thu, 29 Apr 2010 00:17:13 +0200
Message-ID: <20100428221713.GA23512@atrey.karlin.mff.cuni.cz>
References: <87och3q21q.fsf@openvz.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Dmitry Monakhov <dmonakhov@openvz.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from ksp.mff.cuni.cz ([195.113.26.206]:54931 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1755970Ab0D1WRO (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>);
	Wed, 28 Apr 2010 18:17:14 -0400
Content-Disposition: inline
In-Reply-To: <87och3q21q.fsf@openvz.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

  Hi,

> Currently orphan list is global, which require per-sb mutex
> to protect add/del from the list. But it is not really necessary.
> Just think about it we have to add inode to orphan list for each
> ->write_begin call(for each page) if i_size will grow.
  Really? I don't see we would add inode to orphan list on every
->write_begin. We only do it in case write fails (ENOSPC, page fault
or so) but that's not interesting performance wise. The place where
we do add inode to orphan list are truncate path and file extending
direct IO (which might be what you meant).

> For example btrfs support per-ctree orphan list.
> So IMHO per-group orphan list seems to be more natural here.
> So my proposal is following:
> 1) Introduce new incompat feature for per-group orphan list. 
> 2) Store per-group head of the list in group descriptor
>    (Where are several reserved fields in grp-desc).
> 3) Maintain per-group orphan which protected by per-group lst-mutex. 
> 4) Let fsck to scan group descriptors after unclean umount.Since they
>    are close to each other performance penalty will be negligible.
> 
> Seems that development complexity of this feature is not too high, 
> what do you think.
  If you can show it helps in some reasonably realistic load - several direct
IO writers might be interesting, I think it might be worth it. OTOH it will
complicate orphan recovery because that would have to scan all group
descriptors (and there is lots of them on a few TB filesystem). But that will
be probably fine since most of them will have empty list.

								Honza
-- 
Jan Kara <jack@suse.cz>
SuSE CR Labs
