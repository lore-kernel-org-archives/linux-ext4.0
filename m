From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: memory leak: data=journal and {collapse,insert,zero}_range
Date: Tue, 20 Oct 2015 11:54:43 -0400
Message-ID: <20151020155443.GM2972@thunk.org>
References: <20151017160230.GA19968@thunk.org>
 <009301d10b2f$b410e6b0$1c32b410$@samsung.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Namjae Jeon <namjae.jeon@samsung.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:33839 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751043AbbJTPyq (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 20 Oct 2015 11:54:46 -0400
Content-Disposition: inline
In-Reply-To: <009301d10b2f$b410e6b0$1c32b410$@samsung.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, Oct 20, 2015 at 09:06:08PM +0900, Namjae Jeon wrote:
> Hi Ted,
> 
> I will check this issue.

Thanks!

To be clear, the commit that I bisected this down to was fixing a real
issue, so I'm not really blaming your commit.  Furthermore, it wasn't
causing test failures until very recently, and part of this is
probably caused by a change in the test environment, and also probably
a change in the most recent kernels about how memory reclaim and how
we handle low memory situations.  However, once I started seeing test
failures, I started looking harder for memory leaks, and it was clear
that we had memory leaks in the data=journal scenario starting with
1ce01c4a199.

Interestingly we're not seeing these memory leaks on the truncate
path, so I suspect the issue is in how collapse range is clearing
pages from the page cache, especially pages that were freshly written
to the journal by the commit but which hadn't yet been writtten to
disk and then marked as complete so we can allow the relevant
transaction to be checkpointed.  (Although we're not leaking the
journal head structures, but only the buffer heads, so the story most
be a bit more complicated than that.)

Cheers,

					- Ted
					
