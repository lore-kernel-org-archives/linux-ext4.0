From: Jeff Moyer <jmoyer@redhat.com>
Subject: Re: Kernel 3.3.8 breaks accidental ext3 mount of extended partition
Date: Mon, 25 Jun 2012 12:38:03 -0400
Message-ID: <x49r4t3z6s4.fsf@segfault.boston.devel.redhat.com>
References: <4FDEC3C2.4060909@secunet.com>
	<20120625113457.GA1289@amd.home.annexia.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Torsten Hilbrich <torsten.hilbrich@secunet.com>,
	linux-ext4@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
To: "Richard W.M. Jones" <rjones@redhat.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20120625113457.GA1289@amd.home.annexia.org> (Richard
	W. M. Jones's message of "Mon, 25 Jun 2012 12:34:57 +0100")
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

"Richard W.M. Jones" <rjones@redhat.com> writes:

> On Mon, Jun 18, 2012 at 07:59:30AM +0200, Torsten Hilbrich wrote:
>> Hello,
>> 
>> a software that tries to mount each existing partition as ext3 file system started to fail when updating from v3.3.7 to v3.3.8.
>> 
>> The applications then hangs-up in the mount syscall, here is a snapshot of its stack at this moment:
>
> We just ran into what we think is the same problem.
>
> Note that ext4 fails like this for any 1024 byte sized filesystem (of
> zeroes) that you try to mount.  It's really nothing to do with
> extended partitions.
>
> Here is a very simple reproducer + stack trace:
>
>   https://bugzilla.redhat.com/show_bug.cgi?id=835019#c4
>
> I will try out the patch suggested later on in this thread.

Please try the attached patch instead.  The patch I had originally
posted for this allowed marking the first buffer beyond EOD as
uptodate.  This isn't correct.  The patch I've attached below fixes the
infinite loop in __getblk_slow.

Cheers,
Jeff

diff --git a/fs/buffer.c b/fs/buffer.c
index 838a9cf..c7062c8 100644
--- a/fs/buffer.c
+++ b/fs/buffer.c
@@ -1036,6 +1036,9 @@ grow_buffers(struct block_device *bdev, sector_t block, int size)
 static struct buffer_head *
 __getblk_slow(struct block_device *bdev, sector_t block, int size)
 {
+	int ret;
+	struct buffer_head *bh;
+
 	/* Size must be multiple of hard sectorsize */
 	if (unlikely(size & (bdev_logical_block_size(bdev)-1) ||
 			(size < 512 || size > PAGE_SIZE))) {
@@ -1048,20 +1051,21 @@ __getblk_slow(struct block_device *bdev, sector_t block, int size)
 		return NULL;
 	}
 
-	for (;;) {
-		struct buffer_head * bh;
-		int ret;
+retry:
+	bh = __find_get_block(bdev, block, size);
+	if (bh)
+		return bh;
 
+	ret = grow_buffers(bdev, block, size);
+	if (ret == 0) {
+		free_more_memory();
+		goto retry;
+	} else if (ret > 0) {
 		bh = __find_get_block(bdev, block, size);
 		if (bh)
 			return bh;
-
-		ret = grow_buffers(bdev, block, size);
-		if (ret < 0)
-			return NULL;
-		if (ret == 0)
-			free_more_memory();
 	}
+	return NULL;
 }
 
 /*
