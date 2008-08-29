From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: Re: [PATCH] ext3: truncate block allocated on a failed
	ext3_write_begin
Date: Fri, 29 Aug 2008 15:21:15 +0530
Message-ID: <20080829095115.GD6447@skywalker>
References: <1219944473-8770-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com> <1219944473-8770-2-git-send-email-aneesh.kumar@linux.vnet.ibm.com> <m33akoi5kb.fsf@dmon-lap.sw.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: cmm@us.ibm.com, tytso@mit.edu, sandeen@redhat.com,
	linux-ext4@vger.kernel.org
To: Dmitri Monakhov <dmonakhov@openvz.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e28smtp04.in.ibm.com ([59.145.155.4]:53645 "EHLO
	e28esmtp04.in.ibm.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752091AbYH2JvY (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 29 Aug 2008 05:51:24 -0400
Received: from d28relay02.in.ibm.com (d28relay02.in.ibm.com [9.184.220.59])
	by e28esmtp04.in.ibm.com (8.13.1/8.13.1) with ESMTP id m7T9pLFm010769
	for <linux-ext4@vger.kernel.org>; Fri, 29 Aug 2008 15:21:21 +0530
Received: from d28av01.in.ibm.com (d28av01.in.ibm.com [9.184.220.63])
	by d28relay02.in.ibm.com (8.13.8/8.13.8/NCO v9.0) with ESMTP id m7T9pLNA721048
	for <linux-ext4@vger.kernel.org>; Fri, 29 Aug 2008 15:21:21 +0530
Received: from d28av01.in.ibm.com (loopback [127.0.0.1])
	by d28av01.in.ibm.com (8.13.1/8.13.3) with ESMTP id m7T9pKG8023397
	for <linux-ext4@vger.kernel.org>; Fri, 29 Aug 2008 15:21:21 +0530
Content-Disposition: inline
In-Reply-To: <m33akoi5kb.fsf@dmon-lap.sw.ru>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, Aug 29, 2008 at 12:33:24PM +0400, Dmitri Monakhov wrote:
> "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com> writes:
> 
> > For blocksize < pagesize we need to remove blocks that
> > got allocte in block_wirte_begin if we fail with ENOSPC
> > for later blocks. block_write_begin internally does
> > this if it allocated page locally. This make sure
> > we don't have blocks outisde inode.i_size during
> > ENOSPC
> BTW why this check was moved from generic_XXX_write to fs speciffic code?


Not quite sure what you mean by that ? block_write_begin generic
code already does the vmtruncate if it had allocated page locally.
ext3/4 allocate/grab_cache_page  in write_begin and pass the page
pointer to block_write_begin. That implies block_write_begin
won't do the truncate. So we have to do it in filesystem write_begin.
also we have to do it after unlocking the page.


> >
> > Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
> > ---
> >  fs/ext3/inode.c |    7 +++++++
> >  1 files changed, 7 insertions(+), 0 deletions(-)
> >
> > diff --git a/fs/ext3/inode.c b/fs/ext3/inode.c
> > index ebfec4d..f8424ad 100644
> > --- a/fs/ext3/inode.c
> > +++ b/fs/ext3/inode.c
> > @@ -1186,6 +1186,13 @@ static int ext3_write_begin(struct file *file, struct address_space *mapping,
> >  		ext3_journal_stop(handle);
> >  		unlock_page(page);
> >  		page_cache_release(page);
> > +		/*
> > +		 * block_write_begin may have instantiated a few blocks
> > +		 * outside i_size.  Trim these off again. Don't need
> > +		 * i_size_read because we hold i_mutex.
> > +		 */
> > +		if (pos + len > inode->i_size)
> > +			vmtruncate(inode, inode->i_size);
> >  	}
> >  	if (ret == -ENOSPC && ext3_should_retry_alloc(inode->i_sb, &retries))
> >  		goto retry;
> > -- 
> > 1.6.0.1.90.g27a6e
> >
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
