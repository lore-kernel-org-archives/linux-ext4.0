From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH 1/4] ext4: Fix deadlock during page writeback
Date: Fri, 1 Jul 2016 19:40:41 +0200
Message-ID: <20160701174041.GA30040@quack2.suse.cz>
References: <1466073736-30447-1-git-send-email-jack@suse.cz>
 <1466073736-30447-2-git-send-email-jack@suse.cz>
 <20160630150548.GC2028@thunk.org>
 <20160701090950.GB22922@quack2.suse.cz>
 <20160701165339.GB6075@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Jan Kara <jack@suse.cz>, linux-ext4@vger.kernel.org,
	Eryu Guan <eguan@redhat.com>, stable@vger.kernel.org
To: Theodore Ts'o <tytso@mit.edu>
Return-path: <stable-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20160701165339.GB6075@thunk.org>
Sender: stable-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Fri 01-07-16 12:53:39, Ted Tso wrote:
> On Fri, Jul 01, 2016 at 11:09:50AM +0200, Jan Kara wrote:
> > But it is not safe - the bio contains pages, those pages have PageWriteback
> > set and if the inode is part of the running transaction,
> > ext4_journal_stop() will wait for transaction commit which will wait for
> > all outstanding writeback on the inode, which will deadlock on those pages
> > which are part of our unsubmitted bio. So the ordering really has to be the
> > way it is...
> 
> So to be clear. the issue is that PageWriteback won't get cleared
> until we potentially do a uninit->init conversion, and this is what
> requires taking a transaction handle leading to the other half of the
> deadlock?

No. It is even simpler:

ext4_writepages(inode == "foobar")
  prepares pages to write, sets PageWriteback
  ...
  mpage_map_and_submit_extent()
    // Writing data past i_size
    if (disksize > EXT4_I(inode)->i_disksize) {
      ...
      err2 = ext4_mark_inode_dirty(handle, inode);
        ext4_mark_iloc_dirty(handle, inode, &iloc);
          ext4_do_update_inode(handle, inode, iloc);
            // First file beyond 2 GB
            if (ei->i_disksize > 0x7fffffffULL) {
              if (!ext4_has_feature_large_file(sb) || ...)
                set_large_file = 1;
            }
            ...
            if (set_large_file) {
              ...
              ext4_handle_sync(handle);
              ...
            }
  ext4_journal_stop()
    jbd2_journal_stop(handle);
      ...
      if (handle->h_sync || ... ) {
        if (handle->h_sync && !(current->flags & PF_MEMALLOC))
          wait_for_commit = 1;
      if (wait_for_commit)
        err = jbd2_log_wait_commit(journal, tid);

So we are waiting for transaction commit to finish with unsubmitted pages
that already have PageWriteback set (and also potentially other pages that
are locked and we didn't prepare them for writing because the block mapping
we got was too short). Now JBD2 goes on trying to do the transaction
commit:

jbd2_journal_commit_transaction()
  ...
  journal_finish_inode_data_buffers()
    list_for_each_entry(jinode, &commit_transaction->t_inode_list, i_list) {
      ...
      err = filemap_fdatawait(jinode->i_vfs_inode->i_mapping);
      // And when inode "foobar" is part of this transaction's inode list, this
      // call is going to wait for PageWriteback bits on all the pages of
      // the inode to get cleared - which never happens because the IO was
      // not even submitted for them. The bio is just sitting prepared in
      // mpd.io_submit in ext4_writepages() and would be submitted once
      // ext4_journal_stop() completes.

Hope it is clearer now.

								Honza
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
