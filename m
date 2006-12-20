From: "Amit K. Arora" <aarora@linux.vnet.ibm.com>
Subject: Re: [RFC][Patch 1/2] Persistent preallocation in ext4
Date: Wed, 20 Dec 2006 11:58:42 +0530
Message-ID: <20061220062842.GA2988@amitarora.in.ibm.com>
References: <20061205134338.GA1894@amitarora.in.ibm.com> <20061206055822.GA6182@amitarora.in.ibm.com> <20061215123528.GA24572@amitarora.in.ibm.com> <20061219110521.GA1435@amitarora.in.ibm.com> <20061219211206.GO5937@schatzie.adilger.int>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e35.co.us.ibm.com ([32.97.110.153]:38063 "EHLO
	e35.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964910AbWLTG2p (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 20 Dec 2006 01:28:45 -0500
Received: from westrelay02.boulder.ibm.com (westrelay02.boulder.ibm.com [9.17.195.11])
	by e35.co.us.ibm.com (8.13.8/8.12.11) with ESMTP id kBK6Sioo005552
	for <linux-ext4@vger.kernel.org>; Wed, 20 Dec 2006 01:28:44 -0500
Received: from d03av03.boulder.ibm.com (d03av03.boulder.ibm.com [9.17.195.169])
	by westrelay02.boulder.ibm.com (8.13.6/8.13.6/NCO v8.1.1) with ESMTP id kBK6Sixk545308
	for <linux-ext4@vger.kernel.org>; Tue, 19 Dec 2006 23:28:44 -0700
Received: from d03av03.boulder.ibm.com (loopback [127.0.0.1])
	by d03av03.boulder.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id kBK6SiBk025625
	for <linux-ext4@vger.kernel.org>; Tue, 19 Dec 2006 23:28:44 -0700
To: Andreas Dilger <adilger@clusterfs.com>
Content-Disposition: inline
In-Reply-To: <20061219211206.GO5937@schatzie.adilger.int>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Tue, Dec 19, 2006 at 02:12:06PM -0700, Andreas Dilger wrote:
> Minor edits (not worth a resubmit by itself):

Thanks, Andreas ! I will take care of these comments in the next
submission.

Regards,
Amit Arora
> 
> On Dec 19, 2006  16:35 +0530, Amit K. Arora wrote:
> > +		/* ext4_can_extents_be_merged should have checked that either
> > +		 * both extents are uninitialized, or both aren't. Thus we
> > +		 * need to check any of them here.
> 
> s/any/only one/
> 
> >
> > +	case EXT4_IOC_PREALLOCATE: {
> > +		if (IS_RDONLY(inode))
> > +			return -EROFS;
> > +
> > +		if (copy_from_user(&input,
> > +			(struct ext4_falloc_input __user *) arg, sizeof(input)))
> > +			return -EFAULT;
> > +
> > +		if (input.len == 0)
> > +			return -EINVAL;
> > +
> > +		if (!(EXT4_I(inode)->i_flags & EXT4_EXTENTS_FL))
> > +			return -ENOTTY;
> 
> May as well put this check before copy_from_user(), since it doesn't need
> the user data and is much faster to check first.
> 
> > +retry:
> > +		ret = 0;
> > +		while(ret>=0 && ret<max_blocks)
> > +		{
> 
> Opening brace always on same line, like "while() {"
> 
> > +		if (ret == -ENOSPC && ext4_should_retry_alloc(inode->i_sb,
> > +						&retries))
> 
> &retries should be aligned with start of (inode->i_sb, on previous line.
> 
> > +		if(nblocks) {
> 
> Space between "if (" everywhere.
> 
> Cheers, Andreas
> --
> Andreas Dilger
> Principal Software Engineer
> Cluster File Systems, Inc.
