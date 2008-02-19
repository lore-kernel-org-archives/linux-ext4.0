From: Andreas Dilger <adilger@sun.com>
Subject: Re: How were some of the lustre e2fsprogs test cases generated?
Date: Tue, 19 Feb 2008 04:28:39 -0700
Message-ID: <20080219112839.GK3029@webber.adilger.int>
References: <E1JRG0g-0001lz-Ur@closure.thunk.org>
 <20080219003644.GQ25098@mit.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7BIT
Cc: linux-ext4@vger.kernel.org
To: Theodore Tso <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from sca-es-mail-1.Sun.COM ([192.18.43.132]:55210 "EHLO
	sca-es-mail-1.sun.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759514AbYBSL2n (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 19 Feb 2008 06:28:43 -0500
Received: from fe-sfbay-10.sun.com ([192.18.43.129])
	by sca-es-mail-1.sun.com (8.13.7+Sun/8.12.9) with ESMTP id m1JBSg8d021256
	for <linux-ext4@vger.kernel.org>; Tue, 19 Feb 2008 03:28:42 -0800 (PST)
Received: from conversion-daemon.fe-sfbay-10.sun.com by fe-sfbay-10.sun.com
 (Sun Java System Messaging Server 6.2-8.04 (built Feb 28 2007))
 id <0JWH00001H6FKB00@fe-sfbay-10.sun.com> (original mail from adilger@sun.com)
 for linux-ext4@vger.kernel.org; Tue, 19 Feb 2008 03:28:42 -0800 (PST)
In-reply-to: <20080219003644.GQ25098@mit.edu>
Content-disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Feb 18, 2008  19:36 -0500, Theodore Ts'o wrote:
> One minor correction --- the clusterfs e2fsprogs extents code checks
> to see if the ee_leaf_hi field is non-zero, and complains if so.
> However, it ignores the ee_start_hi field for interior (non-leaf)
> nodes in the extent tree, and a number of tests do have non-zero
> ee_start_hi fields which cause my version of e2fsprogs to (rightly)
> complain.
> 
> If you fix this, a whole bunch of tests will fail as a result, and not
> exercise the code paths that the tests were apparently trying to
> exercise.  Which is what is causing me a bit of worry and wonder about
> how those test cases were originally generated....

The original CFS extents kernel patch had a bug where the _hi fields
were not initialized correctly to zero.  The CFS exents e2fsck
patches would clear the _hi fields in the extents and index blocks,
but I disabled that in the upstream patch submission because it will
be incorrect for 48-bit filesystems.

That's the "high_bits_ok" check in e2fsck_ext_block_verify() for error
PR_1_EXTENT_HI, that only allows the high bits when there are > 2^32
blocks in the filesystem.  It's possible I made a mistake when I added
that part of the patch, but the regression tests still passed.

Cheers, Andreas
--
Andreas Dilger
Sr. Staff Engineer, Lustre Group
Sun Microsystems of Canada, Inc.
