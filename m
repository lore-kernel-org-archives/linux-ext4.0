From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 05/47] libext2fs: set BLOCK_UNINIT for non-last
 blockgroups if all blocks are free
Date: Mon, 17 Nov 2014 17:47:19 -0500
Message-ID: <20141117224719.GE9693@thunk.org>
References: <20141107215042.883.49888.stgit@birch.djwong.org>
 <20141107215114.883.46921.stgit@birch.djwong.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:35217 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751626AbaKQWr0 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 17 Nov 2014 17:47:26 -0500
Content-Disposition: inline
In-Reply-To: <20141107215114.883.46921.stgit@birch.djwong.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, Nov 07, 2014 at 01:51:14PM -0800, Darrick J. Wong wrote:
> Set BLOCK_UNINIT in any group whose blocks are all unused, so long as
> it isn't the last group.  This helps us speed up future e2fsck runs
> and mounts because we don't need to read or checksum block bitmaps for
> these groups.
> 
> v2: Take care of this in the library, since e2fsck always updates these
> summary counts.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>

Applied, thanks.

					- Ted
