From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH v2] xfstests, generic: add project quota attribute tests
Date: Thu, 14 Jul 2016 15:13:31 +0200
Message-ID: <20160714131331.GB13151@quack2.suse.cz>
References: <20160706233533.GK27480@dastard>
 <d0018d66-cb32-16df-b46e-5c418cc4bfae@sandeen.net>
 <20160708005127.GK12670@dastard>
 <20160708024654.GE19871@thunk.org>
 <77863b4a-95e6-4100-79c2-5cbcaf0872e7@sandeen.net>
 <20160708050228.GH19871@thunk.org>
 <20160711161556.GB9334@quack2.suse.cz>
 <20160711171242.GA21285@thunk.org>
 <20160712105908.GE16460@quack2.suse.cz>
 <20160712161547.GB11020@thunk.org>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="UugvWAfsgieZRqgk"
Cc: Jan Kara <jack@suse.cz>, Eric Sandeen <sandeen@sandeen.net>,
	Dave Chinner <david@fromorbit.com>,
	Wang Shilong <wangshilong1991@gmail.com>,
	fstests@vger.kernel.org, linux-ext4@vger.kernel.org,
	sihara@ddn.com, lixi@ddn.com, Wang Shilong <wshilong@ddn.com>
To: Theodore Ts'o <tytso@mit.edu>
Return-path: <fstests-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20160712161547.GB11020@thunk.org>
Sender: fstests-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org


--UugvWAfsgieZRqgk
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue 12-07-16 12:15:47, Ted Tso wrote:
> On Tue, Jul 12, 2016 at 12:59:08PM +0200, Jan Kara wrote:
> > OK. But with XFS you'd notice that quotaon -p also returns 'on' whenever
> > the accounting is turned on. So ext4 and xfs behave in the same way.
> > Arguably it would be more useful if quotaon -p reported 'off', 'accounting',
> > 'enforcement'. Maybe I'll do that.
> 
> That would be good, since at the moment to determine whether or not
> quota enforcement is enabled or not.

This is now done.

> > Speaking of automatic enabling of quota enforcement: I wanted to keep the
> > old behavior where no enforcement happens until you run quotaon(8) which is
> > how things traditionally worked for ext2/3/4. That's why things default to
> > having enforcement off. If we want to make things more consistent with XFS,
> > one option I can see is that when e.g. 'usrquota' mount option is set, then
> > user quota enforcement will be turned on. That is essentially how XFS
> > works (including the mount option name). What do you think?
> 
> That seems reasonable.  The only concern is that it might be confusing
> for people who are using older, legacy quota setups, but given that
> usrquota would cause enforcing plus accounting to be enabled, it
> shouldn't cause a problem.

Yes, my thinking about this was that when you transfer from a legacy quota
setup to the latest one with hidden quota files, you have to somewhat
update your mindset anyway (e.g. quota information is now created using
tune2fs / mke2fs and checked using e2fsck instead of quotacheck(8)). So the
fact that you won't need quotaon(8) is only a small addition to that.

> I think aligning with XFS so that the user experience for quota should
> be as identical as possible regardless of which file system is being
> used makes a lot of sense, especially since you've been adding a bunch
> of the plumbing for quotactl to make this possible.
> 
> On the kernel side this means that teaching ext4 so that if the
> usrquota monut option is specified, quota enforcing will be enabled.
> We should make the necessary changes in kernel and possily quota-tools
> so that quotaoff can also disable quota enforcing (just like with
> XFS).
> 
> Does that sound like a plan?

Yes. quotaoff will already disable only enforcement for ext4 with hidden
quota files so there's no need to change anything there. We just need to
add kernel support for enabling quota enforcement based on mount option. 
Attached patch should do that - I still need to test whether it doesn't
break anything so don't apply it yet, just have a look whether it looks
sane to you.

								Honza
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR

--UugvWAfsgieZRqgk
Content-Type: text/x-patch; charset=us-ascii
Content-Disposition: attachment; filename="0001-ext4-Enable-quota-enforcement-based-on-mount-options.patch"

