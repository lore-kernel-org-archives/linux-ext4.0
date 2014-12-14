From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 18/47] e2fsck: only complain about no-checksum directory
 blocks once
Date: Sat, 13 Dec 2014 21:55:37 -0500
Message-ID: <20141214025537.GG29787@thunk.org>
References: <20141107215042.883.49888.stgit@birch.djwong.org>
 <20141107215245.883.75701.stgit@birch.djwong.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:54850 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751361AbaLNCzi (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sat, 13 Dec 2014 21:55:38 -0500
Content-Disposition: inline
In-Reply-To: <20141107215245.883.75701.stgit@birch.djwong.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, Nov 07, 2014 at 01:52:45PM -0800, Darrick J. Wong wrote:
> If a directory block lacks space for a checksum and the user directs
> e2fsck to fix the directory block (by rehashing it), don't complain a
> second time about the checksum verification failure when we get to the
> end of the directory block.
> 
> Also, don't complain about broken HTREE directories if we're already
> planning to rebuild the HTREE directory.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>

Applied, thanks.

						- Ted
