From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH] ext4: Use s_csum_seed instead of i_csum_seed for xattr
 block csum.
Date: Mon, 25 Jun 2012 22:23:00 -0400
Message-ID: <20120626022300.GB14329@thunk.org>
References: <1340547236-2838-1-git-send-email-tm@tao.ma>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, "Darrick J. Wong" <djwong@us.ibm.com>
To: Tao Ma <tm@tao.ma>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:52694 "EHLO
	imap.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757909Ab2FZCXK (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 25 Jun 2012 22:23:10 -0400
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

This makes sense to me; it's an on-disk format change, but we haven't
released the e2fsprogs patches in anything other than the proposed
updates branch of the e2fsprogs repo, so it seems reasonable to make
this change as there's really no other way to fix this.

Darrick, any objections to this change?

						- Ted
