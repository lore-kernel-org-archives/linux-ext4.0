From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 51/47] e2fsck: force-reread of inode from disk when
 re-checking a checksum error
Date: Thu, 11 Dec 2014 17:49:29 -0500
Message-ID: <20141211224929.GG31008@thunk.org>
References: <20141107215042.883.49888.stgit@birch.djwong.org>
 <20141204203903.GC10059@birch.djwong.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:51919 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934279AbaLKWtf (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 11 Dec 2014 17:49:35 -0500
Content-Disposition: inline
In-Reply-To: <20141204203903.GC10059@birch.djwong.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, Dec 04, 2014 at 12:39:03PM -0800, Darrick J. Wong wrote:
> When we're rechecking an inode checksum failure, we need to force the
> inode to be re-read from disk so that the verification routine runs,
> so drop the stashed inode.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>

Applied, thanks.

						- Ted
