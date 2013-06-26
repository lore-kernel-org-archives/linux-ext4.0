From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: Memory allocation can cause ext4 filesystem to be remounted r/o
Date: Wed, 26 Jun 2013 18:14:22 -0400
Message-ID: <20130626221422.GC4128@thunk.org>
References: <CAFy9=U5n-YF017L+gni4v8pgq-AsLVTZBLwaZhPjHJCMXzLLag@mail.gmail.com>
 <20130626140205.GE3875@thunk.org>
 <20130626145417.GB32092@thunk.org>
 <49ee4e84554c82d944d092fe2ec8ce82@josephdwagner.info>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Nagachandra P <nagachandra@gmail.com>,
	Vikram MP <mp.vikram@gmail.com>, linux-ext4@vger.kernel.org
To: "Joseph D. Wagner" <joe@josephdwagner.info>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:33253 "EHLO
	imap.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752890Ab3FZWO1 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 26 Jun 2013 18:14:27 -0400
Content-Disposition: inline
In-Reply-To: <49ee4e84554c82d944d092fe2ec8ce82@josephdwagner.info>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, Jun 26, 2013 at 11:53:12AM -0700, Joseph D. Wagner wrote:
>  1. Does not guarantee that memory will be available when ext4 needs
>     its.  Memory might be available during this pre-check, but another
>     process might scoop it up between the pre-check and ext4's
>     allocation.

This is the huge one.  In some cases we might need to read potentially
one or more disk blocks in the course of servicing the request.  By
the time we've read in the disk blocks, hundreds of milliseconds can
have gone by.  If there is a high speed network transfer coming in
over the network, the networking stack can chew up a huge amount of
memory surprisingly quickly (to say nothing of a JVM that might be
starting up in parallel with reading in the allocation bitmaps, for
example).

This is also assuming we know in advance how much memory would be
needed.  Depending on how fragmented a file might be, the amount of
memory required can vary significantly.  And if the required metadata
blocks are in memory, we won't know how much memory will be needed
until we pull the necessary blocks into memory.

The other problem with doing this is that the point at which we would
do the check for the necessary memory is at the high-level portions of
the ext4, and the places where we are doing the memory allocation are
sometimes deep in the guts of ext4.  So figuring this out would
require some truly nasty abstraction violations.  For the same reason,
we can't just simply allocate the memory before we start the
file system operation.

There are places where we could do this, without doing severe violence
to the surrounding code and without making things a total maintenance
nightmare.  But it's one of those things where we'd have to look at
each place where we allocate memory and decide what's the best way to
handle things.

							- Ted
