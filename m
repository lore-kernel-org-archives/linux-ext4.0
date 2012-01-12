From: Mikulas Patocka <mpatocka@redhat.com>
Subject: Re: [PATCH v2 5/7] VFS: Avoid read-write deadlock in try_to_writeback_inodes_sb
Date: Thu, 12 Jan 2012 10:53:51 -0500 (EST)
Message-ID: <Pine.LNX.4.64.1201121037470.14474@hs20-bc2-1.build.redhat.com>
References: <1323367477-21685-1-git-send-email-kamal@canonical.com>
 <1323367477-21685-6-git-send-email-kamal@canonical.com>
 <20120106003533.GC3790@quack.suse.cz> <1326313742.25050.137.camel@fourier>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Jan Kara <jack@suse.cz>, Christoph Hellwig <hch@infradead.org>,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	Andreas Dilger <adilger.kernel@dilger.ca>,
	Matthew Wilcox <matthew@wil.cx>,
	Randy Dunlap <rdunlap@xenotime.net>,
	Theodore Tso <tytso@mit.edu>, linux-doc@vger.kernel.org,
	linux-ext4@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	linux-kernel@vger.kernel.org, Surbhi Palande <csurbhi@gmail.com>,
	Valerie Aurora <val@vaaconsulting.com>,
	Christopher Chaltain <christopher.chaltain@canonical.com>,
	"Peter M. Petrakis" <peter.petrakis@canonical.com>
To: Kamal Mostafa <kamal@canonical.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:25605 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753872Ab2ALPyc (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 12 Jan 2012 10:54:32 -0500
In-Reply-To: <1326313742.25050.137.camel@fourier>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>



On Wed, 11 Jan 2012, Kamal Mostafa wrote:

> On Fri, 2012-01-06 at 01:35 +0100, Jan Kara wrote:
> > On Thu 08-12-11 10:04:35, Kamal Mostafa wrote:
> > > From: Valerie Aurora <val@vaaconsulting.com>
> > > 
> > > Use trylock in try_to_writeback_inodes_sb to avoid read-write
> > > deadlocks that could be triggered by freeze.
> 
> >   Christoph asked about what is the exact deadlock this patch tries to fix.
> > I don't think you answered that. So can you elaborate please? Is it somehow
> > connected with the fact that ext4 calls try_to_writeback_inodes_sb() with
> > i_mutex held?
> > 
> > 								Honza
> 
> This was discussed in the thread
> http://www.spinics.net/lists/linux-fsdevel/msg48754.html
> Summarizing...
> 
> Jan>   What's exactly the deadlock trylock protects from here?
> Jan>   Or is it just an optimization?
> 
> Val>   The trylock is an optimization Dave Chinner suggested.  The first
> Val>   version I wrote acquired the lock and then checked vfs_is_frozen().
> 
> Dave>  It's not so much an optimisation, but the general case of avoiding
> Dave>  read-write deadlocks such that freezing can trigger. I think remount
> Dave>  can trigger the same deadlock as freezing, so the trylock avoids
> Dave>  both deadlock cases rather than just working around the freeze
> Dave>  problem....
> 
>  -Kamal

As I wrote in 
https://www.redhat.com/archives/dm-devel/2011-November/msg00151.html , 
down_read_trylock doesn't fix the freeze deadlock. Think of this sequence:

Process 1 (freezing)
down_write(&sb->s_umount);
set the filesystem to frozen state
up_write(&sb->s_umount);

Process 2 (executing the code from the patch)
down_read_trylock(&sb->s_umount); - succeeds, because s_umount is not held
writeback_inodes_sb(sb, reason); - waits, because the filesystem is frozen

Process 1 (unfreezing)
down_write(&sb->s_umount); - deadlock (process 1 is waiting for process 2 
to drop the lock; process 2 is waiting for process 1 to unfreeze).

See the patch at 
https://www.redhat.com/archives/dm-devel/2011-November/msg00151.html , it 
has a different approach and it avoids the mentined freeze deadlock.

Mikulas

> > > BugLink: https://bugs.launchpad.net/bugs/897421
> > > Signed-off-by: Valerie Aurora <val@vaaconsulting.com>
> > > Cc: Kamal Mostafa <kamal@canonical.com>
> > > Tested-by: Peter M. Petrakis <peter.petrakis@canonical.com>
> > > [kamal@canonical.com: patch restructure]
> > > Signed-off-by: Kamal Mostafa <kamal@canonical.com>
> > > ---
> > >  fs/fs-writeback.c |   13 ++++++++-----
> > >  1 files changed, 8 insertions(+), 5 deletions(-)
> > > 
> > > diff --git a/fs/fs-writeback.c b/fs/fs-writeback.c
> > > index ea89b3f..3a80f1b 100644
> > > --- a/fs/fs-writeback.c
> > > +++ b/fs/fs-writeback.c
> > > @@ -1274,8 +1274,9 @@ EXPORT_SYMBOL(writeback_inodes_sb);
> > >   * try_to_writeback_inodes_sb	-	start writeback if none underway
> > >   * @sb: the superblock
> > >   *
> > > - * Invoke writeback_inodes_sb if no writeback is currently underway.
> > > - * Returns 1 if writeback was started, 0 if not.
> > > + * Invoke writeback_inodes_sb if no writeback is currently underway
> > > + * and no one else holds the s_umount lock.  Returns 1 if writeback
> > > + * was started, 0 if not.
> > >   */
> > >  int try_to_writeback_inodes_sb(struct super_block *sb, enum wb_reason reason)
> > >  {
> > > @@ -1288,15 +1289,17 @@ EXPORT_SYMBOL(try_to_writeback_inodes_sb);
> > >   * @sb: the superblock
> > >   * @nr: the number of pages to write
> > >   *
> > > - * Invoke writeback_inodes_sb if no writeback is currently underway.
> > > - * Returns 1 if writeback was started, 0 if not.
> > > + * Invoke writeback_inodes_sb if no writeback is currently underway
> > > + * and no one else holds the s_umount lock.  Returns 1 if writeback
> > > + * was started, 0 if not.
> > >   */
> > >  int try_to_writeback_inodes_sb_nr(struct super_block *sb,
> > >  				   unsigned long nr,
> > >  				   enum wb_reason reason)
> > >  {
> > >  	if (!writeback_in_progress(sb->s_bdi)) {
> > > -		down_read(&sb->s_umount);
> > > +		if (!down_read_trylock(&sb->s_umount))
> > > +		    return 0;
> > >  		if (nr == 0)
> > >  			writeback_inodes_sb(sb, reason);
> > >  		else
> > > -- 
> > > 1.7.5.4

