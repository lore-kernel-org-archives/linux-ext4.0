From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH] ext4: Use s_csum_seed instead of i_csum_seed for xattr
 block csum.
Date: Mon, 9 Jul 2012 10:12:48 -0400
Message-ID: <20120709141248.GB3649@thunk.org>
References: <1340547236-2838-1-git-send-email-tm@tao.ma>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, "Darrick J. Wong" <djwong@us.ibm.com>
To: Tao Ma <tm@tao.ma>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:38001 "EHLO
	imap.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753915Ab2GIOMw (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 9 Jul 2012 10:12:52 -0400
Content-Disposition: inline
In-Reply-To: <1340547236-2838-1-git-send-email-tm@tao.ma>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sun, Jun 24, 2012 at 10:13:56PM +0800, Tao Ma wrote:
> From: Tao Ma <boyu.mt@taobao.com>
> 
> In xattr block operation, we use h_refcount to indicate whether the
> xattr block is shared among many inodes. And xattr block csum uses
> s_csum_seed if it is shared and i_csum_seed if it belongs to
> one inode. But this has a problem. So consider the block is shared
> first bewteen inode A and B, and B has some xattr update and CoW
> the xattr block. When it updates the *old* xattr block(because
> of the h_refcount change) and calls ext4_xattr_release_block, we
> has no idea that inode A is the real owner of the *old* xattr
> block and we can't use the i_csum_seed of inode A either in xattr
> block csum calculation. And I don't think we have an easy way to
> find inode A.
> 
> So this patch just removes the tricky i_csum_seed and we now uses
> s_csum_seed every time for the xattr block csum. The corresponding
> patch for the e2fsprogs will be sent in another patch.
> 
> This is spotted by xfstests 117.
> 
> Cc: Darrick J. Wong <djwong@us.ibm.com>
> Cc: "Theodore Ts'o" <tytso@mit.edu>
> Signed-off-by: Tao Ma <boyu.mt@taobao.com>

Thanks, applied.

					- Ted
