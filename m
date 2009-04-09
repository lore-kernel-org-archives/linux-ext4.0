From: Jan Kara <jack@suse.cz>
Subject: Re: [GIT PULL] Ext3 latency fixes
Date: Thu, 9 Apr 2009 19:36:00 +0200
Message-ID: <20090409173600.GC26552@atrey.karlin.mff.cuni.cz>
References: <E1LrhNF-0002zd-BG@closure.thunk.org> <alpine.LFD.2.00.0904090836060.4583@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Theodore Ts'o <tytso@mit.edu>,
	Linux Kernel Developers List <linux-kernel@vger.kernel.org>,
	Ext4 Developers List <linux-ext4@vger.kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S932149AbZDIRhb@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.00.0904090836060.4583@localhost.localdomain>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

> On Wed, 8 Apr 2009, Theodore Ts'o wrote:
> > 
> > One of these patches fixes a performance regression caused by a64c8610,
> > which unplugged the write queue after every page write.  Now that Jens
> > added WRITE_SYNC_PLUG.the patch causes us to use it instead of
> > WRITE_SYNC, to avoid the implicit unplugging.  These patches also seem
> > to further improbve ext3 latency, especially during the "sync" command
> > in Linus's write-big-file-and-sync workload.
> 
> So here's a question and a untested _conceptual_ patch. 
> 
> The kind of writeback mode I'd personally prefer would be more of a 
> mixture of the current "data=writeback" and "data=ordered" modes, with 
> something of the best of both worlds. I'd like the data writeback to get 
> _started_ when the journal is written to disk, but I'd like it to not 
> block journal updates.
> 
> IOW, it wouldn't be "strictly ordered", but at the same time it wouldn't 
> be totally unordered either.
> 
> For true sync operations (ie fsync()), the VFS layer then does the proper 
> "wait for data" part.
> 
> I dunno. I don't actually know the JBD internal constraints, but what I'm 
> talking about is something like the appended patch. It wouldn't help under 
> really heavy writeback IO (because even if we don't end up waiting for all 
> the random data to complete, we'd end up waiting when _submitting_ it), 
> but it might help under somewhat less extreme loads.
> 
> This is totally untested. It might well violate some serious internal jbd 
> rules and eat your filesystem, for all I know. I'm throwing the patch out 
> as a "would something _like_ this perhaps make sense as a half-way-point 
> between 'ordered' and 'writeback', nothing more.
  Yes, your patch should work - it'll change the meaning of ordered mode
as you describe above. It's kind of even safer version than Ted's tweaks
to submit IO after truncate / rename. But it has also higher cost not
only in terms of IO but also because we have to track data buffers in
journal lists in this mode. But if we decide this is a way to go, then I
can port my ordered mode changes from JBD2 so that we track inodes and
not all data buffers in journal lists and that would mitigate this
disadvantage.

									Honza
> ---
>  fs/jbd/commit.c |   11 ++++++++++-
>  1 files changed, 10 insertions(+), 1 deletions(-)
> 
> diff --git a/fs/jbd/commit.c b/fs/jbd/commit.c
> index a8e8513..5bea3ed 100644
> --- a/fs/jbd/commit.c
> +++ b/fs/jbd/commit.c
> @@ -184,6 +184,9 @@ static void journal_do_submit_data(struct buffer_head **wbuf, int bufs,
>  	}
>  }
>  
> +/* This would obviously be a real flag, set at mount time */
> +#define BACKGROUND_DATA(journal) (1)
> +
>  /*
>   *  Submit all the data buffers to disk
>   */
> @@ -198,6 +201,9 @@ static int journal_submit_data_buffers(journal_t *journal,
>  	struct buffer_head **wbuf = journal->j_wbuf;
>  	int err = 0;
>  
> +	if (BACKGROUND_DATA(journal))
> +		write_op = WRITE;
> +
>  	/*
>  	 * Whenever we unlock the journal and sleep, things can get added
>  	 * onto ->t_sync_datalist, so we have to keep looping back to
> @@ -254,7 +260,10 @@ write_out_data:
>  		if (locked && test_clear_buffer_dirty(bh)) {
>  			BUFFER_TRACE(bh, "needs writeout, adding to array");
>  			wbuf[bufs++] = bh;
> -			__journal_file_buffer(jh, commit_transaction,
> +			if (BACKGROUND_DATA(journal))
> +				__journal_unfile_buffer(jh);
> +			else
> +				__journal_file_buffer(jh, commit_transaction,
>  						BJ_Locked);
>  			jbd_unlock_bh_state(bh);
>  			if (bufs == journal->j_wbufsize) {
-- 
Jan Kara <jack@suse.cz>
SuSE CR Labs
