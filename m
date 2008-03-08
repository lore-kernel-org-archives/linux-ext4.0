From: "Duane Griffin" <duaneg@dghda.com>
Subject: Re: [PATCH 1/3] jbd2: eliminate duplicated code in revocation table
	init/destroy functions
Date: Sat, 8 Mar 2008 13:20:46 +0000
Message-ID: <20080308132046.GA29324@dastardly.plus.com>
References: <5e28cd633c71f6354a203a43000cbe5fef045589.1204844851.git.duaneg@dghda.com> <20080307215238.GG1881@webber.adilger.int>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Duane Griffin <duaneg@dghda.com>, linux-ext4@vger.kernel.org,
	linux-kernel@vger.kernel.org, Theodore Tso <tytso@mit.edu>,
	sct@redhat.com, akpm@linux-foundation.org, adilger@clusterfs.com
To: Andreas Dilger <adilger@sun.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from kumera.dghda.com ([80.68.90.171]:3119 "EHLO kumera.dghda.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752327AbYCHNUv (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sat, 8 Mar 2008 08:20:51 -0500
Content-Disposition: inline
In-Reply-To: <20080307215238.GG1881@webber.adilger.int>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, Mar 07, 2008 at 02:52:38PM -0700, Andreas Dilger wrote:
> Duane, thanks for doing the cleanup.  Comments inline.

My pleasure! See my responses below and a revised patch at the end.

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

No problem, I'll be redoing it to address your other comments anyway.

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

Unfortunately one space won't do it with size changed to hash_size, so
I'll go for the second option.

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

OK, I'll go for the second option so as not to split the args over two
lines.

> > +	if (!journal->j_revoke_table[0])
> > +		goto failed_alloc1;
> > +	if (jbd2_journal_init_revoke_table(journal->j_revoke_table[0], hash_size))
> 
> (style) wrap at 80 columns.

OK.

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

Indeed, much nicer! And yes, -ENOMEM is the only possible error, unless
I've missed something.

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

Yep.

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

Yes, that looks much nicer.

> Sure, it is a bit more overhead than just freeing the arrays, but
> performance isn't critical if the mount just failed due to ENOMEM,
> and isn't expected to happen very often at all.

Certainly not.

> > +/* Destroy a journal's revoke table.  The table must already be empty! */
> > +void jbd2_journal_destroy_revoke(journal_t *journal)
> > +{
> > +	if (!journal->j_revoke_table[0])
> >  		return;
> 
> (style) empty line here.

OK.

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

Yeah. I was being ultra-paranoid about not changing the behaviour, even
in strange corner cases that shouldn't have happened, like
j_revoke_table[1] being initialised when j_revoke_table[0] wasn't.

Which was a bit silly, in retrospect.

> Same of course applies to both versions of the patch.  Hopefully once ext4
> has had some chance to bake in the kernel (when people start using it after
> the "dev" moniker is removed) and Fedora we can revert back to a single jbd
> code base.  There are no incompatible format changes in jbd2 that would be
> forced upon ext3 by consolidating the code base, it was just split during
> development to avoid destabilizing ext3.

I'll send the jbd version out shortly. Would you like this version sent
out again with S-O-B and changelog, or is it OK like this?

Cheers,
Duane.

-- 
"I never could learn to drink that blood and call it wine" - Bob Dylan

diff --git a/fs/jbd2/revoke.c b/fs/jbd2/revoke.c
index df36f42..07e4703 100644
--- a/fs/jbd2/revoke.c
+++ b/fs/jbd2/revoke.c
@@ -196,109 +196,84 @@ void jbd2_journal_destroy_revoke_caches(void)
 	jbd2_revoke_table_cache = NULL;
 }
 
-/* Initialise the revoke table for a given journal to a given size. */
-
-int jbd2_journal_init_revoke(journal_t *journal, int hash_size)
+static struct jbd2_revoke_table_s *jbd2_journal_init_revoke_table(int hash_size)
 {
-	int shift, tmp;
+	int shift = 0;
+	int tmp = hash_size;
+	struct jbd2_revoke_table_s *table;
 
-	J_ASSERT (journal->j_revoke_table[0] == NULL);
+	table = kmem_cache_alloc(jbd2_revoke_table_cache, GFP_KERNEL);
+	if (!table)
+		goto out;
 
-	shift = 0;
-	tmp = hash_size;
 	while((tmp >>= 1UL) != 0UL)
 		shift++;
 
-	journal->j_revoke_table[0] = kmem_cache_alloc(jbd2_revoke_table_cache, GFP_KERNEL);
-	if (!journal->j_revoke_table[0])
-		return -ENOMEM;
-	journal->j_revoke = journal->j_revoke_table[0];
-
-	/* Check that the hash_size is a power of two */
-	J_ASSERT(is_power_of_2(hash_size));
-
-	journal->j_revoke->hash_size = hash_size;
-
-	journal->j_revoke->hash_shift = shift;
-
-	journal->j_revoke->hash_table =
+	table->hash_size = hash_size;
+	table->hash_shift = shift;
+	table->hash_table =
 		kmalloc(hash_size * sizeof(struct list_head), GFP_KERNEL);
-	if (!journal->j_revoke->hash_table) {
-		kmem_cache_free(jbd2_revoke_table_cache, journal->j_revoke_table[0]);
-		journal->j_revoke = NULL;
-		return -ENOMEM;
+	if (!table->hash_table) {
+		kmem_cache_free(jbd2_revoke_table_cache, table);
+		table = NULL;
+		goto out;
 	}
 
 	for (tmp = 0; tmp < hash_size; tmp++)
-		INIT_LIST_HEAD(&journal->j_revoke->hash_table[tmp]);
+		INIT_LIST_HEAD(&table->hash_table[tmp]);
 
-	journal->j_revoke_table[1] = kmem_cache_alloc(jbd2_revoke_table_cache, GFP_KERNEL);
-	if (!journal->j_revoke_table[1]) {
-		kfree(journal->j_revoke_table[0]->hash_table);
-		kmem_cache_free(jbd2_revoke_table_cache, journal->j_revoke_table[0]);
-		return -ENOMEM;
+out:
+	return table;
+}
+
+static void jbd2_journal_destroy_revoke_table(struct jbd2_revoke_table_s *table)
+{
+	int i;
+	struct list_head *hash_list;
+
+	for (i = 0; i < table->hash_size; i++) {
+		hash_list = &table->hash_table[i];
+		J_ASSERT(list_empty(hash_list));
 	}
 
-	journal->j_revoke = journal->j_revoke_table[1];
+	kfree(table->hash_table);
+	kmem_cache_free(jbd2_revoke_table_cache, table);
+}
 
-	/* Check that the hash_size is a power of two */
+/* Initialise the revoke table for a given journal to a given size. */
+int jbd2_journal_init_revoke(journal_t *journal, int hash_size)
+{
+	J_ASSERT(journal->j_revoke_table[0] == NULL);
 	J_ASSERT(is_power_of_2(hash_size));
 
-	journal->j_revoke->hash_size = hash_size;
+	journal->j_revoke_table[0] = jbd2_journal_init_revoke_table(hash_size);
+	if (!journal->j_revoke_table[0])
+		goto fail0;
 
-	journal->j_revoke->hash_shift = shift;
+	journal->j_revoke_table[1] = jbd2_journal_init_revoke_table(hash_size);
+	if (!journal->j_revoke_table[1])
+		goto fail1;
 
-	journal->j_revoke->hash_table =
-		kmalloc(hash_size * sizeof(struct list_head), GFP_KERNEL);
-	if (!journal->j_revoke->hash_table) {
-		kfree(journal->j_revoke_table[0]->hash_table);
-		kmem_cache_free(jbd2_revoke_table_cache, journal->j_revoke_table[0]);
-		kmem_cache_free(jbd2_revoke_table_cache, journal->j_revoke_table[1]);
-		journal->j_revoke = NULL;
-		return -ENOMEM;
-	}
-
-	for (tmp = 0; tmp < hash_size; tmp++)
-		INIT_LIST_HEAD(&journal->j_revoke->hash_table[tmp]);
+	journal->j_revoke = journal->j_revoke_table[1];
 
 	spin_lock_init(&journal->j_revoke_lock);
 
 	return 0;
-}
 
-/* Destoy a journal's revoke table.  The table must already be empty! */
+fail1:
+	jbd2_journal_destroy_revoke_table(journal->j_revoke_table[0]);
+fail0:
+	return -ENOMEM;
+}
 
+/* Destroy a journal's revoke table.  The table must already be empty! */
 void jbd2_journal_destroy_revoke(journal_t *journal)
 {
-	struct jbd2_revoke_table_s *table;
-	struct list_head *hash_list;
-	int i;
-
-	table = journal->j_revoke_table[0];
-	if (!table)
-		return;
-
-	for (i=0; i<table->hash_size; i++) {
-		hash_list = &table->hash_table[i];
-		J_ASSERT (list_empty(hash_list));
-	}
-
-	kfree(table->hash_table);
-	kmem_cache_free(jbd2_revoke_table_cache, table);
-	journal->j_revoke = NULL;
-
-	table = journal->j_revoke_table[1];
-	if (!table)
-		return;
-
-	for (i=0; i<table->hash_size; i++) {
-		hash_list = &table->hash_table[i];
-		J_ASSERT (list_empty(hash_list));
-	}
