From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 06/14] e2fsck: convert block-mapped files to extents on
 bigalloc fs
Date: Sat, 16 May 2015 20:51:56 -0400
Message-ID: <20150517005156.GE4489@thunk.org>
References: <20150514002108.10785.85860.stgit@birch.djwong.org>
 <20150514002147.10785.14723.stgit@birch.djwong.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:40763 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751459AbbEQAv5 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sat, 16 May 2015 20:51:57 -0400
Content-Disposition: inline
In-Reply-To: <20150514002147.10785.14723.stgit@birch.djwong.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, May 13, 2015 at 05:21:47PM -0700, Darrick J. Wong wrote:
> As of v4.0, the Linux kernel won't add blocks to a block-mapped file
> on a bigalloc filesystem.  Therefore, convert any such files or
> directories we find, to prevent fs errors later on.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>

Thanks, applied.

					- Ted
