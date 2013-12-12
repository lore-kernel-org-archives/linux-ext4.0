From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 12/74] libext2fs: make symlinks safe for 64bit blocks and
 extents
Date: Thu, 12 Dec 2013 12:48:54 -0500
Message-ID: <20131212174854.GJ13547@thunk.org>
References: <20131211011813.30655.39624.stgit@birch.djwong.org>
 <20131211011941.30655.52101.stgit@birch.djwong.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:39392 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751519Ab3LLRs5 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 12 Dec 2013 12:48:57 -0500
Content-Disposition: inline
In-Reply-To: <20131211011941.30655.52101.stgit@birch.djwong.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, Dec 10, 2013 at 05:19:41PM -0800, Darrick J. Wong wrote:
> If we have to create a big symlink (i.e. one that doesn't fit into
> i_block[]), we are not 64bit block safe and the namei code does not
> handle extents at all.  Fix both.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>

Thanks, applied.

					- Ted
