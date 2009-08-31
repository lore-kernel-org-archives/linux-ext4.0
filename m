From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: Re: [PATCH -V2] ext4: Drop mapped buffer_head check during
	page_mkwrite
Date: Mon, 31 Aug 2009 12:00:06 +0530
Message-ID: <20090831063006.GA7711@skywalker.linux.vnet.ibm.com>
References: <1251264196-31382-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com> <20090829022656.GK16732@mit.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: cmm@us.ibm.com, sandeen@redhat.com, linux-ext4@vger.kernel.org
To: Theodore Tso <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e23smtp01.au.ibm.com ([202.81.31.143]:58084 "EHLO
	e23smtp01.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754445AbZHaGaP (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 31 Aug 2009 02:30:15 -0400
Received: from d23relay03.au.ibm.com (d23relay03.au.ibm.com [202.81.31.245])
	by e23smtp01.au.ibm.com (8.14.3/8.13.1) with ESMTP id n7V6T4BL030796
	for <linux-ext4@vger.kernel.org>; Mon, 31 Aug 2009 16:29:04 +1000
Received: from d23av01.au.ibm.com (d23av01.au.ibm.com [9.190.234.96])
	by d23relay03.au.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id n7V6UGjT1446114
	for <linux-ext4@vger.kernel.org>; Mon, 31 Aug 2009 16:30:16 +1000
Received: from d23av01.au.ibm.com (loopback [127.0.0.1])
	by d23av01.au.ibm.com (8.14.3/8.13.1/NCO v10.0 AVout) with ESMTP id n7V6UF9r027597
	for <linux-ext4@vger.kernel.org>; Mon, 31 Aug 2009 16:30:16 +1000
Content-Disposition: inline
In-Reply-To: <20090829022656.GK16732@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, Aug 28, 2009 at 10:26:56PM -0400, Theodore Tso wrote:
> On Wed, Aug 26, 2009 at 10:53:16AM +0530, Aneesh Kumar K.V wrote:
> > Inorder to check whether the buffer_heads are mapped we need
> > to hold page lock. Otherwise a reclaim can cleanup the attached
> > buffer_heads. Instead of taking page lock and check whether
> > buffer_heads are mapped we let the write_begin/write_end callback
> > does the equivalent. It does have a performance impact in that we
> > are doing more work if we the buffer_heads are already mapped.
> 
> So I started looking at all of the work that we need to do in
> write_begin/write_end; did you check both write paths depending on
> whether we are using delayed allocation or not?  It would seem to me
> that it might be better to use lock_page() and unlock_page() around
> the check, since in many work loads the buffer heads will already be
> mapped often, and it appears to me that write_begin() will end up
> locking the page anyway.
> 
> Am I missing something?
> 

Below are the possibilities i looked at

a) mmap with no parallel write to the same offset. That would mean
we don't have attached buffer heads because nobody attach buffer
heads to the page.

b) mmap happening to the hole. The buffer heads are not mapped.

c) mmap with parallel write to the same offset. The parallel write
did attach mapped buffer heads to the same page. So we should find
all buffer heads mapped in the above case. 

if we will find buffer heads already be mapped in many workloads then
i guess it make sense to add page lock. It will also avoid the
journal_start that we do in write_begin. I will redo the patch

-aneesh
