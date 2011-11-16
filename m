From: Jan Kara <jack@suse.cz>
Subject: Re: [Cluster-devel] fallocate vs O_(D)SYNC
Date: Wed, 16 Nov 2011 11:54:13 +0100
Message-ID: <20111116105413.GA2916@quack.suse.cz>
References: <20111116084256.GA22963@infradead.org>
 <1321436588.2713.5.camel@menhir>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Christoph Hellwig <hch@infradead.org>, linux-btrfs@vger.kernel.org,
	linux-ext4@vger.kernel.org, mfasheh@suse.com, jlbec@evilplan.org,
	cluster-devel@redhat.com
To: Steven Whitehouse <swhiteho@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:58072 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755569Ab1KPKyg (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 16 Nov 2011 05:54:36 -0500
Content-Disposition: inline
In-Reply-To: <1321436588.2713.5.camel@menhir>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

  Hello,

On Wed 16-11-11 09:43:08, Steven Whitehouse wrote:
> On Wed, 2011-11-16 at 03:42 -0500, Christoph Hellwig wrote:
> > It seems all filesystems but XFS ignore O_SYNC for fallocate, and never
> > make sure the size update transaction made it to disk.
> > 
> > Given that a fallocate without FALLOC_FL_KEEP_SIZE very much is a data
> > operation (it adds new blocks that return zeroes) that seems like a
> > fairly nasty surprise for O_SYNC users.
> 
> In GFS2 we zero out the data blocks as we go (since our metadata doesn't
> allow us to mark blocks as zeroed at alloc time) and also because we are
> mostly interested in being able to do FALLOC_FL_KEEP_SIZE which we use
> on our rindex system file in order to ensure that there is always enough
> space to expand a filesystem.
> 
> So there is no danger of having non-zeroed blocks appearing later, as
> that is done before the metadata change.
> 
> Our fallocate_chunk() function calls mark_inode_dirty(inode) on each
> call, so that fsync should pick that up and ensure that the metadata has
> been written back. So we should thus have both data and metadata stable
> on disk.
> 
> Do you have some evidence that this is not happening?
  Yeah, only that nobody calls that fsync() automatically if the fd is
O_SYNC if I'm right. But maybe calling fdatasync() on the range which was
fallocated from sys_fallocate() if the fd is O_SYNC would do the trick for
most filesystems? That would match how we treat O_SYNC for other operations
as well. I'm just not sure whether XFS wouldn't take unnecessarily big hit
with this.

								Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
