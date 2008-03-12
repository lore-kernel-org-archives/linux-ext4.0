From: "Duane Griffin" <duaneg@dghda.com>
Subject: Re: [RFC, PATCH 5/6] jbd: add support for read-only log recovery
Date: Wed, 12 Mar 2008 01:40:56 +0000
Message-ID: <20080312014056.GA21711@dastardly.plus.com>
References: <a047dfbd7855d5f484ae8a3434f6a073302505be.1204685366.git.duaneg@dghda.com> <7f095bf2403465433796f2f7aab20f1c9a2e0f73.1204685366.git.duaneg@dghda.com> <20080311150514.GC6544@atrey.karlin.mff.cuni.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Duane Griffin <duaneg@dghda.com>, linux-ext4@vger.kernel.org,
	linux-kernel@vger.kernel.org, Theodore Tso <tytso@mit.edu>,
	sct@redhat.com, akpm@linux-foundation.org, adilger@clusterfs.com
To: Jan Kara <jack@suse.cz>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from kumera.dghda.com ([80.68.90.171]:4255 "EHLO kumera.dghda.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751188AbYCLBlA (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 11 Mar 2008 21:41:00 -0400
Content-Disposition: inline
In-Reply-To: <20080311150514.GC6544@atrey.karlin.mff.cuni.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, Mar 11, 2008 at 04:05:14PM +0100, Jan Kara wrote:
>   Hmm, how about setting some journal flag in memory and using that one,
> instead of passing 'write' parameter through the functions. And you'd
> also have a nicer solution to your problem in journal_destroy()
> and a few other functions.

That sounds promising. I'll rework it and see how it looks, thanks.

>   Also dynamic sizing of the hashtable would be useful, when you know
> needed number of entries anyway...

Yes, indeed. I'll probably look at this after I get remount support
working.

>   And you have one problem you don't seem to be aware of: JBD escapes
> data in the block to avoid magic number in the first four bytes of the
> block (see the code replaying data from the journal). You have to do
> this unescaping when reading blocks from the journal so it's not that
> easy as you have it now.

D'oh! I noticed that in the journal replay code, but it didn't quite
register. Thanks for pointing it out. I'll think about that and make
sure to add it to my test scripts so it doesn't get overlooked.

> > +void journal_destroy_translations(journal_t *journal)
> > +{
> > +	int ii;
> > +	struct journal_block_translation *jbt;
> > +	struct hlist_node *tmp;
> > +	struct hlist_node *node;
> > +
> > +	if (!journal->j_bt_hash)
> > +		return;
> > +
> > +	for (ii = 0; ii < (1 << journal->j_bt_hash_bits); ii++) {
>   Hmm, why are you using 'ii' and not just 'i'? :) It's below as well.

Habit :)

I usually use ii, jj, etc as they are easier to grep for. However, not
linux style, I must admit. I'll change it.

> > @@ -365,28 +506,34 @@ static int replay_descriptor_block(
> >  			goto skip_write;
> >  		}
> >  
> > -		err = jread(&obh, journal, io_block);
> > -		if (err) {
> > +		if (journal->j_bt_hash) {
> > +			err = journal_record_bt(journal, blocknr, io_block);
> > +		} else {
> > +			struct buffer_head *obh;
> >  
> > -			/* Recover what we can, but
> > -			 * report failure at the end. */
> > -			success = err;
> > -			printk(KERN_ERR "JBD: IO error %d recovering "
> > -			       "block %ld in log\n", err, io_block);
> > -			continue;
> > -		}
> > -		J_ASSERT(obh != NULL);
> > +			err = jread(&obh, journal, io_block);
> > +			if (err) {
> >  
> > -		err = replay_data_block(journal, obh, data, flags, blocknr);
> > -		if (err) {
> > +				/* Recover what we can, but
> > +				 * report failure at the end. */
> > +				success = err;
> > +				printk(KERN_ERR "JBD: IO error %d recovering "
> > +				       "block %ld in log\n", err, io_block);
> > +				continue;
> > +			}
> > +			J_ASSERT(obh != NULL);
> > +
> > +			err = replay_data_block(
> > +				journal, obh, data, flags, blocknr);
> >  			brelse(obh);
> > +		}
> > +		if (err) {
> >  			printk(KERN_ERR "JBD: Out of memory during recovery\n");
> >  			success = err;
> >  			goto failed;
> >  		}
> >  
> ->  		++info->nr_replays;

Sorry, not sure if you are pointing something out or if this is a mailer
glitch. If the former, I'm afraid I don't understand.

> Jan Kara <jack@suse.cz>
> SuSE CR Labs

Cheers,
Duane.

-- 
"I never could learn to drink that blood and call it wine" - Bob Dylan
