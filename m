From: Mingming Cao <cmm@us.ibm.com>
Subject: Re: Possible race between direct IO and JBD?
Date: Mon, 28 Apr 2008 12:09:23 -0700
Message-ID: <1209409764.11872.6.camel@localhost.localdomain>
References: <20080306174209.GA14193@duck.suse.cz>
	 <1209166706.6040.20.camel@localhost.localdomain>
	 <20080428122626.GC17054@duck.suse.cz>
	 <1209402694.23575.5.camel@badari-desktop>
	 <20080428180932.GI17054@duck.suse.cz>
Reply-To: cmm@us.ibm.com
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Cc: Badari Pulavarty <pbadari@us.ibm.com>, akpm@linux-foundation.org,
	linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org
To: Jan Kara <jack@suse.cz>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e1.ny.us.ibm.com ([32.97.182.141]:42740 "EHLO e1.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S937163AbYD1TJ1 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 28 Apr 2008 15:09:27 -0400
In-Reply-To: <20080428180932.GI17054@duck.suse.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, 2008-04-28 at 20:09 +0200, Jan Kara wrote: 
> On Mon 28-04-08 10:11:34, Badari Pulavarty wrote:
> > 
> > On Mon, 2008-04-28 at 14:26 +0200, Jan Kara wrote:
> > > Hi,
> > > 
> > > On Fri 25-04-08 16:38:23, Mingming Cao wrote:
> > > > While looking at a bug related to direct IO returns to EIO, after
> > > > looking at the code, I found there is a window that
> > > > try_to_free_buffers() from direct IO could race with JBD, which holds
> > > > the reference to the data buffers before journal_commit_transaction()
> > > > ensures the data buffers has reached to the disk.
> > > > 
> > > > A little more detail: to prepare for direct IO, generic_file_direct_IO()
> > > > calls invalidate_inode_pages2_range() to invalidate the pages in the
> > > > cache before performaning direct IO.  invalidate_inode_pages2_range()
> > > > tries to free the buffers via try_to free_buffers(), but sometimes it
> > > > can't, due to the buffers is possible still on some transaction's
> > > > t_sync_datalist or t_locked_list waiting for
> > > > journal_commit_transaction() to process it. 
> > > > 
> > > > Currently Direct IO simply returns EIO if try_to_free_buffers() finds
> > > > the buffer is busy, as it has no clue that JBD is referencing it.
> > > > 
> > > > Is this a known issue and expected behavior? Any thoughts?
> > >   Are you seeing this in data=ordered mode? As Andrew pointed out we do
> > > filemap_write_and_wait() so all the relevant data buffers of the inode
> > > should be already on disk. In __journal_try_to_free_buffer() we check
> > > whether the buffer is already-written-out data buffer and unfile and free
> > > it in that case. It shouldn't happen that a data buffer has
> > > b_next_transaction set so really the only idea why try_to_free_buffers()
> > > could fail is that somebody manages to write to a page via mmap before
> > > invalidate_inode_pages2_range() gets to it. Under which kind of load do you
> > > observe the problem? Do you know exactly because of which condition does
> > > journal_try_to_free_buffers() fail?
> > > 
> > 
> > Thank you for your reply.
> > 
> > What we are noticing is invalidate_inode_pages2_range() fails with -EIO
> > (from try_to_free_buffers() since b_count > 0).
> > 
> > I don't think the file is being updated through mmap(). Previous
> > writepage() added these buffers to t_sync_data list (data=ordered).
> > filemap_write_and_wait() waits for pagewrite back to be cleared.
> > So, buffers are no longer dirty, but still on the t_sync_data and
> > kjournald didn't get chance to process them yet :(
> > 
> > Since we have elevated b_count on these buffers, try_to_free_buffers()
> > fails. How can we make filemap_write_and_wait() to wait for kjournald
> > to unfile these buffers ?
>   Hmm, I don't get one thing:
>   The call chain is invalidate_inode_pages2_range() ->
> invalidate_complete_page2() -> try_to_release_page() -> ext3_releasepage()
> -> journal_try_to_free_buffers() -> __journal_try_to_free_buffer() and this
> function should remove the buffer from the committing transaction. 

Thanks, yes I noticed that after you pointing this out.

But __journal_try_to_free_buffer() only unfile the buffer from
t_sync_datalist or t_locked list, the journal head is not removed in
journal_remove_journal_head() there, at that time,
journal_remove_journal_head() just check if counter b_jcount is 0. But
before calling __journal_try_to_free_buffer(), since
journal_try_to_free_buffers() already increase the b_jcount in
journal_grab_journal_head(), so the journal head is not removed in
__journal_try_to_free_buffer-> journal_remove_journal_head()

> So who's
> holding the reference to those buffers? 

Looking at the code, it seems the it's the journal_put_journal_head(jh)
who remove the journal head and decrease the bh

journal_try_to_free_buffers() 
{
...

jh = journal_grab_journal_head(bh);
                if (!jh)
                        continue;

                jbd_lock_bh_state(bh);
                __journal_try_to_free_buffer(journal, bh);
                journal_put_journal_head(jh);
                jbd_unlock_bh_state(bh);

...

}
 so when journal_put_journal_head()-> __journal_remove_journal_head(),
now the b_jcount is zero, but is  
jh->b_transaction is NULL? So it seems possible that bh ref count is non
zero when exit from journal_put_journal_head() if jh_b_transaction is
not cleared.

I miss where jh->b_transaction is clear to NULL? 

void journal_put_journal_head(struct journal_head *jh)
{
        struct buffer_head *bh = jh2bh(jh);

        jbd_lock_bh_journal_head(bh);
        J_ASSERT_JH(jh, jh->b_jcount > 0);
        --jh->b_jcount;
        if (!jh->b_jcount && !jh->b_transaction) {
                __journal_remove_journal_head(bh);
                __brelse(bh);
        }
        jbd_unlock_bh_journal_head(bh);
}


Mingming

> Or is it that
> __journal_try_to_free_buffer() fails to remove the buffer from the
> committing transaction? Why?
>   Hmm, maybe I have one idea - in theory we could call
> __journal_try_to_free_buffer() exactly at the moment commit code inspects
> the buffer. Then we'd release the buffer from the transaction but
> try_to_free_buffers() would fail because of elevated b_count exactly as you
> described. Could you maybe verify this? Not that I'd know how to easily fix
> this ;)...
> 
> 									Honza

