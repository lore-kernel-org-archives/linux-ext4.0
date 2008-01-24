From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: Re: [PATCH 23/49] Add buffer head related helper functions
Date: Thu, 24 Jan 2008 10:52:27 +0530
Message-ID: <20080124052227.GA7902@skywalker>
References: <1200970948-17903-16-git-send-email-tytso@mit.edu> <1200970948-17903-17-git-send-email-tytso@mit.edu> <1200970948-17903-18-git-send-email-tytso@mit.edu> <1200970948-17903-19-git-send-email-tytso@mit.edu> <1200970948-17903-20-git-send-email-tytso@mit.edu> <1200970948-17903-21-git-send-email-tytso@mit.edu> <1200970948-17903-22-git-send-email-tytso@mit.edu> <1200970948-17903-23-git-send-email-tytso@mit.edu> <1200970948-17903-24-git-send-email-tytso@mit.edu> <20080123140648.788fbc49.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: "Theodore Ts'o" <tytso@MIT.EDU>, linux-kernel@vger.kernel.org,
	"linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e28smtp03.in.ibm.com ([59.145.155.3]:43649 "EHLO
	e28esmtp03.in.ibm.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750714AbYAXFWl (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 24 Jan 2008 00:22:41 -0500
Content-Disposition: inline
In-Reply-To: <20080123140648.788fbc49.akpm@linux-foundation.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, Jan 23, 2008 at 02:06:48PM -0800, Andrew Morton wrote:
> > On Mon, 21 Jan 2008 22:02:02 -0500 "Theodore Ts'o" <tytso@MIT.EDU> wrote:
> > +}
> > +EXPORT_SYMBOL(bh_uptodate_or_lock);
> > +/**
> 
> Missing newline.
> 
> > + * bh_submit_read: Submit a locked buffer for reading
> > + * @bh: struct buffer_head
> > + *
> > + * Returns a negative error
> > + */
> > +int bh_submit_read(struct buffer_head *bh)
> > +{
> > +	if (!buffer_locked(bh))
> > +		lock_buffer(bh);
> > +
> > +	if (buffer_uptodate(bh))
> > +		return 0;
> 
> Here it can lock the buffer then return zero
> 
> > +	get_bh(bh);
> > +	bh->b_end_io = end_buffer_read_sync;
> > +	submit_bh(READ, bh);
> > +	wait_on_buffer(bh);
> > +	if (buffer_uptodate(bh))
> > +		return 0;
> 
> Here it will unlock the buffer and return zero.
> 
> This function is unusable when passed an unlocked buffer.
> 

Updated patch below.

commit 70d4ca32604e0935a8b9a49c5ac8b9c64c810693
Author: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
Date:   Thu Jan 24 10:50:24 2008 +0530

    Add buffer head related helper functions
    
    Add buffer head related helper function bh_uptodate_or_lock and
    bh_submit_read which can be used by file system
    
    Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>

diff --git a/fs/buffer.c b/fs/buffer.c
index 7249e01..82aa2db 100644
--- a/fs/buffer.c
+++ b/fs/buffer.c
@@ -3213,6 +3213,53 @@ static int buffer_cpu_notify(struct notifier_block *self,
 	return NOTIFY_OK;
 }
 
+/**
+ * bh_uptodate_or_lock: Test whether the buffer is uptodate
+ * @bh: struct buffer_head
+ *
+ * Return true if the buffer is up-to-date and false,
+ * with the buffer locked, if not.
+ */
+int bh_uptodate_or_lock(struct buffer_head *bh)
+{
+	if (!buffer_uptodate(bh)) {
+		lock_buffer(bh);
+		if (!buffer_uptodate(bh))
+			return 0;
+		unlock_buffer(bh);
+	}
+	return 1;
+}
+EXPORT_SYMBOL(bh_uptodate_or_lock);
+
+/**
+ * bh_submit_read: Submit a locked buffer for reading
+ * @bh: struct buffer_head
+ *
+ * Returns zero on success and -EIO on error.If the input
+ * buffer is not locked returns -EINVAL
+ *
+ */
+int bh_submit_read(struct buffer_head *bh)
+{
+	if (!buffer_locked(bh))
+		return -EINVAL;
+
+	if (buffer_uptodate(bh)) {
+		unlock_buffer(bh);
+		return 0;
+	}
+
+	get_bh(bh);
+	bh->b_end_io = end_buffer_read_sync;
+	submit_bh(READ, bh);
+	wait_on_buffer(bh);
+	if (buffer_uptodate(bh))
+		return 0;
+	return -EIO;
+}
+EXPORT_SYMBOL(bh_submit_read);
+
 void __init buffer_init(void)
 {
 	int nrpages;
diff --git a/include/linux/buffer_head.h b/include/linux/buffer_head.h
index da0d83f..e98801f 100644
--- a/include/linux/buffer_head.h
+++ b/include/linux/buffer_head.h
@@ -192,6 +192,8 @@ int sync_dirty_buffer(struct buffer_head *bh);
 int submit_bh(int, struct buffer_head *);
 void write_boundary_block(struct block_device *bdev,
 			sector_t bblock, unsigned blocksize);
+int bh_uptodate_or_lock(struct buffer_head *bh);
+int bh_submit_read(struct buffer_head *bh);
 
 extern int buffer_heads_over_limit;
 
