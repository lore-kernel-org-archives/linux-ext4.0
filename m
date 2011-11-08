From: Curt Wohlgemuth <curtw@google.com>
Subject: Bug with "fix partial page writes"
Date: Tue, 8 Nov 2011 14:59:52 -0800
Message-ID: <CAO81RMa4uRsOsaK4G78EDvOenJpEdTp4y+rtkiDxaK9cASbMtA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: Hugh Dickins <hughd@google.com>
To: Allison Henderson <achender@linux.vnet.ibm.com>,
	ext4 development <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-qy0-f174.google.com ([209.85.216.174]:59098 "EHLO
	mail-qy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753606Ab1KHW7x (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 8 Nov 2011 17:59:53 -0500
Received: by qyk27 with SMTP id 27so4270900qyk.19
        for <linux-ext4@vger.kernel.org>; Tue, 08 Nov 2011 14:59:52 -0800 (PST)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

It appears that there's a bug with this patch:

-------------------------------------------
commit 02fac1297eb3f471a27368271aadd285548297b0
Author: Allison Henderson <achender@linux.vnet.ibm.com>
Date:   Tue Sep 6 21:53:01 2011 -0400

    ext4: fix partial page writes
...
-------------------------------------------

Hugh Dickens found a bug with some nasty testing and lockdep that
crashed in ext4_da_write_end(), and after looking at the code with
him, it appears that the call to
ext4_discard_partial_page_buffers_no_lock() in this routine is
manipulating an unlocked, and possibly non-existent page:


-------------------------------------------
...
	ret2 = generic_write_end(file, mapping, pos, len, copied,
							page, fsdata);

	page_len = PAGE_CACHE_SIZE -
			((pos + copied - 1) & (PAGE_CACHE_SIZE - 1));

	if (page_len > 0) {
		ret = ext4_discard_partial_page_buffers_no_lock(handle,
			inode, page, pos + copied - 1, page_len,
			EXT4_DISCARD_PARTIAL_PG_ZERO_UNMAPPED);
	}
...
-------------------------------------------

Note that generic_write_end() will unlock and release the page before
it returns.

I've no good answer for how to fix this properly, but I wanted to let
Allison know about this, if she hadn't already.  I looked but didn't
see any related email on the linux-ext4 list for this problem.

Thanks,
Curt
