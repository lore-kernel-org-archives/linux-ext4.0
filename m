From: Andreas Dilger <adilger@sun.com>
Subject: Re: [PATCH, RFC] ext4: Replace hackish ext4_mb_poll_new_transaction
	with commit callback
Date: Sun, 19 Oct 2008 16:49:28 -0600
Message-ID: <20081019224904.GF3184@webber.adilger.int>
References: <1224201763-9637-1-git-send-email-tytso@mit.edu>
 <20081017060424.GA26192@skywalker> <20081017100214.GB11557@mit.edu>
 <20081017122552.GC21503@mit.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7BIT
To: Theodore Tso <tytso@mit.edu>,
	"Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>,
	linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from sca-es-mail-2.Sun.COM ([192.18.43.133]:35661 "EHLO
	sca-es-mail-2.sun.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751862AbYJSWtl (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sun, 19 Oct 2008 18:49:41 -0400
In-reply-to: <20081017122552.GC21503@mit.edu>
Content-disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Oct 17, 2008  08:25 -0400, Theodore Ts'o wrote:
> What I added was a dead-simple per-journal commit callback, with no
> additional memory allocations (and requirement to do error handling if
> the memory allocation fails), no need to take a spinlock before
> manually adding the call back to each transaction handle, no need to
> search the linked list to see if we have an entry on the linked list
> already, etc.
> 
> If in the future we need a true per-transaction handle commit
> callback, we can add this; but I think it still makes more sense to
> keep the per-journal commit callback.  After all, as it stands the
> current patch results in a net reduction of 46 lines of code.  Adding
> all of this machinery would erase take far more than the savings by
> removing ext4_mb_poll_new_transaction().

The problem with the mechanism you've implemented is that it isn't
possible to add any other kind of callback to the journal.  There
is only a single callback function, and the entries in the "t_private_list"
are all assumed to be "ext4_free_data" structures so even if other
users wanted to add callbacks they would only be handled by the
release_blocks_on_commit() function.

Is there any reason not to make this more generic and have the callback
function pointer embedded in the "ext4_free_data" struct in some way
that other callbacks could be registered?  This would still avoid the
need to allocate for each of these operations, but would make the
callback mechanism more generic and useful.

Cheers, Andreas
--
Andreas Dilger
Sr. Staff Engineer, Lustre Group
Sun Microsystems of Canada, Inc.

