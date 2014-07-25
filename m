From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 22/24] e2fsck: check return value of
 ext2fs_extent_fix_parents()
Date: Fri, 25 Jul 2014 08:51:19 -0400
Message-ID: <20140725125119.GL1865@thunk.org>
References: <20140718225200.31374.85411.stgit@birch.djwong.org>
 <20140718225528.31374.87729.stgit@birch.djwong.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:56322 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751348AbaGYMvX (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 25 Jul 2014 08:51:23 -0400
Content-Disposition: inline
In-Reply-To: <20140718225528.31374.87729.stgit@birch.djwong.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, Jul 18, 2014 at 03:55:28PM -0700, Darrick J. Wong wrote:
> When fixing parent nodes in an extent tree, check the return value for
> errors and bail out if problems happen.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> Fixes-Coverity-Bug: 1193379

Already fixed in my tree, thanks.

						- Ted
