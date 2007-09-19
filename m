From: Mingming Cao <cmm@us.ibm.com>
Subject: Re: [PATCH] JBD slab cleanups
Date: Wed, 19 Sep 2007 15:03:51 -0700
Message-ID: <1190239431.4318.34.camel@localhost.localdomain>
References: <1189796027.3841.6.camel@localhost.localdomain>
	 <1190057391.3845.22.camel@localhost.localdomain>
	 <1190066466.31220.5.camel@dyn9047017100.beaverton.ibm.com>
	 <1190069851.6725.6.camel@localhost.localdomain>
	 <20070918090407.GA671@infradead.org>
	 <1190133347.3819.6.camel@localhost.localdomain>
	 <1190138690.6528.23.camel@norville.austin.ibm.com>
	 <1190163601.3819.15.camel@localhost.localdomain>
	 <20070918191920.a2130a3c.akpm@linux-foundation.org>
	 <1190229352.4318.12.camel@localhost.localdomain>
	 <20070919194813.GT32520@schatzie.adilger.int>
Reply-To: cmm@us.ibm.com
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Cc: Andrew Morton <akpm@linux-foundation.org>,
	Dave Kleikamp <shaggy@linux.vnet.ibm.com>,
	Christoph Hellwig <hch@infradead.org>,
	Badari Pulavarty <pbadari@us.ibm.com>,
	Christoph Lameter <clameter@sgi.com>,
	linux-fsdevel <linux-fsdevel@vger.kernel.org>,
	ext4 development <linux-ext4@vger.kernel.org>,
	lkml <linux-kernel@vger.kernel.org>,
	"Stephen C. Tweedie" <sct@redhat.com>
To: Andreas Dilger <adilger@clusterfs.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e6.ny.us.ibm.com ([32.97.182.146]:43496 "EHLO e6.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751489AbXISWD4 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 19 Sep 2007 18:03:56 -0400
In-Reply-To: <20070919194813.GT32520@schatzie.adilger.int>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Wed, 2007-09-19 at 13:48 -0600, Andreas Dilger wrote:
> On Sep 19, 2007  12:15 -0700, Mingming Cao wrote:
> > @@ -96,8 +96,7 @@ static int start_this_handle(journal_t *
> >  
> >  alloc_transaction:
> >  	if (!journal->j_running_transaction) {
> > -		new_transaction = kmalloc(sizeof(*new_transaction),
> > -						GFP_NOFS|__GFP_NOFAIL);
> > +		new_transaction = kmalloc(sizeof(*new_transaction), GFP_NOFS);
> 
> This should probably be a __GFP_NOFAIL if we are trying to start a new
> handle in truncate, as there is no way to propagate an error to the caller.
> 

Thanks, updated version.

Here is the patch to clean up __GFP_NOFAIL flag in jbd/jbd2, most cases
they are not needed.

Signed-off-by: Mingming Cao <cmm@us.ibm.com>
---
 fs/jbd/journal.c  |    2 +-
 fs/jbd2/journal.c |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

Index: linux-2.6.23-rc6/fs/jbd/journal.c
===================================================================
--- linux-2.6.23-rc6.orig/fs/jbd/journal.c	2007-09-19 11:47:58.000000000 -0700
+++ linux-2.6.23-rc6/fs/jbd/journal.c	2007-09-19 14:23:45.000000000 -0700
@@ -653,7 +653,7 @@ static journal_t * journal_init_common (
 	journal_t *journal;
 	int err;
 
-	journal = kmalloc(sizeof(*journal), GFP_KERNEL|__GFP_NOFAIL);
+	journal = kmalloc(sizeof(*journal), GFP_KERNEL);
 	if (!journal)
 		goto fail;
 	memset(journal, 0, sizeof(*journal));
Index: linux-2.6.23-rc6/fs/jbd2/journal.c
===================================================================
--- linux-2.6.23-rc6.orig/fs/jbd2/journal.c	2007-09-19 11:48:14.000000000 -0700
+++ linux-2.6.23-rc6/fs/jbd2/journal.c	2007-09-19 14:23:45.000000000 -0700
@@ -654,7 +654,7 @@ static journal_t * journal_init_common (
 	journal_t *journal;
 	int err;
 
-	journal = kmalloc(sizeof(*journal), GFP_KERNEL|__GFP_NOFAIL);
+	journal = kmalloc(sizeof(*journal), GFP_KERNEL);
 	if (!journal)
 		goto fail;
 	memset(journal, 0, sizeof(*journal));
