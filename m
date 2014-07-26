From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 28/37] libext2fs: provide a function to set inode size
Date: Sat, 26 Jul 2014 14:37:58 -0400
Message-ID: <20140726183758.GF6725@thunk.org>
References: <20140501231222.31890.82860.stgit@birch.djwong.org>
 <20140501231526.31890.13684.stgit@birch.djwong.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:58311 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751819AbaGZSiB (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sat, 26 Jul 2014 14:38:01 -0400
Content-Disposition: inline
In-Reply-To: <20140501231526.31890.13684.stgit@birch.djwong.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, May 01, 2014 at 04:15:26PM -0700, Darrick J. Wong wrote:
> Provide an API to set i_size in an inode and take care of all required
> feature flag modifications.  Refactor the code to use this new
> function.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>

Applied, although I moved the function to blk_num.c and renamed it to
be ext2fs_inode_size_set() to be consistent with the other functions
in blk_num.c.  I also added another use of the function in
misc/mk_hugefile.c.

							- Ted
