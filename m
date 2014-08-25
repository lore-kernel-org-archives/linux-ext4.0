From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 05/27] e2fsck: on BE, re-swap everything after a damaged
 dirent so salvage works correctly
Date: Sun, 24 Aug 2014 22:03:12 -0400
Message-ID: <20140825020312.GL6236@thunk.org>
References: <20140816234550.11171.61585.stgit@birch.djwong.org>
 <20140816234623.11171.70133.stgit@birch.djwong.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:47188 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753088AbaHYCDN (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sun, 24 Aug 2014 22:03:13 -0400
Content-Disposition: inline
In-Reply-To: <20140816234623.11171.70133.stgit@birch.djwong.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sat, Aug 16, 2014 at 04:46:23PM -0700, Darrick J. Wong wrote:
> On big-endian systems, if the dirent swap routine finds a rec_len that
> it doesn't like, it continues processing the block as if rec_len == 8.
> This means that the name field gets byte swapped, which means that
> salvage will not detect the correct name length (unless the name has a
> length that's an exact multiple of four bytes), and it'll discard the
> entry (unnecessarily) and the rest of the dirent block.  Therefore,
> swap the rest of the block back to disk order, run salvage, and
> re-swap anything after the salvaged dirent.
> 
> The test case for this is f_inlinedata_repair if you run it on a BE
> system.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>

Thanks, applied.

					- Ted
