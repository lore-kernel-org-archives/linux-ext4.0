Return-Path: <SRS0=3UD1=RY=vger.kernel.org=linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7CDC9C10F05
	for <linux-ext4@archiver.kernel.org>; Thu, 21 Mar 2019 02:02:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 53BED218A2
	for <linux-ext4@archiver.kernel.org>; Thu, 21 Mar 2019 02:02:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727780AbfCUCCd (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Wed, 20 Mar 2019 22:02:33 -0400
Received: from outgoing-auth-1.mit.edu ([18.9.28.11]:57816 "EHLO
        outgoing.mit.edu" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727614AbfCUCCa (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Wed, 20 Mar 2019 22:02:30 -0400
Received: from callcc.thunk.org (guestnat-104-133-0-99.corp.google.com [104.133.0.99] (may be forged))
        (authenticated bits=0)
        (User authenticated as tytso@ATHENA.MIT.EDU)
        by outgoing.mit.edu (8.14.7/8.12.4) with ESMTP id x2L22Ouu029546
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 20 Mar 2019 22:02:25 -0400
Received: by callcc.thunk.org (Postfix, from userid 15806)
        id 0983A420AAF; Wed, 20 Mar 2019 22:02:23 -0400 (EDT)
From:   "Theodore Ts'o" <tytso@mit.edu>
To:     Ext4 Developers List <linux-ext4@vger.kernel.org>
Cc:     darrick.wong@oracle.com, "Theodore Ts'o" <tytso@mit.edu>
Subject: [PATCH 8/9] e2scrub_all: refactor device probe loop
Date:   Wed, 20 Mar 2019 22:02:17 -0400
Message-Id: <20190321020218.5154-8-tytso@mit.edu>
X-Mailer: git-send-email 2.19.1
In-Reply-To: <20190321020218.5154-1-tytso@mit.edu>
References: <20190321020218.5154-1-tytso@mit.edu>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-ext4-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org

From: "Darrick J. Wong" <darrick.wong@oracle.com>

Paul Menzel reported that the e2scrub_all reaper service that runs at
startup takes a long time to run, and Ted Ts'o pointed out that we could
do a lot less work by using lvs as the outer loop in the ext4 filesystem
probe function so that we only have to lsblk the lvm devices containing
ext4 filesystems.

Therefore, refactor the loops to put lvs first, which should boost speed
a bit.

[ Made some of the further optimizations suggested by Lukas Czerner.  -- TYT ]

Reported-by: Paul Menzel <pmenzel@molgen.mpg.de>
Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
---
 scrub/e2scrub_all.in | 34 +++++++++++++++++++++++-----------
 1 file changed, 23 insertions(+), 11 deletions(-)

diff --git a/scrub/e2scrub_all.in b/scrub/e2scrub_all.in
index 4cb90a0de..cad232987 100644
--- a/scrub/e2scrub_all.in
+++ b/scrub/e2scrub_all.in
@@ -22,6 +22,7 @@ PATH=/usr/local/sbin:/usr/local/bin:/sbin:/bin:/usr/sbin:/usr/bin
 
 scrub_all=0
 snap_size_mb=256
+reap=0
 conffile="@root_sysconfdir@/e2scrub.conf"
 
 test -f "${conffile}" && . "${conffile}"
@@ -65,7 +66,7 @@ exitcode() {
 while getopts "nrAV" opt; do
 	case "${opt}" in
 	"n") DBG="echo Would execute: " ;;
-	"r") scrub_args="${scrub_args} -r";;
+	"r") scrub_args="${scrub_args} -r"; reap=1;;
 	"A") scrub_all=1;;
 	"V") print_version; exitcode 0;;
 	*) print_help; exitcode 2;;
@@ -88,9 +89,12 @@ if ! type lvcreate >& /dev/null ; then
 fi
 
 # Find scrub targets, make sure we only do this once.
-ls_scrub_targets() {
-	lsblk -o NAME,FSTYPE,MOUNTPOINT -p -P -n | while read vars; do
+ls_scan_targets() {
+	lvs --name-prefixes -o vg_name,lv_path \
+			-S lv_active=active,lv_role=public --noheadings | \
+	while read vars; do
 		eval "${vars}"
+		eval "$(lsblk -o FSTYPE,MOUNTPOINT -p -P -n "${LVM2_LV_PATH}")"
 
 		# Skip non-ext[234]
 		case "${FSTYPE}" in
@@ -103,12 +107,6 @@ ls_scrub_targets() {
 			continue;
 		fi
 
-		# Skip non-lvm devices and lvm snapshots
-		lvm_vars="$(lvs --nameprefixes -o vg_name,lv_name,lv_role --noheadings "${NAME}" 2> /dev/null)"
-		test $? -ne 0 && continue
-		eval "${lvm_vars}"
-		echo "${LVM2_LV_ROLE}" | grep -q "snapshot" && continue
-
 		free_space="$(vgs -o vg_free --units m --noheadings --no-suffix "${LVM2_VG_NAME}" 2> /dev/null | sed -e 's/\..*//')"
 		test "${snap_size_mb}" -gt "${free_space}" && continue
 
@@ -120,6 +118,20 @@ ls_scrub_targets() {
 	done | sort | uniq
 }
 
+# Find leftover scrub snapshots
+ls_reap_targets() {
+	lvs -o lv_path -S lv_role=snapshot -S lv_name=~\(e2scrub$\) --noheadings
+}
+
+# Figure out what we're targeting
+ls_targets() {
+	if [ "${reap}" -eq 1 ]; then
+		ls_reap_targets
+	else
+		ls_scan_targets
+	fi
+}
+
 # systemd doesn't know to do path escaping on the instance variable we pass
 # to the e2scrub service, which breaks things if there is a dash in the path
 # name.  Therefore, do the path escaping ourselves if needed.
@@ -140,10 +152,10 @@ escape_path_for_systemd() {
 
 # Scrub any mounted fs on lvm by creating a snapshot and fscking that.
 stdin="$(realpath /dev/stdin)"
-ls_scrub_targets | while read tgt; do
+ls_targets | while read tgt; do
 	# If we're not reaping and systemd is present, try invoking the
 	# systemd service.
-	if [ -z "${scrub_args}" ] && type systemctl > /dev/null 2>&1; then
+	if [ "${reap}" -ne 1 ] && type systemctl > /dev/null 2>&1; then
 		tgt_esc="$(escape_path_for_systemd "${tgt}")"
 		${DBG} systemctl start "e2scrub@${tgt_esc}" 2> /dev/null < "${stdin}"
 		res=$?
-- 
2.19.1

