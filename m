Return-Path: <SRS0=3UD1=RY=vger.kernel.org=linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ED555C4360F
	for <linux-ext4@archiver.kernel.org>; Thu, 21 Mar 2019 20:25:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C6E8E218FD
	for <linux-ext4@archiver.kernel.org>; Thu, 21 Mar 2019 20:25:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728904AbfCUUZb (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Thu, 21 Mar 2019 16:25:31 -0400
Received: from outgoing-auth-1.mit.edu ([18.9.28.11]:52567 "EHLO
        outgoing.mit.edu" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1728093AbfCUUZa (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Thu, 21 Mar 2019 16:25:30 -0400
Received: from callcc.thunk.org (guestnat-104-133-0-99.corp.google.com [104.133.0.99] (may be forged))
        (authenticated bits=0)
        (User authenticated as tytso@ATHENA.MIT.EDU)
        by outgoing.mit.edu (8.14.7/8.12.4) with ESMTP id x2LKPJs9017000
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 21 Mar 2019 16:25:19 -0400
Received: by callcc.thunk.org (Postfix, from userid 15806)
        id E4083420AA9; Thu, 21 Mar 2019 16:25:18 -0400 (EDT)
From:   "Theodore Ts'o" <tytso@mit.edu>
To:     Ext4 Developers List <linux-ext4@vger.kernel.org>
Cc:     darrick.wong@oracle.com, lczerner@redhat.com,
        "Theodore Ts'o" <tytso@mit.edu>
Subject: [PATCH 1/9] e2scrub: check to make sure lvm2 is installed
Date:   Thu, 21 Mar 2019 16:25:05 -0400
Message-Id: <20190321202513.1969-2-tytso@mit.edu>
X-Mailer: git-send-email 2.19.1
In-Reply-To: <20190321202513.1969-1-tytso@mit.edu>
References: <20190321202513.1969-1-tytso@mit.edu>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-ext4-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org

Not all systems will have the lvm2 package installed, so check for
that.  Pretty much all systems should have util-linux installed, but
check for that as well.

Of course, if lvm2 is installed we shouldn't find any LVM devices ---
but eventually the Demon Murphy will find a way to make it happen. :-)

Also, set the PATH so we don't have to worry about the script failing
due to /sbin not being in the path.

Signed-off-by: Theodore Ts'o <tytso@mit.edu>
---
 scrub/e2scrub.in     | 12 ++++++++++++
 scrub/e2scrub_all.in | 16 ++++++++++++++++
 2 files changed, 28 insertions(+)

diff --git a/scrub/e2scrub.in b/scrub/e2scrub.in
index e1965db4e..51a909373 100644
--- a/scrub/e2scrub.in
+++ b/scrub/e2scrub.in
@@ -23,6 +23,8 @@
 # check filesystems in VGs that have at least 256MB (or so) of
 # free space.
 
+PATH=/usr/local/sbin:/usr/local/bin:/sbin:/bin:/usr/sbin:/usr/bin
+
 snap_size_mb=256
 fstrim=0
 reap=0
@@ -82,6 +84,16 @@ if [ -z "${arg}" ]; then
 	exitcode 1
 fi
 
+if ! type lsblk >& /dev/null ; then
+    echo "e2scrub: can't find lsblk --- is util-linux installed?"
+    exitcode 1
+fi
+
+if ! type lvcreate >& /dev/null ; then
+    echo "e2scrub: can't find lvcreate --- is lvm2 installed?"
+    exitcode 1
+fi
+
 # Find the device for a given mountpoint
 dev_from_mount() {
 	local mountpt="$(realpath "$1")"
diff --git a/scrub/e2scrub_all.in b/scrub/e2scrub_all.in
index 23d122d25..d725a7f2e 100644
--- a/scrub/e2scrub_all.in
+++ b/scrub/e2scrub_all.in
@@ -18,6 +18,8 @@
 #  along with this program; if not, write the Free Software Foundation,
 #  Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301, USA.
 
+PATH=/usr/local/sbin:/usr/local/bin:/sbin:/bin:/usr/sbin:/usr/bin
+
 scrub_all=0
 conffile="@root_sysconfdir@/e2scrub.conf"
 
@@ -68,6 +70,20 @@ while getopts "ArV" opt; do
 done
 shift "$((OPTIND - 1))"
 
+# If some prerequisite packages are not installed, exit with a code
+# indicating success to avoid spamming the sysadmin with fail messages
+# when e2scrub_all is run out of cron or a systemd timer.
+
+if ! type lsblk >& /dev/null ; then
+    echo "e2scrub_all: can't find lsblk --- is util-linux installed?"
+    exitcode 0
+fi
+
+if ! type lvcreate >& /dev/null ; then
+    echo "e2scrub_all: can't find lvcreate --- is lvm2 installed?"
+    exitcode 0
+fi
+
 # Find scrub targets, make sure we only do this once.
 ls_scrub_targets() {
 	lsblk -o NAME,FSTYPE,MOUNTPOINT -p -P -n | while read vars; do
-- 
2.19.1

