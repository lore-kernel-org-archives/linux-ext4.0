From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 24/47] resize2fs: don't exit if shrinking sparse_super2
 fs to one bg
Date: Sat, 13 Dec 2014 22:06:43 -0500
Message-ID: <20141214030643.GM29787@thunk.org>
References: <20141107215042.883.49888.stgit@birch.djwong.org>
 <20141107215323.883.85339.stgit@birch.djwong.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:54892 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751076AbaLNDGq (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sat, 13 Dec 2014 22:06:46 -0500
Content-Disposition: inline
In-Reply-To: <20141107215323.883.85339.stgit@birch.djwong.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, Nov 07, 2014 at 01:53:23PM -0800, Darrick J. Wong wrote:
> If we're shrinking a sparse_super2 filesystem to a single block group,
> the superblock will be in block 0.  This is perfectly valid (for block
> group 0 with a blocksize > 1024) so don't exit.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>

Applied, thanks.

						- Ted
