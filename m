From: Mingming Cao <cmm@us.ibm.com>
Subject: Re: ext2_discard_prealloc() called on each iput?
Date: Tue, 29 May 2007 14:10:52 -0700
Message-ID: <1180473052.4204.27.camel@localhost.localdomain>
References: <20070522161127.GC13633@duck.suse.cz>
	 <20070523123743.GD5608@thunk.org>  <20070528160420.GD21509@duck.suse.cz>
Reply-To: cmm@us.ibm.com
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Cc: Theodore Tso <tytso@mit.edu>, linux-ext4@vger.kernel.org
To: Jan Kara <jack@suse.cz>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e33.co.us.ibm.com ([32.97.110.151]:55727 "EHLO
	e33.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750746AbXE2VLD (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 29 May 2007 17:11:03 -0400
Received: from d03relay02.boulder.ibm.com (d03relay02.boulder.ibm.com [9.17.195.227])
	by e33.co.us.ibm.com (8.13.8/8.13.8) with ESMTP id l4TLB3OB008790
	for <linux-ext4@vger.kernel.org>; Tue, 29 May 2007 17:11:03 -0400
Received: from d03av01.boulder.ibm.com (d03av01.boulder.ibm.com [9.17.195.167])
	by d03relay02.boulder.ibm.com (8.13.8/8.13.8/NCO v8.3) with ESMTP id l4TLAwQ8243446
	for <linux-ext4@vger.kernel.org>; Tue, 29 May 2007 15:11:02 -0600
Received: from d03av01.boulder.ibm.com (loopback [127.0.0.1])
	by d03av01.boulder.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id l4TLAsYj027750
	for <linux-ext4@vger.kernel.org>; Tue, 29 May 2007 15:10:54 -0600
In-Reply-To: <20070528160420.GD21509@duck.suse.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Mon, 2007-05-28 at 18:04 +0200, Jan Kara wrote:
> On Wed 23-05-07 08:37:43, Theodore Tso wrote:
> > On Tue, May 22, 2007 at 06:11:27PM +0200, Jan Kara wrote:
> > > 
> > >   while fixing some problems with preallocation in UDF, I had a look how
> > > ext2 solves similar problems. I found out that ext2_discard_prealloc() is
> > > called on every iput() from ext2_put_inode(). Is it really appropriate? I
> > > don't see a reason for doing so...
> > 
> > I agree, it's probably not appropriate.  It's been that way for a long
> > time, though (since 2.4.20).  It's not as horrible as it seems since
> > unlike traditional Unix systems, we don't call iput() as often, since
> > for example operations like close() end up calling dput(), which
> > decrements the ref. count on dentry, not the inode.  But it would
> > probably be better to check to see if i_count is 1 before deciding to
> > discard the preallocation.
>   OK, but then you could move the code to drop_inode() which is called at
> exactly that moment... I've been thinking more about it when fixing UDF.

I have tried to optimize ext2 discard preallocation code like ext3
discard reservation a while back: we only call ext2_discard_prealloc on
the last iput(), i.e. ext2/3_clear_inode().

This patch actually made into mainline for a little while, then later it
is being reversed back because of possible leak of preallocated blocks.

Tt the unmount time, someone might still hold the reference of the
inode, thus ext2_discard_prealloc() did not get a chance to be called.
Since ext2 preallocation is doing pre-allocation on disk, this leads to
leak of preallocated blocks, confused fsck later.

http://lkml.org/lkml/2005/4/12/333

> Discarding prealloc at drop_inode() has the disadvantage that
> symlinks/directories will keep their preallocated blocks until inodes are
> evicted from memory. Which is probably why ext2 discards prealloc on
> iput().
> 
> > >   Also I found slightly misleading the comment at ext2_release_file().
> > > As far as I understand the code it isn't when /all/ files are closed but
> > > rather when all fd's for given filp are closed. I.e. if you open the same
> > > file two times, ->release will get called once for each open. Am I right?
> > 
> > Yep!
> > 
> > > If so, then also calling ext2_discard_prealloc() from ext2_release_file()
> > > is suboptimal, isn't it?
> > 
> > Yes, although it's a bit better because only discaord the
> > preallocation if the file descriptor was opened for writing.  The file
> > could be opened for writing by multiple file descriptors, true, but in
> > that case it's likely that the write pattern will be a random access one
> > anyway, so the preallocated region is less useful.
>   OK, but still we could use e.g. i_writecount to check that we drop the
> last descriptor for writing...
> 
Yep, that is what ext3 does in ext3_release_file(), I forget why we
didn't fix this for ext2.

Mingming
