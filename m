From: Josef Bacik <josef@redhat.com>
Subject: Re: [PATCH] jbd: clear b_modified before moving the jh to a
 different transaction
Date: Thu, 5 Apr 2012 10:19:54 -0400
Message-ID: <20120405141951.GA2086@localhost.localdomain>
References: <1326219175-4529-1-git-send-email-josef@redhat.com>
 <20120404075520.GA5725@quack.suse.cz>
 <20120404164656.GA2097@localhost.localdomain>
 <20120404211444.GA4214@quack.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Josef Bacik <josef@redhat.com>, linux-fsdevel@vger.kernel.org,
	linux-ext4@vger.kernel.org
To: Jan Kara <jack@suse.cz>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:23484 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751608Ab2DEOUV (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 5 Apr 2012 10:20:21 -0400
Content-Disposition: inline
In-Reply-To: <20120404211444.GA4214@quack.suse.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, Apr 04, 2012 at 11:14:44PM +0200, Jan Kara wrote:
> On Wed 04-04-12 12:46:57, Josef Bacik wrote:
> > On Wed, Apr 04, 2012 at 09:55:20AM +0200, Jan Kara wrote:
> > > On Tue 10-01-12 13:12:55, Josef Bacik wrote:
> > > > If we are journalling data (ie journal=data or big symlinks) we can discard
> > > > buffers and move them to different transactions to make sure they get cleaned up
> > > > properly.  The problem is b_modified could still be set from the last
> > > > transaction that touched it, so putting it on the currently running transaction
> > > > or setting it up to be put on the next transaction will run into problems if the
> > > > buffer gets reused in that transaction as the space accounting logic won't be
> > > > done, which will result in panics at commit time because t_nr_buffers will end
> > > > up being more than t_outstanding_credits.  Thanks to Jan Kara for pointing out
> > > > the other part of this problem a few months ago.  Thanks,
> > > > 
> > > > Signed-off-by: Josef Bacik <josef@redhat.com>
> > >   So I think I've nailed this down. Your feeling that the problem is with
> > > refiling buffer to BJ_Forget list of the running transaction was right. The
> > > missing piece to the puzzle was that journal_invalidatepage() can get
> > > called not only when underlying block is freed but also when someone
> > > flushes page cache. The traces I have suggest that someone has flushed page
> > > cache (likely of the block device), that moved buffer from the checkpoint
> > > list to BJ_Forget list of the running transaction and then the same running
> > > transaction tried to modify the buffer which triggered the accounting
> > > problem you spotted.
> > > 
> > > I have updated the changelog and pushed the patch to my tree (for JBD
> > > only). I'll duplicate the patch for JBD2 tomorrow.
> > > 
> > 
> > Ok now it's my turn to be unsure ;).  I thought invalidatepage could only be
> > called via truncate?  You say it happens when someone flushes pagecache, do you
> > mean like echo 3 > /proc/sys/vm/drop_caches?
>   Yup, or things like BLKFLSBUF ioctl. But yes, you are right they don't
> end up calling ext3_invalidatepage() I often get confused by the name of
> invalidate_mapping_pages()... Anyway ext3_invalidatepage() definitely gets
> called (I see that in my traces) and now I tend to thing it's from
> ext3_evict_inode(). The guy was using 2.6.37 kernel which doesn't have
> b22570d9abb3d844e65c15c8bc0d57a78129e3b4 so truncate_inode_pages() gets
> called from ext3_evict_inode() before the buffer is checkpointed and that
> causes the described scenario. But the guy claims he's seen the problem
> with 3.2 as well. So I guess I'll forward-port the buffer tracking patches
> and ask him to reproduce with 3.2.
> 

Ah yeah and my reports are from RHEL5 which calls truncate_inode_pages from
generic_forget_inode, so that makes sense, but yeah why it would happen on newer
stuff is weird.  Let me know how that works out ;).  If anything the patch is
obviously correct, I'm ok with patch and praying.  Thanks,

Josef
