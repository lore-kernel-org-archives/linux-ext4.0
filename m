From: Jan Kara <jack@suse.cz>
Subject: Re: Possible race between direct IO and JBD?
Date: Mon, 28 Apr 2008 20:09:32 +0200
Message-ID: <20080428180932.GI17054@duck.suse.cz>
References: <20080306174209.GA14193@duck.suse.cz> <1209166706.6040.20.camel@localhost.localdomain> <20080428122626.GC17054@duck.suse.cz> <1209402694.23575.5.camel@badari-desktop>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Mingming Cao <cmm@us.ibm.com>, akpm@linux-foundation.org,
	linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org
To: Badari Pulavarty <pbadari@us.ibm.com>
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S965551AbYD1SJy@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1209402694.23575.5.camel@badari-desktop>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Mon 28-04-08 10:11:34, Badari Pulavarty wrote:
> 
> On Mon, 2008-04-28 at 14:26 +0200, Jan Kara wrote:
> > Hi,
> > 
> > On Fri 25-04-08 16:38:23, Mingming Cao wrote:
> > > While looking at a bug related to direct IO returns to EIO, after
> > > looking at the code, I found there is a window that
> > > try_to_free_buffers() from direct IO could race with JBD, which holds
> > > the reference to the data buffers before journal_commit_transaction()
> > > ensures the data buffers has reached to the disk.
> > > 
> > > A little more detail: to prepare for direct IO, generic_file_direct_IO()
> > > calls invalidate_inode_pages2_range() to invalidate the pages in the
> > > cache before performaning direct IO.  invalidate_inode_pages2_range()
> > > tries to free the buffers via try_to free_buffers(), but sometimes it
> > > can't, due to the buffers is possible still on some transaction's
> > > t_sync_datalist or t_locked_list waiting for
> > > journal_commit_transaction() to process it. 
> > > 
> > > Currently Direct IO simply returns EIO if try_to_free_buffers() finds
> > > the buffer is busy, as it has no clue that JBD is referencing it.
> > > 
> > > Is this a known issue and expected behavior? Any thoughts?
> >   Are you seeing this in data=ordered mode? As Andrew pointed out we do
> > filemap_write_and_wait() so all the relevant data buffers of the inode
> > should be already on disk. In __journal_try_to_free_buffer() we check
> > whether the buffer is already-written-out data buffer and unfile and free
> > it in that case. It shouldn't happen that a data buffer has
> > b_next_transaction set so really the only idea why try_to_free_buffers()
> > could fail is that somebody manages to write to a page via mmap before
> > invalidate_inode_pages2_range() gets to it. Under which kind of load do you
> > observe the problem? Do you know exactly because of which condition does
> > journal_try_to_free_buffers() fail?
> > 
> 
> Thank you for your reply.
> 
> What we are noticing is invalidate_inode_pages2_range() fails with -EIO
> (from try_to_free_buffers() since b_count > 0).
> 
> I don't think the file is being updated through mmap(). Previous
> writepage() added these buffers to t_sync_data list (data=ordered).
> filemap_write_and_wait() waits for pagewrite back to be cleared.
> So, buffers are no longer dirty, but still on the t_sync_data and
> kjournald didn't get chance to process them yet :(
> 
> Since we have elevated b_count on these buffers, try_to_free_buffers()
> fails. How can we make filemap_write_and_wait() to wait for kjournald
> to unfile these buffers ?
  Hmm, I don't get one thing:
  The call chain is invalidate_inode_pages2_range() ->
invalidate_complete_page2() -> try_to_release_page() -> ext3_releasepage()
-> journal_try_to_free_buffers() -> __journal_try_to_free_buffer() and this
function should remove the buffer from the committing transaction. So who's
holding the reference to those buffers? Or is it that
__journal_try_to_free_buffer() fails to remove the buffer from the
committing transaction? Why?
  Hmm, maybe I have one idea - in theory we could call
__journal_try_to_free_buffer() exactly at the moment commit code inspects
the buffer. Then we'd release the buffer from the transaction but
try_to_free_buffers() would fail because of elevated b_count exactly as you
described. Could you maybe verify this? Not that I'd know how to easily fix
this ;)...

									Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
