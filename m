From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: Re: [RFC PATCH -v2 8/9] ext4: Fix double free of blocks
Date: Wed, 5 Nov 2008 20:55:47 +0530
Message-ID: <20081105152547.GD6244@skywalker>
References: <1225733769-23734-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com> <1225733769-23734-2-git-send-email-aneesh.kumar@linux.vnet.ibm.com> <1225733769-23734-3-git-send-email-aneesh.kumar@linux.vnet.ibm.com> <1225733769-23734-4-git-send-email-aneesh.kumar@linux.vnet.ibm.com> <1225733769-23734-5-git-send-email-aneesh.kumar@linux.vnet.ibm.com> <1225733769-23734-6-git-send-email-aneesh.kumar@linux.vnet.ibm.com> <1225733769-23734-7-git-send-email-aneesh.kumar@linux.vnet.ibm.com> <1225733769-23734-8-git-send-email-aneesh.kumar@linux.vnet.ibm.com> <20081104164604.GK30291@mit.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: cmm@us.ibm.com, sandeen@redhat.com, linux-ext4@vger.kernel.org
To: Theodore Tso <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e28smtp05.in.ibm.com ([59.145.155.5]:46342 "EHLO
	e28smtp05.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751639AbYKEP0d (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 5 Nov 2008 10:26:33 -0500
Received: from d28relay02.in.ibm.com (d28relay02.in.ibm.com [9.184.220.59])
	by e28smtp05.in.ibm.com (8.13.1/8.13.1) with ESMTP id mA5FQ6Sd007028
	for <linux-ext4@vger.kernel.org>; Wed, 5 Nov 2008 20:56:16 +0530
Received: from d28av05.in.ibm.com (d28av05.in.ibm.com [9.184.220.67])
	by d28relay02.in.ibm.com (8.13.8/8.13.8/NCO v9.1) with ESMTP id mA5FPnD64133092
	for <linux-ext4@vger.kernel.org>; Wed, 5 Nov 2008 20:55:49 +0530
Received: from d28av05.in.ibm.com (loopback [127.0.0.1])
	by d28av05.in.ibm.com (8.13.1/8.13.3) with ESMTP id mA5FPtDc008453
	for <linux-ext4@vger.kernel.org>; Thu, 6 Nov 2008 02:25:55 +1100
Content-Disposition: inline
In-Reply-To: <20081104164604.GK30291@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, Nov 04, 2008 at 11:46:04AM -0500, Theodore Tso wrote:
> On Mon, Nov 03, 2008 at 11:06:08PM +0530, Aneesh Kumar K.V wrote:
> > blocks freed but not yet committed will be marked free
> > in disk bitmap. We need to consider them as used when
> > releasing inode prealloc space. Otherwise we would
> > double free them via mb_free_blocks
> 
> Stupid question...   
> 
> Blocks that are added to an inode's preallocation list were initially
> free, right?  And once they are in the inode's preallocation they are
> marked in use by mballoc, so they can't be allocated for another
> inode.  If a block in the preallocation list is used, it's removed
> from the preallocation line.  So even if that inode is subsequented
> unlinked or truncated, I'm curious how the double free situation
> happens in the first place.
> 
> What am I missing?
> 

We we discard  inode preallocation we look at the block bitmap
and mark the blocks found free in the bitmap using mb_free_blocks.
Now if we  allocate some blocks and later free some of them we would
have called ext4_mb_free blocks on them which mean we would have
marked the blocks free on bitmap. Now on file close we release
inode pa. We look at the block bitmap and if the block is free
in bitmap we call mb_free_blocks. Also on committing the transaction we
call mb_free_blocks on them. To avoid the above we need to make sure
when we discard_inode_pa we look at a bitmap that have block freed
and not yet committed as used.

-aneesh
