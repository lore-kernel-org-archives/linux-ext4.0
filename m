From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH 3/4] jbd2: restart replay without revokes if journal
 block csum fails
Date: Thu, 11 Sep 2014 10:30:09 -0700
Message-ID: <20140911173009.GL10351@birch.djwong.org>
References: <20140911002818.10109.51772.stgit@birch.djwong.org>
 <20140911002838.10109.50948.stgit@birch.djwong.org>
 <20140911131511.GA30901@quack.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: tytso@mit.edu, linux-ext4@vger.kernel.org
To: Jan Kara <jack@suse.cz>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:34406 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751761AbaIKRaR (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 11 Sep 2014 13:30:17 -0400
Content-Disposition: inline
In-Reply-To: <20140911131511.GA30901@quack.suse.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, Sep 11, 2014 at 03:15:11PM +0200, Jan Kara wrote:
> On Wed 10-09-14 17:28:38, Darrick J. Wong wrote:
> > If, during a journal_checksum_v3 replay we encounter a block that
> > doesn't match its tag in the descriptor block tag, we need to restart
> > the replay without the revoke table in the hopes of replaying the
> > newest non-corrupt version of the block that we possibly can.
>   Ho hum, I don't like this. If you just ignore revoke list, you'll happily
> overwrite freshly allocated data blocks with older metadata. Also when
> verifying the checksum, we already know the block hasn't been revoked
> so what's even the benefit of ignoring the revoke list?

Let's say block X contains contents B0 and the journal contains:

 1. write block 1 with B1
 2. revoke "write of block 1 (with B1)"
 3. write block 1 with B2

Now say that B2 gets corrupt, which means that #3 won't get replayed.  Because
the revoke in #2 prevented the write in #1 from being written, at the end of
replay, block 1 has contents B0, even though B1 could have been played back.

What I'm really confused about is the intent of revoke records -- do they exist
to say "don't replay older versions of this block; a new one will follow
later"?  Or they mean only "don't replay this block if it exists in an earlier
transaction" either because a newer block will follow OR because that block is
now something non-journalled (i.e.  file data)?  I started off thinking the
first, but perhaps it's really the second.

Rather than dumping the entire revoke list, I think I can just erase the
previous revoke records for just the corrupt block and then restart the replay.

--D

> 
> 								Honza
>  
> > Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> > ---
> >  fs/jbd2/recovery.c |   19 +++++++++++++++++--
> >  1 file changed, 17 insertions(+), 2 deletions(-)
> > 
> > 
> > diff --git a/fs/jbd2/recovery.c b/fs/jbd2/recovery.c
> > index 9b329b5..0094d8b 100644
> > --- a/fs/jbd2/recovery.c
> > +++ b/fs/jbd2/recovery.c
> > @@ -439,6 +439,7 @@ static int do_one_pass(journal_t *journal,
> >  	 * block offsets): query the superblock.
> >  	 */
> >  
> > +restart_pass:
> >  	sb = journal->j_superblock;
> >  	next_commit_ID = be32_to_cpu(sb->s_sequence);
> >  	next_log_block = be32_to_cpu(sb->s_start);
> > @@ -585,7 +586,8 @@ static int do_one_pass(journal_t *journal,
> >  					/* If the block has been
> >  					 * revoked, then we're all done
> >  					 * here. */
> > -					if (jbd2_journal_test_revoke
> > +					if (!block_error &&
> > +					    jbd2_journal_test_revoke
> >  					    (journal, blocknr,
> >  					     next_commit_ID)) {
> >  						brelse(obh);
> > @@ -599,11 +601,24 @@ static int do_one_pass(journal_t *journal,
> >  						be32_to_cpu(tmp->h_sequence))) {
> >  						brelse(obh);
> >  						success = -EIO;
> > +						if (!block_error) {
> > +							/* If we see a corrupt
> > +							 * block, kill the
> > +							 * revoke list and
> > +							 * restart the replay
> > +							 * so that the blocks
> > +							 * are as close to
> > +							 * accurate as
> > +							 * possible. */
> > +							jbd2_journal_clear_revoke(journal);
> > +							brelse(bh);
> > +							block_error = 1;
> > +							goto restart_pass;
> > +						}
> >  						printk(KERN_ERR "JBD2: Invalid "
> >  						       "checksum recovering "
> >  						       "block %llu in log\n",
> >  						       blocknr);
> > -						block_error = 1;
> >  						goto skip_write;
> >  					}
> >  
> > 
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> -- 
> Jan Kara <jack@suse.cz>
> SUSE Labs, CR
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
