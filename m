From: Steven Whitehouse <swhiteho@redhat.com>
Subject: [RFC] [PATCH] Fix race when checking i_size on direct i/o read
Date: Thu, 16 Jan 2014 15:35:53 +0000
Message-ID: <1389886553.2779.32.camel@menhir>
References: <1387273422.2729.13.camel@menhir>
	 <20131217111626.GA7544@gmail.com> <1387282664.2729.42.camel@menhir>
	 <20131217164159.GA7331@gmail.com> <1387456073.2763.20.camel@menhir>
	 <20131219224400.GC31386@dastard> <1387531724.2739.13.camel@menhir>
	 <20131223030006.GD3220@dastard> <1389712933.2790.31.camel@menhir>
	 <20140114191901.GC27863@quack.suse.cz>  <20140115071933.GA3449@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Cc: Jan Kara <jack@suse.cz>, Dave Chinner <david@fromorbit.com>,
	linux-fsdevel@vger.kernel.org,
	Christoph Hellwig <hch@infradead.org>,
	Dmitry Monakhov <dmonakhov@openvz.org>,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	Zheng Liu <wenqing.lz@taobao.com>,
	Lukas Czerner <lczerner@redhat.com>,
	Miklos Szeredi <miklos@szeredi.hu>, linux-ext4@vger.kernel.org,
	Chris Mason <clm@fb.com>, Josef Bacik <jbacik@fb.com>
To: Zheng Liu <gnehzuil.liu@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:24686 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751883AbaAPP5q (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 16 Jan 2014 10:57:46 -0500
In-Reply-To: <20140115071933.GA3449@gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


Following on from the "Re: [PATCH v3] vfs: fix a bug when we do some dio
reads with append dio writes" thread on linux-fsdevel, this patch is my
current version of the fix proposed as option (b) in that thread.

Removing the i_size test from the direct i/o read path at VFS level
means that filesystems now have to deal with requests which are beyond
i_size themselves. These I've divided into three sets:

 a) Those with "no op" ->direct_IO (9p, cifs, ceph)
These are obviously not going to be an issue

 b) Those with "home brew" ->direct_IO (nfs, fuse)
I've been told that NFS should not have any problem with the larger
i_size, however I've added an extra test to FUSE to duplicate the
original behaviour just to be on the safe side. Someone who knows fuse
better maybe able to confirm whether this is actually required or not.

 c) Those using __blockdev_direct_IO()
These call through to ->get_block() which should deal with the EOF
condition correctly. I've verified that with GFS2 and I believe that
Zheng has verified it for ext4. I've also run the test on XFS and it
passes both before and after this change.

The part of the patch in filemap.c looks a lot larger than it really is
- there are only two lines of real change. The rest is just indentation
of the contained code.

There remains a test of i_size though, which was added for btrfs. It
doesn't cause the other filesystems a problem as the test is performed
after ->direct_IO has been called. It is possible that there is a race
that does matter to btrfs, however this patch doesn't change that, so
its still an overall improvement.

So please have a look at this and let me know what you think. I guess
that when time comes to submit it, it should probably be via the vfs
tree.

Signed-off-by: Steven Whitehouse <swhiteho@redhat.com>
Reported-by: Zheng Liu <gnehzuil.liu@gmail.com>
Cc: Jan Kara <jack@suse.cz>
Cc: Dave Chinner <david@fromorbit.com>
Cc: Miklos Szeredi <miklos@szeredi.hu>
Cc: Chris Mason <clm@fb.com>
Cc: Josef Bacik <jbacik@fb.com>
Cc: Christoph Hellwig <hch@infradead.org>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>

diff --git a/fs/fuse/file.c b/fs/fuse/file.c
index 7e70506..89fdfd1 100644
--- a/fs/fuse/file.c
+++ b/fs/fuse/file.c
@@ -2710,6 +2710,9 @@ fuse_direct_IO(int rw, struct kiocb *iocb, const struct iovec *iov,
 	inode = file->f_mapping->host;
 	i_size = i_size_read(inode);
 
+	if ((rw == READ) && (offset > i_size))
+		return 0;
+
 	/* optimization for short read */
 	if (async_dio && rw != WRITE && offset + count > i_size) {
 		if (offset >= i_size)
diff --git a/mm/filemap.c b/mm/filemap.c
index b7749a9..0184286 100644
--- a/mm/filemap.c
+++ b/mm/filemap.c
@@ -1428,30 +1428,28 @@ generic_file_aio_read(struct kiocb *iocb, const struct iovec *iov,
 		if (!count)
 			goto out; /* skip atime */
 		size = i_size_read(inode);
-		if (pos < size) {
-			retval = filemap_write_and_wait_range(mapping, pos,
+		retval = filemap_write_and_wait_range(mapping, pos,
 					pos + iov_length(iov, nr_segs) - 1);
-			if (!retval) {
-				retval = mapping->a_ops->direct_IO(READ, iocb,
-							iov, pos, nr_segs);
-			}
-			if (retval > 0) {
-				*ppos = pos + retval;
-				count -= retval;
-			}
+		if (!retval) {
+			retval = mapping->a_ops->direct_IO(READ, iocb,
+							   iov, pos, nr_segs);
+		}
+		if (retval > 0) {
+			*ppos = pos + retval;
+			count -= retval;
+		}
 
-			/*
-			 * Btrfs can have a short DIO read if we encounter
-			 * compressed extents, so if there was an error, or if
-			 * we've already read everything we wanted to, or if
-			 * there was a short read because we hit EOF, go ahead
-			 * and return.  Otherwise fallthrough to buffered io for
-			 * the rest of the read.
-			 */
-			if (retval < 0 || !count || *ppos >= size) {
-				file_accessed(filp);
-				goto out;
-			}
+		/*
+		 * Btrfs can have a short DIO read if we encounter
+		 * compressed extents, so if there was an error, or if
+		 * we've already read everything we wanted to, or if
+		 * there was a short read because we hit EOF, go ahead
+		 * and return.  Otherwise fallthrough to buffered io for
+		 * the rest of the read.
+		 */
+		if (retval < 0 || !count || *ppos >= size) {
+			file_accessed(filp);
+			goto out;
 		}
 	}
 


