From: Theodore Tso <tytso@MIT.EDU>
Subject: Re: [PATCH][e2fsprogs][mke2fs] fix FLEX_BG offset
Date: Mon, 7 Jul 2008 12:46:07 -0400
Message-ID: <20080707164607.GO31490@mit.edu>
References: <486C8BEE.5030200@bull.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, "Jose R. Santos" <jrs@us.ibm.com>,
	cmm@us.ibm.com,
	=?iso-8859-1?Q?Fr=E9d=E9ric_Boh=E9?= <frederic.bohe@bull.net>,
	SOLOFO RAMANGALAHY <Solofo.Ramangalahy@bull.net>,
	Jean-Pierre Dion <jean-pierre.dion@bull.net>
To: Celine Bourde <celine.bourde@bull.net>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from BISCAYNE-ONE-STATION.MIT.EDU ([18.7.7.80]:60689 "EHLO
	biscayne-one-station.mit.edu" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753190AbYGGQqu (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 7 Jul 2008 12:46:50 -0400
Content-Disposition: inline
In-Reply-To: <486C8BEE.5030200@bull.net>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, Jul 03, 2008 at 10:21:02AM +0200, Celine Bourde wrote:
> This patch resolves the offset problem of the flex_bg
> option when you use mke2fs tool.

Actually, I think the problem is a bigger one.  Ext2fs_get_free_blocks()
returns a error code on failure.  So the code before the conditional
you modified is totally bogus:

	/* Find the first available block */
	if (ext2fs_get_free_blocks(fs, start_blk, last_blk, 1, bmap,
				   &first_free))
		return first_free;

	if (ext2fs_get_free_blocks(fs, first_free + offset, last_blk, size,
				   bmap, &first_free))
		return first_free;

	return first_free;

I think this should be instead:

	/* Find the first available block */
	if (ext2fs_get_free_blocks(fs, start_blk, last_blk, 1, bmap,
				   &first_free) == 0)
		return first_free;

	if (ext2fs_get_free_blocks(fs, first_free + offset, last_blk, size,
				   bmap, &first_free) == 0)
		return first_free;

	/* 
	 * Oops, we weren't able to find enough space.  We return 
	 * first_free as a best try.
	 */

	return first_free;

							- Ted
