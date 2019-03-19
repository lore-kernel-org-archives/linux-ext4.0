Return-Path: <SRS0=iy/Z=RW=vger.kernel.org=linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.6 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,UNPARSEABLE_RELAY,URIBL_BLOCKED,
	USER_AGENT_MUTT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DEF54C43381
	for <linux-ext4@archiver.kernel.org>; Tue, 19 Mar 2019 00:17:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id ADCA4213F2
	for <linux-ext4@archiver.kernel.org>; Tue, 19 Mar 2019 00:17:47 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="Gl2A+n+h"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726743AbfCSARr (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Mon, 18 Mar 2019 20:17:47 -0400
Received: from aserp2130.oracle.com ([141.146.126.79]:50058 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726438AbfCSARr (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Mon, 18 Mar 2019 20:17:47 -0400
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x2J04o9h172370;
        Tue, 19 Mar 2019 00:17:34 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : mime-version : content-type; s=corp-2018-07-02;
 bh=mv9F3bWNe/tNdoUKk9S+wVumZ19i5LBJISW5ADpdnoU=;
 b=Gl2A+n+hzgPjRNR+bjb9sdJLVKNmRvgfrmVKNK8Mg9GPOfSexQSxNa9xrrR7gTe1f8T1
 FrgxEYI7n6wCI1BOIBaR8weHv6Is3OovYW/BjRIsSuU6GTMmcURJ1+QtIh+nDxR1jmFF
 wDZCM6X/gqXJOPDzCPZLq/zBIOCod5M50z5xv9ThO2jmo+C4HfUFY0Hlt0qns5nyJVA4
 vR43Fk9P8/hK5Ff6rC8m5uprsLFYU+ooY6t7H/GZ7J3ArQHEoat8qgKzOYnAXnysfAY0
 5dNme6wGLwqXXE151rj//2C3IMApM4WKpvugWVskiYeW7AyPfFtLmiOfGqmvKP6rSm76 uw== 
Received: from aserv0022.oracle.com (aserv0022.oracle.com [141.146.126.234])
        by aserp2130.oracle.com with ESMTP id 2r8pnehud9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 19 Mar 2019 00:17:34 +0000
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by aserv0022.oracle.com (8.14.4/8.14.4) with ESMTP id x2J0HXGl018338
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 19 Mar 2019 00:17:34 GMT
Received: from abhmp0014.oracle.com (abhmp0014.oracle.com [141.146.116.20])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id x2J0HX4r013845;
        Tue, 19 Mar 2019 00:17:33 GMT
Received: from localhost (/10.159.250.22)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 18 Mar 2019 17:17:32 -0700
Date:   Mon, 18 Mar 2019 17:17:32 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     "Theodore Ts'o" <tytso@mit.edu>
Cc:     linux-ext4@vger.kernel.org, Paul Menzel <pmenzel@molgen.mpg.de>
Subject: [PATCH] e2scrub_all: refactor device probe loop
Message-ID: <20190319001732.GB4916@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=5900 definitions=9199 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=9 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1810050000
 definitions=main-1903180166
Sender: linux-ext4-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

Paul Menzel reported that the e2scrub_all reaper service that runs at
startup takes a long time to run, and Ted T'so pointed out that we could
do a lot less work by using lvs as the outer loop in the ext4 filesystem
probe function so that we only have to lsblk the lvm devices containing
ext4 filesystems.

Therefore, refactor the loops to put lvs first, which should boost speed
a bit.

Reported-by: Paul Menzel <pmenzel@molgen.mpg.de>
Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 scrub/e2scrub_all.in |   51 ++++++++++++++++++++++++++++++++++++--------------
 1 file changed, 37 insertions(+), 14 deletions(-)

diff --git a/scrub/e2scrub_all.in b/scrub/e2scrub_all.in
index 23d122d25..41420d03d 100644
--- a/scrub/e2scrub_all.in
+++ b/scrub/e2scrub_all.in
@@ -19,6 +19,7 @@
 #  Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301, USA.
 
 scrub_all=0
+reap=0
 conffile="@root_sysconfdir@/e2scrub.conf"
 
 test -f "${conffile}" && . "${conffile}"
@@ -61,7 +62,7 @@ exitcode() {
 while getopts "ArV" opt; do
 	case "${opt}" in
 	"A") scrub_all=1;;
-	"r") scrub_args="${scrub_args} -r";;
+	"r") scrub_args="${scrub_args} -r"; reap=1;;
 	"V") print_version; exitcode 0;;
 	*) print_help; exitcode 2;;
 	esac
@@ -69,27 +70,27 @@ done
 shift "$((OPTIND - 1))"
 
 # Find scrub targets, make sure we only do this once.
-ls_scrub_targets() {
-	lsblk -o NAME,FSTYPE,MOUNTPOINT -p -P -n | while read vars; do
+ls_scan_targets() {
+	lvs --name-prefixes -o vg_name,lv_name,lv_path \
+			-S lv_active=active,lv_role=public --noheadings | \
+	while read vars; do
 		eval "${vars}"
+		eval "$(lsblk -o NAME,FSTYPE,MOUNTPOINT -p -P -n "${LVM2_LV_PATH}")"
 
-		# Skip non-ext[234]
+		# Skip unless ext*
 		case "${FSTYPE}" in
-		ext[234])	;;
-		*)		continue;;
+		ext*) ;;
+		*) continue;;
 		esac
 
+		# Don't run against a snapshot ever
+		echo "${LVM2_LV_ROLE}" | grep -q "snapshot" && continue
+
 		# Skip unmounted filesystems unless -A
 		if [ "${scrub_all}" -eq 0 ] && [ -z "${MOUNTPOINT}" ]; then
 			continue;
 		fi
 
-		# Skip non-lvm devices and lvm snapshots
-		lvm_vars="$(lvs --nameprefixes -o vg_name,lv_name,lv_role --noheadings "${NAME}" 2> /dev/null)"
-		test $? -ne 0 && continue
-		eval "${lvm_vars}"
-		echo "${LVM2_LV_ROLE}" | grep -q "snapshot" && continue
-
 		if [ -n "${MOUNTPOINT}" ]; then
 			echo "${MOUNTPOINT}"
 		else
@@ -98,6 +99,28 @@ ls_scrub_targets() {
 	done | sort | uniq
 }
 
+# Find leftover scrub snapshots
+ls_reap_targets() {
+	lvs --name-prefixes -o vg_name,lv_name,lv_path,origin \
+		-S lv_role=snapshot --noheadings | while read vars; do
+		eval "${vars}"
+
+		# Filter out anything except our snapshots
+		case "${LVM2_LV_NAME}" in
+		*.e2scrub) echo "${LVM2_LV_PATH}";;
+		esac
+	done | sort | uniq
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
@@ -118,10 +141,10 @@ escape_path_for_systemd() {
 
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
