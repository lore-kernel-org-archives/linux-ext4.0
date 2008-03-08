From: "Duane Griffin" <duaneg@dghda.com>
Subject: Re: [PATCH 2/3] jbd2: replace potentially false assertion with if
	block
Date: Sat, 8 Mar 2008 13:33:24 +0000
Message-ID: <20080308133324.GA9422@dastardly.plus.com>
References: <5e28cd633c71f6354a203a43000cbe5fef045589.1204844851.git.duaneg@dghda.com> <48afbb3a44aa24dc1e31835c14e86c3c6c1c3b0a.1204844851.git.duaneg@dghda.com> <20080307212336.GE1881@webber.adilger.int>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Duane Griffin <duaneg@dghda.com>, linux-ext4@vger.kernel.org,
	linux-kernel@vger.kernel.org, Theodore Tso <tytso@mit.edu>,
	sct@redhat.com, akpm@linux-foundation.org
To: Andreas Dilger <adilger@sun.com>
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1754795AbYCHNdm@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20080307212336.GE1881@webber.adilger.int>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Fri, Mar 07, 2008 at 02:23:36PM -0700, Andreas Dilger wrote:
> On Mar 07, 2008  01:31 +0000, Duane Griffin wrote:
> > If an error occurs during jbd2 cache initialisation it is possible for the
> > journal_head_cache to be NULL when jbd2_journal_destroy_journal_head_cache is
> > called. Replace the J_ASSERT with an if block to handle the situation
> > correctly.
> > 
> > Note that even with this fix things will break badly if jbd2 is statically
> > compiled in and cache initialisation fails.
> 
> It would probably be prudent to verify that these caches are initialized
> at journal_load() time and either re-try to create the cache, and/or report
> an error in that case and refuse to continue mounting.

Sounds like a plan. I'll see what I can whip up.

> Also, I note that journal_init_journal_head_cache() is comparing pointers
> to "0", a style no-no...

Yes, checkpatch noticed that, too. It was in the original, so I left it
alone. There are also a couple of places in revoke.c where it is done.
See the patch below. If you like it I'll send through one for jbd too.

Cheers,
Duane.

-- 
"I never could learn to drink that blood and call it wine" - Bob Dylan

diff --git a/fs/jbd2/journal.c b/fs/jbd2/journal.c
index 9d48419..75349b1 100644
--- a/fs/jbd2/journal.c
+++ b/fs/jbd2/journal.c
@@ -1969,14 +1969,14 @@ static int journal_init_jbd2_journal_head_cache(void)
 {
 	int retval;
 
-	J_ASSERT(jbd2_journal_head_cache == 0);
+	J_ASSERT(!jbd2_journal_head_cache);
 	jbd2_journal_head_cache = kmem_cache_create("jbd2_journal_head",
 				sizeof(struct journal_head),
 				0,		/* offset */
 				SLAB_TEMPORARY,	/* flags */
 				NULL);		/* ctor */
 	retval = 0;
-	if (jbd2_journal_head_cache == 0) {
+	if (!jbd2_journal_head_cache) {
 		retval = -ENOMEM;
 		printk(KERN_EMERG "JBD: no memory for journal_head cache\n");
 	}
diff --git a/fs/jbd2/revoke.c b/fs/jbd2/revoke.c
index 1bf4c1f..cae1172 100644
--- a/fs/jbd2/revoke.c
+++ b/fs/jbd2/revoke.c
@@ -174,13 +174,13 @@ int __init jbd2_journal_init_revoke_caches(void)
 					   0,
 					   SLAB_HWCACHE_ALIGN|SLAB_TEMPORARY,
 					   NULL);
-	if (jbd2_revoke_record_cache == 0)
+	if (!jbd2_revoke_record_cache)
 		return -ENOMEM;
 
 	jbd2_revoke_table_cache = kmem_cache_create("jbd2_revoke_table",
 					   sizeof(struct jbd2_revoke_table_s),
 					   0, SLAB_TEMPORARY, NULL);
-	if (jbd2_revoke_table_cache == 0) {
+	if (!jbd2_revoke_table_cache) {
 		kmem_cache_destroy(jbd2_revoke_record_cache);
 		jbd2_revoke_record_cache = NULL;
 		return -ENOMEM;
