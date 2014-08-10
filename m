From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 12/21] e2fsck: check inline directory data "block" first
Date: Sun, 10 Aug 2014 18:40:02 -0400
Message-ID: <20140810224002.GX15431@thunk.org>
References: <20140805010457.2611.89813.stgit@birch.djwong.org>
 <20140805010615.2611.4060.stgit@birch.djwong.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:53560 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751685AbaHJWvU (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sun, 10 Aug 2014 18:51:20 -0400
Content-Disposition: inline
In-Reply-To: <20140805010615.2611.4060.stgit@birch.djwong.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Aug 04, 2014 at 06:06:15PM -0700, Darrick J. Wong wrote:
> Since the inline data flag will cause the extent/block map iteration
> code to abort fsck early, move the test for the inode flag and the
> actual block check call further forward in check_blocks.  This
> eliminates an e2fsck abort on an inline data symlink when the file ACL
> block is set.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>

Applied, thanks.

					- Ted
