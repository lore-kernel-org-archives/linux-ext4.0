From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH v2 1/2] ext4: fix COLLAPSE_RANGE failure issue on ext4
 with 1KB block size
Date: Sat, 19 Apr 2014 16:36:41 -0400
Message-ID: <20140419203641.GC13492@thunk.org>
References: <000c01cf5b8a$e7dd2cc0$b7978640$@samsung.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4 <linux-ext4@vger.kernel.org>,
	=?utf-8?B?THVrw6HFoQ==?= Czerner <lczerner@redhat.com>
To: Namjae Jeon <namjae.jeon@samsung.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:50090 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751241AbaDSUgq (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sat, 19 Apr 2014 16:36:46 -0400
Content-Disposition: inline
In-Reply-To: <000c01cf5b8a$e7dd2cc0$b7978640$@samsung.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sat, Apr 19, 2014 at 01:50:37PM +0900, Namjae Jeon wrote:
> From: Namjae Jeon <namjae.jeon@samsung.com>
> 
> When formatting with 1KB or 2KB(not aligned with PAGE SIZE) block size,
> xfstests generic/075 and 091 are failing. The offset supplied to function
> truncate_pagecache_range is block size aligned. In this function start offset
> is re-aligned to PAGE_SIZE by rounding_up to the next page boundary.
> Due to this rounding up, old data remains in the page cache when blocksize is
> less than page size and start offset is not aligned with page size.
> In case of collapse range, we need to align start offset to page size boundary
> by doing a round down operation instead of round up.
> 
> Signed-off-by: Namjae Jeon <namjae.jeon@samsung.com>
> Signed-off-by: Ashish Sangwan <a.sangwan@samsung.com>

Thanks, applied.

						- Ted
