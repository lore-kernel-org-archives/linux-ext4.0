From: Wang Shilong <wangshilong1991@gmail.com>
Subject: [PATCH] quota: add project support for quotacheck
Date: Thu,  7 Jul 2016 16:10:46 +0900
Message-ID: <1467875446-28147-1-git-send-email-wangshilong1991@gmail.com>
Cc: sihara@ddn.com, lixi@ddn.com, Wang Shilong <wshilong@ddn.com>
To: linux-ext4@vger.kernel.org, jack@suse.cz
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-pf0-f194.google.com ([209.85.192.194]:34047 "EHLO
	mail-pf0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030284AbcGGIJh (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 7 Jul 2016 04:09:37 -0400
Received: by mail-pf0-f194.google.com with SMTP id 66so1167974pfy.1
        for <linux-ext4@vger.kernel.org>; Thu, 07 Jul 2016 01:09:36 -0700 (PDT)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

From: Wang Shilong <wshilong@ddn.com>

With prjquota mount option supported, quotacheck should be
aware of ext4 project quota.

This patch add support for it.

Signed-off-by: Wang Shilong <wshilong@ddn.com>
---
 mntopt.h     |   2 +
 quota.h      |   3 +-
 quotacheck.c | 161 ++++++++++++++++++++++++++++++++++++++++++++++-------------
 quotacheck.h |  17 +++++++
 quotaio_v2.h |   2 +-
 quotasys.c   |  10 ++++
 6 files changed, 159 insertions(+), 36 deletions(-)

diff --git a/mntopt.h b/mntopt.h
index f31abb7..b055f7a 100644
--- a/mntopt.h
+++ b/mntopt.h
@@ -32,6 +32,8 @@
 #define MNTOPT_USRJQUOTA	"usrjquota"	/* enforce user quota */
 #define MNTOPT_GRPQUOTA		"grpquota"	/* enforce group quota */
 #define MNTOPT_GRPJQUOTA	"grpjquota"	/* enforce group quota */
+#define MNTOPT_PRJQUOTA		"prjquota"	/* enforce group quota */
+#define MNTOPT_PRJJQUOTA	"prjjquota"	/* enforce group quota */
 #define MNTOPT_RSQUASH		"rsquash"	/* root as ordinary user */
 #define MNTOPT_BIND		"bind"		/* binded mount */
 #define MNTOPT_LOOP		"loop"		/* loopback mount */
diff --git a/quota.h b/quota.h
index 3628614..094130a 100644
--- a/quota.h
+++ b/quota.h
@@ -30,7 +30,8 @@ typedef int64_t qsize_t;	/* Type in which we store size limitations */
  */
 #define INITQMAGICS {\
 	0xd9c01f11,	/* USRQUOTA */\
-	0xd9c01927	/* GRPQUOTA */\
+	0xd9c01927,	/* GRPQUOTA */\
+	0xd9c03f14	/* PRJQUOTA */\
 }
 
 /* Size of blocks in which are counted size limits in generic utility parts */
diff --git a/quotacheck.c b/quotacheck.c
index 6f34cff..d895f77 100644
--- a/quotacheck.c
+++ b/quotacheck.c
@@ -61,7 +61,7 @@ struct dirs {
 static dev_t cur_dev;			/* Device we are working on */
 static int files_done, dirs_done;
 int flags, fmt = -1, cfmt;	/* Options from command line; Quota format to use spec. by user; Actual format to check */
-static int uwant, gwant, ucheck, gcheck;	/* Does user want to check user/group quota; Do we check user/group quota? */
+static int uwant, gwant, pwant, ucheck, gcheck, pcheck;	/* Does user want to check quotas; Do we check quotas? */
 static char *mntpoint;			/* Mountpoint to check */
 char *progname;
 struct util_dqinfo old_info[MAXQUOTAS];	/* Loaded infos */
@@ -179,16 +179,18 @@ struct dquot *add_dquot(qid_t id, int type)
 /*
  * Add a number of blocks and inodes to a quota.
  */
-static void add_to_quota(int type, ino_t i_num, uid_t i_uid, gid_t i_gid, mode_t i_mode,
-			 nlink_t i_nlink, loff_t i_space, int need_remember)
+static void add_to_quota(int type, ino_t i_num, uid_t i_uid, gid_t i_gid, __u32 prjid,
+			 mode_t i_mode, nlink_t i_nlink, loff_t i_space, int need_remember)
 {
 	qid_t wanted;
 	struct dquot *lptr;
 
 	if (type == USRQUOTA)
 		wanted = i_uid;
-	else
+	else if (type == PRJQUOTA)
 		wanted = i_gid;
+	else
+		wanted = prjid;
 
 	if ((lptr = lookup_dquot(wanted, type)) == NODQUOT)
 		lptr = add_dquot(wanted, type);
@@ -293,9 +295,10 @@ static inline void blit(const char *msg)
 
 static void usage(void)
 {
-	printf(_("Utility for checking and repairing quota files.\n%s [-gucbfinvdmMR] [-F <quota-format>] filesystem|-a\n\n\
+	printf(_("Utility for checking and repairing quota files.\n%s [-gupcbfinvdmMR] [-F <quota-format>] filesystem|-a\n\n\
 -u, --user                check user files\n\
 -g, --group               check group files\n\
+-p, --project             check group files\n\
 -c, --create-files        create new quota files\n\
 -b, --backup              create backups of old quota files\n\
 -f, --force               force check even if quotas are enabled\n\
@@ -327,6 +330,7 @@ static void parse_options(int argcnt, char **argstr)
 		{ "debug", 0, NULL, 'd' },
 		{ "user", 0, NULL, 'u' },
 		{ "group", 0, NULL, 'g' },
+		{ "group", 0, NULL, 'p' },
 		{ "interactive", 0, NULL, 'i' },
 		{ "use-first-dquot", 0, NULL, 'n' },
 		{ "force", 0, NULL, 'f' },
@@ -338,7 +342,7 @@ static void parse_options(int argcnt, char **argstr)
 		{ NULL, 0, NULL, 0 }
 	};
 
-	while ((ret = getopt_long(argcnt, argstr, "VhbcvugidnfF:mMRa", long_opts, NULL)) != -1) {
+	while ((ret = getopt_long(argcnt, argstr, "VhbcvugpidnfF:mMRa", long_opts, NULL)) != -1) {
   	        switch (ret) {
 		  case 'b':
   		          flags |= FL_BACKUPS;
@@ -349,6 +353,9 @@ static void parse_options(int argcnt, char **argstr)
 		  case 'u':
 			  uwant = 1;
 			  break;
+		  case 'p':
+			  pwant = 1;
+			  break;
 		  case 'd':
 			  flags |= FL_DEBUG;
 			  setlinebuf(stderr);
@@ -394,7 +401,7 @@ static void parse_options(int argcnt, char **argstr)
 			usage();
 		}
 	}
-	if (!(uwant | gwant))
+	if (!(uwant | gwant | pwant))
 		uwant = 1;
 	if ((argcnt == optind && !(flags & FL_ALL)) || (argcnt > optind && flags & FL_ALL)) {
 		fputs(_("Bad number of arguments.\n"), stderr);
@@ -415,12 +422,14 @@ static int ext2_direct_scan(const char *device)
 	ext2_filsys fs;
 	errcode_t error;
 	ext2_inode_scan scan;
-	struct ext2_inode inode;
+	struct ext2_inode *inode;
+	int inode_size;
 	int inode_buffer_blocks = 0;
 	ext2fs_inode_bitmap inode_used_map;
 	ext2fs_inode_bitmap inode_dir_map;
 	uid_t uid;
 	gid_t gid;
+	u32 projid = 0;
 
 	if ((error = ext2fs_open(device, 0, 0, 0, unix_io_manager, &fs))) {
 		errstr(_("error (%d) while opening %s\n"), (int)error, device);
@@ -441,38 +450,53 @@ static int ext2_direct_scan(const char *device)
 		errstr(_("error (%d) while opening inode scan\n"), (int)error);
 		return -1;
 	}
+	inode_size = EXT2_INODE_SIZE(fs->super);
+	inode = e2fsck_allocate_memory(ctx, inode_size, "scratch inode");
+	if (!inode) {
+		errstr(_("error (%d) while allocating inode\n"), -ENOMEM);
+		return -1;
+	}
 
-	if ((error = ext2fs_get_next_inode(scan, &i_num, &inode))) {
+	if ((error = ext2fs_get_next_inode_full(scan, &i_num, inode, inode_size))) {
 		errstr(_("error (%d) while starting inode scan\n"), (int)error);
 		return -1;
 	}
 
 	while (i_num) {
+		/* keep off project quota inode here ? */
 		if ((i_num == EXT2_ROOT_INO ||
 		     i_num >= EXT2_FIRST_INO(fs->super)) &&
-		    inode.i_links_count) {
+		    inode->i_links_count) {
 			debug(FL_DEBUG, _("Found i_num %ld, blocks %ld\n"), (long)i_num, (long)inode.i_blocks);
 			if (flags & FL_VERBOSE)
 				blit(NULL);
-			uid = inode.i_uid | (inode.i_uid_high << 16);
-			gid = inode.i_gid | (inode.i_gid_high << 16);
-			if (inode.i_uid_high | inode.i_gid_high)
+			uid = inode->i_uid | (inode->i_uid_high << 16);
+			gid = inode->i_gid | (inode->i_gid_high << 16);
+			if (inode->i_uid_high | inode->i_gid_high)
 				debug(FL_DEBUG, _("High uid detected.\n"));
+			inode_size = EXT2_GOOD_OLD_INODE_SIZE +
+					inode->i_extra_isize;
+			if (inode_includes(inode_size, i_projid))
+				projid = inode->i_projid;
 			if (ucheck)
-				add_to_quota(USRQUOTA, i_num, uid, gid,
-					     inode.i_mode, inode.i_links_count,
-					     ((loff_t)inode.i_blocks) << 9, 0);
+				add_to_quota(USRQUOTA, i_num, uid, gid, projid,
+					     inode->i_mode, inode->i_links_count,
+					     ((loff_t)inode->i_blocks) << 9, 0);
 			if (gcheck)
-				add_to_quota(GRPQUOTA, i_num, uid, gid,
-					     inode.i_mode, inode.i_links_count,
-					     ((loff_t)inode.i_blocks) << 9, 0);
-			if (S_ISDIR(inode.i_mode))
+				add_to_quota(GRPQUOTA, i_num, uid, gid, projid,
+					     inode->i_mode, inode->i_links_count,
+					     ((loff_t)inode->i_blocks) << 9, 0);
+			if (pcheck)
+				add_to_quota(PRJQUOTA, i_num, uid, gid, projid,
+					     inode->i_mode, inode->i_links_count,
+					     ((loff_t)inode->i_blocks) << 9, 0);
+			if (S_ISDIR(inode->i_mode))
 				dirs_done++;
 			else
 				files_done++;
 		}
 
-		if ((error = ext2fs_get_next_inode(scan, &i_num, &inode))) {
+		if ((error = ext2fs_get_next_inode_full(scan, &i_num, inode, inode_size))) {
 			errstr(_("Something weird happened while scanning. Error %d\n"), (int)error);
 			return -1;
 		}
@@ -481,6 +505,29 @@ static int ext2_direct_scan(const char *device)
 }
 #endif
 
+static int fgetproject(const char *name, unsigned long *project)
+{
+#ifndef FS_IOC_FSGETXATTR
+	errno = EOPNOTSUPP;
+	return -1;
+#else
+	int fd, r, save_errno = 0;
+	struct fsxattr fsx;
+
+	fd = open (name, O_RDONLY);
+	if (fd == -1)
+		return -1;
+	r = ioctl (fd, FS_IOC_FSGETXATTR, &fsx);
+	if (r == 0)
+		*project = fsx.fsx_projid;
+	save_errno = errno;
+	close (fd);
+	if (save_errno)
+		errno = save_errno;
+	return r;
+#endif
+}
+
 /*
  * Scan a directory with the readdir systemcall. Stat the files and add the sizes
  * of the files to the appropriate quotas. When we find a dir we recursivly call
@@ -493,6 +540,7 @@ static int scan_dir(const char *pathname)
 	struct dirent *de;
 	struct stat st;
 	loff_t qspace;
+	unsigned long projid;
 	DIR *dp;
 	int ret;
 
@@ -500,13 +548,20 @@ static int scan_dir(const char *pathname)
 		errstr(_("Cannot stat directory %s: %s\n"), pathname, strerror(errno));
 		goto out;
 	}
+
+	if (fgetproject(pathname, &projid)) 
+		projid = 0;
+
 	qspace = getqsize(pathname, &st);
 	if (ucheck)
-		add_to_quota(USRQUOTA, st.st_ino, st.st_uid, st.st_gid, st.st_mode,
-			     st.st_nlink, qspace, 0);
+		add_to_quota(USRQUOTA, st.st_ino, st.st_uid, st.st_gid, projid,
+			     st.st_mode, st.st_nlink, qspace, 0);
 	if (gcheck)
-		add_to_quota(GRPQUOTA, st.st_ino, st.st_uid, st.st_gid, st.st_mode,
-			     st.st_nlink, qspace, 0);
+		add_to_quota(GRPQUOTA, st.st_ino, st.st_uid, st.st_gid, projid,
+			     st.st_mode, st.st_nlink, qspace, 0);
+	if (pcheck)
+		add_to_quota(PRJQUOTA, st.st_ino, st.st_uid, st.st_gid, projid,
+			     st.st_mode, st.st_nlink, qspace, 0);
 
 	if ((dp = opendir(pathname)) == (DIR *) NULL)
 		die(2, _("\nCan open directory %s: %s\n"), pathname, strerror(errno));
@@ -541,13 +596,18 @@ static int scan_dir(const char *pathname)
 			dir_stack = new_dir;
 		}
 		else {
+			if (fgetproject(de->d_name, &projid)) 
+				projid = 0;
 			qspace = getqsize(de->d_name, &st);
 			if (ucheck)
-				add_to_quota(USRQUOTA, st.st_ino, st.st_uid, st.st_gid, st.st_mode,
-					     st.st_nlink, qspace, 1);
+				add_to_quota(USRQUOTA, st.st_ino, st.st_uid, st.st_gid, projid,
+					     st.st_mode, st.st_nlink, qspace, 1);
 			if (gcheck)
-				add_to_quota(GRPQUOTA, st.st_ino, st.st_uid, st.st_gid, st.st_mode,
-					     st.st_nlink, qspace, 1);
+				add_to_quota(GRPQUOTA, st.st_ino, st.st_uid, st.st_gid, projid,
+					     st.st_mode, st.st_nlink, qspace, 1);
+			if (pcheck)
+				add_to_quota(PRJQUOTA, st.st_ino, st.st_uid, st.st_gid, projid,
+					     st.st_mode, st.st_nlink, qspace, 1);
 			debug(FL_DEBUG, _("\tAdding %s size %lld ino %d links %d uid %u gid %u\n"), de->d_name,
 			      (long long)st.st_size, (int)st.st_ino, (int)st.st_nlink, (int)st.st_uid, (int)st.st_gid);
 			files_done++;
@@ -930,7 +990,10 @@ static int check_dir(struct mount_entry *mnt)
 	if (gcheck)
 		if (process_file(mnt, GRPQUOTA) < 0)
 			gcheck = 0;
-	if (!ucheck && !gcheck)	/* Nothing to check? */
+	if (pcheck)
+		if (process_file(mnt, PRJQUOTA) < 0)
+			pcheck = 0;
+	if (!ucheck && !gcheck && !pcheck)	/* Nothing to check? */
 		return 0;
 	if (!(flags & FL_NOREMOUNT)) {
 		/* Now we try to remount fs read-only to prevent races when scanning filesystem */
@@ -959,7 +1022,8 @@ Please stop all programs writing to filesystem or use -m flag to force checking.
 start_scan:
 	debug(FL_VERBOSE | FL_DEBUG, _("Scanning %s [%s] "), mnt->me_devname, mnt->me_dir);
 #if defined(EXT2_DIRECT)
-	if (!strcmp(mnt->me_type, MNTTYPE_EXT2) || !strcmp(mnt->me_type, MNTTYPE_EXT3) || !strcmp(mnt->me_type, MNTTYPE_NEXT3)) {
+	if (!strcmp(mnt->me_type, MNTTYPE_EXT2) || !strcmp(mnt->me_type, MNTTYPE_EXT3) ||
+	    !strcmp(mnt->me_type, MNTTYPE_NEXT3) || !strcmp(mnt->me_type, MNTTYPE_EXT4)) {
 		if ((failed = ext2_direct_scan(mnt->me_devname)) < 0)
 			goto out;
 	}
@@ -975,13 +1039,21 @@ start_scan:
 	dirs_done++;
 	if (flags & FL_VERBOSE || flags & FL_DEBUG)
 		fputs(_("done\n"), stdout);
+	/* skip this for project quota */
 	if (ucheck) {
 		failed |= sub_quota_file(mnt, USRQUOTA, USRQUOTA);
 		failed |= sub_quota_file(mnt, USRQUOTA, GRPQUOTA);
+		failed |= sub_quota_file(mnt, USRQUOTA, PRJQUOTA);
 	}
 	if (gcheck) {
 		failed |= sub_quota_file(mnt, GRPQUOTA, USRQUOTA);
 		failed |= sub_quota_file(mnt, GRPQUOTA, GRPQUOTA);
+		failed |= sub_quota_file(mnt, GRPQUOTA, PRJQUOTA);
+	}
+	if (pcheck) {
+		failed |= sub_quota_file(mnt, PRJQUOTA, USRQUOTA);
+		failed |= sub_quota_file(mnt, PRJQUOTA, GRPQUOTA);
+		failed |= sub_quota_file(mnt, PRJQUOTA, PRJQUOTA);
 	}
 	debug(FL_DEBUG | FL_VERBOSE, _("Checked %d directories and %d files\n"), dirs_done,
 	      files_done);
@@ -994,6 +1066,8 @@ start_scan:
 		failed |= dump_to_file(mnt, USRQUOTA);
 	if (gcheck)
 		failed |= dump_to_file(mnt, GRPQUOTA);
+	if (pcheck)
+		failed |= dump_to_file(mnt, PRJQUOTA);
 out:
 	remove_list();
 	return failed;
@@ -1022,13 +1096,20 @@ static int detect_filename_format(struct mount_entry *mnt, int type)
 		else if ((option = str_hasmntopt(mnt->me_opts, MNTOPT_QUOTA)))
 			option += strlen(MNTOPT_QUOTA);
 	}
-	else {
+	else if (type == USRQUOTA){
 		if ((option = str_hasmntopt(mnt->me_opts, MNTOPT_GRPQUOTA)))
 			option += strlen(MNTOPT_GRPQUOTA);
 		else if ((option = str_hasmntopt(mnt->me_opts, MNTOPT_GRPJQUOTA))) {
 			journal = 1;
 			option += strlen(MNTOPT_GRPJQUOTA);
 		}
+	} else {
+		if ((option = str_hasmntopt(mnt->me_opts, MNTOPT_PRJQUOTA)))
+			option += strlen(MNTOPT_PRJQUOTA);
+		else if ((option = str_hasmntopt(mnt->me_opts, MNTOPT_PRJJQUOTA))) {
+			journal = 1;
+			option += strlen(MNTOPT_PRJJQUOTA);
+		}
 	}
 	if (!option)
 		die(2, _("Cannot find quota option on filesystem %s with quotas!\n"), mnt->me_dir);
@@ -1154,10 +1235,21 @@ static int check_all(void)
 			gcheck = 1;
 		else
 			gcheck = 0;
-		if (!ucheck && !gcheck)
+		if (pwant && me_hasquota(mnt, PRJQUOTA))
+			pcheck = 1;
+		else
+			pcheck = 0;
+		if (!ucheck && !gcheck && !pcheck)
 			continue;
 		if (cfmt == -1) {
-			cfmt = detect_filename_format(mnt, ucheck ? USRQUOTA : GRPQUOTA);
+			int qtype;
+			if (ucheck)
+				qtype = USRQUOTA;
+			else if (gcheck)
+				qtype = GRPQUOTA;
+			else
+				qtype = PRJQUOTA;
+			cfmt = detect_filename_format(mnt, qtype);
 			if (cfmt == -1) {
 				errstr(_("Cannot guess format from filename on %s. Please specify format on commandline.\n"),
 					mnt->me_devname);
@@ -1170,6 +1262,7 @@ static int check_all(void)
 		if (flags & (FL_VERBOSE | FL_DEBUG) &&
 		    !str_hasmntopt(mnt->me_opts, MNTOPT_USRJQUOTA) &&
 		    !str_hasmntopt(mnt->me_opts, MNTOPT_GRPJQUOTA) &&
+		    !str_hasmntopt(mnt->me_opts, MNTOPT_PRJJQUOTA) &&
 		    !warned &&
 		    (!strcmp(mnt->me_type, MNTTYPE_EXT3) ||
 		     !strcmp(mnt->me_type, MNTTYPE_EXT4) ||
diff --git a/quotacheck.h b/quotacheck.h
index 0abdaaa..4d5456b 100644
--- a/quotacheck.h
+++ b/quotacheck.h
@@ -35,6 +35,23 @@ extern size_t malloc_mem = 0;
 extern size_t free_mem = 0;
 #endif
 
+#if !defined(FS_IOC_FSGETXATTR)
+#define FS_IOC_FSGETXATTR		_IOR('X', 31, struct fsxattr)
+#define FS_IOC_FSSETXATTR		_IOW('X', 32, struct fsxattr)
+
+/*
+ * Structure for FS_IOC_FSGETXATTR and FS_IOC_FSSETXATTR.
+ */
+struct fsxattr {
+	__u32		fsx_xflags;	/* xflags field value (get/set) */
+	__u32		fsx_extsize;	/* extsize field value (get/set)*/
+	__u32		fsx_nextents;	/* nextents field value (get)	*/
+	__u32		fsx_projid;	/* project identifier (get/set) */
+	unsigned char	fsx_pad[12];
+};
+#endif
+
+
 void *xmalloc(size_t size);
 void debug(int df, char *fmtstr, ...) __attribute__ ((__format__ (__printf__, 2, 3)));
 int ask_yn(char *q, int def);
diff --git a/quotaio_v2.h b/quotaio_v2.h
index 197bb65..3b5bad1 100644
--- a/quotaio_v2.h
+++ b/quotaio_v2.h
@@ -11,7 +11,7 @@
 #include "quota.h"
 
 #define V2_DQINFOOFF	sizeof(struct v2_disk_dqheader)	/* Offset of info header in file */
-#define INIT_V2_VERSIONS { 1, 1}
+#define INIT_V2_VERSIONS { 1, 1, 1}
 
 struct v2_disk_dqheader {
 	u_int32_t dqh_magic;	/* Magic number identifying file */
diff --git a/quotasys.c b/quotasys.c
index c78e02c..8560dca 100644
--- a/quotasys.c
+++ b/quotasys.c
@@ -783,6 +783,8 @@ static int hasquota(const char *dev, struct mntent *mnt, int type, int flags)
 		return QF_VFSUNKNOWN;
 	if ((type == GRPQUOTA) && (hasmntopt(mnt, MNTOPT_GRPQUOTA) || hasmntoptarg(mnt->mnt_opts, MNTOPT_GRPJQUOTA)))
 		return QF_VFSUNKNOWN;
+	if ((type == PRJQUOTA) && (hasmntopt(mnt, MNTOPT_PRJQUOTA) || hasmntoptarg(mnt->mnt_opts, MNTOPT_PRJJQUOTA)))
+		return QF_VFSUNKNOWN;
 	if ((type == USRQUOTA) && hasmntopt(mnt, MNTOPT_QUOTA))
 		return QF_VFSUNKNOWN;
 	return -1;
@@ -862,6 +864,14 @@ int get_qf_name(struct mount_entry *mnt, int type, int fmt, int flags, char **fi
 			has_quota_file_definition = 1;
 			pathname++;
 		}
+	} else if (type == PRJQUOTA && (option = str_hasmntopt(mnt->me_opts, MNTOPT_PRJQUOTA))) {
+		if (*(pathname = option + strlen(MNTOPT_PRJQUOTA)) == '=')
+			has_quota_file_definition = 1;
+	} else if (type == PRJQUOTA && (option = hasmntoptarg(mnt->me_opts, MNTOPT_PRJJQUOTA))) {
+		pathname = option;
+		has_quota_file_definition = 1;
+		sstrncpy(qfullname, mnt->me_dir, sizeof(qfullname));
+		sstrncat(qfullname, "/", sizeof(qfullname));
 	}
 	else
 		return -1;
-- 
2.7.4

