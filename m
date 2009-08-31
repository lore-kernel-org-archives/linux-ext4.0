From: Theodore Tso <tytso@mit.edu>
Subject: Re: [PATCH -V2] ext4: Drop mapped buffer_head check during
	page_mkwrite
Date: Mon, 31 Aug 2009 08:24:48 -0400
Message-ID: <20090831122448.GG20822@mit.edu>
References: <1251264196-31382-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com> <20090829022656.GK16732@mit.edu> <20090831063006.GA7711@skywalker.linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: cmm@us.ibm.com, sandeen@redhat.com, linux-ext4@vger.kernel.org
To: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from THUNK.ORG ([69.25.196.29]:40348 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752287AbZHaMYu (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 31 Aug 2009 08:24:50 -0400
Content-Disposition: inline
In-Reply-To: <20090831063006.GA7711@skywalker.linux.vnet.ibm.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Aug 31, 2009 at 12:00:06PM +0530, Aneesh Kumar K.V wrote:
> Below are the possibilities i looked at
> 
> a) mmap with no parallel write to the same offset. That would mean
> we don't have attached buffer heads because nobody attach buffer
> heads to the page.
> 
> b) mmap happening to the hole. The buffer heads are not mapped.
> 
> c) mmap with parallel write to the same offset. The parallel write
> did attach mapped buffer heads to the same page. So we should find
> all buffer heads mapped in the above case. 
> 
> if we will find buffer heads already be mapped in many workloads then
> i guess it make sense to add page lock. It will also avoid the
> journal_start that we do in write_begin. I will redo the patch

The usage case I was worried about is the one where we are mmap'ing an
existing file (say, like an Oracle or DB2 table space, or a berkdb
database file), and we are writing into already allocated blocks.  In
that case (which does use these code paths, right?) the second time we
write a particular page, the buffer heads will already be mapped.

For database applications where we aren't loading a table, but just
making changes to an already instantiated table, the buffer heads
would be mapped most of the time, would they not?

					- Ted
