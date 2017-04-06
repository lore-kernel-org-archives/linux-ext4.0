From: Jeff Layton <jlayton@redhat.com>
Subject: Re: [RFC PATCH 0/4] fs: introduce new writeback error tracking
 infrastructure and convert ext4 to use it
Date: Thu, 06 Apr 2017 15:14:52 -0400
Message-ID: <1491506092.9621.2.camel@redhat.com>
References: <1491215318.2724.3.camel@redhat.com>
         <20170403143257.GA30811@bombadil.infradead.org>
         <1491241657.2673.10.camel@redhat.com>
         <20170403191602.GF30811@bombadil.infradead.org>
         <1491250577.2673.20.camel@redhat.com>
         <87h924kh6t.fsf@notabene.neil.brown.name>
         <20170404115358.GH30811@bombadil.infradead.org>
         <1491308268.20445.4.camel@redhat.com>
         <20170404161247.GJ30811@bombadil.infradead.org>
         <1491323146.309.1.camel@redhat.com>
         <20170404170909.GK30811@bombadil.infradead.org>
         <1491421792.18658.20.camel@redhat.com>
         <87efx6tnbr.fsf@notabene.neil.brown.name>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-ext4@vger.kernel.org, akpm@linux-foundation.org,
        tytso@mit.edu, jack@suse.cz
To: NeilBrown <neilb@suse.com>, Matthew Wilcox <willy@infradead.org>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <87efx6tnbr.fsf@notabene.neil.brown.name>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Thu, 2017-04-06 at 10:02 +1000, NeilBrown wrote:
> > 

> On Thu, Apr 06 2017, Jeff Layton wrote:
> 
> > On Tue, 2017-04-04 at 10:09 -0700, Matthew Wilcox wrote:
> > > On Tue, Apr 04, 2017 at 12:25:46PM -0400, Jeff Layton wrote:
> > > > That said, I think giving more specific errors where we can is useful.
> > > > When your program is erroring out and writing 'I/O error' to the logs,
> > > > then how much time will your admins burn before they figure out that it
> > > > really failed because the filesystem was full?
> > > 
> > > df is one of the first things I check ... a few years ago, I also learned
> > > to check df -i ... ;-)
> > > 
> > > Anyway, given the decision to simply report the last error lets us do this
> > > implementation:
> > > 
> > > void filemap_set_wb_error(struct address_space *mapping, int err)
> > > {
> > > 	struct inode *inode = mapping->host;
> > > 	unsigned int wb_err;
> > > 
> > > 	if (!err)
> > > 		return;
> > > 	/*
> > > 	 * This should be called with the error code that we want to return
> > > 	 * on fsync. Thus, it should always be <= 0.
> > > 	 */
> > > 	WARN_ON(err > 0 || err < -MAX_ERRNO);
> > > 
> > > 	spin_lock(&inode->i_lock);
> > > 	wb_err = ((mapping->wb_err & ~MAX_ERRNO) + (1 << 12)) | -err;
> > > 	WRITE_ONCE(mapping->wb_err, wb_err);
> > > 	spin_unlock(&inode->i_lock);
> > > }
> > > 
> > 
> > I like this idea of being able to store arbitrary error codes there.
> > That should be used judiciously of course, but we already allow
> > returning arbitrary errors via the ->fsync op anyway.
> > 
> > I'll plan to incorporate something like that into the next set (with
> > judicious comments and constants).
> > 
> > One question...is the i_lock the right way to protect this? I think we
> > could do this locklessly too (cmpxchg in a loop, for instance). I'm not
> > worried about performance here -- it's just nice to be able to call
> > simple stuff like this without worrying about locking.
> 
> I like the idea of using cmpxchg.
> 
> 
> > 
> > > int filemap_report_wb_error(struct file *file)
> > > {
> > > 	struct inode *inode = file_inode(file);
> > > 	unsigned int wb_err = READ_ONCE(mapping->wb_err);
> > > 
> > > 	if (file->f_wb_err == wb_err)
> > > 		return 0;
> > > 	return -(wb_err & 4095);
> > > }
> > > 
> > > That only gives us 20 bits of counter, but I think that's enough.
> > 
> > 2^20 is 1048576, which seems a little small to me.
> > 
> > We may end up bumping the counter on every failed I/O. How fast can we
> > generate 1M failed I/Os? :)
> 
> Do we need to count all of those if no-one sees them?
> i.e. use one bit to say "this error hasn't been seen".
> If an error occurs with has the name error code as is currently stored,
> and the bit is set, don't make a change.  Otherwise make the change,
> inc the counter, set the bit.
> When checking for an error, if the bit is set, clear it first.
> Then you can count 500,000 errors-returned-to-some-thread, which is
> probably enough.
> 

