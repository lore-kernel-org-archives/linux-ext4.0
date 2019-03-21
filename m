Return-Path: <SRS0=3UD1=RY=vger.kernel.org=linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0ED2BC43381
	for <linux-ext4@archiver.kernel.org>; Thu, 21 Mar 2019 20:25:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D2884218FD
	for <linux-ext4@archiver.kernel.org>; Thu, 21 Mar 2019 20:25:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728919AbfCUUZe (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Thu, 21 Mar 2019 16:25:34 -0400
Received: from outgoing-auth-1.mit.edu ([18.9.28.11]:52579 "EHLO
        outgoing.mit.edu" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1728911AbfCUUZb (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Thu, 21 Mar 2019 16:25:31 -0400
Received: from callcc.thunk.org (guestnat-104-133-0-99.corp.google.com [104.133.0.99] (may be forged))
        (authenticated bits=0)
        (User authenticated as tytso@ATHENA.MIT.EDU)
        by outgoing.mit.edu (8.14.7/8.12.4) with ESMTP id x2LKPKu1017025
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 21 Mar 2019 16:25:20 -0400
Received: by callcc.thunk.org (Postfix, from userid 15806)
        id 0EB25420AAF; Thu, 21 Mar 2019 16:25:19 -0400 (EDT)
From:   "Theodore Ts'o" <tytso@mit.edu>
To:     Ext4 Developers List <linux-ext4@vger.kernel.org>
Cc:     darrick.wong@oracle.com, lczerner@redhat.com,
        "Theodore Ts'o" <tytso@mit.edu>
Subject: [PATCH 7/9] e2scrub_all: make sure there's enough free space for a snapshot
Date:   Thu, 21 Mar 2019 16:25:11 -0400
Message-Id: <20190321202513.1969-8-tytso@mit.edu>
X-Mailer: git-send-email 2.19.1
In-Reply-To: <20190321202513.1969-1-tytso@mit.edu>
References: <20190321202513.1969-1-tytso@mit.edu>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-ext4-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org

If there isn't, skip the volume so we don't spam the system
administrator with error messages.  It's quite commkon that there is
is zero free space in the volume group.

Addresses-Debian-Bug: #924301

Signed-off-by: Theodore Ts'o <tytso@mit.edu>
---
 scrub/e2scrub_all.in | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/scrub/e2scrub_all.in b/scrub/e2scrub_all.in
index 8bc868aa0..4cb90a0de 100644
--- a/scrub/e2scrub_all.in
+++ b/scrub/e2scrub_all.in
@@ -21,6 +21,7 @@
 PATH=/usr/local/sbin:/usr/local/bin:/sbin:/bin:/usr/sbin:/usr/bin
 
 scrub_all=0
+snap_size_mb=256
 conffile="@root_sysconfdir@/e2scrub.conf"
 
 test -f "${conffile}" && . "${conffile}"
@@ -108,6 +109,9 @@ ls_scrub_targets() {
 		eval "${lvm_vars}"
 		echo "${LVM2_LV_ROLE}" | grep -q "snapshot" && continue
 
+		free_space="$(vgs -o vg_free --units m --noheadings --no-suffix "${LVM2_VG_NAME}" 2> /dev/null | sed -e 's/\..*//')"
+		test "${snap_size_mb}" -gt "${free_space}" && continue
+
 		if [ -n "${MOUNTPOINT}" ]; then
 			echo "${MOUNTPOINT}"
 		else
-- 
2.19.1

