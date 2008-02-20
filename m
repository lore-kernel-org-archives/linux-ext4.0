From: "Theodore Ts'o" <tytso@MIT.EDU>
Subject: [E2FSPROGS, RFC] New mke2fs types parsing
Date: Wed, 20 Feb 2008 09:06:11 -0500
Message-ID: <E1JRpaN-0000Bs-4N@closure.thunk.org>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from BISCAYNE-ONE-STATION.MIT.EDU ([18.7.7.80]:35685 "EHLO
	biscayne-one-station.mit.edu" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755220AbYBTOGU (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>);
	Wed, 20 Feb 2008 09:06:20 -0500
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


The following patch is a work in progress, but I'm sending it out so
folks can take a look at it and comment on the general approach.

What this does is change how mke2fs -T works so it can take a comma
separated list, so you can do things like this:

	  mke2fs -T ext4,small,news

(which probably doesn't make any sense :-)

This makes it easier for us to specify what the behaviour of mke2fs is
via mke2fs.conf, and mke2fs will default the size and filesystem types
based on contextual hints (i.e., if the user calls mke2fs via
/sbin/mkfs.ext4, or if the -j flag is requested to request a journal,
etc.).

It's pretty flexible in allowing distirbutions and system administrtors
to control the behaviour of mke2fs via the config file, so that we
aren't hardcoding policy.

There are still a lot of debugging printfs in the code, which may be
helpful in seeing how this works.  BTW, This patch is based on some
recently committed changes which allows mke2fs to accept "mke2fs -O
extents", so if you want to actually compile and play with it you'll
probably want to pull the latest master or next branch from git and then
apply this patch against that.

							- Ted


commit 09138f9e096af809f1ff02df9194c9e0dad186db
Author: Theodore Ts'o <tytso@mit.edu>
Date:   Tue Feb 19 08:32:58 2008 -0500

    New mke2fs types parsing --- IN PROGRESS

diff --git a/misc/mke2fs.c b/misc/mke2fs.c
index 9d14bdd..a906797 100644
--- a/misc/mke2fs.c
+++ b/misc/mke2fs.c
@@ -926,6 +926,7 @@ static void edit_feature(const char *str, __u32 *compat_array)
 	if (!str)
 		return;
 
+	printf("Editing feature: '%s'\n", str);
 	if (e2p_edit_feature(str, compat_array, ok_features)) {
 		fprintf(stderr, _("Invalid filesystem option set: %s\n"), 
 			str);
@@ -933,6 +934,201 @@ static void edit_feature(const char *str, __u32 *compat_array)
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
+			    struct ext2_super_block *fs_param,
+			    char *progname)
+{
+	char		*ext_type = 0;
+	char		*parse_str;
+	char		*cp, *t;
+	const char	*size_type;
+	struct str_list	list;
+	int		state = 0;
+	unsigned long	meg;
+
+	if (init_list(&list))
+		return 0;
+
+	if (progname) {
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
+	if (!ext_type && (journal_size != 0))
+		ext_type = "ext3";
+
+	/* Make a copy so we can free it safely later */
+	if (ext_type) {
+		t = ext_type;
+		ext_type = malloc(strlen(t)+1);
+		if (ext_type)
+			strcpy(ext_type, t);
+	}
+
+	if (!ext_type)
+		profile_get_string(profile, "defaults", "fs_type", 0,
+				   "ext2", &ext_type);
+
+	if (ext_type)
+		printf("Using ext_type: '%s'\n", ext_type);
+
+	meg = (1024 * 1024) / EXT2_BLOCK_SIZE(fs_param);
+	printf("Size is %lu (%lu).\n", fs_param->s_blocks_count, meg);
+	if (fs_param->s_blocks_count < 3 * meg)
+		size_type = "floppy";
+	else if (fs_param->s_blocks_count < 512 * meg)
+		size_type = "small";
+	else
+		size_type = "default";
+	printf("Size type is %s.\n", size_type);
+
+	parse_str = malloc(fs_type ? strlen(fs_type)+1 : 1);
+	if (!parse_str) {
+		free(list.list);
+		return 0;
+	}
+	if (fs_type)
+		strcpy(parse_str, fs_type);
+	else
+		*parse_str = '\0';
+
+	cp = parse_str;
+	while (1) {
+		t = strchr(cp, ',');
+		if (t)
+			*t = '\0';
+	again:
+		state++;
+		if (state == 1) {
+			if (strcmp(cp, "ext2") &&
+			    strcmp(cp, "ext3") &&
+			    strcmp(cp, "ext4") &&
+			    strcmp(cp, "ext4dev")) {
+				printf("No filesystem type, adding %s\n",
+					ext_type);
+				push_string(&list, ext_type);
+				goto again;
+			}
+		}
+		if (state == 2) {
+			if (strcmp(cp, "floppy") &&
+			    strcmp(cp, "small") &&
+			    strcmp(cp, "default")) {
+				printf("No size type, adding %s\n",
+					size_type);
+				push_string(&list, size_type);
+				goto again;
+			}
+		}
+		if (*cp) {
+			printf("fs_type: '%s'\n", cp);
+			push_string(&list, cp);
+		}
+		if (t)
+			cp = t+1;
+		else {
+			cp = "";
+			if (state < 2)
+				goto again;
+			break;
+		}
+	}
+	free(parse_str);
+	if (ext_type)
+		free(ext_type);
+	return (list.list);
+}
+
+static char *get_string_from_profile(char **fs_types, const char *opt,
+				     const char *def_val)
+{
+	char *ret = 0;
+	char **cpp;
+
+	profile_get_string(profile, "defaults", opt, 0, 0, &ret);
+	if (ret)
+		return ret;
+
+	for (cpp = fs_types; *cpp; cpp++) {
+		profile_get_string(profile, "fs_types", *cpp, 0,
+				   cpp[1] ? 0 : def_val, &ret);
+		if (ret)
+			return ret;
+	}
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
 
@@ -952,6 +1148,7 @@ static void PRS(int argc, char *argv[])
 	char *		oldpath = getenv("PATH");
 	char *		extended_opts = 0;
 	const char *	fs_type = 0;
+	char		**fs_types;
 	blk_t		dev_size;
 #ifdef __linux__
 	struct 		utsname ut;
@@ -1317,6 +1514,14 @@ static void PRS(int argc, char *argv[])
 		proceed_question();
 	}
 
+	fs_types = parse_fs_type(fs_type, &fs_param, argv[0]);
+	if (!fs_types) {
+		fprintf(stderr, _("Failed to parse fs types list\n"));
+		exit(1);
+	}
+	printf("fs_types: ");
+	print_str_list(fs_types);
+
 	if (!fs_type) {
 		int megs = (__u64)fs_param.s_blocks_count *
 			(EXT2_BLOCK_SIZE(&fs_param) / 1024) / 1024;
@@ -1334,29 +1539,33 @@ static void PRS(int argc, char *argv[])
 
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
+		printf("base features: %s\n", tmp);
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
+		printf("default features: %s\n", tmp);
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
@@ -1414,10 +1623,8 @@ static void PRS(int argc, char *argv[])
 		sector_size = atoi(tmp);
 	
 	if (blocksize <= 0) {
-		profile_get_integer(profile, "defaults", "blocksize", 0,
-				    4096, &use_bsize);
-		profile_get_integer(profile, "fs_types", fs_type, 
-				    "blocksize", use_bsize, &use_bsize);
+		use_bsize = get_int_from_profile(fs_types, "blocksize", 4096);
+		printf("profile blocksize: %d\n", use_bsize);
 
 		if (use_bsize == -1) {
 			use_bsize = sys_page_size;
@@ -1434,12 +1641,9 @@ static void PRS(int argc, char *argv[])
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
+		printf("profile inode_ratio: %d\n", inode_ratio);
 		if (inode_ratio < blocksize)
 			inode_ratio = blocksize;
 	}
@@ -1486,6 +1690,9 @@ static void PRS(int argc, char *argv[])
 			"Use -b 4096 if this is an issue for you.\n\n"));
 
 	if (inode_size == 0) {
+		inode_size = get_int_from_profile(fs_types, "inode_size", 0);
+		printf("profile inode_size: %d\n", inode_size);
+
 		profile_get_integer(profile, "defaults", "inode_size", NULL,
 				    0, &inode_size);
 		profile_get_integer(profile, "fs_types", fs_type,
@@ -1802,5 +2009,6 @@ no_journal:
 	val = ext2fs_close(fs);
 	remove_error_table(&et_ext2_error_table);
 	remove_error_table(&et_prof_error_table);
+	profile_release(profile);
 	return (retval || val) ? 1 : 0;
 }
diff --git a/misc/mke2fs.conf b/misc/mke2fs.conf
index d67593a..a00c4ed 100644
--- a/misc/mke2fs.conf
+++ b/misc/mke2fs.conf
@@ -5,6 +5,13 @@
 	inode_ratio = 16384
 
 [fs_types]
+	ext3 = {
+		features = has_journal
+	}
+	ext4 = {
+		features = extents,flex_bg
+		inode_size = 256
+	}
 	small = {
 		blocksize = 1024
 		inode_size = 128
