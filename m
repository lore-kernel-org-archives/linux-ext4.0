From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 07/35] e2fsck: convert block-mapped files to extents on
 bigalloc fs
Date: Tue, 21 Apr 2015 10:36:55 -0400
Message-ID: <20150421143655.GG3238@thunk.org>
References: <20150402023359.25243.79782.stgit@birch.djwong.org>
 <20150402023446.25243.17421.stgit@birch.djwong.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:50183 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752185AbbDUOg7 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 21 Apr 2015 10:36:59 -0400
Content-Disposition: inline
In-Reply-To: <20150402023446.25243.17421.stgit@birch.djwong.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, Apr 01, 2015 at 07:34:46PM -0700, Darrick J. Wong wrote:
> As of v4.0, the Linux kernel won't add blocks to a block-mapped file
> on a bigalloc filesystem.  Therefore, convert any such files or
> directories we find, to prevent fs errors later on.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>

Thanks, applied.  I adjusted the e2fsck problem messages a little to
compress vertical space, and to remove some gcc-wall warnings.

	 	  	     	       	    - Ted
