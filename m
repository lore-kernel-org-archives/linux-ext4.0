From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: Re: [PATCH 03/11] vfs: Add better VFS support for page_mkwrite when
	blocksize < pagesize
Date: Thu, 28 May 2009 18:40:00 +0530
Message-ID: <20090528131000.GA7398@skywalker>
References: <1243429268-3028-1-git-send-email-jack@suse.cz> <1243429268-3028-4-git-send-email-jack@suse.cz> <20090528130341.GC14315@dhcp231-156.rdu.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Jan Kara <jack@suse.cz>, LKML <linux-kernel@vger.kernel.org>,
	npiggin@suse.de, linux-ext4@vger.kernel.org
To: Josef Bacik <josef@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e23smtp02.au.ibm.com ([202.81.31.144]:34375 "EHLO
	e23smtp02.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757068AbZE1NKT (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 28 May 2009 09:10:19 -0400
Content-Disposition: inline
In-Reply-To: <20090528130341.GC14315@dhcp231-156.rdu.redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, May 28, 2009 at 09:03:41AM -0400, Josef Bacik wrote:
> On Wed, May 27, 2009 at 03:01:00PM +0200, Jan Kara wrote:
> >
> 
> Sorry, another possibly braindead question.  When we extend the i_size you make
> it so that the page will be faulted the next time it's written to via
> page_mkclean, which from what I can tell is done via pte_wrprotect.  The problem
> with this is the next time we write to the page, we do pte_mkwrite, which makes
> it so that we won't fault the next time we write, correct?  So if I were to do
> 
> ftruncate(fd, 0);
> pwrite(fd, buf, 1024, 0);
> map = mmap(NULL, 4096, PROT_WRITE, MAP_SHARED, fd, 0);
> map[0] = 'a';
> ftruncate(fd, 10000);
> map[0] = 'b'; --> causes a page fault again


This will do block allocation for the entire page within i_size. (ie multiple blocks)
ext4_page_mkwrite have

size = i_size_read(..)
if (page->index == size >> PAGE_CACHE_SHIFT)
	len = size & ~PAGE_CACHE_MASK;
else
	len = PAGE_CACHE_SIZE;


> memset(map, 'a', 4096); --> wouldn't cause a pagefault
> writepage at some point
> 
> We'd still be in the position that you are trying to solve, correct, since we
> will have dirtied the rest of the page without calling mkwrite for the other
> sections of it, which would result in unallocated blocks when we hit writepage.
> Thanks,
> 

-aneesh
