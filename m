From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [RFC] mke2fs -E hash_alg=siphash: any interest?
Date: Mon, 22 Sep 2014 13:09:03 -0400
Message-ID: <20140922170903.GC4572@thunk.org>
References: <BAY179-W560EC72EB98547138373E3FDB20@phx.gbl>
 <20140922023105.16748.qmail@ns.horizon.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: thomas_reardon@hotmail.com, linux-ext4@vger.kernel.org
To: George Spelvin <linux@horizon.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:41282 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753542AbaIVRJG (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 22 Sep 2014 13:09:06 -0400
Content-Disposition: inline
In-Reply-To: <20140922023105.16748.qmail@ns.horizon.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sun, Sep 21, 2014 at 10:31:05PM -0400, George Spelvin wrote:
> 
> Yes.  It's the standard hash collision attack: if someone can force too
> many hash collisions, they can force the hash tree to have pessimal
> performance, including excessive disk space allocation in an attempt to
> split directory pages.
> 
> In fact, I'm not sure if the code copes with more than 4096 bytes of
> directory entry with a single hash value or it will cause some sort of
> error.

It does cope correctly, but it means that we degrade to doing a linear
search.  At one point we had a test where we forced the hash algorithm
to always return "42" to check those code paths.

The real problem is that the htree implementation only supports a tree
dpeth of at most two levels, and it doesn't support collapsing the
tree to reduce space after deleting a large number of files.

The first would require making a compatibility-impacting change; the
second one would not necessarily require that, but it's also not
entirely trivial.  We've gotten away with not making any changes here,
partially because using a keyed hash allows us to avoid intentional
attempts to hit those corner cases.

If someone was interested in doing some work in that space, there is
definitely room where we could improve there.

Cheers,

					- Ted
