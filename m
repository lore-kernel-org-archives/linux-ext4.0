From: Andreas Dilger <adilger@dilger.ca>
Subject: Re: [PATCH 4/5] tune2fs: Add support for turning on quota feature
Date: Fri, 9 Sep 2011 16:39:59 -0600
Message-ID: <A8E4523A-14F7-42F3-87F5-BA945DF8FBF3@dilger.ca>
References: <1311187206-30553-1-git-send-email-adityakali@google.com> <1311187206-30553-5-git-send-email-adityakali@google.com>
Mime-Version: 1.0 (Apple Message framework v1084)
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
Cc: linux-ext4@vger.kernel.org
To: Aditya Kali <adityakali@google.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from idcmail-mo2no.shaw.ca ([64.59.134.9]:18457 "EHLO
	idcmail-mo2no.shaw.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758853Ab1IIWkD convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 9 Sep 2011 18:40:03 -0400
In-Reply-To: <1311187206-30553-5-git-send-email-adityakali@google.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 2011-07-20, at 12:40 PM, Aditya Kali wrote:
> This patch adds support for setting the quota feature in superblock
> and allows selectively creating quota inodes (user or group or both)
> in the superblock. Currently, modifying the quota feature is only
> supported when the filesystem is unmounted.
> Also, when setting the quota feature, tune2fs will use aquota.user or
> aquota.group file inode number in superblock if these files exist.
> Otherwise it will initialize empty quota inodes #3 and #4 and use them.
> 
> Here is how it works:
> # Set quota feature and initialize both (user and group) quota inodes
> $ tune2fs -O quota /dev/ram1
> 
> # Enable only one type of quota
> $ tune2fs -Q usrquota /dev/ram1

I was looking at this patch, and would like some clarification.  Does
enabling quota also update the quota files from the filesystem, or
does that need a full e2fsck?  On large filesystems, it would be very
desirable to allow enabling the quota by having tune2fs do a fast inode
table scan (which can complete in a couple of minutes even for a large
filesystem) instead of potentially hours.

It looks like it would be enough to call compute_quota() after the quota
files are opened, before release_quota_context() is called.  In our past
experience, scanning just the inode table for quotas on large filesystems
only takes a few minutes.  Also, this avoids the need to exit from tune2fs
with the RO_COMPAT_QUOTA feature enabled, but the filesystem is not valid
because the quota file is empty, and in fact the below code doesn't even
warn that e2fsck needs to be run.

> # Enable grpquota, disable usrquota
> $ tune2fs -Q ^usrquota,grpquota /dev/ram1
> 
> # Clear quota feature and remove quota inodes
> $ tune2fs -O ^quota /dev/ram1
> 
> Signed-off-by: Aditya Kali <adityakali@google.com>
> ---
> misc/Makefile.in  |   14 +++--
> misc/tune2fs.8.in |   15 +++++
> misc/tune2fs.c    |  148 +++++++++++++++++++++++++++++++++++++++++++++++++++--
> 3 files changed, 167 insertions(+), 10 deletions(-)
> 
> diff --git a/misc/Makefile.in b/misc/Makefile.in
> index 2f7908c..a23adcd 100644
> --- a/misc/Makefile.in
> +++ b/misc/Makefile.in
> @@ -143,24 +143,26 @@ e2initrd_helper: e2initrd_helper.o $(DEPLIBS) $(DEPLIBBLKID) $(LIBEXT2FS)
> 		$(LIBBLKID) $(LIBEXT2FS) $(LIBINTL)
> 
> tune2fs: $(TUNE2FS_OBJS) $(DEPLIBS) $(DEPLIBS_E2P) $(DEPLIBBLKID) \
> -		$(DEPLIBUUID) $(LIBEXT2FS) 
> +		$(DEPLIBUUID) $(DEPLIBQUOTA) $(LIBEXT2FS)
> 	$(E) "	LD $@"
> 	$(Q) $(CC) $(ALL_LDFLAGS) -o tune2fs $(TUNE2FS_OBJS) $(LIBS) \
> -		$(LIBBLKID) $(LIBUUID) $(LIBEXT2FS) $(LIBS_E2P) $(LIBINTL)
> +		$(LIBBLKID) $(LIBUUID) $(LIBQUOTA) $(LIBEXT2FS) $(LIBS_E2P) \
> +		$(LIBINTL)
> 
> tune2fs.static: $(TUNE2FS_OBJS) $(STATIC_DEPLIBS) $(STATIC_LIBE2P) $(DEPSTATIC_LIBBLKID)
> 	$(E) "	LD $@"
> 	$(Q) $(CC) $(LDFLAGS_STATIC) -o tune2fs.static $(TUNE2FS_OBJS) \
> 		$(STATIC_LIBS) $(STATIC_LIBBLKID) $(STATIC_LIBUUID) \
> -		$(STATIC_LIBE2P) $(LIBINTL)
> +		$(STATIC_LIBQUOTA) $(STATIC_LIBE2P) $(LIBINTL)
> 
> tune2fs.profiled: $(PROFILED_TUNE2FS_OBJS) $(PROFILED_DEPLIBS) \
> -		$(PROFILED_E2P) $(DEPPROFILED_LIBBLKID) $(DEPPROFILED_LIBUUID)
> +		$(PROFILED_E2P) $(DEPPROFILED_LIBBLKID) $(DEPPROFILED_LIBUUID) \
> +		$(DEPPROFILED_LIBQUOTA)
> 	$(E) "	LD $@"
> 	$(Q) $(CC) $(ALL_LDFLAGS) -g -pg -o tune2fs.profiled \
> 		$(PROFILED_TUNE2FS_OBJS) $(PROFILED_LIBBLKID) \
> -		$(PROFILED_LIBUUID) $(PROFILED_LIBE2P) $(LIBINTL) \
> -		$(PROFILED_LIBS) 
> +		$(PROFILED_LIBUUID) $(PROFILED_LIBQUOTA) $(PROFILED_LIBE2P) \
> +		$(LIBINTL) $(PROFILED_LIBS)
> 
> blkid: $(BLKID_OBJS) $(DEPLIBBLKID) $(LIBEXT2FS)
> 	$(E) "	LD $@"
> diff --git a/misc/tune2fs.8.in b/misc/tune2fs.8.in
> index 233f85a..89bc1d9 100644
> --- a/misc/tune2fs.8.in
> +++ b/misc/tune2fs.8.in
> @@ -77,6 +77,11 @@ tune2fs \- adjust tunable filesystem parameters on ext2/ext3/ext4 filesystems
> .RI [^] feature [,...]
> ]
> [
> +.B \-Q
> +.I quota-options
> +]
> +[
> +[
> .B \-T
> .I time-last-checked
> ]
> @@ -561,6 +566,16 @@ features are only supported by the ext4 filesystem.
> .BI \-r " reserved-blocks-count"
> Set the number of reserved filesystem blocks.
> .TP
> +.BI \-Q " quota-options"
> +Sets 'quota' feature on the superblock and works on the quota files for the
> +given quota type. Quota options could be one or more of the following:
> +.RS 1.2i
> +.TP
> +.BR [^]usrquota
> +Sets/clears user quota inode in the superblock.
> +.BR [^]usrquota
> +Sets/clears group quota inode in the superblock.
> +.TP
> .BI \-T " time-last-checked"
> Set the time the filesystem was last checked using
> .BR  e2fsck .
> diff --git a/misc/tune2fs.c b/misc/tune2fs.c
> index 5bf5187..3c81898 100644
> --- a/misc/tune2fs.c
> +++ b/misc/tune2fs.c
> @@ -55,16 +55,22 @@ extern int optind;
> #include "jfs_user.h"
> #include "util.h"
> #include "blkid/blkid.h"
> +#include "quota/mkquota.h"
> 
> #include "../version.h"
> #include "nls-enable.h"
> 
> +#define QOPT_ENABLE	(1)
> +#define QOPT_DISABLE	(-1)
> +
> +extern int ask_yn(const char *string, int def);
> +
> const char *program_name = "tune2fs";
> char *device_name;
> char *new_label, *new_last_mounted, *new_UUID;
> char *io_options;
> static int c_flag, C_flag, e_flag, f_flag, g_flag, i_flag, l_flag, L_flag;
> -static int m_flag, M_flag, r_flag, s_flag = -1, u_flag, U_flag, T_flag;
> +static int m_flag, M_flag, Q_flag, r_flag, s_flag = -1, u_flag, U_flag, T_flag;
> static int I_flag;
> static time_t last_check_time;
> static int print_label;
> @@ -82,6 +88,7 @@ static int stride_set, stripe_width_set;
> static char *extended_cmd;
> static unsigned long new_inode_size;
> static char *ext_mount_opts;
> +static int usrquota, grpquota;
> 
> int journal_size, journal_flags;
> char *journal_device;
> @@ -131,7 +138,8 @@ static __u32 ok_features[3] = {
> 		EXT4_FEATURE_RO_COMPAT_DIR_NLINK|
> 		EXT4_FEATURE_RO_COMPAT_EXTRA_ISIZE|
> 		EXT4_FEATURE_RO_COMPAT_GDT_CSUM |
> -		EXT2_FEATURE_RO_COMPAT_SPARSE_SUPER
> +		EXT2_FEATURE_RO_COMPAT_SPARSE_SUPER |
> +		EXT4_FEATURE_RO_COMPAT_QUOTA
> };
> 
> static __u32 clear_ok_features[3] = {
> @@ -147,7 +155,8 @@ static __u32 clear_ok_features[3] = {
> 		EXT4_FEATURE_RO_COMPAT_HUGE_FILE|
> 		EXT4_FEATURE_RO_COMPAT_DIR_NLINK|
> 		EXT4_FEATURE_RO_COMPAT_EXTRA_ISIZE|
> -		EXT4_FEATURE_RO_COMPAT_GDT_CSUM
> +		EXT4_FEATURE_RO_COMPAT_GDT_CSUM |
> +		EXT4_FEATURE_RO_COMPAT_QUOTA
> };
> 
> /*
> @@ -477,6 +486,36 @@ static void update_feature_set(ext2_filsys fs, char *features)
> 		fs->flags &= ~EXT2_FLAG_SUPER_ONLY;
> 	}
> 
> +	if (FEATURE_ON(E2P_FEATURE_RO_INCOMPAT,
> +				EXT4_FEATURE_RO_COMPAT_QUOTA)) {
> +		/*
> +		 * Set the Q_flag here and handle the quota options in the code
> +		 * below.
> +		 */
> +		if (!Q_flag) {
> +			Q_flag = 1;
> +			/* Enable both user quota and group quota by default */
> +			usrquota = QOPT_ENABLE;
> +			grpquota = QOPT_ENABLE;
> +		}
> +		sb->s_feature_ro_compat &= ~EXT4_FEATURE_RO_COMPAT_QUOTA;
> +	}
> +
> +	if (FEATURE_OFF(E2P_FEATURE_RO_INCOMPAT,
> +				EXT4_FEATURE_RO_COMPAT_QUOTA)) {
> +		/*
> +		 * Set the Q_flag here and handle the quota options in the code
> +		 * below.
> +		 */
> +		if (Q_flag)
> +			fputs(_("\nWarning: '^quota' option overrides '-Q'"
> +				"arguments.\n"), stderr);
> +		Q_flag = 1;
> +		/* Disable both user quota and group quota by default */
> +		usrquota = QOPT_DISABLE;
> +		grpquota = QOPT_DISABLE;
> +	}
> +
> 	if (sb->s_rev_level == EXT2_GOOD_OLD_REV &&
> 	    (sb->s_feature_compat || sb->s_feature_ro_compat ||
> 	     sb->s_feature_incompat))
> @@ -576,6 +615,93 @@ err:
> 	exit(1);
> }
> 
> +void handle_quota_options(ext2_filsys fs)
> +{
> +	quota_ctx_t qctx;
> +	errcode_t retval;
> +	ext2_ino_t qf_ino;
> +
> +	if (!usrquota && !grpquota)
> +		/* Nothing to do. */
> +		return;
> +
> +	init_quota_context(&qctx, fs, -1);
> +
> +	if (usrquota == QOPT_ENABLE && !fs->super->s_usr_quota_inum) {
> +		if ((qf_ino = quota_file_exists(fs, USRQUOTA, QFMT_VFS_V1)) > 0)
> +			set_sb_quota_inum(fs, qf_ino, USRQUOTA);
> +		else
> +			write_quota_inode(qctx, USRQUOTA);
> +	} else if (usrquota == QOPT_DISABLE) {
> +		remove_quota_inode(fs, USRQUOTA);
> +	}
> +
> +	if (grpquota == QOPT_ENABLE && !fs->super->s_grp_quota_inum) {
> +		if ((qf_ino = quota_file_exists(fs, GRPQUOTA, QFMT_VFS_V1)) > 0)
> +			set_sb_quota_inum(fs, qf_ino, GRPQUOTA);
> +		else
> +			write_quota_inode(qctx, GRPQUOTA);
> +	} else if (grpquota == QOPT_DISABLE) {
> +		remove_quota_inode(fs, GRPQUOTA);
> +	}
> +
> +	release_quota_context(&qctx);
> +
> +	if ((usrquota == QOPT_ENABLE) || (grpquota == QOPT_ENABLE)) {
> +		fs->super->s_feature_ro_compat |= EXT4_FEATURE_RO_COMPAT_QUOTA;
> +		ext2fs_mark_super_dirty(fs);
> +	} else if ((usrquota == QOPT_DISABLE) && (grpquota == QOPT_DISABLE)) {
> +		fs->super->s_feature_ro_compat &= ~EXT4_FEATURE_RO_COMPAT_QUOTA;
> +		ext2fs_mark_super_dirty(fs);
> +	}
> +
> +	return;
> +}
> +
> +void parse_quota_opts(const char *opts)
> +{
> +	char	*buf, *token, *next, *p, *arg;
> +	int	len;
> +
> +	len = strlen(opts);
> +	buf = malloc(len+1);
> +	if (!buf) {
> +		fputs(_("Couldn't allocate memory to parse quota "
> +			"options!\n"), stderr);
> +		exit(1);
> +	}
> +	strcpy(buf, opts);
> +	for (token = buf; token && *token; token = next) {
> +		p = strchr(token, ',');
> +		next = 0;
> +		if (p) {
> +			*p = 0;
> +			next = p+1;
> +		}
> +
> +		if (strcmp(token, "usrquota") == 0) {
> +			usrquota = QOPT_ENABLE;
> +		} else if (strcmp(token, "^usrquota") == 0) {
> +			usrquota = QOPT_DISABLE;
> +		} else if (strcmp(token, "grpquota") == 0) {
> +			grpquota = QOPT_ENABLE;
> +		} else if (strcmp(token, "^grpquota") == 0) {
> +			grpquota = QOPT_DISABLE;
> +		} else {
> +			fputs(_("\nBad quota options specified.\n\n"
> +				"Following valid quota options are available "
> +				"(pass by separating with comma):\n"
> +				"\t[^]usrquota\n"
> +				"\t[^]grpquota\n"
> +				"\n\n"), stderr);
> +			free(buf);
> +			exit(1);
> +		}
> +	}
> +	free(buf);
> +}
> +
> +
> 
> static void parse_e2label_options(int argc, char ** argv)
> {
> @@ -641,7 +767,7 @@ static void parse_tune2fs_options(int argc, char **argv)
> 	open_flag = 0;
> 
> 	printf("tune2fs %s (%s)\n", E2FSPROGS_VERSION, E2FSPROGS_DATE);
> -	while ((c = getopt(argc, argv, "c:e:fg:i:jlm:o:r:s:u:C:E:I:J:L:M:O:T:U:")) != EOF)
> +	while ((c = getopt(argc, argv, "c:e:fg:i:jlm:o:r:s:u:C:E:I:J:L:M:O:Q:T:U:")) != EOF)
> 		switch (c) {
> 		case 'c':
> 			max_mount_count = strtol(optarg, &tmp, 0);
> @@ -796,6 +922,11 @@ static void parse_tune2fs_options(int argc, char **argv)
> 			features_cmd = optarg;
> 			open_flag = EXT2_FLAG_RW;
> 			break;
> +		case 'Q':
> +			Q_flag = 1;
> +			parse_quota_opts(optarg);
> +			open_flag = EXT2_FLAG_RW;
> +			break;
> 		case 'r':
> 			reserved_blocks = strtoul(optarg, &tmp, 0);
> 			if (*tmp) {
> @@ -1790,6 +1921,15 @@ retry_open:
> 	if (journal_size || journal_device)
> 		add_journal(fs);
> 
> +	if (Q_flag) {
> +		if (mount_flags & EXT2_MF_MOUNTED) {
> +			fputs(_("The quota feature may only be changed when "
> +				"the filesystem is unmounted.\n"), stderr);
> +			exit(1);
> +		}
> +		handle_quota_options(fs);
> +	}
> +
> 	if (U_flag) {
> 		int set_csum = 0;
> 		dgrp_t i;
> -- 
> 1.7.3.1
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


Cheers, Andreas





