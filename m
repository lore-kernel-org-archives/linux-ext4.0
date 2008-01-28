From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH] Fix commit block write in JBD
Date: Mon, 28 Jan 2008 14:18:54 +0100
Message-ID: <20080128131854.GC14038@duck.suse.cz>
References: <20080123190943.GG10144@duck.suse.cz> <20080126220207.9152ff8b.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Andrew Morton <akpm@linux-foundation.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from styx.suse.cz ([82.119.242.94]:51582 "EHLO duck.suse.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755536AbYA1NS4 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 28 Jan 2008 08:18:56 -0500
Content-Disposition: inline
In-Reply-To: <20080126220207.9152ff8b.akpm@linux-foundation.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sat 26-01-08 22:02:07, Andrew Morton wrote:
> > On Wed, 23 Jan 2008 20:09:43 +0100 Jan Kara <jack@suse.cz> wrote:
> > 
> > Commit block is expected to have several copies of the header. Fix the
> > bug Andrew has spotted ages ago.
> > 
> 
> "ages" indeed.
> 
> > 
> > diff --git a/fs/jbd/commit.c b/fs/jbd/commit.c
> > index 610264b..a69b240 100644
> > --- a/fs/jbd/commit.c
> > +++ b/fs/jbd/commit.c
> > @@ -116,9 +116,8 @@ static int journal_write_commit_record(journal_t *journal,
> >  
> >  	bh = jh2bh(descriptor);
> >  
> > -	/* AKPM: buglet - add `i' to tmp! */
> >  	for (i = 0; i < bh->b_size; i += 512) {
> > -		journal_header_t *tmp = (journal_header_t*)bh->b_data;
> > +		journal_header_t *tmp = (journal_header_t*)(bh->b_data+i);
> >  		tmp->h_magic = cpu_to_be32(JFS_MAGIC_NUMBER);
> >  		tmp->h_blocktype = cpu_to_be32(JFS_COMMIT_BLOCK);
> >  		tmp->h_sequence = cpu_to_be32(commit_transaction->t_tid);
> 
> But I don't think we can _use_ this feature now.  Because there are
> 100000000000 disks out there which didn't implement it.
> So why not just remove the loop and do a single write?
  Yes, but OTOH once the filesystem gets mounted with a new kernel, the
journal gets quickly rewritten and we'll have correct commit blocks there.
But since neither kernel nor e2fsprogs actually check for further sectors
(they check for the header just in the beginning of a block), I agree that
removing the loop completely is probably the best option. Nobody cared so
far so I guess they won't care in future as well. I'll send you a
replacement patch.

									Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
