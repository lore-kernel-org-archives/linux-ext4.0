From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH] debugfs: fix printing of inline data during symlink
 inode dump
Date: Tue, 22 Jul 2014 18:44:18 -0400
Message-ID: <20140722224418.GS25291@thunk.org>
References: <20140722204752.GE8628@birch.djwong.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Andreas Dilger <adilger@dilger.ca>,
	"linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:51055 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932154AbaGVWoX (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 22 Jul 2014 18:44:23 -0400
Content-Disposition: inline
In-Reply-To: <20140722204752.GE8628@birch.djwong.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, Jul 22, 2014 at 01:47:52PM -0700, Darrick J. Wong wrote:
> When we're dumping a fast symlink inode, we print some odd things to
> stdout.  To clean this up, first don't print inline data EA, since the
> inode dump doesn't display file and directory contents.  Then, teach
> the inode dump function how to print out either an inline data fast
> symlink or a non-inline data fast symlink.
> 
> (This is a follow-up to the earlier patch "debugfs: Only print the
> first 60 bytes from i_block on a fast symlink")
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>

Applied, thanks.

I had to make a minor change in your script to use $test_dir/image.gz
instead of $test_name/image.gz.  (The former doesn't work when the
build directory != the source directory, i.e., when doing a VPATH
build).

					- Ted
