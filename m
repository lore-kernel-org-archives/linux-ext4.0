From: Mingming Cao <cmm@us.ibm.com>
Subject: Re: Ordered mode rewrite for jbd2/ext4
Date: Wed, 04 Jun 2008 19:40:36 -0700
Message-ID: <1212633637.3645.15.camel@localhost.localdomain>
References: <20080604154435.GE16572@duck.suse.cz>
Reply-To: cmm@us.ibm.com
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Cc: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>,
	linux-ext4@vger.kernel.org
To: Jan Kara <jack@suse.cz>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e36.co.us.ibm.com ([32.97.110.154]:54309 "EHLO
	e36.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750942AbYFECkn (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 4 Jun 2008 22:40:43 -0400
Received: from d03relay04.boulder.ibm.com (d03relay04.boulder.ibm.com [9.17.195.106])
	by e36.co.us.ibm.com (8.13.8/8.13.8) with ESMTP id m552eg5E012370
	for <linux-ext4@vger.kernel.org>; Wed, 4 Jun 2008 22:40:42 -0400
Received: from d03av02.boulder.ibm.com (d03av02.boulder.ibm.com [9.17.195.168])
	by d03relay04.boulder.ibm.com (8.13.8/8.13.8/NCO v8.7) with ESMTP id m552egBU099162
	for <linux-ext4@vger.kernel.org>; Wed, 4 Jun 2008 20:40:42 -0600
Received: from d03av02.boulder.ibm.com (loopback [127.0.0.1])
	by d03av02.boulder.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id m552efwP026005
	for <linux-ext4@vger.kernel.org>; Wed, 4 Jun 2008 20:40:42 -0600
In-Reply-To: <20080604154435.GE16572@duck.suse.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, 2008-06-04 at 17:44 +0200, Jan Kara wrote:
>   Hi,
> 
>   So I've split and ported ordered mode rewrite for ext4+jbd2.
> The core of the rewrite are two patches
> 
> jbd2-Implement-data-ordered-mode-handling-via-inode.patch
> ext4-Use-new-framework-for-data-ordered-mode-in-JBD.patch
> 
> They also need two trivial fixes:
> vfs-export-filemap_fdatawrite_range.patch
> ext4-Use-new-framework-for-data-ordered-mode-in-JBD.patch
> 
> And finally there's a patch removing old ordered mode from jbd2:
> jbd2-Remove-data-ordered-mode-support-using-jbd-buf.patch
> 
> I've created the patches to be added to the ext4 patch queue just
> after inversion of page lock and transaction start.
> 
> I have refreshed the following patches in the ext4 queue to apply cleanly
> and also fixed some typos in them and added one BUG_ON():
> 
> ext4-delalloc-sync-hang-with-journal-lock-inverse-fix.patch
> ext4-delalloc-inverse-jbd-and-page-lock-ordering.patch
> ext4-inverse-jbd-and-page-locking-order.patch
> 
> Finally, I've rewritten checks in writepage so
> ext4-Add-validation-to-jbd-lock-inversion-patch-and.patch
> should be replaced with
> ext4-add-checks-to-writepage
> 
> as we spoke about it with Aneesh.
> 
> All the patches are attached and I'll also post the new ones separately for
> more convenient review. The tests for 4k blocksize run fine for me. The
> kernel oopses for 1k blocksize because of a problem in ext4_page_mkwrite()
> - I'll post that in a separate mail. If noone objects, patches can be added
> to ext4 patch queue.
> 

Thanks!

I have added the patches to the patch queue, will take a close look
later.


Regards,
Mingming
> 								Honza

