From: Theodore Tso <tytso@mit.edu>
Subject: Re: [RFC PATCH 8/9][e2fsprogs] Add 64-bit closefs interface.
Date: Mon, 12 May 2008 11:05:50 -0400
Message-ID: <20080512150550.GF7029@mit.edu>
References: <20080509163928.15484.22146.stgit@gara> <20080509164018.15484.53983.stgit@gara>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: "Jose R. Santos" <jrs@us.ibm.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from www.church-of-our-saviour.org ([69.25.196.31]:45974 "EHLO
	thunker.thunk.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751726AbYELPGQ (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 12 May 2008 11:06:16 -0400
Content-Disposition: inline
In-Reply-To: <20080509164018.15484.53983.stgit@gara>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, May 09, 2008 at 11:40:19AM -0500, Jose R. Santos wrote:
> From: Jose R. Santos <jrs@us.ibm.com>
> 
> Add 64-bit closefs interface.
> 
> Add new ext2fs_super_and_bgd_loc2() that returns blk64_t pointers.
> The function now returns the number of blocks used by super block and
> group descriptors since with flex_bg, it can no longer be assumed that
> bitmaps and inode tables still resided within the block group.

This change makes me nervous, because (a) I need to assure myself that
ext2fs_super_and_bgd_loc() is going to always do the right thing, and
(b) the changes to the callers of ext2fs_super_and_bgd_loc2() aren't
also described.

So this requires more thought.  One change I would make is to return
the number of blocks via a pointer rather than through a straight
return value.  And also, if I recall correctly, nothing is actually
using the ret_meta_bg pointer, so we might be able to drop that in the
_2 version. of the interface.

We should probably include in this patch series the callers of
ext2fs_super_and_bgd_loc() and assure ourselves that the new interface
actually works correctly and is clean for the users before we finalize
the interface change.

						- Ted
