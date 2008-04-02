From: "Theodore Ts'o" <tytso@mit.edu>
Subject: (Hopefully) final version of the mke2fs types patch
Date: Wed, 02 Apr 2008 11:06:31 -0400
Message-ID: <E1Jh4Xm-0007wL-W8@closure.thunk.org>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from www.church-of-our-saviour.ORG ([69.25.196.31]:53315 "EHLO
	thunker.thunk.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755097AbYDBPGk (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 2 Apr 2008 11:06:40 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


I plan to merge this into e2fsprogs mainline shortly, the design is
slightly different from before, based on the conversations between Eric
and I.

						- Ted

>From 3cd4f0366aae974b280f9416910a2fc164e9ebd8 Mon Sep 17 00:00:00 2001
From: Theodore Ts'o <tytso@mit.edu>
Date: Tue, 19 Feb 2008 08:32:58 -0500
Subject: [PATCH] New mke2fs filesystem and usage types support

Provide mke2fs with a much more sophisticated system for controlling
configuration parameters of a newly created filesystem based on a
split filesystem and usage type system.  The -t option to mke2fs was a
deprecated alias to -c; it now specifies a filesystem type (ext2,
ext3, ext4, etc.), while the -T option can now be a comma separated
usage list.

Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
---
 misc/mke2fs.8.in      |   61 ++++++++++---
 misc/mke2fs.c         |  242 +++++++++++++++++++++++++++++++++++++++++-------
 misc/mke2fs.conf      |    9 ++
 misc/mke2fs.conf.5.in |  152 +++++++++++++++++++++++++------
 tests/Makefile.in     |    7 +-
 tests/test_config     |    2 +-
 6 files changed, 395 insertions(+), 78 deletions(-)

diff --git a/misc/mke2fs.8.in b/misc/mke2fs.8.in
index 6cd10b1..a8977c7 100644
--- a/misc/mke2fs.8.in
+++ b/misc/mke2fs.8.in
@@ -88,8 +88,12 @@ mke2fs \- create an ext2/ext3 filesystem
 .B \-S
 ]
 [
+.B \-t
+.I fs-type
+]
+[
 .B \-T
-.I filesystem-type
+.I usage-type
 ]
 [
 .B \-V
@@ -384,19 +388,26 @@ executable.
 .TP
 .B "\-O \fIfeature\fR[,...]"
 Create filesystem with given features (filesystem options), overriding 
-the default filesystem options.  The default features which are 
+the default filesystem options.  The default features which are
 enabled by default are specified by the
 .I base_features
 relation, either in the
 .I [libdefaults]
 section in the
 .B /etc/mke2fs.conf
-configuration file, or in the subsection of the 
+configuration file,
+or in the subsection of the
 .I [fs_types]
-section for the filesystem type as specified by the
+section for the usage types as specified by the
 .B -T
-option.  The filesystem type-specific configuration setting found in
-the 
+option, further modified by the
+.I features
+relation found in the
+.I [fs_types] section
+based on the filesystem and usage types.  See the
+.BR mke2fs.conf (5)
+manual page for more details.
+The filesystem type-specific configuration setting found in the
 .I [fs_types]
 section will override the global default found in
 .IR [libdefaults] .
@@ -490,14 +501,40 @@ or there is no chance of recovery.
 .\" Check the device for bad blocks before creating the file system
 .\" using the specified test.
 .TP
-.BI \-T " fs-type"
+.BI
+.BI \-t " fs-type"
+Specify the filesystem (i.e., ext2, ext3, ext4, etc., is to be created.
+If this option is not specified mke2fs will pick a default either how
+the command was run (if it was run using a name of the form mkfs.ext2,
+mkfs.ext3, etc.) or via a default as defined by the
+.BR /etc/mke2fs.conf (5)
+file.
+.TP
+.BI \-T " usage-type[,...]"
 Specify how the filesystem is going to be used, so that 
 .B mke2fs 
-can choose optimal filesystem parameters for that use.  The filesystem
-types that are can be supported are defined in the configuration file 
-.BR /etc/mke2fs.conf (5).
-The default configuration file contains definitions for the filesystem
-types: small, floppy, news, largefile, and largefile4.  
+can choose optimal filesystem parameters for that use.  The usage
+types that are supported are defined in the configuration file 
+.BR /etc/mke2fs.conf (5).  
+The user may specify one or more usage types
+using a comma separated list.
+.sp
+If this option is is not specified,
+.B mke2fs
+will pick a single default usage type based on the size of the filesystem to 
+be created.  If the filesystem size is less than or equal to 3 megabytes,
+.BR mke2fs (8)
+will use the filesystem type 
+.IR floppy .
+If the filesystem size is greater than 3 but less than or equal to 
+512 megabytes, 
+.BR mke2fs (8)
+will use the filesystem
+.IR small .
+Otherwise, 
+.BR mke2fs (8)
+will use the default filesystem type
+.IR default .
 .TP
 .B \-v
 Verbose execution.
diff --git a/misc/mke2fs.c b/misc/mke2fs.c
index fd48b83..a58b116 100644
--- a/misc/mke2fs.c
+++ b/misc/mke2fs.c
@@ -956,6 +956,171 @@ static void edit_feature(const char *str, __u32 *compat_array)
 	}
 }
 
+struct str_list {
+	char **list;
+	int num;
+	int max;
+};
+
+static errcode_t init_list(struct str_list *sl)
+{
+	sl->num = 0;
+	sl->max = 0;
+	sl->list = malloc((sl->max+1) * sizeof(char *));
+	if (!sl->list)
+		return ENOMEM;
+	sl->list[0] = 0;
+	return 0;
+}
+
+static errcode_t push_string(struct str_list *sl, const char *str)
+{
+	char **new_list;
+
+	if (sl->num >= sl->max) {
+		sl->max += 2;
+		new_list = realloc(sl->list, (sl->max+1) * sizeof(char *));
+		if (!new_list)
+			return ENOMEM;
+		sl->list = new_list;
+	}
+	sl->list[sl->num] = malloc(strlen(str)+1);
+	if (sl->list[sl->num] == 0)
+		return ENOMEM;
+	strcpy(sl->list[sl->num], str);
+	sl->num++;
+	sl->list[sl->num] = 0;
+	return 0;
+}
+
+static void print_str_list(char **list)
+{
+	char **cpp;
+
+	for (cpp = list; *cpp; cpp++) {
+		printf("'%s'", *cpp);
+		if (cpp[1])
+			fputs(", ", stdout);
+	}
+	fputc('\n', stdout);
+}
+
+static char **parse_fs_type(const char *fs_type,
+			    const char *usage_types,
+			    struct ext2_super_block *fs_param,
+			    char *progname)
+{
+	const char	*ext_type = 0;
+	char		*parse_str;
+	char		*profile_type = 0;
+	char		*cp, *t;
+	const char	*size_type;
+	struct str_list	list;
+	int		state = 0;
+	unsigned long	meg;
+
+	if (init_list(&list))
+		return 0;
+
+	if (fs_type)
+		ext_type = fs_type;
+	else if (progname) {
+		ext_type = strrchr(progname, '/');
+		if (ext_type)
+			ext_type++;
+		else
+			ext_type = progname;
+
+		if (!strncmp(ext_type, "mkfs.", 5)) {
+			ext_type += 5;
+			if (ext_type[0] == 0)
+				ext_type = 0;
+		} else
+			ext_type = 0;
+	}
+
+	if (!ext_type) {
+		profile_get_string(profile, "defaults", "fs_type", 0,
+				   "ext2", &profile_type);
+		ext_type = profile_type;
+		if (!strcmp(ext_type, "ext2") && (journal_size != 0))
+			ext_type = "ext3";
+	}
+
+	meg = (1024 * 1024) / EXT2_BLOCK_SIZE(fs_param);
+	if (fs_param->s_blocks_count < 3 * meg)
+		size_type = "floppy";
+	else if (fs_param->s_blocks_count < 512 * meg)
+		size_type = "small";
+	else
+		size_type = "default";
+
+	if (!usage_types)
+		usage_types = size_type;
+
+	parse_str = malloc(usage_types ? strlen(usage_types)+1 : 1);
+	if (!parse_str) {
+		free(list.list);
+		return 0;
+	}
+	if (usage_types)
+		strcpy(parse_str, usage_types);
+	else
+		*parse_str = '\0';
+
+	if (ext_type)
+		push_string(&list, ext_type);
+	cp = parse_str;
+	while (1) {
+		t = strchr(cp, ',');
+		if (t)
+			*t = '\0';
+
+		if (*cp)
+			push_string(&list, cp);
+		if (t)
+			cp = t+1;
+		else {
+			cp = "";
+			break;
+		}
+	}
+	free(parse_str);
+	if (profile_type)
+		free(profile_type);
+	return (list.list);
+}
+
+static char *get_string_from_profile(char **fs_types, const char *opt,
+				     const char *def_val)
+{
+	char *ret = 0;
+	char **cpp;
+	int i;
+
+	for (i=0; fs_types[i]; i++);
+	for (i-=1; i >=0 ; i--) {
+		profile_get_string(profile, "fs_types", fs_types[i],
+				   opt, 0, &ret);
+		if (ret)
+			return ret;
+	}
+	profile_get_string(profile, "defaults", opt, 0, def_val, &ret);
+	return (ret);
+}
+
+static int get_int_from_profile(char **fs_types, const char *opt, int def_val)
+{
+	int ret;
+	char **cpp;
+
+	profile_get_integer(profile, "defaults", opt, 0, def_val, &ret);
+	for (cpp = fs_types; *cpp; cpp++)
+		profile_get_integer(profile, "fs_types", *cpp, opt, ret, &ret);
+	return ret;
+}
+
+
 extern const char *mke2fs_default_profile;
 static const char *default_files[] = { "<default>", 0 };
 
@@ -975,6 +1140,8 @@ static void PRS(int argc, char *argv[])
 	char *		oldpath = getenv("PATH");
 	char *		extended_opts = 0;
 	const char *	fs_type = 0;
+	const char *	usage_types = 0;
+	char		**fs_types;
 	blk_t		dev_size;
 #ifdef __linux__
 	struct 		utsname ut;
@@ -1049,7 +1216,7 @@ static void PRS(int argc, char *argv[])
 	}
 
 	while ((c = getopt (argc, argv,
-		    "b:cf:g:i:jl:m:no:qr:s:tvE:FI:J:L:M:N:O:R:ST:V")) != EOF) {
+		    "b:cf:g:i:jl:m:no:qr:s:t:vE:FI:J:L:M:N:O:R:ST:V")) != EOF) {
 		switch (c) {
 		case 'b':
 			blocksize = strtol(optarg, &tmp, 0);
@@ -1070,7 +1237,6 @@ static void PRS(int argc, char *argv[])
 						 EXT2_MIN_BLOCK_LOG_SIZE);
 			break;
 		case 'c':	/* Check for bad blocks */
-		case 't':	/* deprecated */
 			cflag++;
 			break;
 		case 'f':
@@ -1196,9 +1362,12 @@ static void PRS(int argc, char *argv[])
 		case 'S':
 			super_only = 1;
 			break;
-		case 'T':
+		case 't':
 			fs_type = optarg;
 			break;
+		case 'T':
+			usage_types = optarg;
+			break;
 		case 'V':
 			/* Print version number and exit */
 			show_version_only++;
@@ -1340,6 +1509,16 @@ static void PRS(int argc, char *argv[])
 		proceed_question();
 	}
 
