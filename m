From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: A memory-leak problem of unix_open()
Date: Sun, 16 Dec 2012 20:20:52 -0500
Message-ID: <20121217012052.GA9130@thunk.org>
References: <CAPTn0cDC2r3upOb=PAdT_SDH3HbYmkL-Me69RUMU2hxLZjBM7g@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Li Xi <pkuelelixi@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:38800 "EHLO
	imap.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751397Ab2LQBU5 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sun, 16 Dec 2012 20:20:57 -0500
Content-Disposition: inline
In-Reply-To: <CAPTn0cDC2r3upOb=PAdT_SDH3HbYmkL-Me69RUMU2hxLZjBM7g@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Dec 17, 2012 at 12:34:56AM +0800, Li Xi wrote:
> I think I found a memory-leak problem of e2fsprofgs while using
> valgrind to testing a tool. 'log.txt' is the output. It is a simple
> problem. I wrote a patch, and it works on my server.

Thank you very much for reporting the problem!  While I was looking at
your patch, I found some some potential fd leaks that should also be
fixed.  This is what I have checked into the e2fsprogs tree.

Regards,

							- Ted

commit 4e0bb5eb745009decac4c5836671ff4bef21ce2a
Author: Theodore Ts'o <tytso@mit.edu>
Date:   Sun Dec 16 20:14:20 2012 -0500

    libext2fs: fix memory and fd leak in error path of unix_open()
    
    Fix a potential memory leak reported by Li Xi.  In addition, there
    were possible error cases where the file descriptor would not be
    properly closed, so fix those as well while we're at it.
    
    Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
    Reported-by:  Li Xi <pkuelelixi@gmail.com>

diff --git a/lib/ext2fs/unix_io.c b/lib/ext2fs/unix_io.c
index 02570f0..7371654 100644
--- a/lib/ext2fs/unix_io.c
+++ b/lib/ext2fs/unix_io.c
@@ -505,6 +505,7 @@ static errcode_t unix_open(const char *name, int flags, io_channel *channel)
 	memset(data, 0, sizeof(struct unix_private_data));
 	data->magic = EXT2_ET_MAGIC_UNIX_IO_CHANNEL;
 	data->io_stats.num_fields = 2;
+	data->dev = -1;
 
 	open_flags = (flags & IO_FLAG_RW) ? O_RDWR : O_RDONLY;
 	if (flags & IO_FLAG_EXCLUSIVE)
@@ -575,7 +576,6 @@ static errcode_t unix_open(const char *name, int flags, io_channel *channel)
 		/* Is the block device actually writable? */
 		error = ioctl(data->dev, BLKROGET, &readonly);
 		if (!error && readonly) {
-			close(data->dev);
 			retval = EPERM;
 			goto cleanup;
 		}
@@ -621,11 +621,17 @@ static errcode_t unix_open(const char *name, int flags, io_channel *channel)
 
 cleanup:
 	if (data) {
+		if (data->dev >= 0)
+			close(data->dev);
 		free_cache(data);
 		ext2fs_free_mem(&data);
 	}
-	if (io)
+	if (io) {
+		if (io->name) {
+			ext2fs_free_mem(&io->name);
+		}
 		ext2fs_free_mem(&io);
+	}
 	return retval;
 }
 
