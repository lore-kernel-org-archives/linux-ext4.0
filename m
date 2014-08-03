From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 11/19] e2fsck: disable checksum verification in a few
 select places
Date: Sat, 2 Aug 2014 22:51:49 -0400
Message-ID: <20140803025149.GK24826@thunk.org>
References: <20140801181139.12496.14390.stgit@birch.djwong.org>
 <20140801181254.12496.15751.stgit@birch.djwong.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:41972 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751944AbaHCCvu (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sat, 2 Aug 2014 22:51:50 -0400
Content-Disposition: inline
In-Reply-To: <20140801181254.12496.15751.stgit@birch.djwong.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, Aug 01, 2014 at 11:12:54AM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> Selectively disable checksum verification in a couple more places:
> 
> In check_blocks, disable checksum verification when iterating a block
> map because the block map iterator function (re)reads the inode, which
> could be unchanged since the scan found that the checksum fails.  We
> don't want to abort here; we want to keep evaluating the inode, and we
> already know if the inode checksum doesn't match.
> 
> Further down in check_blocks when we're trying to see if i_size
> matches the amount of data stored in the inode, don't allow checksum
> errors when we go looking for the size of inline data.  If the
> required attribute is at all find-able in the EA block, we'll fix any
> other problems with the EA block later.  In the meantime, we don't
> want to be truncating files unnecessarily.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>

Applied, thanks.

					- Ted
