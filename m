From: Theodore Ts'o <tytso@mit.edu>
Subject: [PATCH] [regression] fix 32-bit breakage in block device read(2)
Date: Mon, 23 Jun 2014 11:41:54 -0400
Message-ID: <20140623154154.GA29952@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:53435 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753980AbaFWPl5 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 23 Jun 2014 11:41:57 -0400
Content-Disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Here's the patch that I mentioned on today's concall.  The patch isn't
in 3.16-rc2, but it's needed if you want to run xfstests on 32-bit
kernels on 3.16-rc1 or 3.16-rc2 without seeing massive failures.

	   	       			- Ted


>From 71c73fb0fc61fa569d961b8f5ba21bf5597fc3f1 Mon Sep 17 00:00:00 2001
From: Al Viro <viro@ZenIV.linux.org.uk>
Date: Mon, 23 Jun 2014 11:31:36 -0400
Subject: [PATCH] [regression] fix 32-bit breakage in block device read(2)

blkdev_read_iter() wants to cap the iov_iter by the amount of
data remaining to the end of device.  That's what iov_iter_truncate()
is for (trim iter->count if it's above the given limit).  So far,
so good, but the argument of iov_iter_truncate() is size_t, so on
32bit boxen (in case of a large device) we end up with that upper
limit truncated down to 32 bits *before* comparing it with iter->count.

Easily fixed by making iov_iter_truncate() take 64bit argument -
it does the right thing after such change (we only reach the
assignment in there when the current value of iter->count is greater
than the limit, i.e. for anything that would get truncated we don't
reach the assignment at all) and that argument is not the new
value of iter->count - it's an upper limit for such.

The overhead of passing u64 is not an issue - the thing is inlined,
so callers passing size_t won't pay any penalty.

Reported-by: Theodore Tso <tytso@mit.edu>
Tested-by: Theodore Tso <tytso@mit.edu>
Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
---
 include/linux/uio.h | 14 +++++++++++++-
 1 file changed, 13 insertions(+), 1 deletion(-)

diff --git a/include/linux/uio.h b/include/linux/uio.h
index e2231e4..d54985e 100644
--- a/include/linux/uio.h
+++ b/include/linux/uio.h
@@ -94,8 +94,20 @@ static inline size_t iov_iter_count(struct iov_iter *i)
 	return i->count;
 }
 
-static inline void iov_iter_truncate(struct iov_iter *i, size_t count)
+/*
+ * Cap the iov_iter by given limit; note that the second argument is
+ * *not* the new size - it's upper limit for such.  Passing it a value
+ * greater than the amount of data in iov_iter is fine - it'll just do
+ * nothing in that case.
+ */
+static inline void iov_iter_truncate(struct iov_iter *i, u64 count)
 {
+	/*
+	 * count doesn't have to fit in size_t - comparison extends both
+	 * operands to u64 here and any value that would be truncated by
+	 * conversion in assignement is by definition greater than all
+	 * values of size_t, including old i->count.
+	 */
 	if (i->count > count)
 		i->count = count;
 }
-- 
2.0.0

