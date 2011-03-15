From: Andreas Dilger <adilger@whamcloud.com>
Subject: [PATCH]: e2fsprogs m_* self tests no longer pass
Date: Tue, 15 Mar 2011 13:50:48 -0600
Message-ID: <F6277800-7506-4613-B9D8-F180191F4ABB@whamcloud.com>
References: <AANLkTikX2u+tz7e39tb8abRuXtiLDusKpjAf9vZ1tYUU@mail.gmail.com> <alpine.LFD.2.00.1103011046240.3874@dhcp-27-109.brq.redhat.com> <AANLkTing03byqyWRXbS+AJjHuyZCaJaHczHmVMoW+MBB@mail.gmail.com>
Mime-Version: 1.0 (Apple Message framework v1082)
Content-Type: multipart/mixed; boundary=Apple-Mail-5--211098723
Cc: ext4 development <linux-ext4@vger.kernel.org>,
	Bruce Cassidy <bruce@whamcloud.com>
To: Lukas Czerner <lczerner@redhat.com>, Ted Ts'o <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-fx0-f46.google.com ([209.85.161.46]:35131 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758202Ab1COTuz (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 15 Mar 2011 15:50:55 -0400
Received: by fxm17 with SMTP id 17so957771fxm.19
        for <linux-ext4@vger.kernel.org>; Tue, 15 Mar 2011 12:50:54 -0700 (PDT)
In-Reply-To: <AANLkTing03byqyWRXbS+AJjHuyZCaJaHczHmVMoW+MBB@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


--Apple-Mail-5--211098723
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain;
	charset=us-ascii

Only display the "Discarding device blocks:" status bar if discard is =
actually implemented in the IO manager and in the kernel.  Otherwise, =
there is no correct test result that will work in all environments.  I'd =
prefer not to print an error message for the majority of devices that do =
not support discard, since this is confusing.

Signed-off-by: Andreas Dilger <adilger@dilger.ca>



--Apple-Mail-5--211098723
Content-Disposition: attachment;
	filename=e2fsprogs-discard.patch
Content-Type: application/octet-stream;
	name="e2fsprogs-discard.patch"
Content-Transfer-Encoding: 7bit

Allow mke2fs discard patches to pass regression tests.

Index: e2fsprogs/lib/ext2fs/unix_io.c
===================================================================
--- e2fsprogs.orig/lib/ext2fs/unix_io.c
+++ e2fsprogs/lib/ext2fs/unix_io.c
@@ -872,8 +872,11 @@ static errcode_t unix_discard(io_channel
 	range[1] = (__uint64_t)(count) * channel->block_size;
 
 	ret = ioctl(data->dev, BLKDISCARD, &range);
-	if (ret < 0)
+	if (ret < 0) {
+		if (errno == ENOTTY)
+			return EXT2_ET_UNIMPLEMENTED;
 		return errno;
+	}
 	return 0;
 #else
 	return EXT2_ET_UNIMPLEMENTED;
Index: e2fsprogs/misc/mke2fs.c
===================================================================
--- e2fsprogs.orig/misc/mke2fs.c
+++ e2fsprogs/misc/mke2fs.c
@@ -2010,29 +2010,37 @@ static int mke2fs_discard_device(ext2_fi
 	count *= (1024 * 1024);
 	count /= fs->blocksize;
 
-	ext2fs_numeric_progress_init(fs, &progress,
-				     _("Discarding device blocks: "),
-				     blocks);
 	while (cur < blocks) {
-		ext2fs_numeric_progress_update(fs, &progress, cur);
-
 		if (cur + count > blocks)
 			count = blocks - cur;
 
 		retval = io_channel_discard(fs->io, cur, count, fs->blocksize);
+		if (cur == 0) {
+			/* If discard is unimplemented skip the progress bar */
+			if (retval == EXT2_ET_UNIMPLEMENTED)
+				return retval;
+
+			ext2fs_numeric_progress_init(fs, &progress,
+						_("Discarding device blocks: "),
+						blocks);
+		}
+
+		ext2fs_numeric_progress_update(fs, &progress, cur);
+
 		if (retval)
 			break;
+
 		cur += count;
 	}
 
 	if (retval) {
-		ext2fs_numeric_progress_close(fs, &progress,
-				      _("failed - "));
+		ext2fs_numeric_progress_close(fs, &progress, _("failed - "));
 		if (!quiet)
 			printf("%s\n",error_message(retval));
-	} else
+	} else {
 		ext2fs_numeric_progress_close(fs, &progress,
 				      _("done                            \n"));
+	}
 
 	return retval;
 }

--Apple-Mail-5--211098723--
