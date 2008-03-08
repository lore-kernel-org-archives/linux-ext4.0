From: Mingming Cao <cmm@us.ibm.com>
Subject: Re: [PATCH 1/3] jbd2: eliminate duplicated code in
	revocation	table init/destroy functions
Date: Fri, 07 Mar 2008 16:05:26 -0800
Message-ID: <1204934726.14884.63.camel@localhost.localdomain>
References: <5e28cd633c71f6354a203a43000cbe5fef045589.1204844851.git.duaneg@dghda.com>
	 <20080307215238.GG1881@webber.adilger.int>
Reply-To: cmm@us.ibm.com
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Cc: Duane Griffin <duaneg@dghda.com>, linux-ext4@vger.kernel.org,
	linux-kernel@vger.kernel.org, Theodore Tso <tytso@mit.edu>,
	sct@redhat.com, akpm@linux-foundation.org, adilger@clusterfs.com
To: Andreas Dilger <adilger@sun.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e5.ny.us.ibm.com ([32.97.182.145]:54593 "EHLO e5.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752080AbYCHAGD (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 7 Mar 2008 19:06:03 -0500
In-Reply-To: <20080307215238.GG1881@webber.adilger.int>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, 2008-03-07 at 14:52 -0700, Andreas Dilger wrote:
> On Mar 07, 2008  01:31 +0000, Duane Griffin wrote:
> > The revocation table initialisation/destruction code is repeated for each of
> > the two revocation tables stored in the journal. Refactoring the duplicated
> > code into functions is tidier, simplifies the logic in initialisation in
> > particular, and slightly reduces the code size.
> > 
> > There should not be any functional change.
> 
> Duane, thanks for doing the cleanup.  Comments inline.
> 
> > Signed-off-by: Duane Griffin <duaneg@dghda.com>
> > ---
> >  fs/jbd2/revoke.c |  125 +++++++++++++++++++++++-------------------------------
> >  1 files changed, 53 insertions(+), 72 deletions(-)
> > 
> > diff --git a/fs/jbd2/revoke.c b/fs/jbd2/revoke.c
> > index df36f42..1bf4c1f 100644
> > --- a/fs/jbd2/revoke.c
> > +++ b/fs/jbd2/revoke.c
> > @@ -196,108 +196,89 @@ void jbd2_journal_destroy_revoke_caches(void)
> >  	jbd2_revoke_table_cache = NULL;
> >  }
> >  
> > -/* Initialise the revoke table for a given journal to a given size. */
> > -
> > -int jbd2_journal_init_revoke(journal_t *journal, int hash_size)
> > +static int jbd2_journal_init_revoke_table(struct jbd2_revoke_table_s *table,
> > +					  int size)
> >  {
> 
> (minor) calling this "hash_size" would be a bit clearer, and more consistent
> with the old code.  Not a reason in itself to redo the patch though.
> 
> > +	int shift = 0;
> > +	int tmp = size;
> >  
> >  	while((tmp >>= 1UL) != 0UL)
> >  		shift++;
> >  
> > +	table->hash_size = size;
> > +	table->hash_shift = shift;
> > +	table->hash_table = kmalloc(
> > +		size * sizeof(struct list_head), GFP_KERNEL);
> 
> (style) could fit on a single line by removing one space somewhere, or follow
> code style and move only "GFP_KERNEL" to the second line...
> 
> > +	if (!table->hash_table)
> >  		return -ENOMEM;
> >  
> > +	for (tmp = 0; tmp < size; tmp++)
> > +		INIT_LIST_HEAD(&table->hash_table[tmp]);
> >  
> > +	return 0;
> > +}
> >  
> > +/* Initialise the revoke table for a given journal to a given size. */
> > +int jbd2_journal_init_revoke(journal_t *journal, int hash_size)
> > +{
> > +	J_ASSERT(journal->j_revoke_table[0] == NULL);
> >  	J_ASSERT(is_power_of_2(hash_size));
> >  
> > +	journal->j_revoke_table[0] = kmem_cache_alloc(
> > +		jbd2_revoke_table_cache, GFP_KERNEL);
> 
> (style) it is preferred to indent continuation lines to the previous '(' like:
> 
> 	journal->j_revoke_table[0] = kmem_cache_alloc(jbd2_revoke_table_cache,
> 						      GFP_KERNEL);
> 
> or alternately:
> 
> 	journal->j_revoke_table[0] =
> 		kmem_cache_alloc(jbd2_revoke_table_cache, GFP_KERNEL);
> 
> > +	if (!journal->j_revoke_table[0])
> > +		goto failed_alloc1;
> > +	if (jbd2_journal_init_revoke_table(journal->j_revoke_table[0], hash_size))
> 
> (style) wrap at 80 columns.
> 

checkpatch.pl catched this...fyi.

> > +		goto failed_init1;
> >  
> > +	journal->j_revoke_table[1] = kmem_cache_alloc(
> > +		jbd2_revoke_table_cache, GFP_KERNEL);
> > +	if (!journal->j_revoke_table[1])
> > +		goto failed_alloc2;
> > +	if (jbd2_journal_init_revoke_table(journal->j_revoke_table[1], hash_size))
> > +		goto failed_init2;
> 
> (minor) It appears we could reduce some more code duplication by doing
> the allocation of j_revoke_table[0] and j_revoke_table[1] inside
> journal_init_revoke_table(), passing back the table pointer or NULL on
> failure (-ENOMEM is really the only possible error return code here)?
> 
> > +	journal->j_revoke = journal->j_revoke_table[1];
> >  
> >  	spin_lock_init(&journal->j_revoke_lock);
> >  
> >  	return 0;
> >  
> > +failed_init2:
> > +	kmem_cache_free(jbd2_revoke_table_cache, journal->j_revoke_table[1]);
> > +failed_alloc2:
> > +	kfree(journal->j_revoke_table[0]->hash_table);
> > +failed_init1:
> > +	kmem_cache_free(jbd2_revoke_table_cache, journal->j_revoke_table[0]);
> > +failed_alloc1:
> > +	return -ENOMEM;
> 
> Doing the table allocation inside journal_init_revoke_table() also
> simplifies cleanup, because we don't need to handle "init" and "alloc"
> failures separately here.
> 
> > +static void jbd2_journal_destroy_revoke_table(struct jbd2_revoke_table_s *table)
> >  {
> >  	int i;
> > +	struct list_head *hash_list;
> >  
> > +	for (i = 0; i < table->hash_size; i++) {
> >  		hash_list = &table->hash_table[i];
> > +		J_ASSERT(list_empty(hash_list));
> >  	}
> >  
> >  	kfree(table->hash_table);
> >  	kmem_cache_free(jbd2_revoke_table_cache, table);
> > +}
> 
> (minor) This should be moved above journal_init_revoke_table() and be used
> to free the first table if allocation/init of the second table fails.
> That is proper encapsulation of functionality, and by moving the table
> allocation inside journal_init_revoke_table() as previously suggested,
> we never have to handle partially-initialized tables (i.e. alloc, but
> list_heads not init.
> 
> Sure, it is a bit more overhead than just freeing the arrays, but
> performance isn't critical if the mount just failed due to ENOMEM,
> and isn't expected to happen very often at all.
> 
> > +/* Destroy a journal's revoke table.  The table must already be empty! */
> > +void jbd2_journal_destroy_revoke(journal_t *journal)
> > +{
> > +	if (!journal->j_revoke_table[0])
> >  		return;
> 
> (style) empty line here.
> 
> > +	jbd2_journal_destroy_revoke_table(journal->j_revoke_table[0]);
> > +	journal->j_revoke = NULL;
> >  
> > +	if (!journal->j_revoke_table[1])
> > +		return;
> > +	jbd2_journal_destroy_revoke_table(journal->j_revoke_table[1]);
> >  	journal->j_revoke = NULL;
> 
> (style) I'd probably write this as below, to keep the logic simpler:
> 
> 	journal->j_revoke = NULL;
> 
> 	if (journal->j_revoke_table[0])
> 		jbd2_journal_destroy_revoke_table(journal->j_revoke_table[0]);
> 	if (journal->j_revoke_table[1])
> 		jbd2_journal_destroy_revoke_table(journal->j_revoke_table[1]);
> 
> Also, we don't really need to set journal->j_revoke = NULL twice.
> 
> Same of course applies to both versions of the patch.  Hopefully once ext4
> has had some chance to bake in the kernel (when people start using it after
> the "dev" moniker is removed) and Fedora we can revert back to a single jbd
> code base.  There are no incompatible format changes in jbd2 that would be
> forced upon ext3 by consolidating the code base, it was just split during
> development to avoid destabilizing ext3.
> 

Thanks for reviewing this Andreas.

The patch is already in ext4 candidate patch queue.  FYI.

Mingming
> Cheers, Andreas
> --
> Andreas Dilger
> Sr. Staff Engineer, Lustre Group
> Sun Microsystems of Canada, Inc.
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

