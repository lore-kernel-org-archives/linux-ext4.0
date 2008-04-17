From: Theodore Tso <tytso@mit.edu>
Subject: Re: [PATCH 4/5] make extent_goto() deterministic when logical
	block not found
Date: Thu, 17 Apr 2008 17:14:21 -0400
Message-ID: <20080417211421.GL3063@mit.edu>
References: <1207623660-1088-1-git-send-email-sandeen@redhat.com> <1207623660-1088-5-git-send-email-sandeen@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Eric Sandeen <sandeen@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from www.church-of-our-saviour.org ([69.25.196.31]:35754 "EHLO
	thunker.thunk.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754104AbYDQWPw (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 17 Apr 2008 18:15:52 -0400
Content-Disposition: inline
In-Reply-To: <1207623660-1088-5-git-send-email-sandeen@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Apr 07, 2008 at 10:00:59PM -0500, Eric Sandeen wrote:
> Make sure that extent_goto() leaves us at the last extent
> prior to the requested logical block, if the logical block
> requested lands in a hole.

Thanks, applied.  You do realize this won't necessarily do the right
thing if the sparse file doesn't have a block mapped at logical block
#0, and you then do an extent_goto() block 0, right?  Also, if
extent_get(EXT2_EXTENT_PREV_SIB) fails for various reasons, it still
could be non-deterministic.  Code that depends on this may want to do
some sanity checking.

Also, it might be prudent to check the return value here:

> +				retval = ext2fs_extent_get(handle,
> +							   EXT2_EXTENT_PREV_SIB,
> +							   &extent);
>  				return EXT2_ET_EXTENT_NOT_FOUND;

and return either the error returned by ext2fs_extent_get, or possibly
invent a new error code, say EXT2_ET_EXTENT_GOTO_BACKUP_FAILED and
return that if retval is non-zero.

I've left this as-is for now but there might be a potential robustness
problem hiding here.

						- Ted
