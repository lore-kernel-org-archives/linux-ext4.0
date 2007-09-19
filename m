From: Mingming Cao <cmm@us.ibm.com>
Subject: Re: [PATCH] JBD slab cleanups
Date: Wed, 19 Sep 2007 12:15:52 -0700
Message-ID: <1190229352.4318.12.camel@localhost.localdomain>
References: <Pine.LNX.4.64.0709020438490.28046@schroedinger.engr.sgi.com>
	 <20070902152801.GA19962@infradead.org>
	 <Pine.LNX.4.64.0709030051370.31366@schroedinger.engr.sgi.com>
	 <20070903134043.GB28962@infradead.org>
	 <Pine.LNX.4.64.0709031230190.2131@schroedinger.engr.sgi.com>
	 <20070903193308.GA7771@infradead.org>
	 <1189796027.3841.6.camel@localhost.localdomain>
	 <1190057391.3845.22.camel@localhost.localdomain>
	 <1190066466.31220.5.camel@dyn9047017100.beaverton.ibm.com>
	 <1190069851.6725.6.camel@localhost.localdomain>
	 <20070918090407.GA671@infradead.org>
	 <1190133347.3819.6.camel@localhost.localdomain>
	 <1190138690.6528.23.camel@norville.austin.ibm.com>
	 <1190163601.3819.15.camel@localhost.localdomain>
	 <20070918191920.a2130a3c.akpm@linux-foundation.org>
Reply-To: cmm@us.ibm.com
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Cc: Dave Kleikamp <shaggy@linux.vnet.ibm.com>,
	Christoph Hellwig <hch@infradead.org>,
	Badari Pulavarty <pbadari@us.ibm.com>,
	Christoph Lameter <clameter@sgi.com>,
	linux-fsdevel <linux-fsdevel@vger.kernel.org>,
	ext4 development <linux-ext4@vger.kernel.org>,
	lkml <linux-kernel@vger.kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <20070918191920.a2130a3c.akpm@linux-foundation.org>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Tue, 2007-09-18 at 19:19 -0700, Andrew Morton wrote:
> On Tue, 18 Sep 2007 18:00:01 -0700 Mingming Cao <cmm@us.ibm.com> wrote:
> 
> > JBD: Replace slab allocations with page cache allocations
> > 
> > JBD allocate memory for committed_data and frozen_data from slab. However
> > JBD should not pass slab pages down to the block layer. Use page allocator pages instead. This will also prepare JBD for the large blocksize patchset.
> > 
> > 
> > Also this patch cleans up jbd_kmalloc and replace it with kmalloc directly
> 
> __GFP_NOFAIL should only be used when we have no way of recovering
> from failure.  The allocation in journal_init_common() (at least)
> _can_ recover and hence really shouldn't be using __GFP_NOFAIL.
> 
> (Actually, nothing in the kernel should be using __GFP_NOFAIL.  It is 
> there as a marker which says "we really shouldn't be doing this but
> we don't know how to fix it").
> 
> So sometime it'd be good if you could review all the __GFP_NOFAILs in
> there and see if we can remove some, thanks.

Here is the patch to clean up __GFP_NOFAIL flag in jbd/jbd2. In all
cases except one handles memory allocation failure so I get rid of those
GFP_NOFAIL flags.

Also, shouldn't we use GFP_KERNEL instead of GFP_NOFS flag for kmalloc
in jbd/jbd2? I will send a separate patch to cleanup that.

Signed-off-by: Mingming Cao <cmm@us.ibm.com>
---
 fs/jbd/journal.c      |    2 +-
 fs/jbd/transaction.c  |    3 +--
 fs/jbd2/journal.c     |    2 +-
 fs/jbd2/transaction.c |    3 +--
 4 files changed, 4 insertions(+), 6 deletions(-)

Index: linux-2.6.23-rc6/fs/jbd/journal.c
===================================================================
--- linux-2.6.23-rc6.orig/fs/jbd/journal.c	2007-09-19 11:47:58.000000000 -0700
+++ linux-2.6.23-rc6/fs/jbd/journal.c	2007-09-19 11:48:40.000000000 -0700
@@ -653,7 +653,7 @@ static journal_t * journal_init_common (
 	journal_t *journal;
 	int err;
 
-	journal = kmalloc(sizeof(*journal), GFP_KERNEL|__GFP_NOFAIL);
+	journal = kmalloc(sizeof(*journal), GFP_KERNEL);
 	if (!journal)
 		goto fail;
 	memset(journal, 0, sizeof(*journal));
Index: linux-2.6.23-rc6/fs/jbd/transaction.c
===================================================================
--- linux-2.6.23-rc6.orig/fs/jbd/transaction.c	2007-09-19 11:48:05.000000000 -0700
+++ linux-2.6.23-rc6/fs/jbd/transaction.c	2007-09-19 11:49:10.000000000 -0700
@@ -96,8 +96,7 @@ static int start_this_handle(journal_t *
 
 alloc_transaction:
 	if (!journal->j_running_transaction) {
-		new_transaction = kmalloc(sizeof(*new_transaction),
-						GFP_NOFS|__GFP_NOFAIL);
+		new_transaction = kmalloc(sizeof(*new_transaction), GFP_NOFS);
 		if (!new_transaction) {
 			ret = -ENOMEM;
 			goto out;
Index: linux-2.6.23-rc6/fs/jbd2/journal.c
===================================================================
--- linux-2.6.23-rc6.orig/fs/jbd2/journal.c	2007-09-19 11:48:14.000000000 -0700
+++ linux-2.6.23-rc6/fs/jbd2/journal.c	2007-09-19 11:49:46.000000000 -0700
@@ -654,7 +654,7 @@ static journal_t * journal_init_common (
 	journal_t *journal;
 	int err;
 
-	journal = kmalloc(sizeof(*journal), GFP_KERNEL|__GFP_NOFAIL);
+	journal = kmalloc(sizeof(*journal), GFP_KERNEL);
 	if (!journal)
 		goto fail;
 	memset(journal, 0, sizeof(*journal));
Index: linux-2.6.23-rc6/fs/jbd2/transaction.c
===================================================================
--- linux-2.6.23-rc6.orig/fs/jbd2/transaction.c	2007-09-19 11:48:08.000000000 -0700
+++ linux-2.6.23-rc6/fs/jbd2/transaction.c	2007-09-19 11:50:12.000000000 -0700
@@ -96,8 +96,7 @@ static int start_this_handle(journal_t *
 
 alloc_transaction:
 	if (!journal->j_running_transaction) {
-		new_transaction = kmalloc(sizeof(*new_transaction),
-						GFP_NOFS|__GFP_NOFAIL);
+		new_transaction = kmalloc(sizeof(*new_transaction), GFP_NOFS);
 		if (!new_transaction) {
 			ret = -ENOMEM;
 			goto out;




