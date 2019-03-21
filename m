Return-Path: <SRS0=3UD1=RY=vger.kernel.org=linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A3433C43381
	for <linux-ext4@archiver.kernel.org>; Thu, 21 Mar 2019 02:02:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 721AC218A2
	for <linux-ext4@archiver.kernel.org>; Thu, 21 Mar 2019 02:02:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727776AbfCUCCc (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Wed, 20 Mar 2019 22:02:32 -0400
Received: from outgoing-auth-1.mit.edu ([18.9.28.11]:57818 "EHLO
        outgoing.mit.edu" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727760AbfCUCCa (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Wed, 20 Mar 2019 22:02:30 -0400
Received: from callcc.thunk.org (guestnat-104-133-0-99.corp.google.com [104.133.0.99] (may be forged))
        (authenticated bits=0)
        (User authenticated as tytso@ATHENA.MIT.EDU)
        by outgoing.mit.edu (8.14.7/8.12.4) with ESMTP id x2L22OrL029544
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 20 Mar 2019 22:02:25 -0400
Received: by callcc.thunk.org (Postfix, from userid 15806)
        id E8D90420AAD; Wed, 20 Mar 2019 22:02:22 -0400 (EDT)
From:   "Theodore Ts'o" <tytso@mit.edu>
To:     Ext4 Developers List <linux-ext4@vger.kernel.org>
Cc:     darrick.wong@oracle.com, "Theodore Ts'o" <tytso@mit.edu>
Subject: [PATCH 6/9] e2scrub_all: add the -n option which shows what e2scrub_all would do
Date:   Wed, 20 Mar 2019 22:02:15 -0400
Message-Id: <20190321020218.5154-6-tytso@mit.edu>
X-Mailer: git-send-email 2.19.1
In-Reply-To: <20190321020218.5154-1-tytso@mit.edu>
References: <20190321020218.5154-1-tytso@mit.edu>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-ext4-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org

Signed-off-by: Theodore Ts'o <tytso@mit.edu>
---
 scrub/e2scrub_all.8.in | 9 +++++++--
 scrub/e2scrub_all.in   | 8 +++++---
 2 files changed, 12 insertions(+), 5 deletions(-)

diff --git a/scrub/e2scrub_all.8.in b/scrub/e2scrub_all.8.in
index ba3b8735e..2787a7108 100644
--- a/scrub/e2scrub_all.8.in
+++ b/scrub/e2scrub_all.8.in
@@ -20,12 +20,17 @@ See the
 manual page for more information about how the checking is performed.
 .SH OPTIONS
 .TP
-\fB-A\fR
-Scrub all ext[234] filesystems even if they are not mounted.
+\fB-n\fR
+Print what commands
+.B e2scrub_all
+would execute (but don't actually execute them).
 .TP
 \fB-r\fR
 Remove e2scrub snapshots but do not check anything.
 .TP
+\fB-A\fR
+Scrub all ext[234] filesystems even if they are not mounted.
+.TP
 \fB-V\fR
 Print version information and exit.
 .SH SEE ALSO
diff --git a/scrub/e2scrub_all.in b/scrub/e2scrub_all.in
index d725a7f2e..8bc868aa0 100644
--- a/scrub/e2scrub_all.in
+++ b/scrub/e2scrub_all.in
@@ -29,8 +29,9 @@ scrub_args=""
 
 print_help() {
 	echo "Usage: $0 [OPTIONS]"
-	echo " -A: Scrub all ext[234] filesystems even if not mounted."
+	echo " -n: Show what commands e2scrub_all would execute."
 	echo " -r: Remove e2scrub snapshots."
+	echo " -A: Scrub all ext[234] filesystems even if not mounted."
 	echo " -V: Print version information and exit."
 }
 
@@ -60,10 +61,11 @@ exitcode() {
 	exit "${ret}"
 }
 
-while getopts "ArV" opt; do
+while getopts "nrAV" opt; do
 	case "${opt}" in
-	"A") scrub_all=1;;
+	"n") DBG="echo Would execute: " ;;
 	"r") scrub_args="${scrub_args} -r";;
+	"A") scrub_all=1;;
 	"V") print_version; exitcode 0;;
 	*) print_help; exitcode 2;;
 	esac
-- 
2.19.1

