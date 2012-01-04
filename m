From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH] fs/ext{3,4}: fix potential race when setversion ioctl
 updates inode
Date: Wed, 4 Jan 2012 18:34:36 +0100
Message-ID: <20120104173436.GC28907@quack.suse.cz>
References: <20120103013152.GA26455@dztty>
 <20120103124624.GB31457@quack.suse.cz>
 <20120103231432.GA23522@dztty>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Jan Kara <jack@suse.cz>, Andrew Morton <akpm@linux-foundation.org>,
	Andreas Dilger <adilger.kernel@dilger.ca>,
	Theodore Ts'o <tytso@mit.edu>,
	Yongqiang Yang <xiaoqiangnk@gmail.com>,
	linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org,
	Al Viro <viro@zeniv.linux.org.uk>
To: Djalal Harouni <tixxdz@opendz.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:57993 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750805Ab2ADReu (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 4 Jan 2012 12:34:50 -0500
Content-Disposition: inline
In-Reply-To: <20120103231432.GA23522@dztty>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed 04-01-12 00:14:32, Djalal Harouni wrote:
> On Tue, Jan 03, 2012 at 01:46:24PM +0100, Jan Kara wrote:
> > On Tue 03-01-12 02:31:52, Djalal Harouni wrote:
> > > 
> > > The EXT{3,4}_IOC_SETVERSION ioctl() updates the inode without i_mutex,
> > > this can lead to a race with the other operations that update the same
> > > inode.
> > > 
> > > Patch tested.
> >   Thanks for the patch but I don't quite understand the problem.
> > i_generation is set when:
> >   a) inode is loaded from disk
> >   b) inode is allocated
> >   c) in SETVERSION ioctl
> > 
> >   The only thing that can race here seems to be c) against c) and that is
> > racy with i_mutex as well. So what problems do you exactly observe without
> > the patch?
> Right, but what about the related i_ctime change ? (i_ctime is updated in
> other places...)
> 
> The i_ctime update must reflect the _appropriate_ inode modification
> operation. This is why IMHO we should protect them to avoid a lost update.
  Yes, but realistically even if we race with someone else updating
i_ctime, the times will be rather similar so there's hardly a real
difference.

Anyway, using i_mutex is consistent with how we handle permission changes
or timestamp changes and the ioctl isn't performance critical so I'll take
your patch. I was just wondering whether you observed a real problem or
whether it's more or less a theoretical concern.

> BTW the i_generation which is used by NFS and fuse filesystems is updated
> even if the inode is marked immutable, is this the intended behaviour?
  Well, I'd say it's unexpected that generation can be changed for
immutable inode so I'd be inclined to take a patch that would make ext3
refuse to do that. But it's a change in how the ioctl behaves so I'd like
to hear opinion of Ted or Andrew on this.

								Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
