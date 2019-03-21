Return-Path: <SRS0=3UD1=RY=vger.kernel.org=linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9F24FC10F00
	for <linux-ext4@archiver.kernel.org>; Thu, 21 Mar 2019 20:25:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 6F838218FD
	for <linux-ext4@archiver.kernel.org>; Thu, 21 Mar 2019 20:25:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728917AbfCUUZc (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Thu, 21 Mar 2019 16:25:32 -0400
Received: from outgoing-auth-1.mit.edu ([18.9.28.11]:52580 "EHLO
        outgoing.mit.edu" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1728862AbfCUUZc (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Thu, 21 Mar 2019 16:25:32 -0400
Received: from callcc.thunk.org (guestnat-104-133-0-99.corp.google.com [104.133.0.99] (may be forged))
        (authenticated bits=0)
        (User authenticated as tytso@ATHENA.MIT.EDU)
        by outgoing.mit.edu (8.14.7/8.12.4) with ESMTP id x2LKPK2K017023
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 21 Mar 2019 16:25:20 -0400
Received: by callcc.thunk.org (Postfix, from userid 15806)
        id 0453D420AAD; Thu, 21 Mar 2019 16:25:19 -0400 (EDT)
From:   "Theodore Ts'o" <tytso@mit.edu>
To:     Ext4 Developers List <linux-ext4@vger.kernel.org>
Cc:     darrick.wong@oracle.com, lczerner@redhat.com,
        "Theodore Ts'o" <tytso@mit.edu>
Subject: [PATCH 5/9] e2scrub: add the -n option which shows what commands e2scrub would execute
Date:   Thu, 21 Mar 2019 16:25:09 -0400
Message-Id: <20190321202513.1969-6-tytso@mit.edu>
X-Mailer: git-send-email 2.19.1
In-Reply-To: <20190321202513.1969-1-tytso@mit.edu>
References: <20190321202513.1969-1-tytso@mit.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-ext4-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org

Also fix the copyright symbol so it is properly formatted when
processed into postscript or pdf.

Signed-off-by: Theodore Ts'o <tytso@mit.edu>
---
 scrub/e2scrub.8.in | 11 ++++++++++-
 scrub/e2scrub.in   |  6 ++++--
 2 files changed, 14 insertions(+), 3 deletions(-)

diff --git a/scrub/e2scrub.8.in b/scrub/e2scrub.8.in
index ff03523e3..d0c8b2528 100644
--- a/scrub/e2scrub.8.in
+++ b/scrub/e2scrub.8.in
@@ -38,6 +38,15 @@ If the filesystem is not repaired,
 will be run before the next mount.
 .SH OPTIONS
 .TP
+\fB-n\fR
+Print what commands
+.B e2scrub
+would execute to check the file system.  (Note: the commands will not
+actually be executed; however, since
+.B e2scrub
+needs to run some commands to query the system to determine what
+commands would be executed, it still needs to be run as root.)
+.TP
 \fB-r\fR
 Remove the e2scrub snapshot and exit without checking anything.
 .TP
@@ -57,4 +66,4 @@ The exit codes are the same as in
 .SH AUTHOR
 Darrick J. Wong <darrick.wong@oracle.com>
 .SH COPYRIGHT
-Copyright ©2018 Oracle.  License is GPLv2+. <http://www.gnu.org/licenses/gpl-2.0.html>
+Copyright \[co]2018 Oracle.  License is GPLv2+. <http://www.gnu.org/licenses/gpl-2.0.html>
diff --git a/scrub/e2scrub.in b/scrub/e2scrub.in
index 51a909373..301574968 100644
--- a/scrub/e2scrub.in
+++ b/scrub/e2scrub.in
@@ -37,6 +37,7 @@ print_help() {
 	echo "Usage: $0 [OPTIONS] mountpoint | device"
 	echo
 	echo "mountpoint must be on a LVM-managed block device"
+	echo "-n: Show what commands e2scrub would execute."
 	echo "-r: Remove e2scrub snapshot and exit, do not check anything."
 	echo "-t: Run fstrim if successful."
 	echo "-V: Print version information and exit."
@@ -68,8 +69,9 @@ exitcode() {
 	exit "${ret}"
 }
 
-while getopts "rtV" opt; do
-	case "${opt}" in
+while getopts "nrtV" opt; do
+    case "${opt}" in
+	"n") DBG="echo Would execute: " ;;
 	"r") reap=1;;
 	"t") fstrim=1;;
 	"V") print_version; exitcode 0;;
-- 
2.19.1

