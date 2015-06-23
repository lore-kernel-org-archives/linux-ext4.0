From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH] ext4: prevent ext4_quota_write() from failing due to
 ENOSPC
Date: Tue, 23 Jun 2015 10:25:45 -0400
Message-ID: <20150623142545.GA11771@thunk.org>
References: <1434864462-24300-1-git-send-email-tytso@mit.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Jan Kara <jack@suse.cz>
To: Ext4 Developers List <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:50520 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932882AbbFWOZr (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 23 Jun 2015 10:25:47 -0400
Content-Disposition: inline
In-Reply-To: <1434864462-24300-1-git-send-email-tytso@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sun, Jun 21, 2015 at 01:27:42AM -0400, Theodore Ts'o wrote:
> In order to prevent quota block tracking to be inaccurate when
> ext4_quota_write() fails with ENOSPC, we make two changes.  The quota
> file can now use the reserved block (since the quota file is arguably
> file system metadata), and ext4_quota_write() now uses
> ext4_should_retry_alloc() to retry the block allocation after a commit
> has completed and released some blocks for allocation.
> 
> This fixes failures of xfstests generic/270:
> 
> Quota error (device vdc): write_blk: dquota write failed
> Quota error (device vdc): qtree_write_dquot: Error -28 occurred while creating quota
> 
> Signed-off-by: Theodore Ts'o <tytso@mit.edu>

This patch significantly reduces the incidence of generic/270 failing,
but it doesn't completely eliminate them, especially when using a 1k
block size.  This makes sense, because what this generic/270 does is
to chown files to random uid's using an ENOSPC hitter as an
antagonist.  This means the quota system needs to allocate a huge
number of blocks, and with a 1k block, it's doing 4x the number
allocations.

Something we could do that would help this situation is if there was
an interface in the quota system that initialized the quota records
for a particular uid or gid, which we could call from ext4_setattr()
or ext4_open() *before* we actually need to allocate a block quota
record for the file.

(We do check the error return from dquot_transfer() and abort if it
fails, but either the allocation qtree_write_dquot() isn't getting
perculated all the way up to dquot_transfer(), or the quota mismatch
is taking place because we're doing the chown on an empty file, and
then when we subsequently write to the file, that's when the quota
record is created and by the time we try to resolve the quota file
update, it's too late to back out the delayed allocation write.)

Jan, does that make sense to you as a way to solve this issue?

     	       	    	     	 - Ted

P.S.  BTW, have you had a chance to take a look at the various
competing project quota patches and do you have an opinion about their
disposition?  Project quota hasn't been high priority for me, to be
honest, but there are people who seem to care about it, and I've been
waiting to see what you think about the patchsets from Li Xi and
Konstantin Khlebnikov.  Thanks!!

