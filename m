From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: Need to potentially watch stack usage for ext4 and AIO...
Date: Wed, 24 Jun 2009 23:58:46 -0500
Message-ID: <4A430406.2080904@redhat.com>
References: <E1MHiN1-0002TX-Cu@closure.thunk.org> <4A3C3F64.70007@redhat.com> <20090621004919.GA6798@mit.edu> <4A42513C.6020607@redhat.com> <4A4256A6.7070707@redhat.com> <20090625000558.GD7035@mit.edu> <4A42C5BA.8020804@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org
To: Theodore Tso <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx2.redhat.com ([66.187.237.31]:47006 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750944AbZFYE6x (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 25 Jun 2009 00:58:53 -0400
In-Reply-To: <4A42C5BA.8020804@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Eric Sandeen wrote:

> I had found some tools once to do static callchain analysis & graph
> them, maybe time to break it out again.

codeviz was the tool; getting it to work is fiddly.  But here, for
example, are some of the callers of ext4_mb_init_cache() (one of the
functions at the bottom of your deep chain), with stack usage and
piggish ones highlighted in red:

http://sandeen.fedorapeople.org/ext4/ext4_mb_init_cache_callers.png

This is actually only analysis of the functions in mballoc.c, but that's
relevant for the static / noinline decisions.

The stack usage values were after my attempt to get gcc to inline
-nothing- at all.

So there you can see that ext4_mb_regular_allocator by itself uses 104
bytes, but calls several other functions which get inlined normally:

ext4_mb_try_best_found	16
ext4_mb_try_by_goal	56
ext4_mb_load_buddy	24
ext4_mb_init_group	24

Without all the noinlining, ext4_mb_regular_allocator uses 232 bytes ...
104+16+56+24+24 = 224 is close to that.

On the flip side here are the functions called by
ext4_mb_init_cache_callees within mballoc.c:

http://sandeen.fedorapeople.org/ext4/ext4_mb_init_cache_callees.png

Here too I think you can see that if much of that gets inlined, it'll
bloat that function.

A bit more analysis like this might yield some prudent changes ... but
it's tedious.  :)

-Eric
