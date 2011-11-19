From: Ted Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 0/9 v2 bigalloc] ext4: change unit of extent's ee_block
 and ee_len from block to cluster for bigalloc
Date: Fri, 18 Nov 2011 23:22:20 -0500
Message-ID: <20111119042220.GF4130@thunk.org>
References: <1321612984-10228-1-git-send-email-hao.bigrat@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, Robin Dong <sanbai@taobao.com>
To: Robin Dong <hao.bigrat@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:59709 "EHLO
	test.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751744Ab1KSEWZ (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 18 Nov 2011 23:22:25 -0500
Content-Disposition: inline
In-Reply-To: <1321612984-10228-1-git-send-email-hao.bigrat@gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, Nov 18, 2011 at 06:42:55PM +0800, Robin Dong wrote:
> From: Robin Dong <sanbai@taobao.com>
> 
> This patch series change ee_block and ee_len (of extent) 's unit
> from "block" to "cluster", since it could reduce the space occupied
> by meta data.
> 
> This patch series should be used after Ted's bigalloc-patchs and it
> now can't support:
> 1. delay allocation
> 2. 1k/2k blocksize

It *can't* support delayed allocation or sub-4k block sizes?  That's
only with your modified bigalloc enabled, I presume, right?

If we are going to support this modified bigalloc, I think it only
makes sense to do it as new file system feature, so we can support
both extents which are denominated in blocks, as well as extents which
are denominated in clusters.

But it may be that we're better off biting the bullet and supporting
at 2nd extent format, which looks like this:

struct ext4_extent2 {
       __le64	   ee_block;	/* first logical block extent covers */
       __le64	   ee_start;	/* starting physical block */
       __le32	   ee_len;	/* number of blocks covered by extent */
       __le32	   ee_flags;    /* flags and future extension */
};

This is 24 bytes, which means we can only fit two extents in the inode
(12 bytes header, plus two 24 byte extents).  But it expands the size
of files we can support, as well as supporting larger volumes.

Yes, using units of clusters could support this as well, but the fact
that it is required that sparse blocks have to get zeroed out to the
nearest cluster binary means that it's only going to work for clusters
sizes of 128k at most, since the requirements that clusters get
zero'ed out when doing a partial write is going to get pretty onerous
much beyond that size.

						- Ted



