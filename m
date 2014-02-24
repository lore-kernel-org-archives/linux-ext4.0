From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 48/74] resize2fs: don't free in-use clusters when moving
 blocks
Date: Sun, 23 Feb 2014 20:56:31 -0500
Message-ID: <20140224015631.GB23946@thunk.org>
References: <20131211011813.30655.39624.stgit@birch.djwong.org>
 <20131211012340.30655.31519.stgit@birch.djwong.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:33225 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751042AbaBXB4d (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sun, 23 Feb 2014 20:56:33 -0500
Content-Disposition: inline
In-Reply-To: <20131211012340.30655.31519.stgit@birch.djwong.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, Dec 10, 2013 at 05:23:40PM -0800, Darrick J. Wong wrote:
> When we're moving blocks around the filesystem, ensure that freeing
> the old blocks only frees the clusters if they're not in use by other
> metadata.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>

Thanks, applied.

					- Ted
