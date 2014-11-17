From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 06/47] libext2fs: don't allow alloc_stats on bad
 inode/block numbers
Date: Mon, 17 Nov 2014 18:00:20 -0500
Message-ID: <20141117230020.GF9693@thunk.org>
References: <20141107215042.883.49888.stgit@birch.djwong.org>
 <20141107215121.883.24372.stgit@birch.djwong.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:35247 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752315AbaKQXA0 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 17 Nov 2014 18:00:26 -0500
Content-Disposition: inline
In-Reply-To: <20141107215121.883.24372.stgit@birch.djwong.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, Nov 07, 2014 at 01:51:21PM -0800, Darrick J. Wong wrote:
> Don't allow callers to feed bad block/inode numbers to
> ext2fs_*_alloc_stats2, because evil callers (<cough>resize2fs<cough>)
> can corrupt library state this way, leading to a crash.
> 
> (There will be a subsequent patch to resize2fs to fix its bad
> behavior.)
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>

Applied, thanks.

					- Ted
