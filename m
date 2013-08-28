From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 1/5] ext4: Error out if verifying the block bitmap fails
Date: Wed, 28 Aug 2013 15:36:09 -0400
Message-ID: <20130828193609.GG27079@thunk.org>
References: <20130719235532.24017.31896.stgit@blackbox.djwong.org>
 <20130719235539.24017.94739.stgit@blackbox.djwong.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:50824 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754532Ab3H1TgO (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 28 Aug 2013 15:36:14 -0400
Content-Disposition: inline
In-Reply-To: <20130719235539.24017.94739.stgit@blackbox.djwong.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, Jul 19, 2013 at 04:55:39PM -0700, Darrick J. Wong wrote:
> The block bitmap verification code assumes that calling ext4_error() either
> panics the system or makes the fs readonly.  However, this is not always true:
> when 'errors=continue' is specified, an error is printed but we don't return
> any indication of error to the caller, which is (probably) the block allocator,
> which pretends that the crud we read in off the disk is a usable bitmap.  Yuck.
> 
> A block bitmap that fails the check should at least return no bitmap to the
> caller.  The block allocator should be told to go look in a different group,
> but that's a separate issue.
> 
> The easiest way to reproduce this is to modify bg_block_bitmap (on a ^flex_bg
> fs) to point to a block outside the block group; or you can create a
> metadata_csum filesystem and zero out the block bitmaps.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>

Thanks, applied.

					- Ted
