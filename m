From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 06/74] tune2fs: forbid changing uuid on an uninit_bg
 filesystem
Date: Sat, 14 Dec 2013 21:02:51 -0500
Message-ID: <20131215020251.GB15593@thunk.org>
References: <20131211011813.30655.39624.stgit@birch.djwong.org>
 <20131211011857.30655.20986.stgit@birch.djwong.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:40065 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754578Ab3LOCCz (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sat, 14 Dec 2013 21:02:55 -0500
Content-Disposition: inline
In-Reply-To: <20131211011857.30655.20986.stgit@birch.djwong.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, Dec 10, 2013 at 05:18:57PM -0800, Darrick J. Wong wrote:
> The old uninit_bg checksums depend on the UUID, so prohibit changes to
> the UUID if a checksumming filesystem is mounted, because this
> introduces a nasty race where the kernel and tune2fs are both trying
> to rewrite group descriptors at the same time, with different ideas
> about what the UUID is.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>

I made the following change to the maint branch, which pulls back some
changes that had first made in the next branch into maint, and then
merged the maint branch back into the next branch --- and was
impressed how painlessly git handled the merge.  :-)

The result was slightly cleaner than what resulted after applying your
original patch to the next branch, since it resulted in:

		if (ext2fs_has_group_desc_csum(fs)) {
			/*
			 * Changing the UUID requires rewriting all metadata,
			 * which can race with a mounted fs.  Don't allow that.
			 */
			...
		}

		if (ext2fs_has_group_desc_csum(fs)) {
			/*
			 * Determine if the block group checksums are
			 * correct so we know whether or not to set
			 * them later on.
			 */
			...
		}

	  	      		     	     - Ted

>From 66457fcb842300e757a69c49c2eb4d8e335be34c Mon Sep 17 00:00:00 2001
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Sat, 14 Dec 2013 20:51:04 -0500
Subject: [PATCH] tune2fs: forbid changing uuid on an uninit_bg filesystem

The old uninit_bg checksums depend on the UUID, so prohibit changes to
the UUID if a checksumming filesystem is mounted, because this
introduces a nasty race where the kernel and tune2fs are both trying
to rewrite group descriptors at the same time, with different ideas
about what the UUID is.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
---
 misc/tune2fs.c | 23 +++++++++++++++++++++++
 1 file changed, 23 insertions(+)

diff --git a/misc/tune2fs.c b/misc/tune2fs.c
index 822df74..a8dc111 100644
--- a/misc/tune2fs.c
+++ b/misc/tune2fs.c
@@ -358,6 +358,16 @@ static int update_mntopts(ext2_filsys fs, char *mntopts)
 	return 0;
 }
 
+static int check_fsck_needed(ext2_filsys fs)
+{
+	if (fs->super->s_state & EXT2_VALID_FS)
+		return 0;
+	printf("\n%s\n", _(please_fsck));
+	if (mount_flags & EXT2_MF_READONLY)
+		printf(_("(and reboot afterwards!)\n"));
+	return 1;
+}
+
 static void request_fsck_afterwards(ext2_filsys fs)
 {
 	static int requested = 0;
@@ -2147,6 +2157,19 @@ retry_open:
 		if (sb->s_feature_ro_compat &
 		    EXT4_FEATURE_RO_COMPAT_GDT_CSUM) {
 			/*
+			 * Changing the UUID requires rewriting all metadata,
+			 * which can race with a mounted fs.  Don't allow that.
+			 */
+			if (mount_flags & EXT2_MF_MOUNTED) {
+				fputs(_("The UUID may only be "
+					"changed when the filesystem is "
+					"unmounted.\n"), stderr);
+				exit(1);
+			}
+			if (check_fsck_needed(fs))
+				exit(1);
+
+			/*
 			 * Determine if the block group checksums are
 			 * correct so we know whether or not to set
 			 * them later on.
-- 
1.8.5.rc3.362.gdf10213

