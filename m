From: Theodore Tso <tytso@mit.edu>
Subject: Re: [PATCH 2/3] ext4: Clear the unwritten buffer_head flag properly
Date: Wed, 13 May 2009 18:28:47 -0400
Message-ID: <20090513222847.GA10003@mit.edu>
References: <1241692770-22547-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com> <1241692770-22547-2-git-send-email-aneesh.kumar@linux.vnet.ibm.com> <20090512030856.GI21518@mit.edu> <20090512044627.GA6753@skywalker> <4A0B17F8.3000402@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>,
	cmm@us.ibm.com, linux-ext4@vger.kernel.org
To: Eric Sandeen <sandeen@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from THUNK.ORG ([69.25.196.29]:50318 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753302AbZEMW27 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 13 May 2009 18:28:59 -0400
Content-Disposition: inline
In-Reply-To: <4A0B17F8.3000402@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, May 13, 2009 at 01:56:56PM -0500, Eric Sandeen wrote:
> The comment:
> 
>  	/*
> +	 * The above get_blocks can cause the buffer to be
> +	 * marked unwritten. So clear the same.
> +	 */
> +	clear_buffer_unwritten(bh);
> 
> is imho not helpful; to me it says "we -just- set this, so clear it!"
> It leaves me scratching my head.

I've updated it the comment to say this instead.

	/*
	 * When we call get_blocks without the create flag, the
	 * BH_Unwritten flag could have gotten set if the blocks
	 * requested were part of a uninitialized extent.  We need to
	 * clear this flag now that we are committed to convert all or
	 * part of the uninitialized extent to be an initialized
	 * extent.  This is because we need to avoid the combination
	 * of BH_Unwritten and BH_Mapped flags being simultaneously
	 * set on the buffer_head.
	 */

I'm still not entirely clear what is the downside of having
BH_Unwritten and BH_Mapped at the same time; whether it is just a CPU
time-waster that will cause some unneeded calls to get_blocks() in the
write_begin path which "just" wastes a little CPU, or whether there
are other massive disasters that take place on the combination of
BH_Unwritten and BH_Mapped.

What we *desperately* need is documentation that describes which
functions sets these flags, and whether they are intended for
long-term use (either stored in buffer heads attached to a page, or in
the buffer cache, and if so, which), or just as short-term hacks to
pass information between two functions, or multiple functions deep in
a call stack, and if so, what the implications are of the bits, and
when they should be cleared --- and then we should add assert's or
BUG_ON's to enforce what we think the abstraction invariant should be.

Magic flags attached to objects that are really there because we don't
want to change function signatures are very scary; for example,
i_delalloc_reserved_flag in ext4_inode_info --- it's not clear to me
exactly what this is supposed to do, but I note that mballoc.c does a
lot more with the flag than balloc.c.  So it's not clear to me if
there is magic semantics associated with that flag which are being
done in mballoc.c, but we never got around to implementing them in
balloc.c.  This leads to the kind of code fragility that I've been
complaining about for some time.

The fact that Aneesh missed one of these magic code paths in his patch
attests to why this style of programming is really bad and not
long-term maintainable.  So we need to document all of this mess, and
then gradually clean it up, one tiny patch at a time, each one
describing what we were doing before, and what the new way of doing
this should be, and why it's safe to make that change.

> > That would imply we have BH_Unwritten and BH_Mapped set in the above
> > case which is wrong. So we need a BH_Unwritten clear between (2) and
> > (3). The patch does the same. May be we need to capture it in commit
> > message.
> 
> Better in comments, I think.  :)

The comprehensive description of all of this should be in comments,
yes.  See the example of the sort of comments that I've added in the
clear-unwritten-bh-flag and initialize-map_bh-state.  If we don't like
such verbose comments, then we should use simpler programming
semantics when passing information between the various abstracton
layers.  :-)

						- Ted
