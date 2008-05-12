From: Theodore Tso <tytso@mit.edu>
Subject: Re: [RFC PATCH 4/9][e2fsprogs] Add 64-bit alloc_stats interface.
Date: Mon, 12 May 2008 10:43:53 -0400
Message-ID: <20080512144353.GC7029@mit.edu>
References: <20080509163928.15484.22146.stgit@gara> <20080509163952.15484.56168.stgit@gara>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: "Jose R. Santos" <jrs@us.ibm.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from www.church-of-our-saviour.org ([69.25.196.31]:45044 "EHLO
	thunker.thunk.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751309AbYELOoR (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 12 May 2008 10:44:17 -0400
Content-Disposition: inline
In-Reply-To: <20080509163952.15484.56168.stgit@gara>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, May 09, 2008 at 11:39:52AM -0500, Jose R. Santos wrote:
> +	/*FIXME: Not blk64_t clean */

Suggestion, please use "FIXME-64" instead of fixme so it's easier to
clean this up later.

>  	int	group = ext2fs_group_of_blk(fs, blk);

Might as well fix this in the initial patch series, earlier --- and
let's *not* make it be an inline function.  Yeah, we call
ext2fs_group_of_blk and ext2fs_group_of_ino a fair amount, but #1, on
32-bit machines, the 64 bit arithmemtic makes the function bigger, and
#2, modern CPU's have greatly reduced the cost of procedure
activations.

						- Ted
