From: Alex Tomas <alex@clusterfs.com>
Subject: Re: delayed allocatiou result in Oops
Date: Tue, 19 Jun 2007 11:11:02 +0400
Message-ID: <46778186.9030306@clusterfs.com>
References: <20070614072352.GA6517@localhost.sw.ru>	 <4672202C.4080304@clusterfs.com>	 <1181949368.3808.7.camel@dyn9047017103.beaverton.ibm.com>	 <20070616081426.GB14349@localhost.sw.ru> <1182214878.3711.21.camel@dyn9047017103.beaverton.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Dmitriy Monakhov <dmonakhov@sw.ru>, linux-ext4@vger.kernel.org
To: cmm@us.ibm.com
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.chehov.net ([80.71.245.247]:61180 "EHLO mail.rialcom.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753785AbXFSHLW (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 19 Jun 2007 03:11:22 -0400
In-Reply-To: <1182214878.3711.21.camel@dyn9047017103.beaverton.ibm.com>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Mingming Cao wrote:
>>From the comments it says the page->private is set to 1 to letting
> commit_write know that it needs block reservation, but I don't see the
> page->private value being checked in ext4_wb_commit_write(). Instead,
> the PageMappedToDisk(page) flag is being checked.
> 
> Alex, can you clarify the use of page->private and PagePrivate flag
> here? Do we still need the page->private for delayed allocation, with
> PageBooked flag and PageMappedToDisk page flag?

sorry for confusion, we need PagePrivate so that truncate calls our
->invalidatepage(). in turn this call is needed to drop unused reservation.

block_read_full_page() must not happen to pages being delayed allocated
in the first place - it's uptodate by definition. I think the problem
began when ext4_wb_commit_write() exited due to -ENOSPC but left not
uptodate *and* with PG_private. then subsequent access to page turned to
block_read_full_page() which relies on PG_private and meaningful private
field. Dmitry, could you repeat the test with SetPagePrivate(page) moved
to after that if() with ext4_wb_reserve_space_page(), please?


as i'm here ... status update: I've been reworking delayed allocation
patches to support blocksize < PAGE_CACHE_SIZE (and address akpm's request
for more generic implementation). the patch isn't ready for review, but
hopefully will be in few days.


thanks, Alex
