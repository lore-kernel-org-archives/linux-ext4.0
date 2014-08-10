From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 17/21] e2fsck: use the correct block size when salvaging
 directories
Date: Sun, 10 Aug 2014 18:45:30 -0400
Message-ID: <20140810224530.GC15431@thunk.org>
References: <20140805010457.2611.89813.stgit@birch.djwong.org>
 <20140805010649.2611.15991.stgit@birch.djwong.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:53532 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751735AbaHJWpc (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sun, 10 Aug 2014 18:45:32 -0400
Content-Disposition: inline
In-Reply-To: <20140805010649.2611.15991.stgit@birch.djwong.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Aug 04, 2014 at 06:06:49PM -0700, Darrick J. Wong wrote:
> Now that the directory salvaging operation is fed the block size,
> teach pass 2 that it should use the size of the inline data if the
> directory is inline_data.  Without this, it'll "fix" inline
> directories by setting the rec_len to something approaching the FS
> blocksize, which is clearly wrong.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>

Applied, thanks.

						- Ted
