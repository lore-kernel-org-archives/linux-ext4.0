From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: Re: [PATCH, RFC] ext4: add EXT4_IOC_ALLOC_DA_BLKS ioctl
Date: Thu, 12 Mar 2009 10:59:06 +0530
Message-ID: <20090312052906.GA3033@skywalker>
References: <1235451952-2726-1-git-send-email-tytso@mit.edu> <1235451952-2726-2-git-send-email-tytso@mit.edu> <1235451952-2726-3-git-send-email-tytso@mit.edu> <1235451952-2726-4-git-send-email-tytso@mit.edu> <1235451952-2726-5-git-send-email-tytso@mit.edu> <49B83E01.1040605@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: "Theodore Ts'o" <tytso@mit.edu>, linux-ext4@vger.kernel.org
To: Eric Sandeen <sandeen@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e28smtp07.in.ibm.com ([59.145.155.7]:46979 "EHLO
	e28smtp07.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750984AbZCLF3N (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 12 Mar 2009 01:29:13 -0400
Received: from d28relay02.in.ibm.com (d28relay02.in.ibm.com [9.184.220.59])
	by e28smtp07.in.ibm.com (8.13.1/8.13.1) with ESMTP id n2C5T8Sn026671
	for <linux-ext4@vger.kernel.org>; Thu, 12 Mar 2009 10:59:08 +0530
Received: from d28av02.in.ibm.com (d28av02.in.ibm.com [9.184.220.64])
	by d28relay02.in.ibm.com (8.13.8/8.13.8/NCO v9.2) with ESMTP id n2C5PueG585834
	for <linux-ext4@vger.kernel.org>; Thu, 12 Mar 2009 10:55:56 +0530
Received: from d28av02.in.ibm.com (loopback [127.0.0.1])
	by d28av02.in.ibm.com (8.13.1/8.13.3) with ESMTP id n2C5T7UW027584
	for <linux-ext4@vger.kernel.org>; Thu, 12 Mar 2009 16:29:07 +1100
Content-Disposition: inline
In-Reply-To: <49B83E01.1040605@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, Mar 11, 2009 at 05:41:05PM -0500, Eric Sandeen wrote:
> Theodore Ts'o wrote:
> > Add an ioctl which forces all of the delay allocated blocks to be
> > allocated.  This also provides a function ext4_alloc_da_blocks() which
> > will be used by the following commits to force files to be fully
> > allocated to preserve application-expected ext3 behaviour.
> > 
> 
> Is it worth checking whether a) the file has delalloc blocks, and/or b)
> whether the mapping is dirty before we spin off a filemap_flush?
> 
+int ext4_alloc_da_blocks(struct inode *inode)
+{
+       if (!EXT4_I(inode)->i_reserved_data_blocks &&
+           !EXT4_I(inode)->i_reserved_meta_blocks)
+               return 0;

This check test does (a). Since the ioctl is to force allocation of
delayed allocated blocks i guess (a) is enough because we don't want to
cause a filemap_flush when we don't have any delayed allocated blocks
but have dirty pages around.

-aneesh
