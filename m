From: Mingming Cao <cmm@us.ibm.com>
Subject: Re: delayed allocatiou result in Oops
Date: Tue, 19 Jun 2007 09:23:49 -0700
Message-ID: <1182270229.4113.8.camel@dyn9047017103.beaverton.ibm.com>
References: <20070614072352.GA6517@localhost.sw.ru>
	 <4672202C.4080304@clusterfs.com>
	 <1181949368.3808.7.camel@dyn9047017103.beaverton.ibm.com>
	 <20070616081426.GB14349@localhost.sw.ru>
	 <1182214878.3711.21.camel@dyn9047017103.beaverton.ibm.com>
	 <46778186.9030306@clusterfs.com>
Reply-To: cmm@us.ibm.com
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Cc: Dmitriy Monakhov <dmonakhov@sw.ru>, linux-ext4@vger.kernel.org
To: Alex Tomas <alex@clusterfs.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e34.co.us.ibm.com ([32.97.110.152]:59052 "EHLO
	e34.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757987AbXFSQYB (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 19 Jun 2007 12:24:01 -0400
Received: from d03relay04.boulder.ibm.com (d03relay04.boulder.ibm.com [9.17.195.106])
	by e34.co.us.ibm.com (8.13.8/8.13.8) with ESMTP id l5JGNxdS009505
	for <linux-ext4@vger.kernel.org>; Tue, 19 Jun 2007 12:23:59 -0400
Received: from d03av01.boulder.ibm.com (d03av01.boulder.ibm.com [9.17.195.167])
	by d03relay04.boulder.ibm.com (8.13.8/8.13.8/NCO v8.3) with ESMTP id l5JGNwuM217914
	for <linux-ext4@vger.kernel.org>; Tue, 19 Jun 2007 10:23:58 -0600
Received: from d03av01.boulder.ibm.com (loopback [127.0.0.1])
	by d03av01.boulder.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id l5JGNw0F019214
	for <linux-ext4@vger.kernel.org>; Tue, 19 Jun 2007 10:23:58 -0600
In-Reply-To: <46778186.9030306@clusterfs.com>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Tue, 2007-06-19 at 11:11 +0400, Alex Tomas wrote:
> Mingming Cao wrote:
> >>From the comments it says the page->private is set to 1 to letting
> > commit_write know that it needs block reservation, but I don't see the
> > page->private value being checked in ext4_wb_commit_write(). Instead,
> > the PageMappedToDisk(page) flag is being checked.
> > 
> > Alex, can you clarify the use of page->private and PagePrivate flag
> > here? Do we still need the page->private for delayed allocation, with
> > PageBooked flag and PageMappedToDisk page flag?
> 
> sorry for confusion, we need PagePrivate so that truncate calls our
> ->invalidatepage(). in turn this call is needed to drop unused reservation.


One more question, do we still need page->private? I don't see page-
>private value being checked anywhere.  I see you cleared
PageMappedToDisk page flag at prepare_write, and checked
PageMappedToDisk in commit_write()...

Hmm, PageMappedToDisk is probably not sufficient enough for pagesize!
=blocksize. Is that the reason we need page->private to pass the
request?


> block_read_full_page() must not happen to pages being delayed allocated
> in the first place - it's uptodate by definition. I think the problem
> began when ext4_wb_commit_write() exited due to -ENOSPC but left not
> uptodate *and* with PG_private. then subsequent access to page turned to
> block_read_full_page() which relies on PG_private and meaningful private
> field. Dmitry, could you repeat the test with SetPagePrivate(page) moved
> to after that if() with ext4_wb_reserve_space_page(), please?
> 
> 
> as i'm here ... status update: I've been reworking delayed allocation
> patches to support blocksize < PAGE_CACHE_SIZE (and address akpm's request
> for more generic implementation). the patch isn't ready for review, but
> hopefully will be in few days.
> 

That's good to know, thanks for the update. So probably above error case
handling will be addressed in the new version? 

BTW, can you point me your latest and greatest mballoc patch? I am
trying to forward port and merge that patch to ext4 patch queue....


Thanks,


Mingming
> 
> thanks, Alex
> 
> 
