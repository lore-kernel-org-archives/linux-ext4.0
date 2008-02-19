From: Theodore Tso <tytso@mit.edu>
Subject: Re: How were some of the lustre e2fsprogs test cases generated?
Date: Mon, 18 Feb 2008 19:36:44 -0500
Message-ID: <20080219003644.GQ25098@mit.edu>
References: <E1JRG0g-0001lz-Ur@closure.thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Andreas Dilger <adilger@sun.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from www.church-of-our-saviour.org ([69.25.196.31]:51647 "EHLO
	thunker.thunk.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750775AbYBSAgq (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 18 Feb 2008 19:36:46 -0500
Content-Disposition: inline
In-Reply-To: <E1JRG0g-0001lz-Ur@closure.thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Feb 18, 2008 at 07:06:58PM -0500, Theodore Ts'o wrote:
> 
> The clusterfs e2fsprogs code doesn't notice this, because it apparently
> ignores ee_start_hi field entirely.  

One minor correction --- the clusterfs e2fsprogs extents code checks
to see if the ee_leaf_hi field is non-zero, and complains if so.
However, it ignores the ee_start_hi field for interior (non-leaf)
nodes in the extent tree, and a number of tests do have non-zero
ee_start_hi fields which cause my version of e2fsprogs to (rightly)
complain.

If you fix this, a whole bunch of tests will fail as a result, and not
exercise the code paths that the tests were apparently trying to
exercise.  Which is what is causing me a bit of worry and wonder about
how those test cases were originally generated....

Regards,

						- Ted