>From 80653a01d0a7ec10598ad5d1eee55612d5a355a5 Mon Sep 17 00:00:00 2001
From: Jan Kara <jack@suse.cz>
Date: Thu, 14 Jul 2016 15:08:24 +0200
Subject: [PATCH] ext4: Enable quota enforcement based on mount options

When quota information is stored in quota files, we enable only quota
accounting on mount and enforcement is enabled only in response to
Q_QUOTAON quotactl. To make ext4 behavior consistent with XFS, we add a
possibility to enable quota enforcement on mount by specifying
corresponding quota mount option (usrquota, grpquota, prjquota).

Signed-off-by: Jan Kara <jack@suse.cz>
---
 fs/ext4/ext4.h  | 12 +++++++++---
 fs/ext4/super.c | 34 ++++++++++++++++++++++++----------
 2 files changed, 33 insertions(+), 13 deletions(-)

diff --git a/fs/ext4/ext4.h b/fs/ext4/ext4.h
index b84aa1ca480a..224cb832e2dc 100644
--- a/fs/ext4/ext4.h
+++ b/fs/ext4/ext4.h
@@ -1129,9 +1129,15 @@ struct ext4_inode_info {
 #define EXT4_MOUNT_POSIX_ACL		0x08000	/* POSIX Access Control Lists */
 #define EXT4_MOUNT_NO_AUTO_DA_ALLOC	0x10000	/* No auto delalloc mapping */
 #define EXT4_MOUNT_BARRIER		0x20000 /* Use block barriers */
-#define EXT4_MOUNT_QUOTA		0x80000 /* Some quota option set */
-#define EXT4_MOUNT_USRQUOTA		0x100000 /* "old" user quota */
-#define EXT4_MOUNT_GRPQUOTA		0x200000 /* "old" group quota */
+#define EXT4_MOUNT_QUOTA		0x40000 /* Some quota option set */
+#define EXT4_MOUNT_USRQUOTA		0x80000 /* "old" user quota,
+						 * enable enforcement for hidden
+						 * quota files */
+#define EXT4_MOUNT_GRPQUOTA		0x100000 /* "old" group quota, enable
+						  * enforcement for hidden quota
+						  * files */
+#define EXT4_MOUNT_PRJQUOTA		0x200000 /* Enable project quota
+						  * enforcement */
 #define EXT4_MOUNT_DIOREAD_NOLOCK	0x400000 /* Enable support for dio read nolocking */
 #define EXT4_MOUNT_JOURNAL_CHECKSUM	0x800000 /* Journal checksums */
 #define EXT4_MOUNT_JOURNAL_ASYNC_COMMIT	0x1000000 /* Journal Async Commit */
diff --git a/fs/ext4/super.c b/fs/ext4/super.c
index 3822a5aedc61..a03232634cd5 100644
--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -1187,7 +1187,7 @@ enum {
 	Opt_usrjquota, Opt_grpjquota, Opt_offusrjquota, Opt_offgrpjquota,
 	Opt_jqfmt_vfsold, Opt_jqfmt_vfsv0, Opt_jqfmt_vfsv1, Opt_quota,
 	Opt_noquota, Opt_barrier, Opt_nobarrier, Opt_err,
-	Opt_usrquota, Opt_grpquota, Opt_i_version, Opt_dax,
+	Opt_usrquota, Opt_grpquota, Opt_prjquota, Opt_i_version, Opt_dax,
 	Opt_stripe, Opt_delalloc, Opt_nodelalloc, Opt_mblk_io_submit,
 	Opt_lazytime, Opt_nolazytime,
 	Opt_nomblk_io_submit, Opt_block_validity, Opt_noblock_validity,
@@ -1247,6 +1247,7 @@ static const match_table_t tokens = {
 	{Opt_noquota, "noquota"},
 	{Opt_quota, "quota"},
 	{Opt_usrquota, "usrquota"},
+	{Opt_prjquota, "prjquota"},
 	{Opt_barrier, "barrier=%u"},
 	{Opt_barrier, "barrier"},
 	{Opt_nobarrier, "nobarrier"},
@@ -1466,8 +1467,11 @@ static const struct mount_opts {
 							MOPT_SET | MOPT_Q},
 	{Opt_grpquota, EXT4_MOUNT_QUOTA | EXT4_MOUNT_GRPQUOTA,
 							MOPT_SET | MOPT_Q},
+	{Opt_prjquota, EXT4_MOUNT_QUOTA | EXT4_MOUNT_PRJQUOTA,
+							MOPT_SET | MOPT_Q},
 	{Opt_noquota, (EXT4_MOUNT_QUOTA | EXT4_MOUNT_USRQUOTA |
-		       EXT4_MOUNT_GRPQUOTA), MOPT_CLEAR | MOPT_Q},
+		       EXT4_MOUNT_GRPQUOTA | EXT4_MOUNT_PRJQUOTA),
+							MOPT_CLEAR | MOPT_Q},
 	{Opt_usrjquota, 0, MOPT_Q},
 	{Opt_grpjquota, 0, MOPT_Q},
 	{Opt_offusrjquota, 0, MOPT_Q},
@@ -1756,13 +1760,17 @@ static int parse_options(char *options, struct super_block *sb,
 			return 0;
 	}
 #ifdef CONFIG_QUOTA
-	if (ext4_has_feature_quota(sb) &&
-	    (test_opt(sb, USRQUOTA) || test_opt(sb, GRPQUOTA))) {
-		ext4_msg(sb, KERN_INFO, "Quota feature enabled, usrquota and grpquota "
-			 "mount options ignored.");
-		clear_opt(sb, USRQUOTA);
-		clear_opt(sb, GRPQUOTA);
-	} else if (sbi->s_qf_names[USRQUOTA] || sbi->s_qf_names[GRPQUOTA]) {
+	/*
+	 * We do the test below only for project quotas. 'usrquota' and
+	 * 'grpquota' mount options are allowed even without quota feature
+	 * to support legacy quotas in quota files.
+	 */
+	if (test_opt(sb, PRJQUOTA) && !ext4_has_feature_project(sb)) {
+		ext4_msg(sb, KERN_ERR, "Project quota feature not enabled. "
+			 "Cannot enable project quota enforcement.");
+		return 0;
+	}
+	if (sbi->s_qf_names[USRQUOTA] || sbi->s_qf_names[GRPQUOTA]) {
 		if (test_opt(sb, USRQUOTA) && sbi->s_qf_names[USRQUOTA])
 			clear_opt(sb, USRQUOTA);
 
@@ -5129,12 +5137,18 @@ static int ext4_enable_quotas(struct super_block *sb)
 		le32_to_cpu(EXT4_SB(sb)->s_es->s_grp_quota_inum),
 		le32_to_cpu(EXT4_SB(sb)->s_es->s_prj_quota_inum)
 	};
+	bool quota_mopt[EXT4_MAXQUOTAS] = {
+		test_opt(sb, USRQUOTA),
+		test_opt(sb, GRPQUOTA),
+		test_opt(sb, PRJQUOTA),
+	};
 
 	sb_dqopt(sb)->flags |= DQUOT_QUOTA_SYS_FILE;
 	for (type = 0; type < EXT4_MAXQUOTAS; type++) {
 		if (qf_inums[type]) {
 			err = ext4_quota_enable(sb, type, QFMT_VFS_V1,
-						DQUOT_USAGE_ENABLED);
+				DQUOT_USAGE_ENABLED |
+				(quota_mopt[type] ? DQUOT_LIMITS_ENABLED : 0));
 			if (err) {
 				ext4_warning(sb,
 					"Failed to enable quota tracking "
-- 
2.6.6


--UugvWAfsgieZRqgk--
