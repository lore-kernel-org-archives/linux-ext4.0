From: Eric Sandeen <sandeen@redhat.com>
Subject: [PATCH] resize2fs: handle exactly-16T filesystems in resize2fs
Date: Wed, 15 Dec 2010 22:37:34 -0600
Message-ID: <4D09978E.5050302@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
To: Theodore Tso <tytso@mit.edu>,
	ext4 development <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:1655 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751022Ab0LPEhi (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 15 Dec 2010 23:37:38 -0500
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Before we go whole-hog on 64-bit e2fsprogs, I wonder if this
is worth considering as a last-minute addition to the 1.41
stream.  Currently, mke2fs will shave a block off an exactly-16T
device to fit*, but resize2fs does not do the same, leading
to some asymmetry.  This patch fixes that up, and allows 16T
devices to be handled more gracefully in offline resize.
(in fact resize2fs will not even open a 16T device, today).

*commit 37d17a65ecb4615546b417038190a41bafca7c51

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---

Index: e2fsprogs-1.41.12/resize/main.c
===================================================================
--- e2fsprogs-1.41.12.orig/resize/main.c
+++ e2fsprogs-1.41.12/resize/main.c
@@ -159,7 +159,7 @@ int main (int argc, char ** argv)
 	int		print_min_size = 0;
 	int		fd, ret;
 	blk_t		new_size = 0;
-	blk_t		max_size = 0;
+	blk64_t		max_size = 0;
 	blk_t		min_size = 0;
 	io_manager	io_ptr;
 	char		*new_size_str = 0;
@@ -375,7 +375,7 @@ int main (int argc, char ** argv)
 	 * defaults and for making sure the new filesystem doesn't
 	 * exceed the partition size.
 	 */
-	retval = ext2fs_get_device_size(device_name, fs->blocksize,
+	retval = ext2fs_get_device_size2(device_name, fs->blocksize,
 					&max_size);
 	if (retval) {
 		com_err(program_name, retval,
@@ -393,6 +393,14 @@ int main (int argc, char ** argv)
 			exit(1);
 		}
 	} else {
+		/* Take down devices exactly 16T to 2^32-1 blocks */
+		if (max_size == (1ULL << 32))
+			max_size--;
+		else if (max_size > (1ULL << 32)) {
+			com_err(program_name, 0, _("New size too large to be "
+				"expressed in 32 bits\n"));
+			exit(1);
+		}
 		new_size = max_size;
 		/* Round down to an even multiple of a pagesize */
 		if (sys_page_size > fs->blocksize)
@@ -432,7 +441,7 @@ int main (int argc, char ** argv)
 	}
 	if (!force && (new_size > max_size)) {
 		fprintf(stderr, _("The containing partition (or device)"
-			" is only %u (%dk) blocks.\nYou requested a new size"
+			" is only %llu (%dk) blocks.\nYou requested a new size"
 			" of %u blocks.\n\n"), max_size,
 			fs->blocksize / 1024, new_size);
 		exit(1);
