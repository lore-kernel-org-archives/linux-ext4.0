From: Matthias Koenig <mkoenig@suse.de>
Subject: [PATCH 1/3] fsck: add fsck from e2fsprogs to util-linux-ng tree
Date: Wed, 06 Feb 2008 12:39:01 +0100
Message-ID: <20080206113901.7833.37585.stgit@sor.suse.de>
References: <20080206113426.7833.59505.stgit@sor.suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
To: util-linux-ng@vger.kernel.org, linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:51650 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756297AbYBFLjD (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 6 Feb 2008 06:39:03 -0500
In-Reply-To: <20080206113426.7833.59505.stgit@sor.suse.de>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Signed-off-by: Matthias Koenig <mkoenig@suse.de>
---

 Makefile.am        |    1 
 configure.ac       |    2 
 fsck/Makefile.am   |    7 
 fsck/base_device.c |  169 +++++++
 fsck/fsck.8.in     |  410 ++++++++++++++++
 fsck/fsck.c        | 1309 ++++++++++++++++++++++++++++++++++++++++++++++++++++
 fsck/fsck.h        |   70 +++
 7 files changed, 1968 insertions(+), 0 deletions(-)

diff --git a/Makefile.am b/Makefile.am
index 245f90e..e2b5ed1 100644
--- a/Makefile.am
+++ b/Makefile.am
@@ -3,6 +3,7 @@ include $(top_srcdir)/config/include-Makefile.am
 SUBDIRS = \
 	include \
 	disk-utils \
+	fsck \
 	fdisk \
 	getopt \
 	lib \
diff --git a/configure.ac b/configure.ac
index a148e28..cacf790 100644
--- a/configure.ac
+++ b/configure.ac
@@ -578,6 +578,8 @@ AC_CONFIG_HEADERS(config.h)
 AC_CONFIG_FILES([
 Makefile
 disk-utils/Makefile
+fsck/Makefile
+fsck/fsck.8
 fdisk/Makefile
 getopt/Makefile
 hwclock/Makefile
diff --git a/fsck/Makefile.am b/fsck/Makefile.am
new file mode 100644
index 0000000..59523fc
--- /dev/null
+++ b/fsck/Makefile.am
@@ -0,0 +1,7 @@
+include $(top_srcdir)/config/include-Makefile.am
+
+usrsbinexec_PROGRAMS = fsck
+fsck_SOURCES = fsck.c fsck.h base_device.c
+fsck_LDADD = -lblkid
+man_MANS = fsck.8
+
diff --git a/fsck/base_device.c b/fsck/base_device.c
new file mode 100644
index 0000000..6237d0e
--- /dev/null
+++ b/fsck/base_device.c
@@ -0,0 +1,169 @@
+/*
+ * base_device.c
+ *
+ * Return the "base device" given a particular device; this is used to
+ * assure that we only fsck one partition on a particular drive at any
+ * one time.  Otherwise, the disk heads will be seeking all over the
+ * place.  If the base device can not be determined, return NULL.
+ * 
+ * The base_device() function returns an allocated string which must
+ * be freed.
+ * 
+ * Written by Theodore Ts'o, <tytso@mit.edu>
+ * 
+ * Copyright (C) 2000 Theodore Ts'o.
+ *
+ * %Begin-Header%
+ * This file may be redistributed under the terms of the GNU Public
+ * License.
+ * %End-Header%
+ */
+#include <stdio.h>
+#if HAVE_UNISTD_H
+#include <unistd.h>
+#endif
+#if HAVE_STDLIB_H
+#include <stdlib.h>
+#endif
+#include <ctype.h>
+#include <string.h>
+
+#include "fsck.h"
+
+/*
+ * Required for the uber-silly devfs /dev/ide/host1/bus2/target3/lun3
+ * pathames.
+ */
+static const char *devfs_hier[] = {
+	"host", "bus", "target", "lun", 0
+};
+
+char *base_device(const char *device)
+{
+	char *str, *cp;
+	const char **hier, *disk;
+	int len;
+
+	str = malloc(strlen(device)+1);
+	if (!str)
+		return NULL;
+	strcpy(str, device);
+	cp = str;
+
+	/* Skip over /dev/; if it's not present, give up. */
+	if (strncmp(cp, "/dev/", 5) != 0)
+		goto errout;
+	cp += 5;
+
+	/* Skip over /dev/dsk/... */
+	if (strncmp(cp, "dsk/", 4) == 0)
+		cp += 4;
+	
+	/*
+	 * For md devices, we treat them all as if they were all
+	 * on one disk, since we don't know how to parallelize them.
+	 */
+	if (cp[0] == 'm' && cp[1] == 'd') {
+		*(cp+2) = 0;
+		return str;
+	}
+
+	/* Handle DAC 960 devices */
+	if (strncmp(cp, "rd/", 3) == 0) {
+		cp += 3;
+		if (cp[0] != 'c' || cp[2] != 'd' ||
+		    !isdigit(cp[1]) || !isdigit(cp[3]))
+			goto errout;
+		*(cp+4) = 0;
+		return str;
+	}
+
+	/* Now let's handle /dev/hd* and /dev/sd* devices.... */
+	if ((cp[0] == 'h' || cp[0] == 's') && (cp[1] == 'd')) {
+		cp += 2;
+		/* If there's a single number after /dev/hd, skip it */
+		if (isdigit(*cp))
+			cp++;
+		/* What follows must be an alpha char, or give up */
+		if (!isalpha(*cp))
+			goto errout;
+		*(cp + 1) = 0;
+		return str;
+	}
+
+	/* Now let's handle devfs (ugh) names */
+	len = 0;
+	if (strncmp(cp, "ide/", 4) == 0)
+		len = 4;
+	if (strncmp(cp, "scsi/", 5) == 0)
+		len = 5;
+	if (len) {
+		cp += len;
+		/*
+		 * Now we proceed down the expected devfs hierarchy.
+		 * i.e., .../host1/bus2/target3/lun4/...
+		 * If we don't find the expected token, followed by
+		 * some number of digits at each level, abort.
+		 */
+		for (hier = devfs_hier; *hier; hier++) {
+			len = strlen(*hier);
+			if (strncmp(cp, *hier, len) != 0)
+				goto errout;
+			cp += len;
+			while (*cp != '/' && *cp != 0) {
+				if (!isdigit(*cp))
+					goto errout;
+				cp++;
+			}
+			cp++;
+		}
+		*(cp - 1) = 0;
+		return str;
+	}
+
+	/* Now handle devfs /dev/disc or /dev/disk names */
+	disk = 0;
+	if (strncmp(cp, "discs/", 6) == 0)
+		disk = "disc";
+	else if (strncmp(cp, "disks/", 6) == 0)
+		disk = "disk";
+	if (disk) {
+		cp += 6;
+		if (strncmp(cp, disk, 4) != 0)
+			goto errout;
+		cp += 4;
+		while (*cp != '/' && *cp != 0) {
+			if (!isdigit(*cp))
+				goto errout;
+			cp++;
+		}
+		*cp = 0;
+		return str;
+	}
+
+errout:
+	free(str);
+	return NULL;
+}
+
+#ifdef DEBUG
+int main(int argc, char** argv)
+{
+	const char *base;
+	char  buf[256], *cp;
+
+	while (1) {
+		if (fgets(buf, sizeof(buf), stdin) == NULL)
+			break;
+		cp = strchr(buf, '\n');
+		if (cp)
+			*cp = 0;
+		cp = strchr(buf, '\t');
+		if (cp)
+			*cp = 0;
+		base = base_device(buf);
+		printf("%s\t%s\n", buf, base ? base : "NONE");
+	}
+	exit(0);
+}
+#endif
diff --git a/fsck/fsck.8.in b/fsck/fsck.8.in
new file mode 100644
index 0000000..4a12677
--- /dev/null
+++ b/fsck/fsck.8.in
@@ -0,0 +1,410 @@
+.\" -*- nroff -*-
+.\" Copyright 1993, 1994, 1995 by Theodore Ts'o.  All Rights Reserved.
+.\" This file may be copied under the terms of the GNU Public License.
+.\" 
+.TH FSCK 8 "Feb 2008" "@PACKAGE_NAME@ version @PACKAGE_VERSION@"
+.SH NAME
+fsck \- check and repair a Linux file system
+.SH SYNOPSIS
+.B fsck
+[
+.B \-sAVRTNP
+]
+[
+.B \-C
+[
+.I fd
+]
+]
+[
+.B \-t
+.I fstype
+] 
+.I [filesys ... ]
+[\-\-] [
+.B fs-specific-options
+]
+.SH DESCRIPTION
+.B fsck
+is used to check and optionally repair one or more Linux file systems.  
+.I filesys
+can be a device name (e.g.
+.IR /dev/hdc1 ", " /dev/sdb2 ),
+a mount point (e.g.
+.IR / ", " /usr ", " /home ),
+or an ext2 label or UUID specifier (e.g.
+UUID=8868abf6-88c5-4a83-98b8-bfc24057f7bd or LABEL=root).  
+Normally, the 
+.B fsck 
+program will try to handle filesystems on different physical disk drives 
+in parallel to reduce the total amount of time needed to check all of the
+filesystems.
+.PP
+If no filesystems are specified on the command line, and the 
+.B \-A 
+option is not specified, 
+.B fsck
+will default to checking filesystems in
+.B /etc/fstab
+serially.  This is equivalent to the 
+.B \-As
+options.
+.PP
+The exit code returned by
+.B fsck
+is the sum of the following conditions:
+.br
+\	0\	\-\ No errors
+.br
+\	1\	\-\ File system errors corrected
+.br
+\	2\	\-\ System should be rebooted
+.br
+\	4\	\-\ File system errors left uncorrected
+.br
+\	8\	\-\ Operational error
+.br
+\	16\	\-\ Usage or syntax error
+.br
+\	32\	\-\ Fsck canceled by user request
+.br
+\	128\	\-\ Shared library error
+.br
+The exit code returned when multiple file systems are checked 
+is the bit-wise OR of the exit codes for each
+file system that is checked.
+.PP
+In actuality,
+.B fsck
+is simply a front-end for the various file system checkers
+(\fBfsck\fR.\fIfstype\fR) available under Linux.  The file
+system-specific checker is searched for in
+.I /sbin
+first, then in
+.I /etc/fs
+and
+.IR /etc ,
+and finally in the directories listed in the PATH environment
+variable.  Please see the file system-specific checker manual pages for
+further details.
+.SH OPTIONS
+.TP
+.B \-s
+Serialize 
+.B fsck 
+operations.  This is a good idea if you are checking multiple
+filesystems and the checkers are in an interactive mode.  (Note:
+.BR e2fsck (8)
+runs in an interactive mode by default.  To make 
+.BR e2fsck (8)
+run in a non-interactive mode, you must either specify the
+.B \-p
+or
+.B \-a
+option, if you wish for errors to be corrected automatically, or the 
+.B \-n
+option if you do not.)
+.TP
+.BI \-t " fslist"
+Specifies the type(s) of file system to be checked.  When the
+.B \-A 
+flag is specified, only filesystems that match 
+.I fslist
+are checked.  The
+.I fslist
+parameter is a comma-separated list of filesystems and options
+specifiers.  All of the filesystems in this comma-separated list may be
+prefixed by a negation operator 
+.RB ' no '
+or 
+.RB ' ! ',
+which requests that only those filesystems not listed in
+.I fslist
+will be checked.  If all of the filesystems in 
+.I fslist
+are not prefixed by a negation operator, then only those filesystems
+listed
+in
+.I fslist
+will be checked.
+.sp
+Options specifiers may be included in the comma-separated
+.IR fslist .
+They must have the format 
+.BI opts= fs-option\fR.
+If an options specifier is present, then only filesystems which contain
+.I fs-option
+in their mount options field of 
+.B /etc/fstab
+will be checked.  If the options specifier is prefixed by a negation
+operator, then only 
+those filesystems that do not have
+.I fs-option
+in their mount options field of
+.B /etc/fstab 
+will be checked.
+.sp
+For example, if
+.B opts=ro
+appears in
+.IR fslist ,
+then only filesystems listed in
+.B /etc/fstab 
+with the
+.B ro
+option will be checked.
+.sp
+For compatibility with Mandrake distributions whose boot scripts
+depend upon an unauthorized UI change to the
+.B fsck
+program, if a filesystem type of
+.B loop
+is found in
+.IR fslist ,
+it is treated as if
+.B opts=loop
+were specified as an argument to the
+.B \-t
+option.
+.sp
+Normally, the filesystem type is deduced by searching for
+.I filesys
+in the 
+.I /etc/fstab 
+file and using the corresponding entry.
+If the type can not be deduced, and there is only a single filesystem 
+given as an argument to the 
+.B \-t 
+option, 
+.B fsck
+will use the specified filesystem type.  If this type is not
+available, then the default file system type (currently ext2) is used. 
+.TP
+.B \-A
+Walk through the
+.I /etc/fstab
+file and try to check all file systems in one run.  This option is
+typically used from the
+.I /etc/rc
+system initialization file, instead of multiple commands for checking
+a single file system.
+.sp
+The root filesystem will be checked first unless the
+.B \-P
+option is specified (see below).  After that, 
+filesystems will be checked in the order specified by the 
+.I fs_passno 
+(the sixth) field in the 
+.I /etc/fstab
+file.  
+Filesystems with a 
+.I fs_passno
+value of 0 are skipped and are not checked at all.  Filesystems with a
+.I fs_passno
+value of greater than zero will be checked in order, 
+with filesystems with the lowest
+.I fs_passno 
+number being checked first.
+If there are multiple filesystems with the same pass number, 
+fsck will attempt to check them in parallel, although it will avoid running 
+multiple filesystem checks on the same physical disk.  
+.sp
+Hence, a very common configuration in 
+.I /etc/fstab
+files is to set the root filesystem to have a 
+.I fs_passno
+value of 1
+and to set all other filesystems to have a
+.I fs_passno
+value of 2.  This will allow
+.B fsck
+to automatically run filesystem checkers in parallel if it is advantageous
+to do so.  System administrators might choose
+not to use this configuration if they need to avoid multiple filesystem
+checks running in parallel for some reason --- for example, if the
+machine in question is short on memory so that
+excessive paging is a concern.
+.TP
+.B \-C\fR [ \fI "fd" \fR ]
+Display completion/progress bars for those filesystem checkers (currently 
+only for ext2 and ext3) which support them.   Fsck will manage the
+filesystem checkers so that only one of them will display  
+a progress bar at a time.  GUI front-ends may specify a file descriptor
+.IR fd ,
+in which case the progress bar information will be sent to that file descriptor.
+.TP
+.B \-N
+Don't execute, just show what would be done.
+.TP
+.B \-P
+When the 
+.B \-A
+flag is set, check the root filesystem in parallel with the other filesystems.
+This is not the safest thing in the world to do,
+since if the root filesystem is in doubt things like the 
+.BR e2fsck (8) 
+executable might be corrupted!  This option is mainly provided
+for those sysadmins who don't want to repartition the root
+filesystem to be small and compact (which is really the right solution).
+.TP
+.B \-R
+When checking all file systems with the
+.B \-A
+flag, skip the root file system (in case it's already mounted read-write).
+.TP
+.B \-T
+Don't show the title on startup.
+.TP
+.B \-V
+Produce verbose output, including all file system-specific commands
+that are executed.
+.TP
+.B fs-specific-options
+Options which are not understood by 
+.B fsck 
+are passed to the filesystem-specific checker.  These arguments
+.B must
+not take arguments, as there is no
+way for 
+.B fsck
+to be able to properly guess which arguments take options and which
+don't.
+.IP
+Options and arguments which follow the
+.B \-\-
+are treated as file system-specific options to be passed to the
+file system-specific checker.
+.IP
+Please note that fsck is not
+designed to pass arbitrarily complicated options to filesystem-specific
+checkers.  If you're doing something complicated, please just
+execute the filesystem-specific checker directly.  If you pass 
+.B fsck
+some horribly complicated option and arguments, and it doesn't do
+what you expect, 
+.B don't bother reporting it as a bug.
+You're almost certainly doing something that you shouldn't be doing
+with 
+.BR fsck.
+.PP
+Options to different filesystem-specific fsck's are not standardized.
+If in doubt, please consult the man pages of the filesystem-specific
+checker.  Although not guaranteed, the following options are supported
+by most file system checkers:
+.TP
+.B \-a
+Automatically repair the file system without any questions (use
+this option with caution).  Note that 
+.BR e2fsck (8)
+supports 
+.B \-a
+for backwards compatibility only.  This option is mapped to 
+.BR e2fsck 's
+.B \-p
+option which is safe to use, unlike the 
+.B \-a 
+option that some file system checkers support.
+.TP
+.B \-n
+For some filesystem-specific checkers, the 
+.B \-n
+option will cause the fs-specific fsck to avoid attempting to repair any 
+problems, but simply report such problems to stdout.  This is however
+not true for all filesystem-specific checkers.  In particular, 
+.BR fsck.reiserfs (8)
+will not report any corruption if given this option.
+.BR fsck.minix (8)
+does not support the 
+.B \-n 
+option at all.
+.TP
+.B \-r
+Interactively repair the filesystem (ask for confirmations).  Note: It
+is generally a bad idea to use this option if multiple fsck's are being
+run in parallel.  Also note that this is 
+.BR e2fsck 's
+default behavior; it supports this option for backwards compatibility
+reasons only.
+.TP
+.B \-y
+For some filesystem-specific checkers, the 
+.B \-y 
+option will cause the fs-specific fsck to always attempt to fix any
+detected filesystem corruption automatically.  Sometimes an expert may
+be able to do better driving the fsck manually.  Note that 
+.B not
+all filesystem-specific checkers implement this option.  In particular 
+.BR fsck.minix (8)
+and
+.BR fsck.cramfs (8)
+does not support the
+.B -y
+option as of this writing.
+.SH AUTHOR
+Theodore Ts'o (tytso@mit.edu)
+.SH FILES
+.IR /etc/fstab .
+.SH ENVIRONMENT VARIABLES
+The
+.B fsck
+program's behavior is affected by the following environment variables:
+.TP
+.B FSCK_FORCE_ALL_PARALLEL
+If this environment variable is set, 
+.B fsck
+will attempt to run all of the specified filesystems in parallel,
+regardless of whether the filesystems appear to be on the same
+device.  (This is useful for RAID systems or high-end storage systems
+such as those sold by companies such as IBM or EMC.)
+.TP
+.B FSCK_MAX_INST
+This environment variable will limit the maximum number of file system
+checkers that can be running at one time.  This allows configurations
+which have a large number of disks to avoid 
+.B fsck
+starting too many file system checkers at once, which might overload
+CPU and memory resources available on the system.  If this value is
+zero, then an unlimited number of processes can be spawned.  This is
+currently the default, but future versions of
+.B fsck
+may attempt to automatically determine how many file system checks can
+be run based on gathering accounting data from the operating system.
+.TP
+.B PATH
+The 
+.B PATH
+environment variable is used to find file system checkers.  A set of
+system directories are searched first: 
+.BR /sbin ,
+.BR /sbin/fs.d ,
+.BR  /sbin/fs ,
+.BR /etc/fs ,
+and 
+.BR /etc .
+Then the set of directories found in the
+.B PATH
+environment are searched.
+.TP
+.B FSTAB_FILE
+This environment variable allows the system administrator 
+to override the standard location of the 
+.B /etc/fstab
+file.  It is also useful for developers who are testing
+.BR fsck .
+.SH SEE ALSO
+.BR fstab (5),
+.BR mkfs (8),
+.BR fsck.ext2 (8)
+or
+.BR fsck.ext3 (8)
+or
+.BR e2fsck (8),
+.BR cramfsck (8),
+.BR fsck.minix (8),
+.BR fsck.msdos (8),
+.BR fsck.jfs (8),
+.BR fsck.nfs (8),
+.BR fsck.vfat (8),
+.BR fsck.xfs (8),
+.BR fsck.xiafs (8),
+.BR reiserfsck (8).
diff --git a/fsck/fsck.c b/fsck/fsck.c
new file mode 100644
index 0000000..6b39b21
--- /dev/null
+++ b/fsck/fsck.c
@@ -0,0 +1,1309 @@
+/*
+ * pfsck --- A generic, parallelizing front-end for the fsck program.
+ * It will automatically try to run fsck programs in parallel if the
+ * devices are on separate spindles.  It is based on the same ideas as
+ * the generic front end for fsck by David Engel and Fred van Kempen,
+ * but it has been completely rewritten from scratch to support
+ * parallel execution.
+ *
+ * Written by Theodore Ts'o, <tytso@mit.edu>
+ * 
+ * Miquel van Smoorenburg (miquels@drinkel.ow.org) 20-Oct-1994:
+ *   o Changed -t fstype to behave like with mount when -A (all file
+ *     systems) or -M (like mount) is specified.
+ *   o fsck looks if it can find the fsck.type program to decide
+ *     if it should ignore the fs type. This way more fsck programs
+ *     can be added without changing this front-end.
+ *   o -R flag skip root file system.
+ *
+ * Copyright (C) 1993, 1994, 1995, 1996, 1997, 1998, 1999, 2000, 
+ * 	2001, 2002, 2003, 2004, 2005 by  Theodore Ts'o.
+ *
+ * %Begin-Header%
+ * This file may be redistributed under the terms of the GNU Public
+ * License.
+ * %End-Header%
+ */
+
+#include <sys/types.h>
+#include <sys/wait.h>
+#include <sys/signal.h>
+#include <sys/stat.h>
+#include <limits.h>
+#include <stdio.h>
+#include <ctype.h>
+#include <string.h>
+#include <time.h>
+#include <stdlib.h>
+#include <errno.h>
+#include <paths.h>
+#include <unistd.h>
+#include <errno.h>
+#include <malloc.h>
+#include <signal.h>
+
+#include "../config.h"
+#include "nls.h"
+#include "fsck.h"
+#include "blkid/blkid.h"
+
+#ifndef _PATH_MNTTAB
+#define	_PATH_MNTTAB	"/etc/fstab"
+#endif
+
+static const char *ignored_types[] = {
+	"ignore",
+	"iso9660",
+	"nfs",
+	"proc",
+	"sw",
+	"swap",
+	"tmpfs",
+	"devpts",
+	NULL
+};
+
+static const char *really_wanted[] = {
+	"minix",
+	"ext2",
+	"ext3",
+	"jfs",
+	"reiserfs",
+	"xiafs",
+	"xfs",
+	NULL
+};
+
+#define BASE_MD "/dev/md"
+
+/*
+ * Global variables for options
+ */
+char *devices[MAX_DEVICES];
+char *args[MAX_ARGS];
+int num_devices, num_args;
+
+int verbose = 0;
+int doall = 0;
+int noexecute = 0;
+int serialize = 0;
+int skip_root = 0;
+int like_mount = 0;
+int notitle = 0;
+int parallel_root = 0;
+int progress = 0;
+int progress_fd = 0;
+int force_all_parallel = 0;
+int num_running = 0;
+int max_running = 0;
+volatile int cancel_requested = 0;
+int kill_sent = 0;
+char *progname;
+char *fstype = NULL;
+struct fs_info *filesys_info = NULL, *filesys_last = NULL;
+struct fsck_instance *instance_list;
+const char *fsck_prefix_path = "/sbin:/sbin/fs.d:/sbin/fs:/etc/fs:/etc";
+char *fsck_path = 0;
+blkid_cache cache = NULL;
+
+static char *string_copy(const char *s)
+{
+	char	*ret;
+
+	if (!s)
+		return 0;
+	ret = malloc(strlen(s)+1);
+	if (ret)
+		strcpy(ret, s);
+	return ret;
+}
+
+static int string_to_int(const char *s)
+{
+	long l;
+	char *p;
+
+	l = strtol(s, &p, 0);
+	if (*p || l == LONG_MIN || l == LONG_MAX || l < 0 || l > INT_MAX)
+		return -1;
+	else
+		return (int) l;
+}
+
+static int ignore(struct fs_info *);
+
+static char *skip_over_blank(char *cp)
+{
+	while (*cp && isspace(*cp))
+		cp++;
+	return cp;
+}
+
+static char *skip_over_word(char *cp)
+{
+	while (*cp && !isspace(*cp))
+		cp++;
+	return cp;
+}
+
+static void strip_line(char *line)
+{
+	char	*p;
+
+	while (*line) {
+		p = line + strlen(line) - 1;
+		if ((*p == '\n') || (*p == '\r'))
+			*p = 0;
+		else
+			break;
+	}
+}
+
+static char *parse_word(char **buf)
+{
+	char *word, *next;
+
+	word = *buf;
+	if (*word == 0)
+		return 0;
+
+	word = skip_over_blank(word);
+	next = skip_over_word(word);
+	if (*next)
+		*next++ = 0;
+	*buf = next;
+	return word;
+}
+
+static void parse_escape(char *word)
+{
+	char	*p, *q;
+	int	ac, i;
+
+	if (!word)
+		return;
+
+	for (p = word, q = word; *p; p++, q++) {
+		*q = *p;
+		if (*p != '\\')
+			continue;
+		if (*++p == 0)
+			break;
+		if (*p == 't') {
+			*q = '\t';
+			continue;
+		}
+		if (*p == 'n') {
+			*q = '\n';
+			continue;
+		}
+		if (!isdigit(*p)) {
+			*q = *p;
+			continue;
+		}
+		ac = 0;
+		for (i = 0; i < 3; i++, p++) {
+			if (!isdigit(*p))
+				break;
+			ac = (ac * 8) + (*p - '0');
+		}
+		*q = ac;
+		p--;
+	}
+	*q = 0;
+}
+
+static void free_instance(struct fsck_instance *i)
+{
+	if (i->prog)
+		free(i->prog);
+	if (i->device)
+		free(i->device);
+	if (i->base_device)
+		free(i->base_device);
+	free(i);
+	return;
+}
+
+static struct fs_info *create_fs_device(const char *device, const char *mntpnt,
+					const char *type, const char *opts, 
+					int freq, int passno)
+{
+	struct fs_info *fs;
+
+	if (!(fs = malloc(sizeof(struct fs_info))))
+		return NULL;
+
+	fs->device = string_copy(device);
+	fs->mountpt = string_copy(mntpnt);
+	fs->type = string_copy(type);
+	fs->opts = string_copy(opts ? opts : "");
+	fs->freq = freq;
+	fs->passno = passno;
+	fs->flags = 0;
+	fs->next = NULL;
+
+	if (!filesys_info)
+		filesys_info = fs;
+	else
+		filesys_last->next = fs;
+	filesys_last = fs;
+
+	return fs;
+}
+
+
+
+static int parse_fstab_line(char *line, struct fs_info **ret_fs)
+{
+	char	*dev, *device, *mntpnt, *type, *opts, *freq, *passno, *cp;
+	struct fs_info *fs;
+
+	*ret_fs = 0;
+	strip_line(line);
+	cp = line;
+
+	device = parse_word(&cp);
+	if (!device || *device == '#')
+		return 0;	/* Ignore blank lines and comments */
+	mntpnt = parse_word(&cp);
+	type = parse_word(&cp);
+	opts = parse_word(&cp);
+	freq = parse_word(&cp);
+	passno = parse_word(&cp);
+
+	if (!mntpnt || !type)
+		return -1;
+
+	parse_escape(device);
+	parse_escape(mntpnt);
+	parse_escape(type);
+	parse_escape(opts);
+	parse_escape(freq);
+	parse_escape(passno);
+
+	dev = blkid_get_devname(cache, device, NULL);
+	if (dev)
+		device = dev;
+
+	if (strchr(type, ','))
+		type = 0;
+
+	fs = create_fs_device(device, mntpnt, type ? type : "auto", opts,
+			      freq ? atoi(freq) : -1,
+			      passno ? atoi(passno) : -1);
+	if (dev)
+		free(dev);
+	   
+	if (!fs)
+		return -1;
+	*ret_fs = fs;
+	return 0;
+}
+
+static void interpret_type(struct fs_info *fs)
+{
+	char	*t;
+	
+	if (strcmp(fs->type, "auto") != 0)
+		return;
+	t = blkid_get_tag_value(cache, "TYPE", fs->device);
+	if (t) {
+		free(fs->type);
+		fs->type = t;
+	}
+}
+
+/*
+ * Load the filesystem database from /etc/fstab
+ */
+static void load_fs_info(const char *filename)
+{
+	FILE	*f;
+	char	buf[1024];
+	int	lineno = 0;
+	int	old_fstab = 1;
+	struct fs_info *fs;
+
+	if ((f = fopen(filename, "r")) == NULL) {
+		fprintf(stderr, _("WARNING: couldn't open %s: %s\n"),
+			filename, strerror(errno));
+		return;
+	}
+	while (!feof(f)) {
+		lineno++;
+		if (!fgets(buf, sizeof(buf), f))
+			break;
+		buf[sizeof(buf)-1] = 0;
+		if (parse_fstab_line(buf, &fs) < 0) {
+			fprintf(stderr, _("WARNING: bad format "
+				"on line %d of %s\n"), lineno, filename);
+			continue;
+		}
+		if (!fs)
+			continue;
+		if (fs->passno < 0)
+			fs->passno = 0;
+		else
+			old_fstab = 0;
+	}
+	
+	fclose(f);
+	
+	if (old_fstab) {
+		fputs(_("\007\007\007"
+		"WARNING: Your /etc/fstab does not contain the fsck passno\n"
+		"	field.  I will kludge around things for you, but you\n"
+		"	should fix your /etc/fstab file as soon as you can.\n\n"), stderr);
+		
+		for (fs = filesys_info; fs; fs = fs->next) {
+			fs->passno = 1;
+		}
+	}
+}
+	
+/* Lookup filesys in /etc/fstab and return the corresponding entry. */
+static struct fs_info *lookup(char *filesys)
+{
+	struct fs_info *fs;
+
+	/* No filesys name given. */
+	if (filesys == NULL)
+		return NULL;
+
+	for (fs = filesys_info; fs; fs = fs->next) {
+		if (!strcmp(filesys, fs->device) ||
+		    (fs->mountpt && !strcmp(filesys, fs->mountpt)))
+			break;
+	}
+
+	return fs;
+}
+
+/* Find fsck program for a given fs type. */
+static char *find_fsck(char *type)
+{
+  char *s;
+  const char *tpl;
+  static char prog[256];
+  char *p = string_copy(fsck_path);
+  struct stat st;
+
+  /* Are we looking for a program or just a type? */
+  tpl = (strncmp(type, "fsck.", 5) ? "%s/fsck.%s" : "%s/%s");
+
+  for(s = strtok(p, ":"); s; s = strtok(NULL, ":")) {
+	sprintf(prog, tpl, s, type);
+	if (stat(prog, &st) == 0) break;
+  }
+  free(p);
+  return(s ? prog : NULL);
+}
+
+static int progress_active(NOARGS)
+{
+	struct fsck_instance *inst;
+
+	for (inst = instance_list; inst; inst = inst->next) {
+		if (inst->flags & FLAG_DONE)
+			continue;
+		if (inst->flags & FLAG_PROGRESS)
+			return 1;
+	}
+	return 0;
+}
+
+/*
+ * Execute a particular fsck program, and link it into the list of
+ * child processes we are waiting for.
+ */
+static int execute(const char *type, const char *device, const char *mntpt,
+		   int interactive)
+{
+	char *s, *argv[80], prog[80];
+	int  argc, i;
+	struct fsck_instance *inst, *p;
+	pid_t	pid;
+
+	inst = malloc(sizeof(struct fsck_instance));
+	if (!inst)
+		return ENOMEM;
+	memset(inst, 0, sizeof(struct fsck_instance));
+
+	sprintf(prog, "fsck.%s", type);
+	argv[0] = string_copy(prog);
+	argc = 1;
+	
+	for (i=0; i <num_args; i++)
+		argv[argc++] = string_copy(args[i]);
+
+	if (progress && !progress_active()) {
+		if ((strcmp(type, "ext2") == 0) ||
+		    (strcmp(type, "ext3") == 0)) {
+			char tmp[80];
+			snprintf(tmp, 80, "-C%d", progress_fd);
+			argv[argc++] = string_copy(tmp);
+			inst->flags |= FLAG_PROGRESS;
+		}
+	}
+
+	argv[argc++] = string_copy(device);
+	argv[argc] = 0;
+
+	s = find_fsck(prog);
+	if (s == NULL) {
+		fprintf(stderr, _("fsck: %s: not found\n"), prog);
+		free(inst);
+		return ENOENT;
+	}
+
+	if (verbose || noexecute) {
+		printf("[%s (%d) -- %s] ", s, num_running,
+		       mntpt ? mntpt : device);
+		for (i=0; i < argc; i++)
+			printf("%s ", argv[i]);
+		printf("\n");
+	}
+	
+	/* Fork and execute the correct program. */
+	if (noexecute)
+		pid = -1;
+	else if ((pid = fork()) < 0) {
+		perror("fork");
+		free(inst);
+		return errno;
+	} else if (pid == 0) {
+		if (!interactive)
+			close(0);
+		(void) execv(s, argv);
+		perror(argv[0]);
+		free(inst);
+		exit(EXIT_ERROR);
+	}
+
+	for (i=0; i < argc; i++)
+		free(argv[i]);
+	
+	inst->pid = pid;
+	inst->prog = string_copy(prog);
+	inst->type = string_copy(type);
+	inst->device = string_copy(device);
+	inst->base_device = base_device(device);
+	inst->start_time = time(0);
+	inst->next = NULL;
+
+	/*
+	 * Find the end of the list, so we add the instance on at the end.
+	 */
+	for (p = instance_list; p && p->next; p = p->next);
+
+	if (p)
+		p->next = inst;
+	else
+		instance_list = inst;
+	
+	return 0;
+}
+
+/*
+ * Send a signal to all outstanding fsck child processes
+ */
+static int kill_all(int signum)
+{
+	struct fsck_instance *inst;
+	int	n = 0;
+
+	for (inst = instance_list; inst; inst = inst->next) {
+		if (inst->flags & FLAG_DONE)
+			continue;
+		kill(inst->pid, signum);
+		n++;
+	}
+	return n;
+}
+
+/*
+ * Wait for one child process to exit; when it does, unlink it from
+ * the list of executing child processes, and return it.
+ */
+static struct fsck_instance *wait_one(int flags)
+{
+	int	status;
+	int	sig;
+	struct fsck_instance *inst, *inst2, *prev;
+	pid_t	pid;
+
+	if (!instance_list)
+		return NULL;
+
+	if (noexecute) {
+		inst = instance_list;
+		prev = 0;
+#ifdef RANDOM_DEBUG
+		while (inst->next && (random() & 1)) {
+			prev = inst;
+			inst = inst->next;
+		}
+#endif
+		inst->exit_status = 0;
+		goto ret_inst;
+	}
+
+	/*
+	 * gcc -Wall fails saving throw against stupidity
+	 * (inst and prev are thought to be uninitialized variables)
+	 */
+	inst = prev = NULL;
+	
+	do {
+		pid = waitpid(-1, &status, flags);
+		if (cancel_requested && !kill_sent) {
+			kill_all(SIGTERM);
+			kill_sent++;
+		}
+		if ((pid == 0) && (flags & WNOHANG))
+			return NULL;
+		if (pid < 0) {
+			if ((errno == EINTR) || (errno == EAGAIN))
+				continue;
+			if (errno == ECHILD) {
+				fprintf(stderr,
+					_("%s: wait: No more child process?!?\n"),
+					progname);
+				return NULL;
+			}
+			perror("wait");
+			continue;
+		}
+		for (prev = 0, inst = instance_list;
+		     inst;
+		     prev = inst, inst = inst->next) {
+			if (inst->pid == pid)
+				break;
+		}
+	} while (!inst);
+
+	if (WIFEXITED(status)) 
+		status = WEXITSTATUS(status);
+	else if (WIFSIGNALED(status)) {
+		sig = WTERMSIG(status);
+		if (sig == SIGINT) {
+			status = EXIT_UNCORRECTED;
+		} else {
+			printf(_("Warning... %s for device %s exited "
+			       "with signal %d.\n"),
+			       inst->prog, inst->device, sig);
+			status = EXIT_ERROR;
+		}
+	} else {
+		printf(_("%s %s: status is %x, should never happen.\n"),
+		       inst->prog, inst->device, status);
+		status = EXIT_ERROR;
+	}
+	inst->exit_status = status;
+	if (progress && (inst->flags & FLAG_PROGRESS) &&
+	    !progress_active()) {
+		for (inst2 = instance_list; inst2; inst2 = inst2->next) {
+			if (inst2->flags & FLAG_DONE)
+				continue;
+			if (strcmp(inst2->type, "ext2") &&
+			    strcmp(inst2->type, "ext3"))
+				continue;
+			/*
+			 * If we've just started the fsck, wait a tiny
+			 * bit before sending the kill, to give it
+			 * time to set up the signal handler
+			 */
+			if (inst2->start_time < time(0)+2) {
+				if (fork() == 0) {
+					sleep(1);
+					kill(inst2->pid, SIGUSR1);
+					exit(0);
+				}
+			} else
+				kill(inst2->pid, SIGUSR1);
+			inst2->flags |= FLAG_PROGRESS;
+			break;
+		}
+	}
+ret_inst:
+	if (prev)
+		prev->next = inst->next;
+	else
+		instance_list = inst->next;
+	if (verbose > 1)
+		printf(_("Finished with %s (exit status %d)\n"),
+		       inst->device, inst->exit_status);
+	num_running--;
+	return inst;
+}
+
+#define FLAG_WAIT_ALL		0
+#define FLAG_WAIT_ATLEAST_ONE	1
+/*
+ * Wait until all executing child processes have exited; return the
+ * logical OR of all of their exit code values.
+ */
+static int wait_many(int flags)
+{
+	struct fsck_instance *inst;
+	int	global_status = 0;
+	int	wait_flags = 0;
+
+	while ((inst = wait_one(wait_flags))) {
+		global_status |= inst->exit_status;
+		free_instance(inst);
+#ifdef RANDOM_DEBUG
+		if (noexecute && (flags & WNOHANG) && !(random() % 3))
+			break;
+#endif
+		if (flags & FLAG_WAIT_ATLEAST_ONE)
+			wait_flags = WNOHANG;
+	}
+	return global_status;
+}
+
+/*
+ * Run the fsck program on a particular device
+ * 
+ * If the type is specified using -t, and it isn't prefixed with "no"
+ * (as in "noext2") and only one filesystem type is specified, then
+ * use that type regardless of what is specified in /etc/fstab.
+ * 
+ * If the type isn't specified by the user, then use either the type
+ * specified in /etc/fstab, or DEFAULT_FSTYPE.
+ */
+static void fsck_device(struct fs_info *fs, int interactive)
+{
+	const char *type;
+	int retval;
+
+	interpret_type(fs);
+
+	if (strcmp(fs->type, "auto") != 0)
+		type = fs->type;
+	else if (fstype && strncmp(fstype, "no", 2) &&
+	    strncmp(fstype, "opts=", 5) && strncmp(fstype, "loop", 4) && 
+	    !strchr(fstype, ','))
+		type = fstype;
+	else
+		type = DEFAULT_FSTYPE;
+
+	num_running++;
+	retval = execute(type, fs->device, fs->mountpt, interactive);
+	if (retval) {
+		fprintf(stderr, _("%s: Error %d while executing fsck.%s "
+			"for %s\n"), progname, retval, type, fs->device);
+		num_running--;
+	}
+}
+
+
+/*
+ * Deal with the fsck -t argument.
+ */
+struct fs_type_compile {
+	char **list;
+	int *type;
+	int  negate;
+} fs_type_compiled;
+
+#define FS_TYPE_NORMAL	0
+#define FS_TYPE_OPT	1
+#define FS_TYPE_NEGOPT	2
+
+static const char *fs_type_syntax_error =
+N_("Either all or none of the filesystem types passed to -t must be prefixed\n"
+   "with 'no' or '!'.\n");
+
+static void compile_fs_type(char *fs_type, struct fs_type_compile *cmp)
+{
+	char 	*cp, *list, *s;
+	int	num = 2;
+	int	negate, first_negate = 1;
+
+	if (fs_type) {
+		for (cp=fs_type; *cp; cp++) {
+			if (*cp == ',')
+				num++;
+		}
+	}
+
+	cmp->list = malloc(num * sizeof(char *));
+	cmp->type = malloc(num * sizeof(int));
+	if (!cmp->list || !cmp->type) {
+		fputs(_("Couldn't allocate memory for filesystem types\n"), 
+		      stderr);
+		exit(EXIT_ERROR);
+	}
+	memset(cmp->list, 0, num * sizeof(char *));
+	memset(cmp->type, 0, num * sizeof(int));
+	cmp->negate = 0;
+
+	if (!fs_type)
+		return;
+	
+	list = string_copy(fs_type);
+	num = 0;
+	s = strtok(list, ",");
+	while(s) {
+		negate = 0;
+		if (strncmp(s, "no", 2) == 0) {
+			s += 2;
+			negate = 1;
+		} else if (*s == '!') {
+			s++;
+			negate = 1;
+		}
+		if (strcmp(s, "loop") == 0)
+			/* loop is really short-hand for opts=loop */
+			goto loop_special_case;
+		else if (strncmp(s, "opts=", 5) == 0) {
+			s += 5;
+		loop_special_case:
+			cmp->type[num] = negate ? FS_TYPE_NEGOPT : FS_TYPE_OPT;
+		} else {
+			if (first_negate) {
+				cmp->negate = negate;
+				first_negate = 0;
+			}
+			if ((negate && !cmp->negate) ||
+			    (!negate && cmp->negate)) {
+				fputs(_(fs_type_syntax_error), stderr);
+				exit(EXIT_USAGE);
+			}
+		}
+#if 0
+		printf("Adding %s to list (type %d).\n", s, cmp->type[num]);
+#endif
+	        cmp->list[num++] = string_copy(s);
+		s = strtok(NULL, ",");
+	}
+	free(list);
+}
+
+/*
+ * This function returns true if a particular option appears in a
+ * comma-delimited options list
+ */
+static int opt_in_list(char *opt, char *optlist)
+{
+	char	*list, *s;
+
+	if (!optlist)
+		return 0;
+	list = string_copy(optlist);
+	
+	s = strtok(list, ",");
+	while(s) {
+		if (strcmp(s, opt) == 0) {
+			free(list);
+			return 1;
+		}
+		s = strtok(NULL, ",");
+	}
+        free(list);
+	return 0;
+}
+
+/* See if the filesystem matches the criteria given by the -t option */
+static int fs_match(struct fs_info *fs, struct fs_type_compile *cmp)
+{
+	int n, ret = 0, checked_type = 0;
+	char *cp;
+
+	if (cmp->list == 0 || cmp->list[0] == 0)
+		return 1;
+
+	for (n=0; (cp = cmp->list[n]); n++) {
+		switch (cmp->type[n]) {
+		case FS_TYPE_NORMAL:
+			checked_type++;
+			if (strcmp(cp, fs->type) == 0) {
+				ret = 1;
+			}
+			break;
+		case FS_TYPE_NEGOPT:
+			if (opt_in_list(cp, fs->opts))
+				return 0;
+			break;
+		case FS_TYPE_OPT:
+			if (!opt_in_list(cp, fs->opts))
+				return 0;
+			break;
+		}
+	}
+	if (checked_type == 0)
+		return 1;
+	return (cmp->negate ? !ret : ret);
+}
+
+/* Check if we should ignore this filesystem. */
+static int ignore(struct fs_info *fs)
+{
+	const char **ip;
+	int wanted = 0;
+
+	/*
+	 * If the pass number is 0, ignore it.
+	 */
+	if (fs->passno == 0)
+		return 1;
+
+	/*
+	 * If this is a bind mount, ignore it.
+	 */
+	if (opt_in_list("bind", fs->opts)) {
+		fprintf(stderr,
+			_("%s: skipping bad line in /etc/fstab: bind mount with nonzero fsck pass number\n"),
+			fs->mountpt);
+		return 1;
+	}
+
+	interpret_type(fs);
+
+	/*
+	 * If a specific fstype is specified, and it doesn't match,
+	 * ignore it.
+	 */
+	if (!fs_match(fs, &fs_type_compiled)) return 1;
+	
+	/* Are we ignoring this type? */
+	for(ip = ignored_types; *ip; ip++)
+		if (strcmp(fs->type, *ip) == 0) return 1;
+
+	/* Do we really really want to check this fs? */
+	for(ip = really_wanted; *ip; ip++)
+		if (strcmp(fs->type, *ip) == 0) {
+			wanted = 1;
+			break;
+		}
+
+	/* See if the <fsck.fs> program is available. */
+	if (find_fsck(fs->type) == NULL) {
+		if (wanted)
+			fprintf(stderr, _("fsck: cannot check %s: fsck.%s not found\n"),
+				fs->device, fs->type);
+		return 1;
+	}
+
+	/* We can and want to check this file system type. */
+	return 0;
+}
+
+/*
+ * Returns TRUE if a partition on the same disk is already being
+ * checked.
+ */
+static int device_already_active(char *device)
+{
+	struct fsck_instance *inst;
+	char *base;
+
+	if (force_all_parallel)
+		return 0;
+
+#ifdef BASE_MD
+	/* Don't check a soft raid disk with any other disk */
+	if (instance_list &&
+	    (!strncmp(instance_list->device, BASE_MD, sizeof(BASE_MD)-1) ||
+	     !strncmp(device, BASE_MD, sizeof(BASE_MD)-1)))
+		return 1;
+#endif
+
+	base = base_device(device);
+	/*
+	 * If we don't know the base device, assume that the device is
+	 * already active if there are any fsck instances running.
+	 */
+	if (!base) 
+		return (instance_list != 0);
+	for (inst = instance_list; inst; inst = inst->next) {
+		if (!inst->base_device || !strcmp(base, inst->base_device)) {
+			free(base);
+			return 1;
+		}
+	}
+	free(base);
+	return 0;
+}
+
+/* Check all file systems, using the /etc/fstab table. */
+static int check_all(NOARGS)
+{
+	struct fs_info *fs = NULL;
+	int status = EXIT_OK;
+	int not_done_yet = 1;
+	int passno = 1;
+	int pass_done;
+
+	if (verbose)
+		fputs(_("Checking all file systems.\n"), stdout);
+
+	/*
+	 * Do an initial scan over the filesystem; mark filesystems
+	 * which should be ignored as done, and resolve any "auto"
+	 * filesystem types (done as a side-effect of calling ignore()).
+	 */
+	for (fs = filesys_info; fs; fs = fs->next) {
+		if (ignore(fs))
+			fs->flags |= FLAG_DONE;
+	}
+		
+	/*
+	 * Find and check the root filesystem.
+	 */
+	if (!parallel_root) {
+		for (fs = filesys_info; fs; fs = fs->next) {
+			if (!strcmp(fs->mountpt, "/"))
+				break;
+		}
+		if (fs) {
+			if (!skip_root && !ignore(fs)) {
+				fsck_device(fs, 1);
+				status |= wait_many(FLAG_WAIT_ALL);
+				if (status > EXIT_NONDESTRUCT)
+					return status;
+			}
+			fs->flags |= FLAG_DONE;
+		}
+	}
+	/*
+	 * This is for the bone-headed user who enters the root
+	 * filesystem twice.  Skip root will skep all root entries.
+	 */
+	if (skip_root)
+		for (fs = filesys_info; fs; fs = fs->next)
+			if (!strcmp(fs->mountpt, "/"))
+				fs->flags |= FLAG_DONE;
+
+	while (not_done_yet) {
+		not_done_yet = 0;
+		pass_done = 1;
+
+		for (fs = filesys_info; fs; fs = fs->next) {
+			if (cancel_requested)
+				break;
+			if (fs->flags & FLAG_DONE)
+				continue;
+			/*
+			 * If the filesystem's pass number is higher
+			 * than the current pass number, then we don't
+			 * do it yet.
+			 */
+			if (fs->passno > passno) {
+				not_done_yet++;
+				continue;
+			}
+			/*
+			 * If a filesystem on a particular device has
+			 * already been spawned, then we need to defer
+			 * this to another pass.
+			 */
+			if (device_already_active(fs->device)) {
+				pass_done = 0;
+				continue;
+			}
+			/*
+			 * Spawn off the fsck process
+			 */
+			fsck_device(fs, serialize);
+			fs->flags |= FLAG_DONE;
+
+			/*
+			 * Only do one filesystem at a time, or if we
+			 * have a limit on the number of fsck's extant
+			 * at one time, apply that limit.
+			 */
+			if (serialize ||
+			    (max_running && (num_running >= max_running))) {
+				pass_done = 0;
+				break;
+			}
+		}
+		if (cancel_requested)
+			break;
+		if (verbose > 1)
+			printf(_("--waiting-- (pass %d)\n"), passno);
+		status |= wait_many(pass_done ? FLAG_WAIT_ALL :
+				    FLAG_WAIT_ATLEAST_ONE);
+		if (pass_done) {
+			if (verbose > 1) 
+				printf("----------------------------------\n");
+			passno++;
+		} else
+			not_done_yet++;
+	}
+	if (cancel_requested && !kill_sent) {
+		kill_all(SIGTERM);
+		kill_sent++;
+	}
+	status |= wait_many(FLAG_WAIT_ATLEAST_ONE);
+	return status;
+}
+
+static void usage(NOARGS)
+{
+	fputs(_("Usage: fsck [-ANPRTV] [ -C [ fd ] ] [-t fstype] [fs-options] [filesys ...]\n"), stderr);
+	exit(EXIT_USAGE);
+}
+
+#ifdef HAVE_SIGNAL_H
+static void signal_cancel(int sig FSCK_ATTR((unused)))
+{
+	cancel_requested++;
+}
+#endif
+
+static void PRS(int argc, char *argv[])
+{
+	int	i, j;
+	char	*arg, *dev, *tmp = 0;
+	char	options[128];
+	int	opt = 0;
+	int     opts_for_fsck = 0;
+#ifdef HAVE_SIGNAL_H
+	struct sigaction	sa;
+
+	/*
+	 * Set up signal action
+	 */
+	memset(&sa, 0, sizeof(struct sigaction));
+	sa.sa_handler = signal_cancel;
+	sigaction(SIGINT, &sa, 0);
+	sigaction(SIGTERM, &sa, 0);
+#endif
+	
+	num_devices = 0;
+	num_args = 0;
+	instance_list = 0;
+
+	progname = argv[0];
+
+	for (i=1; i < argc; i++) {
+		arg = argv[i];
+		if (!arg)
+			continue;
+		if ((arg[0] == '/' && !opts_for_fsck) || strchr(arg, '=')) {
+			if (num_devices >= MAX_DEVICES) {
+				fprintf(stderr, _("%s: too many devices\n"),
+					progname);
+				exit(EXIT_ERROR);
+			}
+			dev = blkid_get_devname(cache, arg, NULL);
+			if (!dev && strchr(arg, '=')) {
+				/*
+				 * Check to see if we failed because
+				 * /proc/partitions isn't found.
+				 */
+				if (access("/proc/partitions", R_OK) < 0) {
+					fprintf(stderr, "Couldn't open /proc/partitions: %s\n",
+						strerror(errno));
+					fprintf(stderr, "Is /proc mounted?\n");
+					exit(EXIT_ERROR);
+				}
+				/*
+				 * Check to see if this is because
+				 * we're not running as root
+				 */
+				if (geteuid())
+					fprintf(stderr,
+		"Must be root to scan for matching filesystems: %s\n", arg);
+				else
+					fprintf(stderr,
+		"Couldn't find matching filesystem: %s\n", arg);
+				exit(EXIT_ERROR);
+			}
+			devices[num_devices++] = dev ? dev : string_copy(arg);
+			continue;
+		}
+		if (arg[0] != '-' || opts_for_fsck) {
+			if (num_args >= MAX_ARGS) {
+				fprintf(stderr, _("%s: too many arguments\n"),
+					progname);
+				exit(EXIT_ERROR);
+			}
+			args[num_args++] = string_copy(arg);
+			continue;
+		}
+		for (j=1; arg[j]; j++) {
+			if (opts_for_fsck) {
+				options[++opt] = arg[j];
+				continue;
+			}
+			switch (arg[j]) {
+			case 'A':
+				doall++;
+				break;
+			case 'C':
+				progress++;
+				if (arg[j+1]) {
+					progress_fd = string_to_int(arg+j+1);
+					if (progress_fd < 0)
+						progress_fd = 0;
+					else
+						goto next_arg;
+				} else if ((i+1) < argc && 
+					   !strncmp(argv[i+1], "-", 1) == 0) {
+					progress_fd = string_to_int(argv[i]);
+					if (progress_fd < 0)
+						progress_fd = 0;
+					else {
+						goto next_arg;
+						i++;
+					}
+				}
+				break;
+			case 'V':
+				verbose++;
+				break;
+			case 'N':
+				noexecute++;
+				break;
+			case 'R':
+				skip_root++;
+				break;
+			case 'T':
+				notitle++;
+				break;
+			case 'M':
+				like_mount++;
+				break;
+			case 'P':
+				parallel_root++;
+				break;
+			case 's':
+				serialize++;
+				break;
+			case 't':
+				tmp = 0;
+				if (fstype)
+					usage();
+				if (arg[j+1])
+					tmp = arg+j+1;
+				else if ((i+1) < argc)
+					tmp = argv[++i];
+				else
+					usage();
+				fstype = string_copy(tmp);
+				compile_fs_type(fstype, &fs_type_compiled);
+				goto next_arg;
+			case '-':
+				opts_for_fsck++;
+				break;
+			case '?':
+				usage();
+				break;
+			default:
+				options[++opt] = arg[j];
+				break;
+			}
+		}
+	next_arg:
+		if (opt) {
+			options[0] = '-';
+			options[++opt] = '\0';
+			if (num_args >= MAX_ARGS) {
+				fprintf(stderr,
+					_("%s: too many arguments\n"),
+					progname);
+				exit(EXIT_ERROR);
+			}
+			args[num_args++] = string_copy(options);
+			opt = 0;
+		}
+	}
+	if (getenv("FSCK_FORCE_ALL_PARALLEL"))
+		force_all_parallel++;
+	if ((tmp = getenv("FSCK_MAX_INST")))
+	    max_running = atoi(tmp);
+}
+
+int main(int argc, char *argv[])
+{
+	int i, status = 0;
+	int interactive = 0;
+	char *oldpath = getenv("PATH");
+	const char *fstab;
+	struct fs_info *fs;
+
+	setvbuf(stdout, NULL, _IONBF, BUFSIZ);
+	setvbuf(stderr, NULL, _IONBF, BUFSIZ);
+
+	setlocale(LC_MESSAGES, "");
+	setlocale(LC_CTYPE, "");
+	bindtextdomain(PACKAGE, LOCALEDIR);
+	textdomain(PACKAGE);
+
+	blkid_get_cache(&cache, NULL);
+	PRS(argc, argv);
+
+	if (!notitle)
+		printf("fsck %s\n", PACKAGE_VERSION);
+
+	fstab = getenv("FSTAB_FILE");
+	if (!fstab)
+		fstab = _PATH_MNTTAB;
+	load_fs_info(fstab);
+
+	/* Update our search path to include uncommon directories. */
+	if (oldpath) {
+		fsck_path = malloc (strlen (fsck_prefix_path) + 1 +
+				    strlen (oldpath) + 1);
+		if (!fsck_path) {
+			fprintf(stderr, "%s: Unable to allocate memory for fsck_path\n", progname);
+			exit(EXIT_ERROR);
+		}
+		strcpy (fsck_path, fsck_prefix_path);
+		strcat (fsck_path, ":");
+		strcat (fsck_path, oldpath);
+	} else {
+		fsck_path = string_copy(fsck_prefix_path);
+	}
+	
+	if ((num_devices == 1) || (serialize))
+		interactive = 1;
+
+	/* If -A was specified ("check all"), do that! */
+	if (doall)
+		return check_all();
+
+	if (num_devices == 0) {
+		serialize++;
+		interactive++;
+		return check_all();
+	}
+	for (i = 0 ; i < num_devices; i++) {
+		if (cancel_requested) {
+			if (!kill_sent) {
+				kill_all(SIGTERM);
+				kill_sent++;
+			}
+			break;
+		}
+		fs = lookup(devices[i]);
+		if (!fs) {
+			fs = create_fs_device(devices[i], 0, "auto",
+					      0, -1, -1);
+			if (!fs)
+				continue;
+		}
+		fsck_device(fs, interactive);
+		if (serialize ||
+		    (max_running && (num_running >= max_running))) {
+			struct fsck_instance *inst;
+
+			inst = wait_one(0);
+			if (inst) {
+				status |= inst->exit_status;
+				free_instance(inst);
+			}
+			if (verbose > 1) 
+				printf("----------------------------------\n");
+		}
+	}
+	status |= wait_many(FLAG_WAIT_ALL);
+	free(fsck_path);
+	blkid_put_cache(cache);
+	return status;
+}
diff --git a/fsck/fsck.h b/fsck/fsck.h
new file mode 100644
index 0000000..55cb525
--- /dev/null
+++ b/fsck/fsck.h
@@ -0,0 +1,70 @@
+/*
+ * fsck.h
+ */
+
+#include <time.h>
+
+#ifdef __STDC__
+#define NOARGS void
+#else
+#define NOARGS
+#define const
+#endif
+
+#ifdef __GNUC__
+#define FSCK_ATTR(x) __attribute__(x)
+#else
+#define FSCK_ATTR(x)
+#endif
+
+
+#ifndef DEFAULT_FSTYPE
+#define DEFAULT_FSTYPE	"ext2"
+#endif
+
+#define MAX_DEVICES 32
+#define MAX_ARGS 32
+
+#define EXIT_OK          0
+#define EXIT_NONDESTRUCT 1
+#define EXIT_DESTRUCT    2
+#define EXIT_UNCORRECTED 4
+#define EXIT_ERROR       8
+#define EXIT_USAGE       16
+#define EXIT_LIBRARY     128
+
+/*
+ * Internal structure for mount tabel entries.
+ */
+
+struct fs_info {
+	char  *device;
+	char  *mountpt;
+	char  *type;
+	char  *opts;
+	int   freq;
+	int   passno;
+	int   flags;
+	struct fs_info *next;
+};
+
+#define FLAG_DONE 1
+#define FLAG_PROGRESS 2
+
+/*
+ * Structure to allow exit codes to be stored
+ */
+struct fsck_instance {
+	int	pid;
+	int	flags;
+	int	exit_status;
+	time_t	start_time;
+	char *	prog;
+	char *	type;
+	char *	device;
+	char *	base_device;
+	struct fsck_instance *next;
+};
+
+extern char *base_device(const char *device);
+extern const char *identify_fs(const char *fs_name, const char *fs_types);
