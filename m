From: Jan Kara <jack@suse.cz>
Subject: Re: ext2_discard_prealloc() called on each iput?
Date: Wed, 30 May 2007 11:02:19 +0200
Message-ID: <20070530090219.GA11957@duck.suse.cz>
References: <20070522161127.GC13633@duck.suse.cz> <20070523123743.GD5608@thunk.org> <20070528160420.GD21509@duck.suse.cz> <1180473052.4204.27.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Theodore Tso <tytso@mit.edu>, linux-ext4@vger.kernel.org
To: Mingming Cao <cmm@us.ibm.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from styx.suse.cz ([82.119.242.94]:40828 "EHLO duck.suse.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751027AbXE3Iuc (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 30 May 2007 04:50:32 -0400
Content-Disposition: inline
In-Reply-To: <1180473052.4204.27.camel@localhost.localdomain>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Tue 29-05-07 14:10:52, Mingming Cao wrote:
> On Mon, 2007-05-28 at 18:04 +0200, Jan Kara wrote:
> > On Wed 23-05-07 08:37:43, Theodore Tso wrote:
> > > On Tue, May 22, 2007 at 06:11:27PM +0200, Jan Kara wrote:
> > > > 
> > > >   while fixing some problems with preallocation in UDF, I had a look how
> > > > ext2 solves similar problems. I found out that ext2_discard_prealloc() is
> > > > called on every iput() from ext2_put_inode(). Is it really appropriate? I
> > > > don't see a reason for doing so...
> > > 
> > > I agree, it's probably not appropriate.  It's been that way for a long
> > > time, though (since 2.4.20).  It's not as horrible as it seems since
> > > unlike traditional Unix systems, we don't call iput() as often, since
> > > for example operations like close() end up calling dput(), which
> > > decrements the ref. count on dentry, not the inode.  But it would
> > > probably be better to check to see if i_count is 1 before deciding to
> > > discard the preallocation.
> >   OK, but then you could move the code to drop_inode() which is called at
> > exactly that moment... I've been thinking more about it when fixing UDF.
> 
> I have tried to optimize ext2 discard preallocation code like ext3
> discard reservation a while back: we only call ext2_discard_prealloc on
> the last iput(), i.e. ext2/3_clear_inode().
> 
> This patch actually made into mainline for a little while, then later it
> is being reversed back because of possible leak of preallocated blocks.
> 
> Tt the unmount time, someone might still hold the reference of the
> inode, thus ext2_discard_prealloc() did not get a chance to be called.
> Since ext2 preallocation is doing pre-allocation on disk, this leads to
> leak of preallocated blocks, confused fsck later.
> 
> http://lkml.org/lkml/2005/4/12/333
  Interesting. I don't quite understand how it can happen that inode is not
released at umount time... It must be released for umount to succeed. There
is a slight problem that inode is not written after calling clear_inode()
which could cause some problems (i_blocks being wrong) but blocks in
bitmaps should be freed just right...

> > > anyway, so the preallocated region is less useful.
> >   OK, but still we could use e.g. i_writecount to check that we drop the
> > last descriptor for writing...
> > 
> Yep, that is what ext3 does in ext3_release_file(), I forget why we
> didn't fix this for ext2.
  Hmm, probably we just forgot...

									Honza
-- 
Jan Kara <jack@suse.cz>
SuSE CR Labs
