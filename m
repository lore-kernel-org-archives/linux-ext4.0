From: Theodore Tso <tytso@mit.edu>
Subject: Re: [PATCH -V2] ext4: Drop mapped buffer_head check during
	page_mkwrite
Date: Mon, 31 Aug 2009 08:50:25 -0400
Message-ID: <20090831125025.GI20822@mit.edu>
References: <1251264196-31382-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com> <20090829022656.GK16732@mit.edu> <20090831063006.GA7711@skywalker.linux.vnet.ibm.com> <20090831122448.GG20822@mit.edu> <20090831123313.GA21973@skywalker.linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: cmm@us.ibm.com, sandeen@redhat.com, linux-ext4@vger.kernel.org
To: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from THUNK.ORG ([69.25.196.29]:46941 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750718AbZHaMu0 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 31 Aug 2009 08:50:26 -0400
Content-Disposition: inline
In-Reply-To: <20090831123313.GA21973@skywalker.linux.vnet.ibm.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Aug 31, 2009 at 06:03:14PM +0530, Aneesh Kumar K.V wrote:
> If the database is not being updated via a write(2), then even though
> the blocks are already allocated, we won't find buffer_heads attached to the page.
> 
> ie, page_buffers(page) will be NULL
> 
> The page_mkwrite -> write_begin  path would be allocating the buffer_heads
> and attaching them to the page. So even in the above case we will be
> doing write_begin -> write_end. That is, it is similar to the (a) i wrote
> above.

What about the case where they are being updated via llseek(2) and
write(2)?  I'll grant that isn't as common these days (dbm used to do
it, but these days most people use berk_db, which does use mmap), but
it's not a totally unknown thing to do.  Certainly any of the
e2fsprogs tools operating on a filesystem-image-in-a-file (which isn't
that uncommon if you are using KVM or some other virtualization
situation) uses llseek(2) and write(2).  I'd have to check to see
whether KVM/qemu is using mmap(2) or write(2).

If we think when we update-in-place already allocated blocks, it's
much more common to use mmap(2) than lseek(2)/write(2), then I can see
how avoiding taking a page_lock in ext4_page_mkwrite() might be the
right choice.  On the other hand, if write(2) is more common, we'll be
starting and stopping a transaction handle, and going through a *much*
more complicated code path.

The other question I have then is that there are multiple
write_begin/write_end functions that could be used, if we are going to
be dropping this check in ext4_page_mkwrite() and depending in
write_begin/write_end to do the right thing.  (ext4_write_begin,
ext4_da_write_begin, ext4_ordered_write_end,
ext4_journalled_write_end, ext4_writeback_write_end).  You did check
all of the possible code path combinations, to make sure they will do
the right thing?

						- Ted
