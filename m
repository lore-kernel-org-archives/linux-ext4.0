From: Ted Ts'o <tytso@mit.edu>
Subject: Re: [PATCH] libext2fs: When truncating file, punch out blocks at
 end
Date: Wed, 15 Feb 2012 15:12:42 -0500
Message-ID: <20120215201242.GJ11382@thunk.org>
References: <20120107044737.3366.45151.stgit@elm3c44.beaverton.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: "Darrick J. Wong" <djwong@us.ibm.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:39014 "EHLO
	test.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753132Ab2BOUMs (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 15 Feb 2012 15:12:48 -0500
Content-Disposition: inline
In-Reply-To: <20120107044737.3366.45151.stgit@elm3c44.beaverton.ibm.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, Jan 06, 2012 at 08:47:37PM -0800, Darrick J. Wong wrote:
> Currently, ext2fs_file_set_size2 punches out data blocks between the
> end of the file and infinity when truncate_block <= old_truncate
> (i.e. when you've made the file longer).  This is not a useful
> behavior, particularly since it *fails* to punch out the data blocks
> when the file is shortened (i.e. truncate_block < old_truncate).
> This seems to be the result of the test being backwards, so fix the
> code to punch only when the file is getting shorter.
> 
> Signed-off-by: Darrick J. Wong <djwong@us.ibm.com>

Thanks, applied.

						- Ted
