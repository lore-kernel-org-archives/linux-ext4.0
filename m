From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: Re: [RFC PATCH] ext4: Fix the locking with respect to ext3 to ext4
	migrate.
Date: Fri, 7 Mar 2008 17:01:06 +0530
Message-ID: <20080307113106.GA9896@skywalker>
References: <1204887184-9902-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com> <1204888653.3627.37.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: tytso@mit.edu, sandeen@redhat.com, linux-ext4@vger.kernel.org
To: Mingming Cao <cmm@us.ibm.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from E23SMTP02.au.ibm.com ([202.81.18.163]:36112 "EHLO
	e23smtp02.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757307AbYCGLbM (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 7 Mar 2008 06:31:12 -0500
Received: from sd0109e.au.ibm.com (d23rh905.au.ibm.com [202.81.18.225])
	by e23smtp02.au.ibm.com (8.13.1/8.13.1) with ESMTP id m27BVK2h017543
	for <linux-ext4@vger.kernel.org>; Fri, 7 Mar 2008 22:31:20 +1100
Received: from d23av02.au.ibm.com (d23av02.au.ibm.com [9.190.235.138])
	by sd0109e.au.ibm.com (8.13.8/8.13.8/NCO v8.7) with ESMTP id m27BYoAW278966
	for <linux-ext4@vger.kernel.org>; Fri, 7 Mar 2008 22:34:50 +1100
Received: from d23av02.au.ibm.com (loopback [127.0.0.1])
	by d23av02.au.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id m27BV9jF003946
	for <linux-ext4@vger.kernel.org>; Fri, 7 Mar 2008 22:31:09 +1100
Content-Disposition: inline
In-Reply-To: <1204888653.3627.37.camel@localhost.localdomain>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, Mar 07, 2008 at 03:17:33AM -0800, Mingming Cao wrote:
> On Fri, 2008-03-07 at 16:23 +0530, Aneesh Kumar K.V wrote:
> Hi Aneesh,
> 
> >  static int init_inodecache(void)
> > diff --git a/include/linux/ext4_fs_i.h b/include/linux/ext4_fs_i.h
> > index d5508d3..96c0b4f 100644
> > --- a/include/linux/ext4_fs_i.h
> > +++ b/include/linux/ext4_fs_i.h
> > @@ -162,6 +162,18 @@ struct ext4_inode_info {
> >  	/* mballoc */
> >  	struct list_head i_prealloc_list;
> >  	spinlock_t i_prealloc_lock;
> > +
> > +	/* When doing migrate we need to ensure that the i_data field
> > +	 * doesn't change. With respect to write and truncate we can ensure
> > +	 * the same by taking inode->i_mutex. But a write to mmap area
> > +	 * mapping holes doesn't take i_mutex since it doesn't change the
> > +	 * i_size. We also can't take i_data_sem because we would like to
> > +	 * extend/restart the journal and locking order prevents us from
> > +	 * restarting journal within i_data_sem. 
> 
> How about we start a journal with estimated worse case transaction
> credits  and then take the i_data_sem down? So that we could ensure that
> whenever the i_data_sem is hold, the i_data is protected. That is what
> currently DIO does, I think. It would be nice to avoid introducing
> another semaphore to protect i_data for migration if we could.
> 


Estimating transaction for a single page directIO write may be easy. But
in case of migrate it involves new blocks allocated to carry the extents
and also we free the indirect blocks of ext3 and that would involve
update of bitmap from different groups. I am not sure we will be able to
come up with a value. But if yes and if we can get that many credits
from journal i agree that would be better than introducing a new
semaphore.


> > This will be taken in
> > +	 * page_mkwrite in the read mode and migrate will take it in the
> > +	 * write mode.
> > +	 */
> > +	struct rw_semaphore i_migrate_sem;
> >  };
> > 
> >  #endif	/* _LINUX_EXT4_FS_I */
> 
> Mingming
> 
