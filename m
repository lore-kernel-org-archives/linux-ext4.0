From: Andreas Dilger <adilger@clusterfs.com>
Subject: Re: [PATCH] JBD slab cleanups
Date: Wed, 19 Sep 2007 13:48:13 -0600
Message-ID: <20070919194813.GT32520@schatzie.adilger.int>
References: <1189796027.3841.6.camel@localhost.localdomain> <1190057391.3845.22.camel@localhost.localdomain> <1190066466.31220.5.camel@dyn9047017100.beaverton.ibm.com> <1190069851.6725.6.camel@localhost.localdomain> <20070918090407.GA671@infradead.org> <1190133347.3819.6.camel@localhost.localdomain> <1190138690.6528.23.camel@norville.austin.ibm.com> <1190163601.3819.15.camel@localhost.localdomain> <20070918191920.a2130a3c.akpm@linux-foundation.org> <1190229352.4318.12.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Andrew Morton <akpm@linux-foundation.org>,
	Dave Kleikamp <shaggy@linux.vnet.ibm.com>,
	Christoph Hellwig <hch@infradead.org>,
	Badari Pulavarty <pbadari@us.ibm.com>,
	Christoph Lameter <clameter@sgi.com>,
	linux-fsdevel <linux-fsdevel@vger.kernel.org>,
	ext4 development <linux-ext4@vger.kernel.org>,
	lkml <linux-kernel@vger.kernel.org>,
	"Stephen C. Tweedie" <sct@redhat.com>
To: Mingming Cao <cmm@us.ibm.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.clusterfs.com ([74.0.229.162]:43385 "EHLO
	mail.clusterfs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750952AbXISTrs (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 19 Sep 2007 15:47:48 -0400
Content-Disposition: inline
In-Reply-To: <1190229352.4318.12.camel@localhost.localdomain>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Sep 19, 2007  12:15 -0700, Mingming Cao wrote:
> @@ -96,8 +96,7 @@ static int start_this_handle(journal_t *
>  
>  alloc_transaction:
>  	if (!journal->j_running_transaction) {
> -		new_transaction = kmalloc(sizeof(*new_transaction),
> -						GFP_NOFS|__GFP_NOFAIL);
> +		new_transaction = kmalloc(sizeof(*new_transaction), GFP_NOFS);

This should probably be a __GFP_NOFAIL if we are trying to start a new
handle in truncate, as there is no way to propagate an error to the caller.

Cheers, Andreas
--
Andreas Dilger
Principal Software Engineer
Cluster File Systems, Inc.
