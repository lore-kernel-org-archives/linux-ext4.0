From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: Re: BUG with delayed allocation
Date: Thu, 20 Mar 2008 23:26:25 +0530
Message-ID: <20080320175625.GA6931@skywalker>
References: <20080319085235.GA6752@skywalker> <1205974018.3637.9.camel@localhost.localdomain> <20080320053902.GD6967@skywalker> <1206034190.3637.25.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Eric Sandeen <sandeen@redhat.com>,
	ext4 <linux-ext4@vger.kernel.org>
To: Mingming Cao <cmm@us.ibm.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from E23SMTP06.au.ibm.com ([202.81.18.175]:47782 "EHLO
	e23smtp06.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755409AbYCTR4e (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 20 Mar 2008 13:56:34 -0400
Received: from d23relay03.au.ibm.com (d23relay03.au.ibm.com [202.81.18.234])
	by e23smtp06.au.ibm.com (8.13.1/8.13.1) with ESMTP id m2KHuFFK031665
	for <linux-ext4@vger.kernel.org>; Fri, 21 Mar 2008 04:56:15 +1100
Received: from d23av04.au.ibm.com (d23av04.au.ibm.com [9.190.235.139])
	by d23relay03.au.ibm.com (8.13.8/8.13.8/NCO v8.7) with ESMTP id m2KHuWFq3141832
	for <linux-ext4@vger.kernel.org>; Fri, 21 Mar 2008 04:56:32 +1100
Received: from d23av04.au.ibm.com (loopback [127.0.0.1])
	by d23av04.au.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id m2KHuWSo022376
	for <linux-ext4@vger.kernel.org>; Fri, 21 Mar 2008 04:56:32 +1100
Content-Disposition: inline
In-Reply-To: <1206034190.3637.25.camel@localhost.localdomain>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, Mar 20, 2008 at 10:29:50AM -0700, Mingming Cao wrote:
> On Thu, 2008-03-20 at 11:09 +0530, Aneesh Kumar K.V wrote:
> 
> > > Could you try the following patch? It updates the i_disksize at the
> > > write_end time.
> > > 
> > 
> > I will test the patch and update you. BTW shouldn't we update
> > i_disksize only after actual block got allocated ?
> > 
> > 
> Hmm...I am not  100% sure but I think we should not to change the
> behavior that the on-disk inode size should be updated when write()
> returns to user. Right now the in-memory inode size is updated, user
> would expecting the same when they run e2fsck, but e2fsck reads inode
> size from disk. Pushing the inode i_disksize update at the writeout
> (allocation) time will cause the window that i_size is different than
> the i_disksize being enlarged quite big.
> 

If we are updating i_disksize during write_end and if we crash before actually
allocating the blocks e2fsck will find errors because the inode doesn't
really have that many blocks right ?


-aneesh
