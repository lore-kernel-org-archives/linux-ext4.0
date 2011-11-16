From: Jan Kara <jack@suse.cz>
Subject: Re: [Cluster-devel] fallocate vs O_(D)SYNC
Date: Wed, 16 Nov 2011 14:39:15 +0100
Message-ID: <20111116133915.GD8195@quack.suse.cz>
References: <20111116084256.GA22963@infradead.org>
 <1321436588.2713.5.camel@menhir>
 <20111116105413.GA2916@quack.suse.cz>
 <20111116124550.GA11650@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Jan Kara <jack@suse.cz>, Steven Whitehouse <swhiteho@redhat.com>,
	linux-btrfs@vger.kernel.org, linux-ext4@vger.kernel.org,
	mfasheh@suse.com, jlbec@evilplan.org, cluster-devel@redhat.com
To: Christoph Hellwig <hch@infradead.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:45718 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756864Ab1KPNj2 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 16 Nov 2011 08:39:28 -0500
Content-Disposition: inline
In-Reply-To: <20111116124550.GA11650@infradead.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed 16-11-11 07:45:50, Christoph Hellwig wrote:
> On Wed, Nov 16, 2011 at 11:54:13AM +0100, Jan Kara wrote:
> >   Yeah, only that nobody calls that fsync() automatically if the fd is
> > O_SYNC if I'm right. But maybe calling fdatasync() on the range which was
> > fallocated from sys_fallocate() if the fd is O_SYNC would do the trick for
> > most filesystems? That would match how we treat O_SYNC for other operations
> > as well. I'm just not sure whether XFS wouldn't take unnecessarily big hit
> > with this.
> 
> This would work fine with XFS and be equivalent to what it does for
> O_DSYNC now.  But I'd rather see every filesystem do the right thing
> and make sure the update actually is on disk when doing O_(D)SYNC
> operations.
  OK, I don't really have a strong opinion here. Are you afraid that just
calling fsync() need not be enough to push all updates fallocate did to
disk?

								Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
