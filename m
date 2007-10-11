From: "Vladimir V. Saveliev" <vs@clusterfs.com>
Subject: Re: Threaded readahead strawman
Date: Thu, 11 Oct 2007 20:41:14 +0300
Message-ID: <470E603A.2080203@clusterfs.com>
References: <70b6f0bf0710102009k1c8732f5n7bb07c37fbc38e0b@mail.gmail.com> <20071011052736.GF8122@schatzie.adilger.int>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------000904040505000901070100"
Cc: Valerie Henson <val.henson@gmail.com>,
	Theodore Ts'o <tytso@mit.edu>, Ric Wheeler <ric@emc.com>,
	linux-ext4 <linux-ext4@vger.kernel.org>
To: Andreas Dilger <adilger@clusterfs.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.clusterfs.com ([74.0.229.162]:37329 "EHLO
	mail.clusterfs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751857AbXJKQgz (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 11 Oct 2007 12:36:55 -0400
Received: from py-out-1112.google.com (py-out-1112.google.com [64.233.166.177])
	by mail.clusterfs.com (Postfix) with ESMTP id BBF4D4E46C8
	for <linux-ext4@vger.kernel.org>; Thu, 11 Oct 2007 10:36:51 -0600 (MDT)
Received: by py-out-1112.google.com with SMTP id d32so2091123pye
        for <linux-ext4@vger.kernel.org>; Thu, 11 Oct 2007 09:36:51 -0700 (PDT)
In-Reply-To: <20071011052736.GF8122@schatzie.adilger.int>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

This is a multi-part message in MIME format.
--------------000904040505000901070100
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit

Hello

Andreas Dilger wrote:
> On Oct 10, 2007  20:09 -0700, Valerie Henson wrote:
>> I need to get started on a mergeable version of the threaded readahead
>> patch for e2fsck.  I intend for it to be compatible with Andreas'
>> sys_readahead() for block devices that support it.  Here's a first
>> draft proposal - your thoughts?  Note that it's not really that
>> anything is being read *ahead* per se, but that it's being read
>> simultaneously.  Single-threaded readahead doesn't go any faster.
> 
> We've been fiddling with this as well.  I'd attach some patches but
> bugzilla is down as I write this :(.  I also asked Vladimir (working on
> these patches) to forward them to you and the linux-ext4 mailing list.
> 

The patch is attached.

If an application can foresee what it is going to read in future - it
can call io_channel_readahead for those data forehand. Even if
io_channel_readahead is called right before the data are actually needed
- it may make positive effect for multi disk devices because of parallel
reading.

For example, using io_channel_readahead to readahead coming inode tables
in done_group callback of ext2_inode_scan changes inode table scan in my
local quick test from 34 seconds to 26 (on 2 two ide disk raid0)

> We added a "readahead" method to the io_manager interface (no-op for
> Win/DOS) that can be used generically.  This is currently done via
> posix_fadvise(POSIX_FADV_WILLNEED).  We haven't done any multi-threading
> yet, but there is some hope that the block layer could sort it out?
> It would still be beneficial to have multiple user-space threads do
> the reading of the data, to get parallel memcpy() into userspace.
> 
>> The major global parameters to the system are:
>>
>> 1. Optimal number of concurrent requests - number of underlying read
>> heads times some N of best number of outstanding requests.  Default to
>> one.
>>
>> 2. Stripe size, or more generally which areas can be read concurrently
>> and which cannot.
> 
> There are new parameters in the superblock (s_raid_stride and
> s_raid_stripe_width) but as yet only s_raid_stride is initialized by
> mke2fs.  There is a library in xfstools (libdisk or somesuch) that
> can get a lot more disk geometry info and it would be good to leverage
> that for mke2fs also.
> 
>> 3. Maximum memory to use.  We have to keep the readahead from
>> outrunning the actual processing (though so far, that hasn't been a
>> problem) and having bits of our buffer cache kicked out before they
>> are used.  This can be set to some percentage of available memory by
>> default.
> 
> Agreed.  I'd proposed in the past that fsck could call fsck.{fstype}
> with a parameter like --expected-memory to determine the expected memory
> usage of fsck.{fstype} based on the filesystem geometry, and it could
> also supply --max-memory so we don't have parallel fscks stomping on
> each other.
> 
>> I see two main ways to do this: One is a straightforward offset plus
>> size, telling it what to read.  The other is to make libext2 do all
>> the interpretation of ondisk format, and design the interface in terms
>> of kinds of metadata to read.  Given that libext2 functions like
>> ext2fs_get_next_inode_full() should be aware of what's going on in
>> readahead.  This argues for a metadata aware, in-library
>> implementation.  Something like:
>>
>> /* Creates the threads, sets some variables.  Returns a handle. */
>> handle = ext2fs_readahead_init(concurrent_requests, stripe_size, max_memory);
>>
>> /* Readahead inode tables and inode indirect blocks - can't really be
>> separated */
>> ext2fs_readahead_inodes(handle, fs);
> 
> Well, there's something to be said for allowing the inode tables and
> corresponding bitmaps to be read in a single shot.  Also, not all users
> require the indirect blocks, so I would make that an option.
> 
>> /* Read the directory block list (pass 2) */
>> ext2fs_readahead_dblist(handle, fs);
> 
> We're working on this as part of e2scan (in bug 13108 above), not sure if
> there is a patch available or not.
> 
>> /* Read bitmaps (pass 5) */
>> ext2fs_readahead_bitmaps(handle, fs);
> 
> This is a big one, because of the many seeks for small data read.  Using
> the FLEX_BG feature (which is really a tiny kernel patch) could improve
> this many times.
> 
> Cheers, Andreas
> --
> Andreas Dilger
> Principal Software Engineer
> Cluster File Systems, Inc.
> 
> 


--------------000904040505000901070100
Content-Type: text/x-patch;
 name="e2fsprogs-add-io_channel_readahead.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="e2fsprogs-add-io_channel_readahead.patch"

This patch adds a "readahead" method to the io_manager interface

Signed-off-by: Vladimir V. Saveliev vs@clusterfs.com

Index: e2fsprogs-1.40.2/lib/ext2fs/ext2_io.h
===================================================================
--- e2fsprogs-1.40.2.orig/lib/ext2fs/ext2_io.h
+++ e2fsprogs-1.40.2/lib/ext2fs/ext2_io.h
@@ -68,6 +68,8 @@ struct struct_io_manager {
 	errcode_t (*set_blksize)(io_channel channel, int blksize);
 	errcode_t (*read_blk)(io_channel channel, unsigned long block,
 			      int count, void *data);
+	errcode_t (*readahead)(io_channel channel, unsigned long block,
+			       int count);
 	errcode_t (*write_blk)(io_channel channel, unsigned long block,
 			       int count, const void *data);
 	errcode_t (*flush)(io_channel channel);
@@ -89,6 +91,7 @@ struct struct_io_manager {
 #define io_channel_close(c) 		((c)->manager->close((c)))
 #define io_channel_set_blksize(c,s)	((c)->manager->set_blksize((c),s))
 #define io_channel_read_blk(c,b,n,d)	((c)->manager->read_blk((c),b,n,d))
+#define io_channel_readahead(c,b,n)	((c)->manager->readahead((c),b,n))
 #define io_channel_write_blk(c,b,n,d)	((c)->manager->write_blk((c),b,n,d))
 #define io_channel_flush(c) 		((c)->manager->flush((c)))
 #define io_channel_bumpcount(c)		((c)->refcount++)
@@ -99,6 +102,8 @@ extern errcode_t io_channel_set_options(
 extern errcode_t io_channel_write_byte(io_channel channel, 
 				       unsigned long offset,
 				       int count, const void *data);
+extern errcode_t readahead_noop(io_channel channel, unsigned long block,
+				int count);
 
 /* unix_io.c */
 extern io_manager unix_io_manager;
Index: e2fsprogs-1.40.2/lib/ext2fs/unix_io.c
===================================================================
--- e2fsprogs-1.40.2.orig/lib/ext2fs/unix_io.c
+++ e2fsprogs-1.40.2/lib/ext2fs/unix_io.c
@@ -15,6 +15,8 @@
  * %End-Header%
  */
 
+#define _XOPEN_SOURCE 600
+#define _FILE_OFFSET_BITS 64
 #define _LARGEFILE_SOURCE
 #define _LARGEFILE64_SOURCE
 
@@ -78,6 +80,8 @@ static errcode_t unix_close(io_channel c
 static errcode_t unix_set_blksize(io_channel channel, int blksize);
 static errcode_t unix_read_blk(io_channel channel, unsigned long block,
 			       int count, void *data);
+static errcode_t unix_readahead(io_channel channel, unsigned long block,
+				int count);
 static errcode_t unix_write_blk(io_channel channel, unsigned long block,
 				int count, const void *data);
 static errcode_t unix_flush(io_channel channel);
@@ -106,6 +110,7 @@ static struct struct_io_manager struct_u
 	unix_close,
 	unix_set_blksize,
 	unix_read_blk,
+	unix_readahead,
 	unix_write_blk,
 	unix_flush,
 #ifdef NEED_BOUNCE_BUFFER
@@ -611,6 +616,18 @@ static errcode_t unix_read_blk(io_channe
 #endif /* NO_IO_CACHE */
 }
 
+static errcode_t unix_readahead(io_channel channel, unsigned long block,
+				int count)
+{
+	struct unix_private_data *data;
+
+	data = (struct unix_private_data *)channel->private_data;
+	posix_fadvise(data->dev, (ext2_loff_t)block * channel->block_size,
+		      (ext2_loff_t)count * channel->block_size,
+		      POSIX_FADV_WILLNEED);
+	return 0;
+}
+
 static errcode_t unix_write_blk(io_channel channel, unsigned long block,
 				int count, const void *buf)
 {
Index: e2fsprogs-1.40.2/lib/ext2fs/inode_io.c
===================================================================
--- e2fsprogs-1.40.2.orig/lib/ext2fs/inode_io.c
+++ e2fsprogs-1.40.2/lib/ext2fs/inode_io.c
@@ -64,6 +64,7 @@ static struct struct_io_manager struct_i
 	inode_close,
 	inode_set_blksize,
 	inode_read_blk,
+	readahead_noop,
 	inode_write_blk,
 	inode_flush,
 	inode_write_byte
Index: e2fsprogs-1.40.2/lib/ext2fs/dosio.c
===================================================================
--- e2fsprogs-1.40.2.orig/lib/ext2fs/dosio.c
+++ e2fsprogs-1.40.2/lib/ext2fs/dosio.c
@@ -64,6 +64,7 @@ static struct struct_io_manager struct_d
         dos_close,
         dos_set_blksize,
         dos_read_blk,
+        readahead_noop,
         dos_write_blk,
         dos_flush
 };
Index: e2fsprogs-1.40.2/lib/ext2fs/nt_io.c
===================================================================
--- e2fsprogs-1.40.2.orig/lib/ext2fs/nt_io.c
+++ e2fsprogs-1.40.2/lib/ext2fs/nt_io.c
@@ -236,6 +236,7 @@ static struct struct_io_manager struct_n
 	nt_close,
 	nt_set_blksize,
 	nt_read_blk,
+	readahead_noop,
 	nt_write_blk,
 	nt_flush
 };
Index: e2fsprogs-1.40.2/lib/ext2fs/test_io.c
===================================================================
--- e2fsprogs-1.40.2.orig/lib/ext2fs/test_io.c
+++ e2fsprogs-1.40.2/lib/ext2fs/test_io.c
@@ -74,6 +74,7 @@ static struct struct_io_manager struct_t
 	test_close,
 	test_set_blksize,
 	test_read_blk,
+	readahead_noop,
 	test_write_blk,
 	test_flush,
 	test_write_byte,
Index: e2fsprogs-1.40.2/lib/ext2fs/io_manager.c
===================================================================
--- e2fsprogs-1.40.2.orig/lib/ext2fs/io_manager.c
+++ e2fsprogs-1.40.2/lib/ext2fs/io_manager.c
@@ -67,3 +67,9 @@ errcode_t io_channel_write_byte(io_chann
 
 	return EXT2_ET_UNIMPLEMENTED;
 }
+
+errcode_t readahead_noop(io_channel channel, unsigned long block,
+			 int count)
+{
+	return 0;
+}

--------------000904040505000901070100--
