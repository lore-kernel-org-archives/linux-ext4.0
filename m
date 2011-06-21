From: Ted Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 01/11 RESEND] libe2p: Add new function
 get_fragment_score()
Date: Tue, 21 Jun 2011 09:56:08 -0400
Message-ID: <20110621135608.GG32133@thunk.org>
References: <4DF8522F.2020304@sx.jp.nec.com>
 <20110617031814.GA31884@thunk.org>
 <4E007FE1.8000704@sx.jp.nec.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: ext4 <linux-ext4@vger.kernel.org>
To: Kazuya Mio <k-mio@sx.jp.nec.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:52225 "EHLO
	test.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753798Ab1FUN4M (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 21 Jun 2011 09:56:12 -0400
Content-Disposition: inline
In-Reply-To: <4E007FE1.8000704@sx.jp.nec.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, Jun 21, 2011 at 08:26:25PM +0900, Kazuya Mio wrote:
> 
> I decided to implement a fragmentation score for the two purposes:
> one is for filefrag that outputs the score to decide which files should be
> defragmented, and the other is for e4defrag that compares two files'
> fragmentation to prevent the worse fragmentation.

I'm really nervous about having filefrag print a "fragmentation
score".  The problem is that the problem is invariably far more
complex than can be boiled into a single number, and so users look at
it and start worrying when they shouldn't.

And the statement, "so that e4defrag can compare two files'
fragmentation to prevent the worse fragmentation" begs the question of
what is "worse".  The real issue here is that it's a multidimensional
problem.

> Certainly, the same fragmentation score doesn't always mean the same
> fragmentation. Just as Andreas said, "fragments per MB" is a good idea. It's
> easy to understand, and other filesystem also would be able to use it without
> change. Moreover, there is no worry about what threshold we use to
> the application.

"fragments per megabyte" is definitely better, especially if you
disregard the tail.  It's worth consider how it works for files
smaller than a megabyte.  Do you round the file size up to the nearest
megabyte?  Is it an integer score, or does it need to be floating
point?  An integer score where the size is rounded up to the nearest
megabyte sounds like a best plan, but I'm sure we could still find
some interesting non-linearities that lead to surprising results.

	      	    	    	      	   - Ted
