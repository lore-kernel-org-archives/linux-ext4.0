From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: Re: [PATCH] fix up thinko in jbd2 revoke code
Date: Mon, 21 Apr 2008 15:24:08 +0530
Message-ID: <20080421095408.GA4212@skywalker>
References: <1206979062.3192.26.camel@localhost.localdomain> <1206988258.3653.2.camel@localhost.localdomain> <20080403161727.GA627@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Mingming Cao <cmm@us.ibm.com>,
	James Bottomley <James.Bottomley@HansenPartnership.com>,
	linux-fsdevel@vger.kernel.org, Duane Griffin <duaneg@dghda.com>,
	linux-ext4 <linux-ext4@vger.kernel.org>
To: Christoph Hellwig <hch@infradead.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from E23SMTP04.au.ibm.com ([202.81.18.173]:56582 "EHLO
	e23smtp04.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750814AbYDUJy1 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 21 Apr 2008 05:54:27 -0400
Content-Disposition: inline
In-Reply-To: <20080403161727.GA627@infradead.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, Apr 03, 2008 at 12:17:27PM -0400, Christoph Hellwig wrote:
> On Mon, Mar 31, 2008 at 11:30:58AM -0700, Mingming Cao wrote:
> > On Mon, 2008-03-31 at 10:57 -0500, James Bottomley wrote:
> > > This commit:
> > > 
> > > commit e898f3154d78d1520265aade0992981866d827fb
> > > Author: Duane Griffin <duaneg@dghda.com>
> > > Date:   Tue Mar 25 19:47:39 2008 -0400
> > > 
> > >     jbd2: tidy up revoke cache initialisation and destruction
> > > 
> > > Introduced a thinko (it doesn't check whether jbd2_revoke_record cache
> > > is null, it checks jbd2_revoke_table_cache twice).
> > > 
> > > Signed-off-by: James Bottomley <James.Bottomley@HansenPartnership.com>
> > > 
> > Signed-off-by: Mingming Cao <cmm@us.ibm.com>
> > 
> > Thanks, I picked this up in ext4 patch queue.
> 
> anyone care to convert this function to proper goto-based error
> unwinding?

Like below. ?

Mingming,

I folded jbd2-tidy-up-revoe-cache-intialisation-and-destruction.patch
jbd2-fix-up-thinko-in-jbd2-revoke-code.patch in the patch queue to 
this.

-aneesh


jbd2: tidy up revoke cache initialisation and destruction

From: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>

Make revocation cache destruction safe to call if initialisation fails
partially or entirely.  This allows it to be used to cleanup in the case of
initialisation failure, simplifying the code slightly.

Signed-off-by: Duane Griffin <duaneg@dghda.com>
Signed-off-by: Mingming Cao <cmm@us.ibm.com>
Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
---

 fs/jbd2/revoke.c |   36 ++++++++++++++++++++++--------------
 1 files changed, 22 insertions(+), 14 deletions(-)


diff --git a/fs/jbd2/revoke.c b/fs/jbd2/revoke.c
index 2e1453a..72b2608 100644
--- a/fs/jbd2/revoke.c
+++ b/fs/jbd2/revoke.c
@@ -167,33 +167,41 @@ static struct jbd2_revoke_record_s *find_revoke_record(journal_t *journal,
 	return NULL;
 }
 
+void jbd2_journal_destroy_revoke_caches(void)
+{
+	if (jbd2_revoke_record_cache) {
+		kmem_cache_destroy(jbd2_revoke_record_cache);
+		jbd2_revoke_record_cache = NULL;
+	}
+	if (jbd2_revoke_table_cache) {
+		kmem_cache_destroy(jbd2_revoke_table_cache);
+		jbd2_revoke_table_cache = NULL;
+	}
+}
+
 int __init jbd2_journal_init_revoke_caches(void)
 {
+	J_ASSERT(!jbd2_revoke_record_cache);
+	J_ASSERT(!jbd2_revoke_table_cache);
+
 	jbd2_revoke_record_cache = kmem_cache_create("jbd2_revoke_record",
 					   sizeof(struct jbd2_revoke_record_s),
 					   0,
 					   SLAB_HWCACHE_ALIGN|SLAB_TEMPORARY,
 					   NULL);
 	if (!jbd2_revoke_record_cache)
-		return -ENOMEM;
+		goto record_cache_failure;
 
 	jbd2_revoke_table_cache = kmem_cache_create("jbd2_revoke_table",
 					   sizeof(struct jbd2_revoke_table_s),
 					   0, SLAB_TEMPORARY, NULL);
-	if (!jbd2_revoke_table_cache) {
-		kmem_cache_destroy(jbd2_revoke_record_cache);
-		jbd2_revoke_record_cache = NULL;
-		return -ENOMEM;
-	}
+	if (!jbd2_revoke_table_cache)
+		goto table_cache_failure;
 	return 0;
-}
