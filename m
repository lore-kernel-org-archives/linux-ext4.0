From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH] ext4: Always journal quota file modifications
Date: Thu, 3 Jun 2010 01:46:59 +0200
Message-ID: <20100602234658.GA26830@quack.suse.cz>
References: <1275488593-7237-1-git-send-email-jack@suse.cz>
 <4C06CFAF.5000300@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Jan Kara <jack@suse.cz>, tytso@mit.edu, linux-ext4@vger.kernel.org
To: Eric Sandeen <sandeen@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cantor.suse.de ([195.135.220.2]:54117 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758647Ab0FBXrQ (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 2 Jun 2010 19:47:16 -0400
Content-Disposition: inline
In-Reply-To: <4C06CFAF.5000300@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed 02-06-10 16:39:59, Eric Sandeen wrote:
> Jan Kara wrote:
> > When journaled quota options are not specified, we do writes
> > to quota files just in data=ordered mode. This actually causes
> > warnings from JBD2 about dirty journaled buffer because ext4_getblk
> > unconditionally treats a block allocated by it as metadata. Since
> > quota actually is filesystem metadata, the easiest way to get rid
> > of the warning is to always treat quota writes as metadata...
> > 
> > Signed-off-by: Jan Kara <jack@suse.cz>
> 
> Seems like a good approach to me, thanks Jan.
> 
> (aside: how big an impact does this have on journal traffic for a busy
> quota-controlled fs?)
  With quota a bit tricky thing is that amount of load depends on the
amount of different groups / users doing IO (and to some extent on how
much these users / groups share blocks of quota file). One can make a
simplistic upper estimate: 1 journalled block per user / group who modified
something in a transaction...
  Just out of curiosity I have created 10000 files in 10 directories, each
file belonging to a different user. Then I run:
sync; time { for (( i = 0; i < 10000; i++ )); do echo "aaaaaaaa"
>dir$((i/1000))/file$((i%1000)); done; sync; }

and

sync; time { for (( i = 0; i < 10000; i++ )); do
>dir$((i/1000))/file$((i%1000)); done; sync; }

  With journaled quotas enabled the times were pretty consistently around
2.9s for writes and 2.1s for truncates, without quotas the times were
around 2.7s for writes and 1.7s for truncates. So this gives some rough
idea how much quota costs for this rather extreme use case.

  Another case where quota impact is measurable is when several threads
bang files of the same user. Then we hit lock contention on the single dquot
structure, most notably on journaling it whenever it gets modified. Dmitry
was looking into addressing this...

									Honza

> Reviewed-by: Eric Sandeen <sandeen@redhat.com>
> 
> > ---
> >  fs/ext4/super.c |   19 +++++--------------
> >  1 files changed, 5 insertions(+), 14 deletions(-)
> > 
> >   Ted, this patch fixes some JBD2 warning for me when running XFSQA
> > with quotas enabled. I think this is a move into a direction you are
> > trying to achieve as well. Will you merge the patch or should I do it?
> > 
> > 								Honza
> > 
> > diff --git a/fs/ext4/super.c b/fs/ext4/super.c
> > index 4e8983a..a8cea08 100644
> > --- a/fs/ext4/super.c
> > +++ b/fs/ext4/super.c
> > @@ -4030,7 +4030,6 @@ static ssize_t ext4_quota_write(struct super_block *sb, int type,
> >  	ext4_lblk_t blk = off >> EXT4_BLOCK_SIZE_BITS(sb);
> >  	int err = 0;
> >  	int offset = off & (sb->s_blocksize - 1);
> > -	int journal_quota = EXT4_SB(sb)->s_qf_names[type] != NULL;
> >  	struct buffer_head *bh;
> >  	handle_t *handle = journal_current_handle();
> >  
> > @@ -4055,24 +4054,16 @@ static ssize_t ext4_quota_write(struct super_block *sb, int type,
> >  	bh = ext4_bread(handle, inode, blk, 1, &err);
> >  	if (!bh)
> >  		goto out;
> > -	if (journal_quota) {
> > -		err = ext4_journal_get_write_access(handle, bh);
> > -		if (err) {
> > -			brelse(bh);
> > -			goto out;
> > -		}
> > +	err = ext4_journal_get_write_access(handle, bh);
> > +	if (err) {
> > +		brelse(bh);
> > +		goto out;
> >  	}
> >  	lock_buffer(bh);
> >  	memcpy(bh->b_data+offset, data, len);
> >  	flush_dcache_page(bh->b_page);
> >  	unlock_buffer(bh);
> > -	if (journal_quota)
> > -		err = ext4_handle_dirty_metadata(handle, NULL, bh);
> > -	else {
> > -		/* Always do at least ordered writes for quotas */
> > -		err = ext4_jbd2_file_inode(handle, inode);
> > -		mark_buffer_dirty(bh);
> > -	}
> > +	err = ext4_handle_dirty_metadata(handle, NULL, bh);
> >  	brelse(bh);
> >  out:
> >  	if (err) {
> 
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
