From: tytso@mit.edu
Subject: Re: ext4: Do not dec quota for reserved blocks on error paths v2
Date: Tue, 25 May 2010 10:02:39 -0400
Message-ID: <20100525140239.GH5556@thunk.org>
References: <87633dcxhp.fsf@openvz.org>
 <87bpd3ecya.fsf@openvz.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, Eric Sandeen <sandeen@redhat.com>
To: Dmitry Monakhov <dmonakhov@openvz.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from thunk.org ([69.25.196.29]:59886 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932653Ab0EYOCk (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 25 May 2010 10:02:40 -0400
Content-Disposition: inline
In-Reply-To: <87bpd3ecya.fsf@openvz.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, Apr 28, 2010 at 08:53:01PM +0400, Dmitry Monakhov wrote:
> If we have failed some where inside ext4_get_blocks() internals we may
> have allocated some new blocks, which was not yet claimed to quota.
> We have to free such blocks, but without touching quota. Quota will
> be updated later on exit from ext4_get_blocks().
> There are two possible ways to understand what we have to skip quota update:
> 1) Caller pass corresponding flag to ext4_free_blocks()
> 2) check that free_blocks() was indirectly called by get_blocks() 
>    (i.e EXT4_I(inode)->i_delalloc_reserved_flag is set)
> Second is simpler, but may result in unpredictable consequences later.
> So i've chosen the first one, because caller must know which blocks it
> is freeing.
> 
> Eric, please take your attention to metadata blocks handling when
> you will work on new versing of  "ext4: don't use quota reservation for
> speculative metadata blocks" patch.

This patch needs to be carefully changed after Eric's patch has gone
in (which I've already applied into the patch queue).  As a result I'm
going to hold off applying your patch until either (a) someone
(probably you or I) has a chance to fix it up in light of Eric's
changes.

I'm not sure I'll get to it before I need to push patches to Linus,
though, so it might miss the merge window.  If we can make this a
simple and easy to vet bugfix, I might be able to push it through as a
supplementary bug fix push.

						- Ted