Ok, so here's a replacement for patch #1. The other 3 are pretty much
the same. The main changes are:

- 32 bit value:
  - 12 bits for error code
  - 1 bit for "seen" flag
  - 19 bits for the counter
- mapping->wb_err is managed with cmpxchg
- file->f_wb_err is protected with file->f_lock

I tried to avoid updating things unnecesssarily. I could use some
guidance on how to specify the constants in terms of MAX_ERRNO as well.

It seems to work, in very basic by-hand testing.

If this looks reasonable, I may try again to plug this in at a higher
level, so we don't need to change so much filesystem code. IOW:

- make filemap_set_wb_error the new implementation of mapping_set_error
- have vfs_fsync_range call filemap_report_wb_error, and return what it
  returns if it's non-zero
- have filemap_check_error grab the current error code without updating
  the counter or the seen flag

That approach may not work, but I'll see. Anyway, here's the updated
patch. I may need to revise the changelog too.

--------------------------8<---------------------

[PATCH] fs: new infrastructure for writeback error handling and reporting

Most filesystems currently use mapping_set_error and
filemap_check_errors for setting and reporting/clearing writeback errors
at the mapping level. filemap_check_errors is indirectly called from
most of the filemap_fdatawait_* functions and from
filemap_write_and_wait*. These functions are called from all sorts of
contexts to wait on writeback to finish -- e.g. mostly in fsync, but
also in truncate calls, getattr, etc.

It's those non-fsync callers that are problematic. We should be
reporting writeback errors during fsync, but many places in the code
clear out errors before they can be properly reported, or report errors
at nonsensical times. If I get -EIO on a stat() call, how do I know that
was because writeback failed?

This patch adds a small bit of new infrastructure for setting and
reporting errors during pagecache writeback. While the above was my
original impetus for adding this, I think it's also the case that
current fsync semantics are just problematic for userland. Most
applications that call fsync do so to ensure that the data they wrote
has hit the backing store.

In the case where there are multiple writers to the file at the same
time, this is really hard to determine. The first one to call fsync will
see any stored error, and the rest get back 0. The processes with open
fd may not be associated with one another in any way. They could even be
in different containers, so ensuring coordination between all fsync
callers is not really an option.

One way to remedy this would be to track what file descriptor was used
to dirty the file, but that's rather cumbersome and would likely be
slow. However, there is a simpler way to improve the semantics here
without incurring too much overhead.

This set adds a wb_error field and a sequence counter to the
address_space, and a corresponding sequence counter in the struct file.
When errors are reported during writeback, we set the error field in the
mapping and increment the sequence counter.

When fsync or flush is called, we check the sequence in the file vs. the
one in the mapping. If the file's counter is behind the one in the
mapping, then we update the sequence counter in the file to the value of
the one in the mapping and report the error. If the file is "caught up"
then we just report 0.

This changes the semantics of fsync such that applications can now use
it to determine whether there were any writeback errors since fsync(fd)
was last called (or since the file was opened in the case of fsync
having never been called).

Note that those writeback errors may have occurred when writing data
that was dirtied via an entirely different fd, but that's the case now
with the current mapping_set_error/filemap_check_error infrastructure.
This will at least prevent you from getting a false report of success.

The basic idea here is for filesystems to use filemap_set_wb_error to
set the error in the mapping when there are writeback errors, and then
have the fsync and flush operations call filemap_report_wb_error just
before returning to ensure that those errors get reported properly.

Eventually, it may make sense to move the reporting into the generic
vfs_fsync_range helper, but doing it this way for now makes it simpler
to convert filesystems to the new API individually.

Signed-off-by: Jeff Layton <jlayton@redhat.com>
---
 Documentation/filesystems/vfs.txt |  14 +++-
 fs/open.c                         |   3 +
 include/linux/fs.h                |   4 +
 mm/filemap.c                      | 162 ++++++++++++++++++++++++++++++++++++++
 4 files changed, 181 insertions(+), 2 deletions(-)

diff --git a/Documentation/filesystems/vfs.txt b/Documentation/filesystems/vfs.txt
index 569211703721..b2b5e411b340 100644
--- a/Documentation/filesystems/vfs.txt
+++ b/Documentation/filesystems/vfs.txt
@@ -577,6 +577,11 @@ should clear PG_Dirty and set PG_Writeback.  It can be actually
 written at any point after PG_Dirty is clear.  Once it is known to be
 safe, PG_Writeback is cleared.
 
