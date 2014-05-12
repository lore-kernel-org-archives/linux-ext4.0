From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 3/5] ext4: fix block bitmap validation when bigalloc,
 ^flex_bg
Date: Mon, 12 May 2014 10:22:08 -0400
Message-ID: <20140512142208.GF31376@thunk.org>
References: <20140501231720.892.58712.stgit@birch.djwong.org>
 <20140501231740.892.50993.stgit@birch.djwong.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:34667 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758221AbaELOWK (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 12 May 2014 10:22:10 -0400
Content-Disposition: inline
In-Reply-To: <20140501231740.892.50993.stgit@birch.djwong.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, May 01, 2014 at 04:17:40PM -0700, Darrick J. Wong wrote:
> On a bigalloc,^flex_bg filesystem, the ext4_valid_block_bitmap
> function fails to convert from blocks to clusters when spot-checking
> the validity of the bitmap block that we've just read from disk.  This
> causes ext4 to think that the bitmap is garbage, which results in the
> block group being taken offline when it's not necessary.  Add in the
> necessary EXT4_B2C() calls to perform the conversions.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>

Applied, thanks.

					- Ted
