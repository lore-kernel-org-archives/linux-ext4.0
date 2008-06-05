From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: Re: [PATCH -v2] ext4: Use inode preallocation with -o noextents
Date: Fri, 6 Jun 2008 00:16:16 +0530
Message-ID: <20080605184616.GA4723@skywalker>
References: <1211229262-11012-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com> <20080604022356.GA7094@mit.edu> <20080604040101.GA22348@skywalker> <20080605032220.GC10488@mit.edu> <20080605084329.GB8942@skywalker> <1212677741.3645.44.camel@localhost.localdomain> <20080605182455.GV2961@webber.adilger.int>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Mingming Cao <cmm@us.ibm.com>, Theodore Tso <tytso@mit.edu>,
	sandeen@redhat.com, linux-ext4@vger.kernel.org
To: Andreas Dilger <adilger@sun.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from E23SMTP06.au.ibm.com ([202.81.18.175]:37187 "EHLO
	e23smtp06.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752941AbYFESqp (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 5 Jun 2008 14:46:45 -0400
Received: from sd0109e.au.ibm.com (d23rh905.au.ibm.com [202.81.18.225])
	by e23smtp06.au.ibm.com (8.13.1/8.13.1) with ESMTP id m55IkDhe031948
	for <linux-ext4@vger.kernel.org>; Fri, 6 Jun 2008 04:46:13 +1000
Received: from d23av04.au.ibm.com (d23av04.au.ibm.com [9.190.235.139])
	by sd0109e.au.ibm.com (8.13.8/8.13.8/NCO v8.7) with ESMTP id m55Ior4T242488
	for <linux-ext4@vger.kernel.org>; Fri, 6 Jun 2008 04:50:53 +1000
Received: from d23av04.au.ibm.com (loopback [127.0.0.1])
	by d23av04.au.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id m55IkgtY015265
	for <linux-ext4@vger.kernel.org>; Fri, 6 Jun 2008 04:46:42 +1000
Content-Disposition: inline
In-Reply-To: <20080605182455.GV2961@webber.adilger.int>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, Jun 05, 2008 at 12:24:55PM -0600, Andreas Dilger wrote:
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

What do you suggest to rename it as ?  I actually got the name from
http://lwn.net/Articles/14633/. But since the old allocator the block
location depends more closely on where the inodes are place i guess we
can name even the block as orlov allocator.


> In the future I suspect we won't want to keep this version at all, using
> the mballoc allocator even for block-mapped files, but it is useful for
> now for performance comparisons.
> 

The patch which is marked in the subject is exactly doing that.


-aneesh
