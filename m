From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 01/25] libext2fs: stop iterating dirents when done linking
Date: Wed, 23 Oct 2013 19:39:09 -0400
Message-ID: <20131023233909.GB31400@thunk.org>
References: <20131018044854.7339.48457.stgit@birch.djwong.org>
 <20131018044901.7339.55731.stgit@birch.djwong.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:49872 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751705Ab3JWXjN (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 23 Oct 2013 19:39:13 -0400
Content-Disposition: inline
In-Reply-To: <20131018044901.7339.55731.stgit@birch.djwong.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, Oct 17, 2013 at 09:49:01PM -0700, Darrick J. Wong wrote:
> When we've succesfully linked an inode into a directory, we can stop
> iterating the directory.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>

Applied, thanks.

					- Ted
