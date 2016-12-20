From: Eric Sandeen <sandeen@redhat.com>
Subject: [PATCH] libext2fs: don't ignore fsync errors
Date: Tue, 20 Dec 2016 09:23:29 -0600
Message-ID: <46250d87-9e7b-3cb3-3d74-5c490023c0ed@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
To: "linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:55838 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752030AbcLTPXa (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Tue, 20 Dec 2016 10:23:30 -0500
Received: from int-mx10.intmail.prod.int.phx2.redhat.com (int-mx10.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 499A761BBD
        for <linux-ext4@vger.kernel.org>; Tue, 20 Dec 2016 15:23:30 +0000 (UTC)
Received: from [IPv6:::1] (ovpn04.gateway.prod.ext.phx2.redhat.com [10.5.9.4])
        by int-mx10.intmail.prod.int.phx2.redhat.com (8.14.4/8.14.4) with ESMTP id uBKFNTeR026728
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
        for <linux-ext4@vger.kernel.org>; Tue, 20 Dec 2016 10:23:30 -0500
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Today, if mke2fs experiences IO errors (say, on a thin device
which filled up during mkfs), mke2fs is silent and returns
success even though the filesystem was not properly created.

Catch errors from the io_channel_flush() callchain to
fix this up.  Fix formatting of the printed error as
well:

...
Creating journal (262144 blocks): done
Writing superblocks and filesystem accounting information:          
Warning, had trouble writing out superblocks.
# echo $?
5

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---

I'm not actually sure what's supposed to be returned
from unix_flush; it's an errcode_t; is a standard error
number (EIO) ok or is there a libcom_err for that?
Anyway, seems to work ok.

diff --git a/lib/ext2fs/closefs.c b/lib/ext2fs/closefs.c
index b69fa09..b255759 100644
--- a/lib/ext2fs/closefs.c
+++ b/lib/ext2fs/closefs.c
@@ -429,16 +429,22 @@ write_primary_superblock_only:
 	if (retval)
 		return retval;
 
-	if (!(flags & EXT2_FLAG_FLUSH_NO_SYNC))
+	if (!(flags & EXT2_FLAG_FLUSH_NO_SYNC)) {
 		retval = io_channel_flush(fs->io);
+		if (retval)
+			goto errout;
+	}
 	retval = write_primary_superblock(fs, super_shadow);
 	if (retval)
 		goto errout;
 
 	fs->flags &= ~EXT2_FLAG_DIRTY;
 
-	if (!(flags & EXT2_FLAG_FLUSH_NO_SYNC))
+	if (!(flags & EXT2_FLAG_FLUSH_NO_SYNC)) {
 		retval = io_channel_flush(fs->io);
+		if (retval)
+			goto errout;
+	}
 errout:
 	fs->super->s_state = fs_state;
 #ifdef WORDS_BIGENDIAN
diff --git a/lib/ext2fs/unix_io.c b/lib/ext2fs/unix_io.c
index 429ea24..f4e6148 100644
--- a/lib/ext2fs/unix_io.c
+++ b/lib/ext2fs/unix_io.c
@@ -1030,7 +1030,8 @@ static errcode_t unix_flush(io_channel channel)
 #ifndef NO_IO_CACHE
 	retval = flush_cached_blocks(channel, data, 0);
 #endif
-	fsync(data->dev);
+	if (!retval && fsync(data->dev) != 0)
+		return errno;
 	return retval;
 }
 
diff --git a/misc/mke2fs.c b/misc/mke2fs.c
index 9f18c83..49c6e94 100644
--- a/misc/mke2fs.c
+++ b/misc/mke2fs.c
@@ -3227,7 +3227,7 @@ no_journal:
 	retval = ext2fs_close_free(&fs);
 	if (retval) {
 		fprintf(stderr, "%s",
-			_("\nWarning, had trouble writing out superblocks."));
+			_("\nWarning, had trouble writing out superblocks.\n"));
 	} else if (!quiet) {
 		printf("%s", _("done\n\n"));
 		if (!getenv("MKE2FS_SKIP_CHECK_MSG"))


