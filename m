From: Theodore Ts'o <tytso@mit.edu>
Subject: [PATCH] e2fsck: skip low dtime check if the number of inodes > s_mkfs_time
Date: Tue, 22 Apr 2014 14:19:12 -0400
Message-ID: <1398190752-12964-1-git-send-email-tytso@mit.edu>
References: <CAAOsTSktc2faYp5x_-3OcT3_DU81mHSQaeXTn1EoixmOLNX98A@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: patrik@hornik.sk, Theodore Ts'o <tytso@mit.edu>
To: Ext4 Developers List <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:54401 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750837AbaDVSTW (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 22 Apr 2014 14:19:22 -0400
In-Reply-To: <CAAOsTSktc2faYp5x_-3OcT3_DU81mHSQaeXTn1EoixmOLNX98A@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

We already skip the low dtime check if the number of inods is greater
than the last mount or last written time.  However, if a very large
file system is resized sufficiently large that the number of inodes is
greater than when the file system was original created, we can end up
running afoul of the low dtime check.  This results in a large number
of false positives which e2fsck can fix up without causing any
problems, but it can induce a large amount of anxiety for the system
administrator.

Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
Reported-by: Patrik Horn=C3=ADk <patrik@hornik.sk>
---
 e2fsck/pass1.c | 10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

diff --git a/e2fsck/pass1.c b/e2fsck/pass1.c
index 38b221c..9ef724a 100644
--- a/e2fsck/pass1.c
+++ b/e2fsck/pass1.c
@@ -559,7 +559,7 @@ void e2fsck_pass1(e2fsck_t ctx)
 	const char	*old_op;
 	unsigned int	save_type;
 	int		imagic_fs, extent_fs;
-	int		busted_fs_time =3D 0;
+	int		low_dtime_check =3D 1;
 	int		inode_size;
=20
 	init_resource_track(&rtrack, ctx->fs->io);
@@ -708,8 +708,10 @@ void e2fsck_pass1(e2fsck_t ctx)
 					      ctx->fs->group_desc_count)))
 		goto endit;
 	if ((fs->super->s_wtime < fs->super->s_inodes_count) ||
-	    (fs->super->s_mtime < fs->super->s_inodes_count))
-		busted_fs_time =3D 1;
+	    (fs->super->s_mtime < fs->super->s_inodes_count) ||
+	    (fs->super->s_mkfs_time &&
+	     fs->super->s_mkfs_time < fs->super->s_inodes_count))
+		low_dtime_check =3D 0;
=20
 	if ((fs->super->s_feature_incompat & EXT4_FEATURE_INCOMPAT_MMP) &&
 	    fs->super->s_mmp_block > fs->super->s_first_data_block &&
@@ -988,7 +990,7 @@ void e2fsck_pass1(e2fsck_t ctx)
 		 * than nothing.  The right answer is that there
 		 * shouldn't be any bugs in the orphan list handling.  :-)
 		 */
-		if (inode->i_dtime && !busted_fs_time &&
+		if (inode->i_dtime && low_dtime_check &&
 		    inode->i_dtime < ctx->fs->super->s_inodes_count) {
 			if (fix_problem(ctx, PR_1_LOW_DTIME, &pctx)) {
 				inode->i_dtime =3D inode->i_links_count ?
--=20
1.9.0

--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
