From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: [PATCH 2/4] e2scrub: create a script to scrub all ext* filesystems
Date: Thu, 07 Dec 2017 10:48:36 -0800
Message-ID: <151267251622.1350.5012077999744307213.stgit@magnolia>
References: <151267250365.1350.7799938074608034424.stgit@magnolia>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Cc: adilger@dilger.ca, linux-ext4@vger.kernel.org
To: tytso@mit.edu, darrick.wong@oracle.com
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from aserp2120.oracle.com ([141.146.126.78]:57482 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750828AbdLGSsl (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Thu, 7 Dec 2017 13:48:41 -0500
In-Reply-To: <151267250365.1350.7799938074608034424.stgit@magnolia>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

From: Darrick J. Wong <darrick.wong@oracle.com>

Create an e2scrub_all command to find all ext* filesystems
and run an online scrub against them all.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 scrub/Makefile.in      |    9 +++++++-
 scrub/e2scrub_all.8.in |   14 +++++++++++++
 scrub/e2scrub_all.in   |   51 ++++++++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 72 insertions(+), 2 deletions(-)
 create mode 100644 scrub/e2scrub_all.8.in
 create mode 100644 scrub/e2scrub_all.in


diff --git a/scrub/Makefile.in b/scrub/Makefile.in
index 1f3253d..ce8c85f 100644
--- a/scrub/Makefile.in
+++ b/scrub/Makefile.in
@@ -11,8 +11,8 @@ INSTALL = @INSTALL@
 
 @MCONFIG@
 
-PROGS=		e2scrub
-MANPAGES=	e2scrub.8
+PROGS=		e2scrub e2scrub_all
+MANPAGES=	e2scrub.8 e2scrub_all.8
 CONFFILES=	e2scrub.conf
 
 ifeq ($(HAVE_UDEV),yes)
@@ -29,6 +29,11 @@ e2scrub: $(DEP_SUBSTITUTE) e2scrub.in
 	$(Q) $(SUBSTITUTE_UPTIME) $(srcdir)/e2scrub.in $@
 	$(Q) chmod a+x $@
 
+e2scrub_all: e2scrub_all.in
+	$(E) "	SUBST $@"
+	$(Q) $(SUBSTITUTE_UPTIME) $(srcdir)/e2scrub_all.in $@
+	$(Q) chmod a+x $@
+
 %.8: %.8.in $(DEP_SUBSTITUTE)
 	$(E) "	SUBST $@"
 	$(Q) $(SUBSTITUTE_UPTIME) $< $@
diff --git a/scrub/e2scrub_all.8.in b/scrub/e2scrub_all.8.in
new file mode 100644
index 0000000..b05f13c
--- /dev/null
+++ b/scrub/e2scrub_all.8.in
@@ -0,0 +1,14 @@
+.TH E2SCRUB 8 "@E2FSPROGS_MONTH@ @E2FSPROGS_YEAR@" "E2fsprogs version @E2FSPROGS_VERSION@"
+.SH NAME
+e2scrub_all - Check all mounted btrfs/ext4/XFS LVM file systems for errors.
+.SH SYNOPSYS
+.B
+e2scrub_all
+.SH DESCRIPTION
+Searches the system for all LVM volumes containing an ext2, ext3, or
+ext4 file system, and checks them all for errors.
+If the file system has no errors, it will be fstrim'd.
+.SH AUTHOR
+Darrick J. Wong <darrick.wong@oracle.com>
+.SH COPYRIGHT
+Copyright ©2017 Darrick J. Wong.  License is GPLv2+. <http://www.gnu.org/licenses/gpl-2.0.html>
diff --git a/scrub/e2scrub_all.in b/scrub/e2scrub_all.in
new file mode 100644
index 0000000..a9ba670
--- /dev/null
+++ b/scrub/e2scrub_all.in
@@ -0,0 +1,51 @@
+#!/bin/bash
+
+#  Copyright (C) 2017 Oracle.  All Rights Reserved.
+#
+#  Author: Darrick J. Wong <darrick.wong@oracle.com>
+#
+#  This program is free software; you can redistribute it and/or
+#  modify it under the terms of the GNU General Public License
+#  as published by the Free Software Foundation; either version 2
+#  of the License, or (at your option) any later version.
+#
+#  This program is distributed in the hope that it would be useful,
+#  but WITHOUT ANY WARRANTY; without even the implied warranty of
+#  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+#  GNU General Public License for more details.
+#
+#  You should have received a copy of the GNU General Public License
+#  along with this program; if not, write the Free Software Foundation,
+#  Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301, USA.
+
+# Check all ext[234] filesystems mounted on LVM
+types="ext2,ext3,ext4"
+
+exitcode() {
+	ret="$1"
+
+	exit "${ret}"
+}
+
+prog_path() {
+	path="$1"
+	displayname="$2"
+
+	if ! type -P "${path}" && [ -n "${displayname}" ]; then
+		echo "${displayname}: Command not found."
+		exitcode 8
+	fi
+}
+
+LVS_PROG="$(prog_path "@root_sbindir@/lvs" "lvs")"
+BLKID_PROG="$(prog_path "@root_sbindir@/blkid" "blkid")"
+
+# Scrub any fs on lvm by creating a snapshot and fscking that.
+"${LVS_PROG}" -o vg_name,lv_name --noheadings 2> /dev/null | while read vg lv; do
+	dev="/dev/${vg}/${lv}"
+	"${BLKID_PROG}" -p -n "${types}" "${dev}" > /dev/null 2>&1 || continue
+
+	${DBG} "@root_sbindir@/e2scrub" "${dev}"
+done
+
+exitcode 0
