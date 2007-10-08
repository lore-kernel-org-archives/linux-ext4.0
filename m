From: Christoph Lameter <clameter@sgi.com>
Subject: Re: [PATCH] jbd: JBD replace jbd_kmalloc with kmalloc
Date: Mon, 8 Oct 2007 10:46:45 -0700 (PDT)
Message-ID: <Pine.LNX.4.64.0710081045180.26627@schroedinger.engr.sgi.com>
References: <1191477059-5357-1-git-send-email-tytso@mit.edu>
 <1191477059-5357-2-git-send-email-tytso@mit.edu>  <20071004065204.GA21481@infradead.org>
 <1191623899.3861.29.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Christoph Hellwig <hch@infradead.org>,
	Theodore Ts'o <tytso@mit.edu>, linux-kernel@vger.kernel.org,
	linux-ext4@vger.kernel.org
To: Mingming Cao <cmm@us.ibm.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:51760 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752507AbXJHRqp (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 8 Oct 2007 13:46:45 -0400
In-Reply-To: <1191623899.3861.29.camel@localhost.localdomain>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Fri, 5 Oct 2007, Mingming Cao wrote:

> Index: linux-2.6.23-rc9/fs/jbd/transaction.c
> ===================================================================
> --- linux-2.6.23-rc9.orig/fs/jbd/transaction.c	2007-10-05 12:08:08.000000000 -0700
> +++ linux-2.6.23-rc9/fs/jbd/transaction.c	2007-10-05 12:08:29.000000000 -0700
> @@ -96,8 +96,8 @@ static int start_this_handle(journal_t *
>  
>  alloc_transaction:
>  	if (!journal->j_running_transaction) {
> -		new_transaction = jbd_kmalloc(sizeof(*new_transaction),
> -						GFP_NOFS);
> +		new_transaction = kmalloc(sizeof(*new_transaction),
> +						GFP_NOFS|__GFP_NOFAIL);


Why was a __GFP_NOFAIL added here? I do not see a use of jbd_rep_kmalloc?

> -#define jbd_kmalloc(size, flags) \
> -	__jbd_kmalloc(__FUNCTION__, (size), (flags), journal_oom_retry)

journal_oom_retry is no longer used?
