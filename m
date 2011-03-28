From: Oren Elrad <elrad@brandeis.edu>
Subject: [PATCH] mke2fs reserved_ratio default value is nonsensical
Date: Mon, 28 Mar 2011 14:02:43 -0400
Message-ID: <AANLkTi=7jMS=yq4-72_CvcyGHuWWV6ixEKtk501wnxUz@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-vx0-f174.google.com ([209.85.220.174]:64543 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754351Ab1C1SDZ (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 28 Mar 2011 14:03:25 -0400
Received: by vxi39 with SMTP id 39so2508376vxi.19
        for <linux-ext4@vger.kernel.org>; Mon, 28 Mar 2011 11:03:24 -0700 (PDT)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Undesired behavior; mke2fs defaults to reserving 5% of the volume for
the root user. 5% of a 2TB volume is 100GB. The rationale for root
reservation (syslogd, etc...) does not require 100GB. As volumes get
larger, this default makes less and less sense.

Proposal; If the user does not specify their preferred reserve_ratio
on the command-line (-m), use the less of 5% or MAX_RSRV_SIZE. I
propose 10GiB as a sensible maximum default reservation for root.

Patch: Follows and http://capsid.brandeis.edu/~elrad/e2fsprog.gitdiff

Tested on the latest git+patch, RHEL5 (2.6.18-194.17.1.el5) with a
12TB volume (which would reserve 600GB under the default!):

# /root/e2fsprogs/misc/mke2fs -T ext4 -L scratch /dev/sdd1
[...]
OS type: Linux
Block size=4096 (log=2)
Fragment size=4096 (log=2)
Stride=0 blocks, Stripe width=0 blocks
732422144 inodes, 2929671159 blocks
2621440 blocks (0.09%) reserved for the super user
[...]

Oren Elrad
Dept. of Physics
Brandeis University

---- Patch follows ----

diff --git a/misc/mke2fs.c b/misc/mke2fs.c
index 9798b88..0ff3785 100644
--- a/misc/mke2fs.c
+++ b/misc/mke2fs.c
@@ -108,6 +108,8 @@ profile_t	profile;
 int sys_page_size = 4096;
 int linux_version_code = 0;

+static const unsigned long long MAX_RSRV_SIZE = 10ULL * (1 << 30); // 10 GiB
+
 static void usage(void)
 {
 	fprintf(stderr, _("Usage: %s [-c|-l filename] [-b block-size] "
@@ -1154,7 +1156,7 @@ static void PRS(int argc, char *argv[])
 	int		inode_ratio = 0;
 	int		inode_size = 0;
 	unsigned long	flex_bg_size = 0;
-	double		reserved_ratio = 5.0;
+	double		reserved_ratio = -1.0; // Default: lesser of 5%, MAX_RSRV_SIZE
 	int		lsector_size = 0, psector_size = 0;
 	int		show_version_only = 0;
 	unsigned long long num_inodes = 0; /* unsigned long long to catch
too-large input */
@@ -1893,9 +1895,17 @@ profile_error:

 	/*
 	 * Calculate number of blocks to reserve
+	 * If reserved_ratio >= 0.0, it was passed as an argument, use it as-is
+	 * If reserved_ratio < 0.0, no argument was passed, choose the
lesser of 5%, MAX_RSRV_SIZE
 	 */
-	ext2fs_r_blocks_count_set(&fs_param, reserved_ratio *
-				  ext2fs_blocks_count(&fs_param) / 100.0);
+	if ( reserved_ratio >= 0.0 ) {
+		ext2fs_r_blocks_count_set(&fs_param, reserved_ratio *
+					  ext2fs_blocks_count(&fs_param) / 100.0);
+	} else {
+		const blk64_t r_blk_count = ext2fs_blocks_count(&fs_param) / 20.0;
+		const blk64_t max_r_blk_count = MAX_RSRV_SIZE / blocksize;
+		ext2fs_r_blocks_count_set(&fs_param, (r_blk_count < max_r_blk_count
? r_blk_count : max_r_blk_count));
+	}
 }

 static int should_do_undo(const char *name)

By making a contribution to this project, I certify that:

	(a) The contribution was created in whole or in part by me and I
            have the right to submit it under the open source license
            indicated in the file;

	(d) I understand and agree that this project and the contribution
	    are public and that a record of the contribution (including all
	    personal information I submit with it, including my sign-off) is
	    maintained indefinitely and may be redistributed consistent with
	    this project or the open source license(s) involved.

Signed-off-by: Oren M Elrad <elrad@brandeis.edu>
