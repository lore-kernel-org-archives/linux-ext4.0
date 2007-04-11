From: Andreas Dilger <adilger@clusterfs.com>
Subject: Re: [PATCH] e2fsprogs - pass1c terminates early if hard links
Date: Tue, 10 Apr 2007 22:22:20 -0600
Message-ID: <20070411042220.GP5967@schatzie.adilger.int>
References: <Pine.LNX.4.61.0704101344050.29750@webb> <20070411034019.GA25231@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Jim Garlick <garlick@llnl.gov>, linux-ext4@vger.kernel.org
To: Theodore Tso <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.clusterfs.com ([206.168.112.78]:48255 "EHLO
	mail.clusterfs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161175AbXDKEWX (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 11 Apr 2007 00:22:23 -0400
Content-Disposition: inline
In-Reply-To: <20070411034019.GA25231@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Apr 10, 2007  23:40 -0400, Theodore Tso wrote:
> Also note that providing a
> script which generates the test filesystem is now preferred to
> including an image.gz file; it avoids the need for binary patches, and
> it makes it clearer how the test filesystem is constructed.

Agreed, though in some cases it is considerably easier to produce the
corruption via binary editing than debugfs commands unless there are
now facilities to copy blocks/bytes around within the filesystem?

> +find all directdory pathnames

Typo.

> diff -r 365efb1a2299 -r 8bb7637c6508 tests/f_dup4/script
> --- /dev/null	Thu Jan 01 00:00:00 1970 +0000
> +++ b/tests/f_dup4/script	Tue Apr 10 22:55:09 2007 -0400
> @@ -0,0 +1,50 @@
> +set_inode_field /dir/foo block[0] 30
> +set_inode_field /dir2/bar block[0] 30
> +set_inode_field /dir3/baz block[0] 30
> +set_inode_field /dir/fee block[0] 34
> +set_inode_field /dir2/fie block[0] 34
> +set_inode_field /dir3/foe block[0] 34

Also, items such as these presuppose that the directory has specific
blocks allocated to it, which need the test case to be constructed in
multiple passes (to extract these numbers) and could break at some time 
in the future.


Cheers, Andreas
--
Andreas Dilger
Principal Software Engineer
Cluster File Systems, Inc.
