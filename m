From: Ted Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 1/1 v4] ext4: fix xfstests 75, 112, 127 punch hole
 failure
Date: Thu, 11 Aug 2011 19:44:45 -0400
Message-ID: <20110811234445.GB31181@thunk.org>
References: <1312698112-7836-1-git-send-email-achender@linux.vnet.ibm.com>
 <20110808024213.GC11497@thunk.org>
 <4E404D06.6010002@linux.vnet.ibm.com>
 <20110809164524.GA3422@thunk.org>
 <4E41A254.3030300@linux.vnet.ibm.com>
 <20110811031712.GF3625@thunk.org>
 <4E444A15.6000405@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Allison Henderson <achender@linux.vnet.ibm.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:49456 "EHLO
	test.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754503Ab1HKXot (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 11 Aug 2011 19:44:49 -0400
Content-Disposition: inline
In-Reply-To: <4E444A15.6000405@linux.vnet.ibm.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, Aug 11, 2011 at 02:31:01PM -0700, Allison Henderson wrote:
> Ah, ok then that makes sense.  So maybe what I need to do is modify
> the ext4_block_zero_page routine to zero everything in the specified
> range and then clear the mapped flag for any buffer header that is
> fully zeroed.  I'm not sure I'm clear about what it means to be
> detached though.  What is the difference between clearing the flag
> and detaching the buffer head?  Thank you for all the explaining!

Technically speaking, there is no guarantee that a page has either no
buffer heads, or all of the buffer heads that cover a page --- or that
the buffer_heads are in any particular order in the linked list.

In practice create_empty_buffers() creates them in a particular order,
and always creates *all* of them --- and I'm not sure if we have any
code paths left that don't use create_empty_buffers() --- but I'm
pretty sure there used to be cases where the buffer_heads could only
be partially present, or in an arbitrary order.

So if you look at the code which iterates over the page buffers,
you'll see they are very defensively coded --- and it's complicated.
One of these days I'd really like to simplify the code so instead of
using linked list, we use an array of structures --- and something
slimmed down from a buffer_head to have only those essential fields
that ext4 uses.

One of these days....

Anyway, clearing the all of the bh_flags as is currently done is good
enough, and actually probably easier (in case there's code which is
dependent on all of the bh's being there, and in order)

					- Ted
