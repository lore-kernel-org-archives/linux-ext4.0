From: Mark Fasheh <mfasheh@suse.de>
Subject: Re: [Cluster-devel] fallocate vs O_(D)SYNC
Date: Wed, 16 Nov 2011 11:35:40 -0800
Message-ID: <20111116193540.GL23779@wotan.suse.de>
References: <20111116084256.GA22963@infradead.org> <1321436588.2713.5.camel@menhir> <20111116105413.GA2916@quack.suse.cz> <20111116124550.GA11650@infradead.org> <20111116133915.GD8195@quack.suse.cz> <20111116134234.GA24258@infradead.org> <20111116155755.GA22284@quack.suse.cz> <20111116161806.GP29279@shiny>
Reply-To: Mark Fasheh <mfasheh@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: Chris Mason <chris.mason@oracle.com>, Jan Kara <jack@suse.cz>,
	Christoph Hellwig <hch@infradead.org>,
	Steven Whitehouse <swhiteho@redhat.com>,
	linux-btrfs@vger.kernel.org, linux-ext4@
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:48694 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751442Ab1KPTfm (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 16 Nov 2011 14:35:42 -0500
Content-Disposition: inline
In-Reply-To: <20111116161806.GP29279@shiny>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, Nov 16, 2011 at 11:18:06AM -0500, Chris Mason wrote:
> On Wed, Nov 16, 2011 at 04:57:55PM +0100, Jan Kara wrote:
> > On Wed 16-11-11 08:42:34, Christoph Hellwig wrote:
> > > On Wed, Nov 16, 2011 at 02:39:15PM +0100, Jan Kara wrote:
> > > > > This would work fine with XFS and be equivalent to what it does for
> > > > > O_DSYNC now.  But I'd rather see every filesystem do the right thing
> > > > > and make sure the update actually is on disk when doing O_(D)SYNC
> > > > > operations.
> > > >   OK, I don't really have a strong opinion here. Are you afraid that just
> > > > calling fsync() need not be enough to push all updates fallocate did to
> > > > disk?
> > > 
> > > No, the point is that you should not have to call fsync when doing
> > > O_SYNC I/O.  That's the whole point of it.
> >   I agree with you that userspace shouldn't have to call fsync. What I
> > meant is that sys_fallocate() or do_fallocate() can call
> > generic_write_sync(file, pos, len), and that would be completely
> > transparent to userspace.
> 
> We should do it per FS though, I'll patch up btrfs.

I agree about doing it per FS. Ocfs2 just needs a one-liner to mark the
journal transaction as synchronous.
	--Mark

--
Mark Fasheh
