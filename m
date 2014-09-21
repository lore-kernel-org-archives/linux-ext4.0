From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [RFC] mke2fs -E hash_alg=siphash: any interest?
Date: Sun, 21 Sep 2014 13:55:15 -0400
Message-ID: <20140921175515.GA30646@thunk.org>
References: <20140921095339.9074.qmail@ns.horizon.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: George Spelvin <linux@horizon.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:39754 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751801AbaIURzW (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sun, 21 Sep 2014 13:55:22 -0400
Content-Disposition: inline
In-Reply-To: <20140921095339.9074.qmail@ns.horizon.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sun, Sep 21, 2014 at 05:53:39AM -0400, George Spelvin wrote:
> 
> Basically, it offers security similar to teahash with a faster, and better
> studied, primitive designed specifically for this application.
> 
> I'm thinking of turning this into a patch for ext2utils and fs/ext4.
> 
> Could I ask what the general level of interest is?  On a scale of "hell,
> no, not more support burden!" to "thank you, I've been meaning to find
> time to add that!"

I'm certainly not against adding a new hash function.  The reality is
that it would be quite a while before we could turn it on by default,
because of the backwards compatibility concerns.

The question I would ask is whether we can show an anctual performance
improvement with the hash being used in situ.  Let's give it the best
possible chance of making a difference; let's assume a RAM disk with a
very metadata intensive benchmark, with journalling turned off.  What
sort of difference would we see, either in terms of system CPU time,
wall clock time, etc.?

The results of such a benchmark would certainly make a difference in
how aggressively we might try to phase in a new hash algorithm.

Cheers,

					- Ted
