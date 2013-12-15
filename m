From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH] libext2fs: clamp block-map punch range end to 2^32 blocks
Date: Sat, 14 Dec 2013 19:48:58 -0500
Message-ID: <20131215004858.GA15593@thunk.org>
References: <20131212211325.10844.50409.stgit@birch.djwong.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:40058 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751407Ab3LOBMB (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sat, 14 Dec 2013 20:12:01 -0500
Content-Disposition: inline
In-Reply-To: <20131212211325.10844.50409.stgit@birch.djwong.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, Dec 12, 2013 at 01:13:25PM -0800, Darrick J. Wong wrote:
> In the ^extent case, passing ~0ULL as the 'end' parameter to
> ext2fs_punch() causes the (end - start + 1) calculation to overflow to
> zero.  Since the old-style mapped block files cannot have more than
> 2^32 blocks, just clamp it to ~0U.
> 
> This fixes a regression in t_quota_2off with the patch "libext2fs: use
> ext2fs_punch() to truncate quota file" applied.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>

Thanks, applied.

					- Ted