+	fs_types = parse_fs_type(fs_type, usage_types, &fs_param, argv[0]);
+	if (!fs_types) {
+		fprintf(stderr, _("Failed to parse fs types list\n"));
+		exit(1);
+	}
+	if (verbose) {
+		fputs("Fs_types for mke2fs.conf resolution: ", stdout);
+		print_str_list(fs_types);
+	}
+
 	if (!fs_type) {
 		int megs = (__u64)fs_param.s_blocks_count *
 			(EXT2_BLOCK_SIZE(&fs_param) / 1024) / 1024;
@@ -1357,29 +1536,31 @@ static void PRS(int argc, char *argv[])
 
 	/* Figure out what features should be enabled */
 
-	tmp = tmp2 = NULL;
+	tmp = NULL;
 	if (fs_param.s_rev_level != EXT2_GOOD_OLD_REV) {
-		profile_get_string(profile, "defaults", "base_features", 0,
-				   "sparse_super,filetype,resize_inode,dir_index",
-				   &tmp);
-		profile_get_string(profile, "fs_types", fs_type, 
-				   "base_features", tmp, &tmp2);
-		edit_feature(tmp2, &fs_param.s_feature_compat);
+		char **cpp;
+
+		tmp = get_string_from_profile(fs_types, "base_features",
+		      "sparse_super,filetype,resize_inode,dir_index");
+		edit_feature(tmp, &fs_param.s_feature_compat);
 		free(tmp);
-		free(tmp2);
 
-		tmp = tmp2 = NULL;
-		profile_get_string(profile, "defaults", "default_features", 0,
-				   "", &tmp);
-		profile_get_string(profile, "fs_types", fs_type, 
-				   "default_features", tmp, &tmp2);
+		for (cpp = fs_types; *cpp; cpp++) {
+			tmp = NULL;
+			profile_get_string(profile, "fs_types", *cpp,
+					   "features", "", &tmp);
+			if (tmp && *tmp)
+				edit_feature(tmp, &fs_param.s_feature_compat);
+			if (tmp)
+				free(tmp);
+		}
+		tmp = get_string_from_profile(fs_types, "default_features",
+					      "");
 	}
-	edit_feature(fs_features ? fs_features : tmp2, 
+	edit_feature(fs_features ? fs_features : tmp,
 		     &fs_param.s_feature_compat);
 	if (tmp)
 		free(tmp);
-	if (tmp2)
-		free(tmp2);
 
 	if (r_opt == EXT2_GOOD_OLD_REV && 
 	    (fs_param.s_feature_compat || fs_param.s_feature_incompat ||
@@ -1437,10 +1618,7 @@ static void PRS(int argc, char *argv[])
 		sector_size = atoi(tmp);
 	
 	if (blocksize <= 0) {
-		profile_get_integer(profile, "defaults", "blocksize", 0,
-				    4096, &use_bsize);
-		profile_get_integer(profile, "fs_types", fs_type, 
-				    "blocksize", use_bsize, &use_bsize);
+		use_bsize = get_int_from_profile(fs_types, "blocksize", 4096);
 
 		if (use_bsize == -1) {
 			use_bsize = sys_page_size;
@@ -1457,12 +1635,8 @@ static void PRS(int argc, char *argv[])
 	}
 
 	if (inode_ratio == 0) {
-		profile_get_integer(profile, "defaults", "inode_ratio", 0,
-				    8192, &inode_ratio);
-		profile_get_integer(profile, "fs_types", fs_type, 
-				    "inode_ratio", inode_ratio, 
-				    &inode_ratio);
-
+		inode_ratio = get_int_from_profile(fs_types, "inode_ratio",
+						   8192);
 		if (inode_ratio < blocksize)
 			inode_ratio = blocksize;
 	}
@@ -1495,13 +1669,8 @@ static void PRS(int argc, char *argv[])
 		}
 	}
 
-	if (inode_size == 0) {
-		profile_get_integer(profile, "defaults", "inode_size", NULL,
-				    0, &inode_size);
-		profile_get_integer(profile, "fs_types", fs_type,
-				    "inode_size", inode_size,
-				    &inode_size);
-	}
+	if (inode_size == 0)
+		inode_size = get_int_from_profile(fs_types, "inode_size", 0);
 
 	if (inode_size && fs_param.s_rev_level >= EXT2_DYNAMIC_REV) {
 		if (inode_size < EXT2_GOOD_OLD_INODE_SIZE ||
@@ -1816,5 +1985,6 @@ no_journal:
 	val = ext2fs_close(fs);
 	remove_error_table(&et_ext2_error_table);
 	remove_error_table(&et_prof_error_table);
+	profile_release(profile);
 	return (retval || val) ? 1 : 0;
 }
diff --git a/misc/mke2fs.conf b/misc/mke2fs.conf
index d67593a..53f0e4d 100644
--- a/misc/mke2fs.conf
+++ b/misc/mke2fs.conf
@@ -5,6 +5,13 @@
 	inode_ratio = 16384
 
 [fs_types]
+	ext3 = {
+		features = has_journal
+	}
+	ext4 = {
+		features = extents,flex_bg,uninit_groups
+		inode_size = 256
+	}
 	small = {
 		blocksize = 1024
 		inode_size = 128
@@ -20,7 +27,9 @@
 	}
 	largefile = {
 		inode_ratio = 1048576
+		blocksize = -1
 	}
 	largefile4 = {
 		inode_ratio = 4194304
+		blocksize = -1
 	}
diff --git a/misc/mke2fs.conf.5.in b/misc/mke2fs.conf.5.in
index 6089031..03dd393 100644
--- a/misc/mke2fs.conf.5.in
+++ b/misc/mke2fs.conf.5.in
@@ -79,20 +79,6 @@ the
 .B -T
 option to
 .BR mke2fs (8).
-If no filesystem type is specified, 
-.BR mke2fs (8)
-will use the filesystem type 
-.I floppy
-if the filesystem size is less than or equal to 3 megabytes.  
-If the filesystem size is greater than 3 but less than or equal to 
-512 megabytes, 
-.BR mke2fs (8)
-will use the filesystem
-.IR small .
-Otherwise, 
-.BR mke2fs (8)
-will use the default filesystem type
-.IR default .
 .SH THE [defaults] STANZA
 The following relations are defined in the 
 .I [defaults]
@@ -102,7 +88,7 @@ stanza.
 This relation specifies the filesystems features which are enabled in
 newly created filesystems.  It may be overridden by the
 .I base_features
-relation found in the filesystem-type-specific subsection of
+relation found in the filesystem or usage type subsection of
 the
 .I [fs_types] 
 stanza.
@@ -113,7 +99,7 @@ removed to the features listed in the
 .I base_features
 relation.  It may be overridden by the filesystem-specific 
 .I default_features
-in the filesystem-type subsection of
+in the filesystem or usage type subsection of
 .IR [fs_types] ,
 and by the 
 .B -O
@@ -121,6 +107,23 @@ command-line option
 to 
 .BR mke2fs (8).
 .TP
+.I fs_type
+This relation specifies the default filesystem type if the user does not
+specify it via the
+.B \-t
+option, or if
+.B mke2fs
+is not started using a program name of the form
+.BI mkfs. fs-type\fR.
+If both the user and the
+.B mke2fs.conf
+file does not specify a default filesystem type, mke2fs will use a
+default filesystem type of
+.IR ext3
+if a journal was requested via a command-line option, or
+.I ext2
+if not.
+.TP
 .I blocksize
 This relation specifies the default blocksize if the user does not
 specify a blocksize on the command line, and the filesystem-type
@@ -140,16 +143,57 @@ inode size.
 .SH THE [fs_types] STANZA
 Each tag in the
 .I [fs_types] 
-stanza names a filesystem type which can be specified via the 
-.B -T
-option to
-.BR mke2fs (8).
-The value of the tag is a subsection where the relations in that
-subsection define the defaults for that filesystem type. For
-example:
+stanza names a filesystem type or usage type which can be specified via the 
+.B \-t 
+or
+.B \-T
+options to
+.BR mke2fs (8),
+respectively.
+.P
+The
+.B mke2fs
+program constructs a list of fs_types by concatenating the filesystem
+type (i.e., ext2, ext3, etc.) with the usage type list.  For most
+configuration options,
+.B mke2fs
+will look for a subsection in the
+.I [fs_types] 
+stanza corresponding with each entry in the constructed list, with later
+entries overriding earlier filesystem or usage types.
+For
+example, consider the following
+.B mke2fs.conf
+fragment:
 .P
+[defaults]
+.br
+	base_features = sparse_super,filetype,resize_inode,dir_index
+.br
+	blocksize = 4096
+.br
+	inode_size = 256
+.br
+	inode_ratio = 16384
+.br
+
+.br
 [fs_types]
 .br
+	ext3 = {
+.br
+		features = has_journal
+.br
+	}
+.br
+	ext4 = {
+.br
+		features = extents,flex_bg
+.br
+		inode_size = 256
+.br
+	}
+.br
 	small = {
 .br
 		blocksize = 1024
@@ -160,22 +204,76 @@ example:
 .br
 	floppy = {
 .br
+		features = ^resize_inode
+.br
 		blocksize = 1024
 .br
+		inode_size = 128
+.br
 	}
 .P
+If mke2fs started with a program name of
+.BR mke2fs.ext4 ,
+then the filesystem type of ext4 will be used.  If the filesystem is
+smaller than 3 megabytes, and no usage type is specified, then 
+.B mke2fs
+will use a default
+usage type of
+.IR floppy .
+This results in an fs_types list of "ext4, floppy".   Both the ext4
+subsection and the floppy subsection define an
+.I inode_size
+relation, but since the later entries in the fs_types list supercede
+earlier ones, the configuration parameter for fs_types.floppy.inode_size
+will be used, so the filesystem  will have an inode size of 128.
+.P
+The exception to this resolution is the
+.I features
+tag, which is specifies a set of changes to the features used by the
+filesystem, and which is cumulative.  So in the above example, first
+the configuration relation defaults.base_features would enable an
+initial feature set with the sparse_super, filetype, resize_inode, and
+dir_index features enabled.  Then configuration relation
+fs_types.ext4.features would enable the extents and flex_bg
+features, and finally the configuration relation
+fs_types.floppy.features would remove
+the resize_inode feature, resulting in a filesystem feature set
+consisting of the sparse_super, filetype, resize_inode, dir_index,
+extents_and flex_bg features.
+.P
 For each filesystem type, the following tags may be used in that 
 fs_type's subsection:
 .TP
 .I base_features
-This relation specifies the features which are enabled for this
-filesystem type.
+This relation specifies the features which are initially enabled for this
+filesystem type.  Only one
+.I base_features
+will be used, so if there are multiple entries in the fs_types list
+whose subsections define the
+.I base_features
+relation, only the last will be used by
+.BR mke2fs (8).
+.TP
+.I features
+This relation specifies a comma-separated list of features edit
+requests which modify the feature set
+used by the newly constructed filesystem.  The syntax is the same as the
+.B -O
+command-line option to
+.BR mke2fs (8);
+that is, a feature can be prefixed by a caret ('^') symbol to disable
+a named feature.  Each
+.I feature
+relation specified in the fs_types list will be applied in the order
+found in the fs_types list.
 .TP
 .I default_features
 This relation specifies set of features which should be enabled or 
-disabled to the features listed in the
+disabled after applying the features listed in the
 .I base_features
-relation.  It may be overridden by the 
+and
+.I features
+relations.  It may be overridden by the 
 .B -O
 command-line option to
 .BR mke2fs (8).
diff --git a/tests/Makefile.in b/tests/Makefile.in
index f9d5d78..2c3ac76 100644
--- a/tests/Makefile.in
+++ b/tests/Makefile.in
@@ -13,7 +13,7 @@ INSTALL = @INSTALL@
 
 all:: @DO_TEST_SUITE@
 
-test_script: test_script.in Makefile
+test_script: test_script.in Makefile mke2fs.conf
 	@echo "Creating test_script..."
 	@echo "#!/bin/sh" > test_script
 @HTREE_CMT@	@echo "HTREE=y" >> test_script
@@ -23,6 +23,9 @@ test_script: test_script.in Makefile
 	@cat $(srcdir)/test_script.in >> test_script
 	@chmod +x test_script
 
+mke2fs.conf: $(srcdir)/../misc/mke2fs.conf
+	sed -e 's/blocksize = -1/blocksize = 4096/' $< >mke2fs.conf
+
 check:: test_script
 	@echo "Running e2fsprogs test suite..."
 	@echo " "
@@ -63,7 +66,7 @@ testend: test_script ${TDIR}/image
 	@echo "If all is well, edit ${TDIR}/name and rename ${TDIR}."
 
 clean::
-	$(RM) -f *~ *.log *.new *.failed *.ok test.img test_script
+	$(RM) -f *~ *.log *.new *.failed *.ok test.img test_script mke2fs.conf
 
 distclean:: clean
 	$(RM) -f Makefile
diff --git a/tests/test_config b/tests/test_config
index f5ae0fe..7313724 100644
--- a/tests/test_config
+++ b/tests/test_config
@@ -26,6 +26,6 @@ LC_ALL=C
 export LC_ALL
 E2FSCK_CONFIG=/dev/null
 export E2FSCK_CONFIG
-MKE2FS_CONFIG=$SRCDIR/../misc/mke2fs.conf
+MKE2FS_CONFIG=./mke2fs.conf
 export MKE2FS_CONFIG
 
-- 
1.5.4.1.144.gdfee-dirty

