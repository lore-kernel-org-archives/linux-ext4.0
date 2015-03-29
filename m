From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 56/54] libext2fs: zero hash in ibody extended attributes
Date: Sun, 29 Mar 2015 00:13:12 -0400
Message-ID: <20150329041312.GG19097@thunk.org>
References: <20150127073533.13308.44994.stgit@birch.djwong.org>
 <20150319214551.GK11031@birch.djwong.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:38594 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750770AbbC2ENO (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sun, 29 Mar 2015 00:13:14 -0400
Content-Disposition: inline
In-Reply-To: <20150319214551.GK11031@birch.djwong.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, Mar 19, 2015 at 02:45:51PM -0700, Darrick J. Wong wrote:
> The kernel never updates the extended attribute hash value for
> attributes stored in the inode.  However, fsck has always checked this
> value (if it's nonzero) and will complain if the hash doesn't match
> the xattr.  Therefore, always zero the hash value when writing to
> in-ibody xattrs to avoid creating "corrupt" attribute errors
> downstream.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>

Thanks, applied.

					- Ted
