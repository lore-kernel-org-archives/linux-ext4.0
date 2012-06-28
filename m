From: "Darrick J. Wong" <djwong@us.ibm.com>
Subject: Re: [PATCH] ext4: Use s_csum_seed instead of i_csum_seed for xattr
 block csum.
Date: Thu, 28 Jun 2012 13:15:41 -0700
Message-ID: <20120628162726.GA2342@tux1.beaverton.ibm.com>
References: <1340547236-2838-1-git-send-email-tm@tao.ma>
 <20120626022300.GB14329@thunk.org>
Reply-To: djwong@us.ibm.com
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Tao Ma <tm@tao.ma>, linux-ext4@vger.kernel.org
To: "Theodore Ts'o" <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e9.ny.us.ibm.com ([32.97.182.139]:38711 "EHLO e9.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751801Ab2F1Ugp (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 28 Jun 2012 16:36:45 -0400
Received: from /spool/local
	by e9.ny.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
	for <linux-ext4@vger.kernel.org> from <djwong@us.ibm.com>;
	Thu, 28 Jun 2012 16:36:44 -0400
Received: from d01av02.pok.ibm.com (d01av02.pok.ibm.com [9.56.224.216])
	by d01relay01.pok.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id q5SKRhAu337442
	for <linux-ext4@vger.kernel.org>; Thu, 28 Jun 2012 16:36:41 -0400
Received: from d01av02.pok.ibm.com (loopback [127.0.0.1])
	by d01av02.pok.ibm.com (8.14.4/8.13.1/NCO v10.0 AVout) with ESMTP id q5SKFjFv014768
	for <linux-ext4@vger.kernel.org>; Thu, 28 Jun 2012 17:15:46 -0300
Content-Disposition: inline
In-Reply-To: <20120626022300.GB14329@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Jun 25, 2012 at 10:23:00PM -0400, Theodore Ts'o wrote:
> On Sun, Jun 24, 2012 at 10:13:56PM +0800, Tao Ma wrote:
> > From: Tao Ma <boyu.mt@taobao.com>
> > 
> > In xattr block operation, we use h_refcount to indicate whether the
> > xattr block is shared among many inodes. And xattr block csum uses
> > s_csum_seed if it is shared and i_csum_seed if it belongs to
> > one inode. But this has a problem. So consider the block is shared
> > first bewteen inode A and B, and B has some xattr update and CoW
> > the xattr block. When it updates the *old* xattr block(because
> > of the h_refcount change) and calls ext4_xattr_release_block, we
> > has no idea that inode A is the real owner of the *old* xattr
> > block and we can't use the i_csum_seed of inode A either in xattr
> > block csum calculation. And I don't think we have an easy way to
> > find inode A.
> > 
> > So this patch just removes the tricky i_csum_seed and we now uses
> > s_csum_seed every time for the xattr block csum. The corresponding
> > patch for the e2fsprogs will be sent in another patch.
> 
> This makes sense to me; it's an on-disk format change, but we haven't
> released the e2fsprogs patches in anything other than the proposed
> updates branch of the e2fsprogs repo, so it seems reasonable to make
> this change as there's really no other way to fix this.
> 
> Darrick, any objections to this change?

Nope. iirc the only reason we had that weird code to start with was that
someone suggested that we use the inode checksum in the "xattr block only has
one owner" case, though I seem to have FUBAR'd it anyway.

--D
> 
> 						- Ted
> 

