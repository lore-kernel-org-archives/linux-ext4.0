From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 28/25] e2fsck: ignore badblocks if it says badblocks
 inode is bad
Date: Thu, 11 Sep 2014 18:09:51 -0400
Message-ID: <20140911220951.GD17990@thunk.org>
References: <20140908231135.25904.66591.stgit@birch.djwong.org>
 <20140911194449.GT10351@birch.djwong.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:52177 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750899AbaIKWJx (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 11 Sep 2014 18:09:53 -0400
Content-Disposition: inline
In-Reply-To: <20140911194449.GT10351@birch.djwong.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, Sep 11, 2014 at 12:44:49PM -0700, Darrick J. Wong wrote:
> If the badblocks list says that the badblocks inode is bad, it's quite
> likely that badblocks is broken.  Worse yet, if the root inode is in
> the same block as the badblocks inode (likely since they're adjacent),
> the filesystem becomes unfixable because pass3 notices the bad root
> inode and exits.
> 
> So... if we encounter this case, just kill the badblocks inode.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>

Applied, thanks.

					- Ted
