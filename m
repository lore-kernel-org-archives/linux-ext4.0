From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 02/19] e2fsck: never free critical metadata blocks in the
 block found map
Date: Sat, 2 Aug 2014 22:22:43 -0400
Message-ID: <20140803022243.GB24826@thunk.org>
References: <20140801181139.12496.14390.stgit@birch.djwong.org>
 <20140801181153.12496.71297.stgit@birch.djwong.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:41905 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751813AbaHCCWp (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sat, 2 Aug 2014 22:22:45 -0400
Content-Disposition: inline
In-Reply-To: <20140801181153.12496.71297.stgit@birch.djwong.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, Aug 01, 2014 at 11:11:53AM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> Don't allow critical metadata blocks to be marked free in the block
> found map.  This can theoretically happen on an FS where a first
> inode's ETB/indirect map block is in the inode table, the first inode
> is itself unclonable (and thus gets deleted) and there are enough
> crosslinked files before and after the first inode to use up all the
> free blocks during pass 1b.
> 
> (I do actually have a test FS image but it's 256M and it proved very
> difficult to craft a bite-sized test case that actually hit this bug.)
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>

Applied, thanks.

						- Ted
