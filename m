From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: Re: [PATCH -V2] ext4: Drop mapped buffer_head check during
	page_mkwrite
Date: Mon, 31 Aug 2009 18:03:14 +0530
Message-ID: <20090831123313.GA21973@skywalker.linux.vnet.ibm.com>
References: <1251264196-31382-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com> <20090829022656.GK16732@mit.edu> <20090831063006.GA7711@skywalker.linux.vnet.ibm.com> <20090831122448.GG20822@mit.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: cmm@us.ibm.com, sandeen@redhat.com, linux-ext4@vger.kernel.org
To: Theodore Tso <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e28smtp04.in.ibm.com ([59.145.155.4]:58699 "EHLO
	e28smtp04.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751072AbZHaMdR (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 31 Aug 2009 08:33:17 -0400
Received: from d28relay03.in.ibm.com (d28relay03.in.ibm.com [9.184.220.60])
	by e28smtp04.in.ibm.com (8.14.3/8.13.1) with ESMTP id n7VCXGAs000443
	for <linux-ext4@vger.kernel.org>; Mon, 31 Aug 2009 18:03:16 +0530
Received: from d28av04.in.ibm.com (d28av04.in.ibm.com [9.184.220.66])
	by d28relay03.in.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id n7VCXGeH2547850
	for <linux-ext4@vger.kernel.org>; Mon, 31 Aug 2009 18:03:16 +0530
Received: from d28av04.in.ibm.com (loopback [127.0.0.1])
	by d28av04.in.ibm.com (8.14.3/8.13.1/NCO v10.0 AVout) with ESMTP id n7VCXF2m023877
	for <linux-ext4@vger.kernel.org>; Mon, 31 Aug 2009 22:33:15 +1000
Content-Disposition: inline
In-Reply-To: <20090831122448.GG20822@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Aug 31, 2009 at 08:24:48AM -0400, Theodore Tso wrote:
> On Mon, Aug 31, 2009 at 12:00:06PM +0530, Aneesh Kumar K.V wrote:
> > Below are the possibilities i looked at
> > 
> > a) mmap with no parallel write to the same offset. That would mean
> > we don't have attached buffer heads because nobody attach buffer
> > heads to the page.
> > 
> > b) mmap happening to the hole. The buffer heads are not mapped.
> > 
> > c) mmap with parallel write to the same offset. The parallel write
> > did attach mapped buffer heads to the same page. So we should find
> > all buffer heads mapped in the above case. 
> > 
> > if we will find buffer heads already be mapped in many workloads then
> > i guess it make sense to add page lock. It will also avoid the
> > journal_start that we do in write_begin. I will redo the patch
> 
> The usage case I was worried about is the one where we are mmap'ing an
> existing file (say, like an Oracle or DB2 table space, or a berkdb
> database file), and we are writing into already allocated blocks.  In
> that case (which does use these code paths, right?) the second time we
> write a particular page, the buffer heads will already be mapped.

If the database is not being updated via a write(2), then even though
the blocks are already allocated, we won't find buffer_heads attached to the page.

ie, page_buffers(page) will be NULL

The page_mkwrite -> write_begin  path would be allocating the buffer_heads
and attaching them to the page. So even in the above case we will be
doing write_begin -> write_end. That is, it is similar to the (a) i wrote
above.


> 
> For database applications where we aren't loading a table, but just
> making changes to an already instantiated table, the buffer heads
> would be mapped most of the time, would they not?
> 
> 					- Ted

-aneesh
