From: Ted Ts'o <tytso@mit.edu>
Subject: Re: [PATCH] e2fsck: When restarting fsck on account of MMP, zero
 ctx->fs after fs is freed
Date: Fri, 30 Sep 2011 17:38:09 -0400
Message-ID: <20110930213809.GH12440@thunk.org>
References: <20110930194005.GT12086@tux1.beaverton.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4 <linux-ext4@vger.kernel.org>
To: "Darrick J. Wong" <djwong@us.ibm.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:50810 "EHLO
	test.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753352Ab1I3ViO (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 30 Sep 2011 17:38:14 -0400
Content-Disposition: inline
In-Reply-To: <20110930194005.GT12086@tux1.beaverton.ibm.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, Sep 30, 2011 at 12:40:05PM -0700, Darrick J. Wong wrote:
> If MMP is enabled and e2fsck determines that it needs to restart itself on
> account of various MMP conditions, it will close the current fs and jump back
> to the start of fs checking.  However, closing fs also frees it, which means
> that we need to set ctx->fs to NULL to prevent subsequent open code from
> accessing the old deleted pointer.
> 
> (This fix came up while testing the metadata checksumming patchset)
> 
> Signed-off-by: Darrick J. Wong <djwong@us.ibm.com>

Thanks, applied.

					- Ted