+If there is an error during writeback, then the address_space should be
+marked with an error (typically using filemap_set_wb_error), in order to
+ensure that the error can later be reported to the application at fsync
+or close.
+
 Writeback makes use of a writeback_control structure...
 
 struct address_space_operations
@@ -885,11 +890,16 @@ otherwise noted.
 	"private_data" member in the file structure if you want to point
 	to a device structure
 
-  flush: called by the close(2) system call to flush a file
+  flush: called by the close(2) system call to flush a file. Writeback
+	errors not previously reported via fsync should be reported
+	here as you would for fsync.
 
   release: called when the last reference to an open file is closed
 
-  fsync: called by the fsync(2) system call
+  fsync: called by the fsync(2) system call. Filesystems that use the
+	pagecache should call filemap_report_wb_error before returning
+	to ensure that any errors that occurred during writeback are
+	reported and the file's error sequence advanced.
 
   fasync: called by the fcntl(2) system call when asynchronous
 	(non-blocking) mode is enabled for a file
diff --git a/fs/open.c b/fs/open.c
index 949cef29c3bb..baf82f2c642e 100644
--- a/fs/open.c
+++ b/fs/open.c
@@ -709,6 +709,9 @@ static int do_dentry_open(struct file *f,
 	f->f_inode = inode;
 	f->f_mapping = inode->i_mapping;
 
+	/* Ensure that we skip any errors that predate opening of the file */
+	f->f_wb_err = READ_ONCE(inode->i_mapping->wb_err);
+
 	if (unlikely(f->f_flags & O_PATH)) {
 		f->f_mode = FMODE_PATH;
 		f->f_op = &empty_fops;
diff --git a/include/linux/fs.h b/include/linux/fs.h
index 7251f7bb45e8..f33857113ff4 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -394,6 +394,7 @@ struct address_space {
 	gfp_t			gfp_mask;	/* implicit gfp mask for allocations */
 	struct list_head	private_list;	/* ditto */
 	void			*private_data;	/* ditto */
+	u32			wb_err;
 } __attribute__((aligned(sizeof(long))));
 	/*
 	 * On most architectures that alignment is already the case; but
@@ -868,6 +869,7 @@ struct file {
 	struct list_head	f_tfile_llink;
 #endif /* #ifdef CONFIG_EPOLL */
 	struct address_space	*f_mapping;
+	u32			f_wb_err;
 } __attribute__((aligned(4)));	/* lest something weird decides that 2 is OK */
 
 struct file_handle {
@@ -2521,6 +2523,8 @@ extern int __filemap_fdatawrite_range(struct address_space *mapping,
 extern int filemap_fdatawrite_range(struct address_space *mapping,
 				loff_t start, loff_t end);
 extern int filemap_check_errors(struct address_space *mapping);
+extern void filemap_set_wb_error(struct address_space *mapping, int err);
+extern int filemap_report_wb_error(struct file *file);
 
 extern int vfs_fsync_range(struct file *file, loff_t start, loff_t end,
 			   int datasync);
diff --git a/mm/filemap.c b/mm/filemap.c
index 1694623a6289..60b6fa417b98 100644
--- a/mm/filemap.c
+++ b/mm/filemap.c
@@ -545,6 +545,168 @@ int filemap_write_and_wait_range(struct address_space *mapping,
 }
 EXPORT_SYMBOL(filemap_write_and_wait_range);
 
+/*
+ * The wb_err field in the address_space provides a place to store writeback
+ * errors. We endeavor to deliver writeback errors to fsync on all open file
+ * descriptors that were open at the time that the error was caught. We do
+ * this using a 32-bit value to store the error, with the upper bits as a
+ * sequence counter. We can store any error up to MAX_ERROR.
+ *
+ * Additionally, we reserve one bit to indicate whether any fd has grabbed the
+ * value to record in its struct file. If nothing has, then we don't really
+ * need to increment the counter.
+ */
+
+/* This bit is used as a flag to indicate whether the value has been seen */
+#define WB_ERR_SEEN		(1 << 12)
+
+/* Increment the counter by this much to ensure that we don't touch earlier
+ * values */
+#define WB_ERR_CTR_INC		(1 << 13)
+
+/**
+ * filemap_set_wb_error - set the wb error in the mapping for later reporting
+ * @mapping: mapping in which the error should be set
+ * @err: error to set. must be negative value but not less than -MAX_ERRNO
+ *
+ * When an error occurs during writeback of inode data, we must report that
+ * error during fsync. This function sets the writeback error field in the
+ * mapping, and increments the sequence counter. When fsync or close is later
+ * performed, the caller can then check the sequence in the mapping against
+ * the one in the file to determine whether the error should be reported.
+ *
+ * Because there are so few bits for the counter, we try to avoid incrementing
+ * it unless someone is going to record the value for later comparison. This
+ * is tracked by a bit in the 32 bit word that we use as a "seen" flag.
+ *
+ * Note that we always use the latest writeback error, since POSIX states
+ * that when there are multiple errors (e.g. -EIO followed by -ENOSPC),
+ * that any possible error may be returned.
+ */
+void filemap_set_wb_error(struct address_space *mapping, int err)
+{
+	u32 old;
+
+	/*
+	 * The above constants rely indirectly on MAX_ERRNO not changing
+	 * since I'm not sure how to take a log at build time. Suggestions
+	 * of better ways to phrase the flag values would be welcome.
+	 */
+	BUILD_BUG_ON(MAX_ERRNO + 1 != WB_ERR_SEEN);
+
+	/* Optimize for common case of no error */
+	if (likely(!err))
+		return;
+
+	/*
+	 * Ensure the error code actually fits where we want it to go. If it
+	 * doesn't then just throw a warning and don't record anything.
+	 */
+	if (unlikely(err > 0 || err < -MAX_ERRNO)) {
+		WARN(1, "err=%d\n", err);
+		return;
+	}
+
+	old = READ_ONCE(mapping->wb_err);
+	for (;;) {
+		u32 new, cur;
+
+		/* Clear out error bits and set new error */
+		new = (old & ~MAX_ERRNO) | -err;
+
+		/* Only increment if someone has looked at it */
+		if (old & WB_ERR_SEEN) {
+			new += WB_ERR_CTR_INC;
+			new &= ~WB_ERR_SEEN;
+		}
+
+		/* Try to swap the new value into place */
+		cur = cmpxchg(&mapping->wb_err, old, new);
+
+		/*
+		 * Call it success if we did the swap or someone else beat us
+		 * to it for the same value.
+		 */
+		if (likely(cur == old || cur == new))
+			break;
+
+		/* Raced with an update, try again */
+		old = cur;
+	}
+}
+EXPORT_SYMBOL(filemap_set_wb_error);
+
+/**
+ * filemap_report_wb_error - report wb error (if any) that was previously set
+ * @file: struct file on which the error is being reported
+ *
+ * When userland calls fsync or close (or something like nfsd does the
+ * equivalent), we want to report any writeback errors that occurred since
+ * the last fsync (or since the file was opened if there haven't been any).
+ *
+ * Grab the wb_err from the mapping. If it matches what we have in the file,
+ * then just quickly return 0. The file is all caught up.
+ *
+ * If it doesn't match, then take the mapping value, set the "seen" flag in
+ * it and try to swap it into place. If it works, or another task beat us
+ * to it with the new value, then update the f_wb_err and return the error
+ * portion. The error at this point _should_ be reported to userland.
+ *
+ * While we handle mapping->wb_err with atomic operations, the f_wb_err
+ * value is protected by the f_lock since we must ensure that it reflects
+ * the latest value swapped in for this file descriptor.
+ */
+int filemap_report_wb_error(struct file *file)
+{
+	int err = 0;
+	struct address_space *mapping = file->f_mapping;
+	u32 old;
+
+	old = READ_ONCE(mapping->wb_err);
+
+	/*
+	 * This catches the common case of no errors, and the case where
+	 * nothing has changed since we last checked.
+	 */
+	if (old == READ_ONCE(file->f_wb_err))
+		goto out;
+
+	spin_lock(&file->f_lock);
+	for (;;) {
+		u32 cur, new;
+
+		/*
+		 * We always store values with the "seen" bit set, so if this
+		 * matches what we already have, then we can call it done.
+		 * There is nothing to update so just return 0.
+		 */
+		if (old == file->f_wb_err)
+			break;
+
+		/* set flag and try to swap it into place */
+		new = old | WB_ERR_SEEN;
+		cur = cmpxchg(&mapping->wb_err, old, new);
+
+		/*
+		 * We can quit now if we successfully swapped in the new value
+		 * or someone else beat us to it with the same value that we
+		 * were planning to store.
+		 */
+		if (likely(cur == old || cur == new)) {
+			file->f_wb_err = new;
+			err = -(new & MAX_ERRNO);
+			break;
+		}
+
+		/* Raced with an update, try again */
+		old = cur;
+	}
+	spin_unlock(&file->f_lock);
+out:
+	return err;
+}
+EXPORT_SYMBOL(filemap_report_wb_error);
+
 /**
  * replace_page_cache_page - replace a pagecache page with a new one
  * @old:	page to be replaced
-- 
2.9.3
