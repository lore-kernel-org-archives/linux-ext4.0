From: Tyson Nottingham <tgnottingham@gmail.com>
Subject: [PATCH 4/5] Add missing information to various man pages and usage texts.
Date: Wed, 13 Dec 2017 23:13:12 -0800
Message-ID: <fb7064572732b5921783c2743577435bd714c73f.1513233071.git.tgnottingham@gmail.com>
References: <cover.1513233071.git.tgnottingham@gmail.com>
Cc: linux-ext4@vger.kernel.org,
        Tyson Nottingham <tgnottingham@gmail.com>
To: tytso@mit.edu
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-pg0-f45.google.com ([74.125.83.45]:38127 "EHLO
        mail-pg0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750825AbdLNHOk (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Thu, 14 Dec 2017 02:14:40 -0500
Received: by mail-pg0-f45.google.com with SMTP id f12so2875311pgo.5
        for <linux-ext4@vger.kernel.org>; Wed, 13 Dec 2017 23:14:40 -0800 (PST)
In-Reply-To: <cover.1513233071.git.tgnottingham@gmail.com>
In-Reply-To: <cover.1513233071.git.tgnottingham@gmail.com>
References: <cover.1513233071.git.tgnottingham@gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

badblocks.c: Add -B and -X to usage text.

chattr.1.in: Add P to list of settable attributes.

e2image.8.in, e2image.c: Remove superfluous mention of -r option.

e2undo.8.in, e2undo.c: Add description for -z to man page and add -o and
  -z to synopsis and usage text.

e4crypt.8.in: Add -p pad option to relevant command descriptions.

lsattr.1.in: Fix typo.

mke2fs.8.in: Add -C to synopsis. Add MKE2FS_DEVICE_PHYS_SECTSIZE
  description and update MKE2FS_DEVICE_SECTSIZE description.

mke2fs.conf.5.in: Add devices stanza summary. Remove base_features and
  default_features descriptions from defaults section, as they are
  already described in fs_types section. Move enable_periodic_fsck and
  force_undo to fs_types section, as they can be set per filesystem
  type. Add missing lazy_journal_init and hugefiles_dir descriptions.

tune2fs.8.in: Remove unsupported -p option and deprecated -s option.
  Add 64bit, ea_inode, large_dir, and metadata_csum_seed descriptions.

tune2fs.c: Remove unsupported -p option from usage text.
  Add mmp_update_interval to extended option usage text.

resize/main.c: Add -S option to usage text.

Signed-off-by: Tyson Nottingham <tgnottingham@gmail.com>
---
 misc/badblocks.c      |  2 +-
 misc/chattr.1.in      |  2 +-
 misc/e2image.8.in     |  2 +-
 misc/e2image.c        |  2 +-
 misc/e2undo.8.in      | 18 ++++++++++++
 misc/e2undo.c         |  2 +-
 misc/e4crypt.8.in     |  8 +++---
 misc/e4crypt.c        |  4 +--
 misc/lsattr.1.in      |  4 +--
 misc/mke2fs.8.in      |  9 ++++++
 misc/mke2fs.conf.5.in | 78 ++++++++++++++++++++++++---------------------------
 misc/tune2fs.8.in     | 33 ++++++++++++++--------
 misc/tune2fs.c        |  6 ++--
 resize/main.c         |  3 +-
 14 files changed, 103 insertions(+), 70 deletions(-)

diff --git a/misc/badblocks.c b/misc/badblocks.c
index e459391..44252dc 100644
--- a/misc/badblocks.c
+++ b/misc/badblocks.c
@@ -97,7 +97,7 @@ static unsigned int sys_page_size = 4096;
 static void usage(void)
 {
 	fprintf(stderr, _(
-"Usage: %s [-b block_size] [-i input_file] [-o output_file] [-svwnf]\n"
+"Usage: %s [-b block_size] [-i input_file] [-o output_file] [-svwnfBX]\n"
 "       [-c blocks_at_once] [-d delay_factor_between_reads] [-e max_bad_blocks]\n"
 "       [-p num_passes] [-t test_pattern [-t test_pattern [...]]]\n"
 "       device [last_block [first_block]]\n"),
diff --git a/misc/chattr.1.in b/misc/chattr.1.in
index 967b808..6a1d446 100644
--- a/misc/chattr.1.in
+++ b/misc/chattr.1.in
@@ -29,7 +29,7 @@ The operator '+' causes the selected attributes to be added to the
 existing attributes of the files; '-' causes them to be removed; and '='
 causes them to be the only attributes that the files have.
 .PP
-The letters 'aAcCdDeijsStTu' select the new attributes for the files:
+The letters 'aAcCdDeijPsStTu' select the new attributes for the files:
 append only (a),
 no atime updates (A),
 compressed (c),
diff --git a/misc/e2image.8.in b/misc/e2image.8.in
index f28a76e..a7bfdf2 100644
--- a/misc/e2image.8.in
+++ b/misc/e2image.8.in
@@ -11,7 +11,7 @@ e2image \- Save critical ext2/ext3/ext4 filesystem metadata to a file
 .B \-r|Q
 ]
 [
-.B \-fr
+.B \-f
 ]
 .I device
 .I image-file
diff --git a/misc/e2image.c b/misc/e2image.c
index be001f0..5a18bb4 100644
--- a/misc/e2image.c
+++ b/misc/e2image.c
@@ -104,7 +104,7 @@ static int get_bits_from_size(size_t size)
 
 static void usage(void)
 {
-	fprintf(stderr, _("Usage: %s [ -r|Q ] [ -fr ] device image-file\n"),
+	fprintf(stderr, _("Usage: %s [ -r|Q ] [ -f ] device image-file\n"),
 		program_name);
 	fprintf(stderr, _("       %s -I device image-file\n"), program_name);
 	fprintf(stderr, _("       %s -ra  [  -cfnp  ] [ -o src_offset ] "
diff --git a/misc/e2undo.8.in b/misc/e2undo.8.in
index da8b918..d8265b1 100644
--- a/misc/e2undo.8.in
+++ b/misc/e2undo.8.in
@@ -17,8 +17,16 @@ e2undo \- Replay an undo log for an ext2/ext3/ext4 filesystem
 .B \-n
 ]
 [
+.B \-o
+.I offset
+]
+[
 .B \-v
 ]
+[
+.B \-z
+.I undo_file
+]
 .I undo_log device
 .SH DESCRIPTION
 .B e2undo
@@ -53,6 +61,16 @@ Specify the filesystem's
 .TP
 .B \-v
 Report which block we're currently replaying.
+.TP
+.BI \-z " undo_file"
+Before overwriting a file system block, write the old contents of the block to
+an undo file.  This undo file can be used with e2undo(8) to restore the old
+contents of the file system should something go wrong.  If the empty string is
+passed as the undo_file argument, the undo file will be written to a file named
+e2undo-\fIdevice\fR.e2undo in the directory specified via the
+\fIE2FSPROGS_UNDO_DIR\fR environment variable.
+
+WARNING: The undo file cannot be used to recover from a power or system crash.
 .SH AUTHOR
 .B e2undo
 was written by Aneesh Kumar K.V. (aneesh.kumar@linux.vnet.ibm.com)
diff --git a/misc/e2undo.c b/misc/e2undo.c
index 6fb6e44..6443ca2 100644
--- a/misc/e2undo.c
+++ b/misc/e2undo.c
@@ -115,7 +115,7 @@ static char *undo_file;
 static void usage(void)
 {
 	fprintf(stderr,
-		_("Usage: %s [-f] [-h] [-n] [-v] <transaction file> <filesystem>\n"), prg_name);
+		_("Usage: %s [-f] [-h] [-n] [-o offset] [-v] [-z undo_file] <transaction file> <filesystem>\n"), prg_name);
 	exit(1);
 }
 
diff --git a/misc/e4crypt.8.in b/misc/e4crypt.8.in
index 6c5e470..169ab58 100644
--- a/misc/e4crypt.8.in
+++ b/misc/e4crypt.8.in
@@ -2,19 +2,19 @@
 .SH NAME
 e4crypt \- ext4 filesystem encryption utility
 .SH SYNOPSIS
-.B e4crypt add_key -S \fR[\fB -k \fIkeyring\fR ] [\fB-v\fR] [\fB-q\fR] [ \fI path\fR ... ]
+.B e4crypt add_key -S \fR[\fB -k \fIkeyring\fR ] [\fB-v\fR] [\fB-q\fR] \fR[\fB -p \fIpad\fR ] [ \fIpath\fR ... ]
 .br
 .B e4crypt new_session
 .br
 .B e4crypt get_policy \fIpath\fR ...
 .br
-.B e4crypt set_policy \fIpolicy path\fR ...
+.B e4crypt set_policy \fR[\fB -p \fIpad\fR ] \fIpolicy path\fR ...
 .SH DESCRIPTION
 .B e4crypt
 performs encryption management for ext4 file systems.
 .SH COMMANDS
 .TP
-.B e4crypt add_key -S \fR[\fB -k \fIkeyring\fR ] [\fB-v\fR] [\fB-q\fR] [ \fI path\fR ... ]
+.B e4crypt add_key -S \fR[\fB -k \fIkeyring\fR ] [\fB-v\fR] [\fB-q\fR] \fR[\fB -p \fIpad\fR ] [ \fIpath\fR ... ]
 Prompts the user for a passphrase and inserts it into the specified
 keyring.  If no keyring is specified, e4crypt will use the session
 keyring if it exists or the user session keyring if it does not.
@@ -30,7 +30,7 @@ Print the policy for the directories specified on the command line.
 Give the invoking process (typically a shell) a new session keyring,
 discarding its old session keyring.
 .TP
-.B e4crypt set_policy \fIpolicy path\fR ...
+.B e4crypt set_policy \fR[\fB -p \fIpad\fR ] \fIpolicy path\fR ...
 Sets the policy for the directories specified on the command line.
 All directories must be empty to set the policy; if the directory
 already has a policy established, e4crypt will validate that the
diff --git a/misc/e4crypt.c b/misc/e4crypt.c
index 7b65d14..c1ec9ab 100644
--- a/misc/e4crypt.c
+++ b/misc/e4crypt.c
@@ -641,7 +641,7 @@ static void do_help(int argc, char **argv, const struct cmd_desc *cmd);
 
 #define add_key_desc "adds a key to the user's keyring"
 #define add_key_help \
-"e4crypt add_key -S salt [ -k keyring ] [-v] [-q] [ path ... ]\n\n" \
+"e4crypt add_key -S salt [ -k keyring ] [-v] [-q] [ -p pad ] [ path ... ]\n\n" \
 "Prompts the user for a passphrase and inserts it into the specified\n" \
 "keyring.  If no keyring is specified, e4crypt will use the session\n" \
 "keyring if it exists or the user session keyring if it does not.\n\n" \
@@ -708,7 +708,7 @@ static void do_add_key(int argc, char **argv, const struct cmd_desc *cmd)
 
 #define set_policy_desc "sets a policy for directories"
 #define set_policy_help \
-"e4crypt set_policy policy path ... \n\n" \
+"e4crypt set_policy [ -p pad ] policy path ... \n\n" \
 "Sets the policy for the directories specified on the command line.\n" \
 "All directories must be empty to set the policy; if the directory\n" \
 "already has a policy established, e4crypt will validate that it the\n" \
diff --git a/misc/lsattr.1.in b/misc/lsattr.1.in
index bb15769..4d02a95 100644
--- a/misc/lsattr.1.in
+++ b/misc/lsattr.1.in
@@ -30,8 +30,8 @@ List all files in directories, including files that start with `.'.
 List directories like other files, rather than listing their contents.
 .TP
 .B \-l
-Print the options using a long names instead of a single
-character abbreviation.
+Print the options using long names instead of single
+character abbreviations.
 .TP
 .B \-p
 List the file's project number.
diff --git a/misc/mke2fs.8.in b/misc/mke2fs.8.in
index 766bf52..7b989e0 100644
--- a/misc/mke2fs.8.in
+++ b/misc/mke2fs.8.in
@@ -18,6 +18,10 @@ mke2fs \- create an ext2/ext3/ext4 filesystem
 .I block-size
 ]
 [
+.B \-C
+.I cluster-size
+]
+[
 .B \-d
 .I root-directory
 ]
@@ -792,6 +796,11 @@ If set to non-zero integer value, its value is used to determine first meta
 block group. This is mostly for debugging purposes.
 .TP
 .BI MKE2FS_DEVICE_SECTSIZE
+If set to non-zero integer value, its value is used to determine logical
+sector size of the
+.IR device .
+.TP
+.BI MKE2FS_DEVICE_PHYS_SECTSIZE
 If set to non-zero integer value, its value is used to determine physical
 sector size of the
 .IR device .
diff --git a/misc/mke2fs.conf.5.in b/misc/mke2fs.conf.5.in
index 21a0c88..cbd1700 100644
--- a/misc/mke2fs.conf.5.in
+++ b/misc/mke2fs.conf.5.in
@@ -78,7 +78,7 @@ used by
 .BR mke2fs (8).
 In general, these defaults may be overridden by a definition in the
 .B fs_types
-stanza, or by an command-line option provided by the user.
+stanza, or by a command-line option provided by the user.
 .TP
 .I [fs_types]
 Contains relations which define defaults that should be used for specific
@@ -89,6 +89,9 @@ the
 options to
 .BR mke2fs (8),
 respectively.
+.TP
+.I [devices]
+Contains relations which define defaults for specific devices.
 .SH THE [options] STANZA
 The following relations are defined in the
 .I [options]
@@ -106,47 +109,6 @@ The following relations are defined in the
 .I [defaults]
 stanza.
 .TP
-.I base_features
-This relation specifies the filesystems features which are enabled in
-newly created filesystems.  It may be overridden by the
-.I base_features
-relation found in the filesystem or usage type subsection of
-the
-.I [fs_types]
-stanza.
-.TP
-.I default_features
-This relation specifies a set of features that should be added or
-removed to the features listed in the
-.I base_features
-relation.  It may be overridden by the filesystem-specific
-.I default_features
-in the filesystem or usage type subsection of
-.IR [fs_types] ,
-and by the
-.B -O
-command-line option
-to
-.BR mke2fs (8).
-.TP
-.I enable_periodic_fsck
-This boolean relation specifies whether periodic filesystem checks should be
-enforced at boot time.  If set to true, checks will be forced every
-180 days, or after a random number of mounts.  These values may
-be changed later via the
-.B -i
-and
-.B -c
-command-line options to
-.BR tune2fs (8).
-.TP
-.I force_undo
-This boolean relation, if set to a value of true, forces
-.B mke2fs
-to always try to create an undo file, even if the undo file might be
-huge and it might extend the time to create the filesystem image
-because the inode table isn't being initialized lazily.
-.TP
 .I fs_type
 This relation specifies the default filesystem type if the user does not
 specify it via the
@@ -301,6 +263,17 @@ whose subsections define the
 relation, only the last will be used by
 .BR mke2fs (8).
 .TP
+.I enable_periodic_fsck
+This boolean relation specifies whether periodic filesystem checks should be
+enforced at boot time.  If set to true, checks will be forced every
+180 days, or after a random number of mounts.  These values may
+be changed later via the
+.B -i
+and
+.B -c
+command-line options to
+.BR tune2fs (8).
+.TP
 .I errors
 Change the behavior of the kernel code when errors are detected.
 In all cases, a filesystem error will cause
@@ -333,6 +306,13 @@ a named feature.  Each
 relation specified in the fs_types list will be applied in the order
 found in the fs_types list.
 .TP
+.I force_undo
+This boolean relation, if set to a value of true, forces
+.B mke2fs
+to always try to create an undo file, even if the undo file might be
+huge and it might extend the time to create the filesystem image
+because the inode table isn't being initialized lazily.
+.TP
 .I default_features
 This relation specifies set of features which should be enabled or
 disabled after applying the features listed in the
@@ -375,6 +355,16 @@ initialization noticeably, but it requires the kernel to finish
 initializing the filesystem in the background when the filesystem is
 first mounted.
 .TP
+.I lazy_journal_init
+This boolean relation specifies whether the journal inode should be
+lazily initialized. It only has meaning if the has_journal feature is
+enabled. If lazy_journal_init is true, the journal inode will not be
+fully zeroed out by
+.BR mke2fs .
+This speeds up filesystem initialization noticeably, but carries some
+small risk if the system crashes before the journal has been overwritten
+entirely one time.
+.TP
 .I journal_location
 This relation specifies the location of the journal.
 .TP
@@ -448,6 +438,10 @@ to be placed near the beginning of the file system (by disabling the
 backup superblocks, using the packed_meta_blocks option, etc.), the data
 blocks of the pre-allocated files will be contiguous.
 .TP
+.I hugefiles_dir
+This relation specifies the directory where huge files are created,
+relative to the filesystem root.
+.TP
 .I hugefiles_uid
 This relation controls the user ownership for all of the files and
 directories created by the
diff --git a/misc/tune2fs.8.in b/misc/tune2fs.8.in
index b1f43ec..740d166 100644
--- a/misc/tune2fs.8.in
+++ b/misc/tune2fs.8.in
@@ -45,18 +45,10 @@ tune2fs \- adjust tunable filesystem parameters on ext2/ext3/ext4 filesystems
 .RI [^]mount-options [,...]
 ]
 [
-.B \-p
-.I mmp_update_interval
-]
-[
 .B \-r
 .I reserved-blocks-count
 ]
 [
-.B \-s
-.I sparse-super-flag
-]
-[
 .B \-u
 .I user
 ]
@@ -537,12 +529,22 @@ The following filesystem features can be set or cleared using
 .BR tune2fs :
 .RS 1.2i
 .TP
+.B 64bit
+Enable the file system to be larger than 2^32 blocks.
+.TP
 .B dir_index
 Use hashed b-trees to speed up lookups for large directories.
 .TP
 .B dir_nlink
 Allow more than 65000 subdirectories per directory.
 .TP
+.B ea_inode
+Allow the value of each extended attribute to be placed in the data blocks of a
+separate inode if necessary, increasing the limit on the size and number of
+extended attributes per file.
+.B Tune2fs
+currently only supports setting this filesystem feature.
+.TP
 .B encrypt
 Enable file system level encryption.
 .B Tune2fs
@@ -574,6 +576,11 @@ Setting the filesystem feature is equivalent to using the
 .B \-j
 option.
 .TP
+.B large_dir
+Increase the limit on the number of files per directory.
+.B Tune2fs
+currently only supports setting this filesystem feature.
+.TP
 .B huge_file
 Support files larger than 2 terabytes in size.
 .TP
@@ -583,6 +590,13 @@ Filesystem can contain files that are greater than 2GB.
 .B metadata_csum
 Store a checksum to protect the contents in each metadata block.
 .TP
+.B metadata_csum_seed
+Allow the filesystem to store the metadata checksum seed in the
+superblock, enabling the administrator to change the UUID of a filesystem
+using the
+.B metadata_csum
+feature while it is mounted.
+.TP
 .B mmp
 Enable or disable multiple mount protection (MMP) feature.
 .TP
@@ -640,9 +654,6 @@ and
 .BR flex_bg
 features are only supported by the ext4 filesystem.
 .TP
-.BI \-p " mmp_check_interval"
-Set the desired MMP check interval in seconds. It is 5 seconds by default.
-.TP
 .BI \-r " reserved-blocks-count"
 Set the number of reserved filesystem blocks.
 .TP
diff --git a/misc/tune2fs.c b/misc/tune2fs.c
index d0a18a1..c33fb9d 100644
--- a/misc/tune2fs.c
+++ b/misc/tune2fs.c
@@ -137,9 +137,8 @@ static void usage(void)
 		  "[-g group]\n"
 		  "\t[-i interval[d|m|w]] [-j] [-J journal_options] [-l]\n"
 		  "\t[-m reserved_blocks_percent] [-o [^]mount_options[,...]]\n"
-		  "\t[-p mmp_update_interval] [-r reserved_blocks_count] "
-		  "[-u user]\n"
-		  "\t[-C mount_count] [-L volume_label] [-M last_mounted_dir]\n"
+		  "\t[-r reserved_blocks_count] [-u user] [-C mount_count]\n"
+		  "\t[-L volume_label] [-M last_mounted_dir]\n"
 		  "\t[-O [^]feature[,...]] [-Q quota_options]\n"
 		  "\t[-E extended-option[,...]] [-T last_check_time] "
 		  "[-U UUID]\n\t[-I new_inode_size] [-z undo_file] device\n"),
@@ -2195,6 +2194,7 @@ static int parse_extended_opts(ext2_filsys fs, const char *opts)
 			"\tclear_mmp\n"
 			"\thash_alg=<hash algorithm>\n"
 			"\tmount_opts=<extended default mount options>\n"
+			"\tmmp_update_interval=<mmp update interval in seconds>\n"
 			"\tstride=<RAID per-disk chunk size in blocks>\n"
 			"\tstripe_width=<RAID stride*data disks in blocks>\n"
 			"\ttest_fs\n"
diff --git a/resize/main.c b/resize/main.c
index aa16077..600e820 100644
--- a/resize/main.c
+++ b/resize/main.c
@@ -47,7 +47,8 @@ static char *device_name, *io_options;
 static void usage (char *prog)
 {
 	fprintf (stderr, _("Usage: %s [-d debug_flags] [-f] [-F] [-M] [-P] "
-			   "[-p] device [-b|-s|new_size] [-z undo_file]\n\n"),
+			   "[-p] device [-b|-s|new_size] [-S RAID-stride] "
+			   "[-z undo_file]\n\n"),
 		 prog);
 
 	exit (1);
-- 
2.7.4
