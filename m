From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH] ext4: prevent ext4_quota_write() from failing due to
 ENOSPC
Date: Tue, 23 Jun 2015 18:29:17 +0200
Message-ID: <20150623162917.GQ2427@quack.suse.cz>
References: <1434864462-24300-1-git-send-email-tytso@mit.edu>
 <20150623142545.GA11771@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Ext4 Developers List <linux-ext4@vger.kernel.org>,
	Jan Kara <jack@suse.cz>
To: Theodore Ts'o <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:40989 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933611AbbFWQ3W (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 23 Jun 2015 12:29:22 -0400
Content-Disposition: inline
In-Reply-To: <20150623142545.GA11771@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue 23-06-15 10:25:45, Ted Tso wrote:
> On Sun, Jun 21, 2015 at 01:27:42AM -0400, Theodore Ts'o wrote:
> > In order to prevent quota block tracking to be inaccurate when
> > ext4_quota_write() fails with ENOSPC, we make two changes.  The quota
> > file can now use the reserved block (since the quota file is arguably
> > file system metadata), and ext4_quota_write() now uses
> > ext4_should_retry_alloc() to retry the block allocation after a commit
> > has completed and released some blocks for allocation.
> > 
> > This fixes failures of xfstests generic/270:
> > 
> > Quota error (device vdc): write_blk: dquota write failed
> > Quota error (device vdc): qtree_write_dquot: Error -28 occurred while creating quota
> > 
> > Signed-off-by: Theodore Ts'o <tytso@mit.edu>
> 
> This patch significantly reduces the incidence of generic/270 failing,
> but it doesn't completely eliminate them, especially when using a 1k
> block size.  This makes sense, because what this generic/270 does is
> to chown files to random uid's using an ENOSPC hitter as an
> antagonist.  This means the quota system needs to allocate a huge
> number of blocks, and with a 1k block, it's doing 4x the number
> allocations.
> 
> Something we could do that would help this situation is if there was
> an interface in the quota system that initialized the quota records
> for a particular uid or gid, which we could call from ext4_setattr()
> or ext4_open() *before* we actually need to allocate a block quota
> record for the file.

So quota record is actually first written from dquot_acquire() function
which gets called (through ->acquire_dquot() callback) when we get the
first reference to a quota structure in dqget() (called from
dquot_initialize() / dquot_transfer()). So the problem really is in the
lack of error propagation from dqget() up through dquot_initialize() /
dquot_transfer() to the filesystem.

Doing the propagation for dquot_transfer() should be pretty easy since that
already reports other errors. With dquot_initialize() it is more difficult
since that doesn't return any errors currently so we have to add error
handling into filesystems to the inode creation path.

I'll look into this.

> P.S.  BTW, have you had a chance to take a look at the various
> competing project quota patches and do you have an opinion about their
> disposition?  Project quota hasn't been high priority for me, to be
> honest, but there are people who seem to care about it, and I've been
> waiting to see what you think about the patchsets from Li Xi and
> Konstantin Khlebnikov.  Thanks!!

Yes, patches from Li Xi look good to me and I think I've added my
Reviewed-by tags to all of them. The only missing piece was that Dave
wanted Li Xi to run xfstests for ext4 & xfs with them and Li Xi got somehow
stuck with that.

								Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
