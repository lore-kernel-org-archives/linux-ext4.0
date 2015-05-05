From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH 07/35] e2fsck: convert block-mapped files to extents on
 bigalloc fs
Date: Tue, 5 May 2015 15:45:05 -0700
Message-ID: <20150505224505.GA30577@birch.djwong.org>
References: <20150402023359.25243.79782.stgit@birch.djwong.org>
 <20150402023446.25243.17421.stgit@birch.djwong.org>
 <20150421143655.GG3238@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: "Theodore Ts'o" <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:49798 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965322AbbEEWpK (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 5 May 2015 18:45:10 -0400
Content-Disposition: inline
In-Reply-To: <20150421143655.GG3238@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, Apr 21, 2015 at 10:36:55AM -0400, Theodore Ts'o wrote:
> On Wed, Apr 01, 2015 at 07:34:46PM -0700, Darrick J. Wong wrote:
> > As of v4.0, the Linux kernel won't add blocks to a block-mapped file
> > on a bigalloc filesystem.  Therefore, convert any such files or
> > directories we find, to prevent fs errors later on.
> > 
> > Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> 
> Thanks, applied.  I adjusted the e2fsck problem messages a little to
> compress vertical space, and to remove some gcc-wall warnings.

Hmm.  Did this patch fall out somewhere?  I don't see it in this morning's
-next branch.

--D
> 
> 	 	  	     	       	    - Ted
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
