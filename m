Return-Path: <SRS0=3UD1=RY=vger.kernel.org=linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EBE7AC43381
	for <linux-ext4@archiver.kernel.org>; Thu, 21 Mar 2019 02:02:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C39DF218A2
	for <linux-ext4@archiver.kernel.org>; Thu, 21 Mar 2019 02:02:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727782AbfCUCCe (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Wed, 20 Mar 2019 22:02:34 -0400
Received: from outgoing-auth-1.mit.edu ([18.9.28.11]:57817 "EHLO
        outgoing.mit.edu" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727728AbfCUCCa (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Wed, 20 Mar 2019 22:02:30 -0400
Received: from callcc.thunk.org (guestnat-104-133-0-99.corp.google.com [104.133.0.99] (may be forged))
        (authenticated bits=0)
        (User authenticated as tytso@ATHENA.MIT.EDU)
        by outgoing.mit.edu (8.14.7/8.12.4) with ESMTP id x2L22O9B029548
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 20 Mar 2019 22:02:25 -0400
Received: by callcc.thunk.org (Postfix, from userid 15806)
        id 0E077420AB0; Wed, 20 Mar 2019 22:02:23 -0400 (EDT)
From:   "Theodore Ts'o" <tytso@mit.edu>
To:     Ext4 Developers List <linux-ext4@vger.kernel.org>
Cc:     darrick.wong@oracle.com, "Theodore Ts'o" <tytso@mit.edu>
Subject: [PATCH 9/9] e2scrub,e2scrub_all: print a (more understandable) error if not run as root
Date:   Wed, 20 Mar 2019 22:02:18 -0400
Message-Id: <20190321020218.5154-9-tytso@mit.edu>
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
 scrub/e2scrub.in     | 5 +++++
 scrub/e2scrub_all.in | 5 +++++
 2 files changed, 10 insertions(+)

diff --git a/scrub/e2scrub.in b/scrub/e2scrub.in
index 301574968..666d6485a 100644
--- a/scrub/e2scrub.in
+++ b/scrub/e2scrub.in
@@ -25,6 +25,11 @@
 
 PATH=/usr/local/sbin:/usr/local/bin:/sbin:/bin:/usr/sbin:/usr/bin
 
+if (( $EUID != 0 )); then
+    echo "e2scrub must be run as root"
+    exit 1
+fi
+
 snap_size_mb=256
 fstrim=0
 reap=0
diff --git a/scrub/e2scrub_all.in b/scrub/e2scrub_all.in
index cad232987..a02ffe226 100644
--- a/scrub/e2scrub_all.in
+++ b/scrub/e2scrub_all.in
@@ -20,6 +20,11 @@
 
 PATH=/usr/local/sbin:/usr/local/bin:/sbin:/bin:/usr/sbin:/usr/bin
 
+if (( $EUID != 0 )); then
+    echo "e2scrub_all must be run as root"
+    exit 1
+fi
+
 scrub_all=0
 snap_size_mb=256
 reap=0
-- 
2.19.1

