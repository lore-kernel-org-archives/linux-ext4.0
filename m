From: Theodore Tso <tytso@mit.edu>
Subject: Re: suspiciously good fsck times?
Date: Thu, 10 Jul 2008 13:53:55 -0400
Message-ID: <20080710175354.GA3447@mit.edu>
References: <20080710172829.GF10402@mit.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from www.church-of-our-saviour.ORG ([69.25.196.31]:48366 "EHLO
	thunker.thunk.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754003AbYGJRx4 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 10 Jul 2008 13:53:56 -0400
Content-Disposition: inline
In-Reply-To: <20080710172829.GF10402@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Based on the graphs which Eric posted, One interesting thing I think
you'll find if you repeat the ext3 experiment with e2fsck -t -t is
that pass2 will be about seven times longer than pass1.  (Which is
backwards from most e2fsck runs, where pass2 is about half pass 1's
run time --- although obviously that depends on how many directory
blocks you have.)

Yes, some kind of reservation windows would help on ext3 --- but the
question is whether such a change would be too-specific for this
benchmark or not.  Most of the time directories don't grow to such a
huge size.  So if you use a smallish (around 8 blocks, say) for many
directories this might lead to more filesystem fragmentation that in
the long run would cause the filesystem not to age well; it also
wouldn't help much when you have over 11 million files in the
directory, and a directory with over 100,000 blocks.

I don't think delayed allocation is what's helping here either,
because the journal will force the directory blocks to be placed as
soon as we commit a transaction.  I think what's saving us here is
that flex_bg and mballoc is separating the directory blocks from the
data blocks, allowng the directory blocks to be closely packed
together.

					- Ted
