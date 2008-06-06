From: Mingming Cao <cmm@us.ibm.com>
Subject: Re: [PATCH -v2] ext4: Use inode preallocation with -o noextents
Date: Fri, 06 Jun 2008 14:33:12 -0700
Message-ID: <1212787992.22102.39.camel@localhost.localdomain>
References: <1211229262-11012-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
	 <20080604022356.GA7094@mit.edu> <20080604040101.GA22348@skywalker>
	 <20080605032220.GC10488@mit.edu> <20080605084329.GB8942@skywalker>
	 <1212677741.3645.44.camel@localhost.localdomain>
	 <20080605182455.GV2961@webber.adilger.int>
Reply-To: cmm@us.ibm.com
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Cc: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>,
	Theodore Tso <tytso@mit.edu>, sandeen@redhat.com,
	linux-ext4@vger.kernel.org
To: Andreas Dilger <adilger@sun.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e2.ny.us.ibm.com ([32.97.182.142]:35805 "EHLO e2.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933192AbYFFVdR (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 6 Jun 2008 17:33:17 -0400
Received: from d01relay02.pok.ibm.com (d01relay02.pok.ibm.com [9.56.227.234])
	by e2.ny.us.ibm.com (8.13.8/8.13.8) with ESMTP id m56LXEKn005405
	for <linux-ext4@vger.kernel.org>; Fri, 6 Jun 2008 17:33:14 -0400
Received: from d01av02.pok.ibm.com (d01av02.pok.ibm.com [9.56.224.216])
	by d01relay02.pok.ibm.com (8.13.8/8.13.8/NCO v9.0) with ESMTP id m56LXE9Q232838
	for <linux-ext4@vger.kernel.org>; Fri, 6 Jun 2008 17:33:14 -0400
Received: from d01av02.pok.ibm.com (loopback [127.0.0.1])
	by d01av02.pok.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id m56LXEKP010800
	for <linux-ext4@vger.kernel.org>; Fri, 6 Jun 2008 17:33:14 -0400
In-Reply-To: <20080605182455.GV2961@webber.adilger.int>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, 2008-06-05 at 12:24 -0600, Andreas Dilger wrote:
> On Jun 05, 2008  07:55 -0700, Mingming Cao wrote:
> > >  /**
> > > - * ext4_new_blocks_old() -- core block(s) allocation function
> > > + * ext4_orlov_new_blocks() -- core block(s) allocation function
> > 
> > what is orlov means? this is core function for non extent based without
> > mballoc block allocation, right? 
> 
> Orlov is the name of the INODE allocator, not the block allocator.  I'm
> not sure there is a name for the block allocator except "old" or "bitmap".

I think rename it as ext4_old_new_blocks() seems better, better than
orlov. This is the block allocator that is only used when mballoc is
turned off. I think we should update the function description.

> In the future I suspect we won't want to keep this version at all, using
> the mballoc allocator even for block-mapped files, but it is useful for
> now for performance comparisons.

In fact I found the mballoc is enabled even for block-mapped files. what
Aneesh's patch "Use inode preallocation with -o noextents" does is
enable the per-inode in-core preallocation for block allocation for
block-mapped files, whem mballoc is turned on. Without this patch, there
is not old ext3 block reservation(as mblloc turned off ext3 block
reservation automatically) and non in-core preallocation in the new
mballoc.

Anessh, Could you clarify this and update in the change log? 

> Cheers, Andreas
> --
> Andreas Dilger
> Sr. Staff Engineer, Lustre Group
> Sun Microsystems of Canada, Inc.
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

