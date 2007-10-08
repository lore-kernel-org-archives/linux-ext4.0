From: Mingming Cao <cmm@us.ibm.com>
Subject: Re: [PATCH] jbd: JBD replace jbd_kmalloc with kmalloc
Date: Mon, 08 Oct 2007 11:26:31 -0700
Message-ID: <1191867991.3870.6.camel@localhost.localdomain>
References: <1191477059-5357-1-git-send-email-tytso@mit.edu>
	 <1191477059-5357-2-git-send-email-tytso@mit.edu>
	 <20071004065204.GA21481@infradead.org>
	 <1191623899.3861.29.camel@localhost.localdomain>
	 <Pine.LNX.4.64.0710081045180.26627@schroedinger.engr.sgi.com>
Reply-To: cmm@us.ibm.com
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Cc: Christoph Hellwig <hch@infradead.org>,
	"Theodore Ts'o" <tytso@mit.edu>, linux-kernel@vger.kernel.org,
	linux-ext4@vger.kernel.org
To: Christoph Lameter <clameter@sgi.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e4.ny.us.ibm.com ([32.97.182.144]:53953 "EHLO e4.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752574AbXJHS0z (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 8 Oct 2007 14:26:55 -0400
In-Reply-To: <Pine.LNX.4.64.0710081045180.26627@schroedinger.engr.sgi.com>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Mon, 2007-10-08 at 10:46 -0700, Christoph Lameter wrote:
> On Fri, 5 Oct 2007, Mingming Cao wrote:
> 
> > Index: linux-2.6.23-rc9/fs/jbd/transaction.c
> > ===================================================================
> > --- linux-2.6.23-rc9.orig/fs/jbd/transaction.c	2007-10-05 12:08:08.000000000 -0700
> > +++ linux-2.6.23-rc9/fs/jbd/transaction.c	2007-10-05 12:08:29.000000000 -0700
> > @@ -96,8 +96,8 @@ static int start_this_handle(journal_t *
> >  
> >  alloc_transaction:
> >  	if (!journal->j_running_transaction) {
> > -		new_transaction = jbd_kmalloc(sizeof(*new_transaction),
> > -						GFP_NOFS);
> > +		new_transaction = kmalloc(sizeof(*new_transaction),
> > +						GFP_NOFS|__GFP_NOFAIL);
> 
> 
> Why was a __GFP_NOFAIL added here? I do not see a use of jbd_rep_kmalloc?
> 
> > -#define jbd_kmalloc(size, flags) \
> > -	__jbd_kmalloc(__FUNCTION__, (size), (flags), journal_oom_retry)
> 
> journal_oom_retry is no longer used?
> -

journal_oom_retry (which is defined as 1 currently) is still being used
in revoke.c, the cleanup patch doesn't remove the define of
journal_oom_retry.

Since journal_oom_retry is always 1 to __jbd_kmalloc, 

void * __jbd_kmalloc (const char *where, size_t size, gfp_t flags, int
retry)
{
        return kmalloc(size, flags | (retry ? __GFP_NOFAIL : 0));
}

So we replace jbd_kmalloc() to kmalloc() with __GFP_NOFAIL flag on in
start_this_handle(). Other two places replacing to kmalloc() is part of
the init process, so no need for __GFP_NOFAIL flag there.

Mingming

> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
