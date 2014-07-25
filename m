From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 16/24] e2fsck: don't crash during rehash
Date: Fri, 25 Jul 2014 07:22:16 -0400
Message-ID: <20140725112216.GG1865@thunk.org>
References: <20140718225200.31374.85411.stgit@birch.djwong.org>
 <20140718225415.31374.89196.stgit@birch.djwong.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:56140 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751860AbaGYLWS (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 25 Jul 2014 07:22:18 -0400
Content-Disposition: inline
In-Reply-To: <20140718225415.31374.89196.stgit@birch.djwong.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, Jul 18, 2014 at 03:54:15PM -0700, Darrick J. Wong wrote:
> If a user crafts a carefully constructed filesystem containing a
> single directory entry block with an invalid checksum and fewer than
> two entries, and then runs e2fsck to fix the filesystem, fsck will
> crash when it tries to "compress" the short dir and passes a negative
> dirent array length to qsort.  Therefore, don't allow directory
> "compression" in this situation.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>

Thanks, applied.

				- Ted
