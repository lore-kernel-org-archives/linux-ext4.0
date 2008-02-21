From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: Re: [PATCH -v2] ext4: Use page_mkwrite vma_operations to get mmap
	write notification.
Date: Fri, 22 Feb 2008 00:49:29 +0530
Message-ID: <20080221191929.GB8292@skywalker>
References: <1203392640-14335-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com> <1203615560.3750.8.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: tytso@mit.edu, linux-ext4@vger.kernel.org
To: Mingming Cao <cmm@us.ibm.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from E23SMTP02.au.ibm.com ([202.81.18.163]:58630 "EHLO
	e23smtp02.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752816AbYBUTTf (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 21 Feb 2008 14:19:35 -0500
Received: from sd0109e.au.ibm.com (d23rh905.au.ibm.com [202.81.18.225])
	by e23smtp02.au.ibm.com (8.13.1/8.13.1) with ESMTP id m1LJJlZH012410
	for <linux-ext4@vger.kernel.org>; Fri, 22 Feb 2008 06:19:47 +1100
Received: from d23av03.au.ibm.com (d23av03.au.ibm.com [9.190.234.97])
	by sd0109e.au.ibm.com (8.13.8/8.13.8/NCO v8.7) with ESMTP id m1LJNB09276750
	for <linux-ext4@vger.kernel.org>; Fri, 22 Feb 2008 06:23:11 +1100
Received: from d23av03.au.ibm.com (loopback [127.0.0.1])
	by d23av03.au.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id m1LJJbLf005910
	for <linux-ext4@vger.kernel.org>; Fri, 22 Feb 2008 06:19:37 +1100
Content-Disposition: inline
In-Reply-To: <1203615560.3750.8.camel@localhost.localdomain>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, Feb 21, 2008 at 09:39:20AM -0800, Mingming Cao wrote:
> On Tue, 2008-02-19 at 09:13 +0530, Aneesh Kumar K.V wrote:
> > We would like to get notified when we are doing a write on mmap section.
> > This is needed with respect to preallocated area. We split the preallocated
> > area into initialzed extent and uninitialzed extent in the call back. This
> > let us handle ENOSPC better. Otherwise we get ENOSPC in the writepage and
> > that would result in data loss. The changes are also needed to handle ENOSPC
> > when writing to an mmap section of files with holes.
> > 
> 
> Hi Aneesh,
> 
> I have a concern, it seems we missed journalling the allocation activity
> for the mmaped write. See comments below...
> 
> Another thing, perhaps similar patch should be ported to ext2/3, as this
> also addressed the mmaped write ENOSPC error without
> preallocation/deleyed allocation.
> 
> > Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>

......

> > +
> > +int ext4_page_mkwrite(struct vm_area_struct *vma, struct page *page)
> > +{
> > +	return block_page_mkwrite(vma, page, ext4_get_block);
> > +}
> > +
> 
> I don't see block allocation being journalled here. block_page_mkwrite()
> eventually calling block_prepare_write() which invokes ext4_get_block()
> without starting a new journal handle.
> 
> Perhaps call ext4 write_begin() and write_end() inode operations, that
> would taking care of different write_begin and write_end for three
> different journalling mode.
> 

You are correct. I missed the journalling details when working on the
patch. Will send the one with fix.


-aneesh
