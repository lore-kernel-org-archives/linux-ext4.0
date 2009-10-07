From: Eric Sandeen <sandeen@redhat.com>
Subject: [PATCH] mke2fs support for BLKDISCARD
Date: Wed, 07 Oct 2009 16:49:17 -0500
Message-ID: <4ACD0CDD.2070806@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
To: ext4 development <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:49507 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754109AbZJGVtr (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 7 Oct 2009 17:49:47 -0400
Received: from int-mx03.intmail.prod.int.phx2.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.16])
	by mx1.redhat.com (8.13.8/8.13.8) with ESMTP id n97LnLqg024547
	for <linux-ext4@vger.kernel.org>; Wed, 7 Oct 2009 17:49:21 -0400
Received: from liberator.sandeen.net (ovpn01.gateway.prod.ext.phx2.redhat.com [10.5.9.1])
	by int-mx03.intmail.prod.int.phx2.redhat.com (8.13.8/8.13.8) with ESMTP id n97LnIoA028397
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-ext4@vger.kernel.org>; Wed, 7 Oct 2009 17:49:21 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Try calling the BLKDISCARD ioctl at mkfs time to pre-discard all blocks
on an ssd, or a thinly-provisioned storage device.

No real error checking; if it fails, it fails, and that's ok - it's
just an optimization.  Also, it cannot work in conjunction with
the undo io manager, for obvious reasons.

Optionally disabled with a "-K" (mnemonic: Keep) option.

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---

diff --git a/misc/mke2fs.8.in b/misc/mke2fs.8.in
index b02905b..45a99f8 100644
--- a/misc/mke2fs.8.in
+++ b/misc/mke2fs.8.in
@@ -45,6 +45,9 @@ mke2fs \- create an ext2/ext3/ext4 filesystem
 .I journal-options
 ]
 [
+.B \-K
+]
+[
 .B \-N
 .I number-of-inodes
 ]
@@ -366,6 +369,10 @@ and may be no more than 102,400 filesystem blocks.
 @JDEV@.BR size " or " device
 @JDEV@options can be given for a filesystem.
 .TP
+.BI \-K
+Keep, do not attempt to discard blocks at mkfs time (discarding blocks initially
+is useful on solid state devices and sparse / thin-provisioned storage).
+.TP
 .BI \-l " filename"
 Read the bad blocks list from
 .IR filename .
diff --git a/misc/mke2fs.c b/misc/mke2fs.c
index 2d9107a..9558495 100644
--- a/misc/mke2fs.c
+++ b/misc/mke2fs.c
@@ -80,6 +80,7 @@ int	cflag;
 int	verbose;
 int	quiet;
 int	super_only;
+int	discard = 1;
 int	force;
 int	noaction;
 int	journal_size;
@@ -112,7 +113,7 @@ static void usage(void)
 	"\t[-g blocks-per-group] [-L volume-label] "
 	"[-M last-mounted-directory]\n\t[-O feature[,...]] "
 	"[-r fs-revision] [-E extended-option[,...]]\n"
-	"\t[-T fs-type] [-U UUID] [-jnqvFSV] device [blocks-count]\n"),
+	"\t[-T fs-type] [-U UUID] [-jnqvFKSV] device [blocks-count]\n"),
 		program_name);
 	exit(1);
 }
@@ -1150,7 +1151,7 @@ static void PRS(int argc, char *argv[])
 	}
 
 	while ((c = getopt (argc, argv,
-		    "b:cf:g:G:i:jl:m:no:qr:s:t:vE:FI:J:L:M:N:O:R:ST:U:V")) != EOF) {
+		    "b:cf:g:G:i:jl:m:no:qr:s:t:vE:FI:J:KL:M:N:O:R:ST:U:V")) != EOF) {
 		switch (c) {
 		case 'b':
 			blocksize = strtol(optarg, &tmp, 0);
@@ -1229,6 +1230,9 @@ static void PRS(int argc, char *argv[])
 		case 'J':
 			parse_journal_opts(optarg);
 			break;
+		case 'K':
+			discard = 0;
+			break;
 		case 'j':
 			if (!journal_size)
 				journal_size = -1;
@@ -1854,6 +1858,48 @@ static int mke2fs_setup_tdb(const char *name, io_manager *io_ptr)
 	return retval;
 }
 
+#ifdef __linux__
+
+#ifndef BLKDISCARD
+#define BLKDISCARD	_IO(0x12,119)
+#endif
+
+static void mke2fs_discard_blocks(ext2_filsys fs)
+{
+	int fd;
+	int ret;
+	int blocksize;
+	__u64 blocks;
+	__uint64_t range[2];
+
+	blocks = ext2fs_blocks_count(fs->super);
+	blocksize = EXT2_BLOCK_SIZE(fs->super);
+	range[0] = 0;
+	range[1] = blocks * blocksize;
+
+	fd = open64(fs->device_name, O_RDONLY);
+
+	/*
+	 * We don't care about whether the ioctl succeeds; it's only an
+	 * optmization for SSDs or sparse storage.
+	 */
+	if (fd > 0) {
+		ret = ioctl(fd, BLKDISCARD, &range);
+		if (verbose) {
+			printf(_("Calling BLKDISCARD from %llu to %llu "),
+				range[0], range[1]);
+			if (ret)
+				printf(_("failed.\n"));
+			else
+				printf(_("succeeded.\n"));
+		}
+		close(fd);
+	}
+}
+#else
+#define mke2fs_discard_blocks(fs)
+#endif
+
 int main (int argc, char *argv[])
 {
 	errcode_t	retval = 0;
@@ -1911,6 +1957,10 @@ int main (int argc, char *argv[])
 		exit(1);
 	}
 
+	/* Can't undo discard ... */
+	if (discard && (io_ptr != undo_io_manager))
+		mke2fs_discard_blocks(fs);
+
 	sprintf(tdb_string, "tdb_data_size=%d", fs->blocksize <= 4096 ?
 		32768 : fs->blocksize * 8);
 	io_channel_set_options(fs->io, tdb_string);

