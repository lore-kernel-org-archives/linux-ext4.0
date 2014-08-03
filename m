From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 06/19] e2fsck: try to salvage extent blocks with bad
 checksums
Date: Sat, 2 Aug 2014 22:33:21 -0400
Message-ID: <20140803023321.GF24826@thunk.org>
References: <20140801181139.12496.14390.stgit@birch.djwong.org>
 <20140801181221.12496.71818.stgit@birch.djwong.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:41931 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753329AbaHCCdX (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sat, 2 Aug 2014 22:33:23 -0400
Content-Disposition: inline
In-Reply-To: <20140801181221.12496.71818.stgit@birch.djwong.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, Aug 01, 2014 at 11:12:21AM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> Remove the code that would zap an extent block immediately if the
> checksum failed (i.e. strict_csums).  Instead, we'll only do that if
> the extent block header shows obvious structural problems; if the
> header checks out, then we'll iterate the block and see if we can
> recover some extents.
> 
> Requires a minor modification to ext2fs_extent_get such that the
> extent block will be returned in the buffer even if the return code
> indicates a checksum error.  This brings its behavior in line with
> the rest of libext2fs.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>

Applied, thanks.

						- Ted
