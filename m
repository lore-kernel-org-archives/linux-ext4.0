From: Theodore Tso <tytso@mit.edu>
Subject: Re: [PATCH] percpu_counter: Fix __percpu_counter_sum()
Date: Sun, 7 Dec 2008 10:28:21 -0500
Message-ID: <20081207152821.GA9596@mit.edu>
References: <4936D287.6090206@cosmosbay.com> <4936EB04.8000609@cosmosbay.com> <20081206202233.3b74febc.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Eric Dumazet <dada1@cosmosbay.com>,
	linux kernel <linux-kernel@vger.kernel.org>,
	"David S. Miller" <davem@davemloft.net>,
	Peter Zijlstra <a.p.zijlstra@chello.nl>,
	Mingming Cao <cmm@us.ibm.com>, linux-ext4@vger.kernel.org
To: Andrew Morton <akpm@linux-foundation.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from www.church-of-our-saviour.org ([69.25.196.31]:41295 "EHLO
	thunker.thunk.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753174AbYLGUcE (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sun, 7 Dec 2008 15:32:04 -0500
Content-Disposition: inline
In-Reply-To: <20081206202233.3b74febc.akpm@linux-foundation.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sat, Dec 06, 2008 at 08:22:33PM -0800, Andrew Morton wrote:
> 
> I suggest that what we do is to revert both those changes.  We can
> worry about the possibly-unneeded spin_lock later, in a separate patch.
> 
> It should have been a separate patch anyway.  It's conceptually
> unrelated and is not a bugfix, but it was mixed in with a bugfix.
> 
> Mingming, this needs urgent consideration, please.  Note that I had to
> make additional changes to ext4 due to the subsequent introduction of
> the dirty_blocks counter.

I've looked the two patches which you've queued in the -mm branch, and
they look correct to me.

The bugs fixed by these patches can potentially lead to filesystem
corruption, since we ultimately use these fields to set the superblock
values.  This in my mind makes them stable candidates at the very
least, and if we weren't so late in the 2.6.28 cycle, I'd be strongly
tempted to push them to Linus as a bugfix before the merge window.

Andrew, any strong objections for me to grab them for the ext4 tree?
Or would you rather carry them?  I would prefer that they get pushed
to Linus as soon as the merge window opens, which is one reason why
I'd prefer carry them, but we can do this either way.

        	   	       	      	     - Ted
