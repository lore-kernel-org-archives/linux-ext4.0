From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: Re: [PATCH] ext4: Use page_mkwrite vma_operations to get mmap
	write notification.
Date: Fri, 22 Feb 2008 23:53:10 +0530
Message-ID: <20080222182310.GC6629@skywalker>
References: <1203691158-6788-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com> <1203703848.3639.9.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: tytso@mit.edu, linux-ext4@vger.kernel.org
To: Mingming Cao <cmm@us.ibm.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from E23SMTP04.au.ibm.com ([202.81.18.173]:49499 "EHLO
	e23smtp04.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756147AbYBVSXX (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 22 Feb 2008 13:23:23 -0500
Received: from d23relay03.au.ibm.com (d23relay03.au.ibm.com [202.81.18.234])
	by e23smtp04.au.ibm.com (8.13.1/8.13.1) with ESMTP id m1MIMxci005344
	for <linux-ext4@vger.kernel.org>; Sat, 23 Feb 2008 05:22:59 +1100
Received: from d23av04.au.ibm.com (d23av04.au.ibm.com [9.190.235.139])
	by d23relay03.au.ibm.com (8.13.8/8.13.8/NCO v8.7) with ESMTP id m1MINL561282244
	for <linux-ext4@vger.kernel.org>; Sat, 23 Feb 2008 05:23:21 +1100
Received: from d23av04.au.ibm.com (loopback [127.0.0.1])
	by d23av04.au.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id m1MINL5t021582
	for <linux-ext4@vger.kernel.org>; Sat, 23 Feb 2008 05:23:21 +1100
Content-Disposition: inline
In-Reply-To: <1203703848.3639.9.camel@localhost.localdomain>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, Feb 22, 2008 at 10:10:48AM -0800, Mingming Cao wrote:
> On Fri, 2008-02-22 at 20:09 +0530, Aneesh Kumar K.V wrote:

.....

> > +		ext4_journal_stop(handle);
> > +		goto out_unlock;
> > +	}
> > +	if (!ret && ext4_should_order_data(inode)) {
> > +		ret = walk_page_buffers(handle, page_buffers(page),
> > +					0, end, NULL, ext4_journal_dirty_data);
> > +	}
> > +	if (!ret)
> > +		ret = block_commit_write(page, 0, end);
> > +
> Hmm, it seems wired to do commit_write when the page is about becoming
> writable, but maybe that's the way it needs to?
> 
> Don't we need to update the i_size somewhere?

block_commit_write simply iterate over buffer_head of page and mark them
dirty. That is why we don't want to call that for data=journalled mode.

> 
> > +	ext4_journal_stop(handle);
> > +out_unlock:
> > +	unlock_page(page);
> > +	mutex_unlock(&inode->i_mutex);
> > +	return ret;
> > +}
> 
> It seems this combined the three journalling mode prepare_write() code
> here:( 
> 
> Since prepare_write() and commit_write() is going to sunset, why not
> simply calling mappings->a_ops->write_begin() and then write_end()? that
> should take care of pretty much the journalling and the page operations,
> no?

write_begin and write_end works with the user space buffer. In this case
we don't have one. Also what ext4_page_mkwrite does is mostly what
write_begin/write_end does except the copy of user space buffer.


-aneesh
