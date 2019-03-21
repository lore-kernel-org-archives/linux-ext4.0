Return-Path: <SRS0=3UD1=RY=vger.kernel.org=linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 06896C4360F
	for <linux-ext4@archiver.kernel.org>; Thu, 21 Mar 2019 02:02:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D3D6E218A2
	for <linux-ext4@archiver.kernel.org>; Thu, 21 Mar 2019 02:02:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727771AbfCUCCc (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Wed, 20 Mar 2019 22:02:32 -0400
Received: from outgoing-auth-1.mit.edu ([18.9.28.11]:57813 "EHLO
        outgoing.mit.edu" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727731AbfCUCC3 (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Wed, 20 Mar 2019 22:02:29 -0400
Received: from callcc.thunk.org (guestnat-104-133-0-99.corp.google.com [104.133.0.99] (may be forged))
        (authenticated bits=0)
        (User authenticated as tytso@ATHENA.MIT.EDU)
        by outgoing.mit.edu (8.14.7/8.12.4) with ESMTP id x2L22NEu029516
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 20 Mar 2019 22:02:23 -0400
Received: by callcc.thunk.org (Postfix, from userid 15806)
        id D2EFA420AA7; Wed, 20 Mar 2019 22:02:22 -0400 (EDT)
From:   "Theodore Ts'o" <tytso@mit.edu>
To:     Ext4 Developers List <linux-ext4@vger.kernel.org>
Cc:     darrick.wong@oracle.com, "Theodore Ts'o" <tytso@mit.edu>
Subject: [PATCH 2/9] debian: drop lvm2 from the recommends line
Date:   Wed, 20 Mar 2019 22:02:11 -0400
Message-Id: <20190321020218.5154-2-tytso@mit.edu>
X-Mailer: git-send-email 2.19.1
In-Reply-To: <20190321020218.5154-1-tytso@mit.edu>
References: <20190321020218.5154-1-tytso@mit.edu>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-ext4-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org

If the user doesn't intend to use lvm2, and it's not installed,
installing e2fsprogs shouldn't drag it (and all of its dependencies)
into the system.

Addresses-Debian-Bug: 924275

Signed-off-by: Theodore Ts'o <tytso@mit.edu>
---
 debian/control | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/debian/control b/debian/control
index 1bb8adb15..e454687f9 100644
--- a/debian/control
+++ b/debian/control
@@ -191,7 +191,7 @@ XB-Important: yes
 Pre-Depends: ${shlibs:Depends}, ${misc:Depends}, libblkid1, libuuid1
 Multi-Arch: foreign
 Suggests: gpart, parted, fuse2fs, e2fsck-static
-Recommends: e2fsprogs-l10n, lvm2
+Recommends: e2fsprogs-l10n
 Architecture: any
 Description: ext2/ext3/ext4 file system utilities
  The ext2, ext3 and ext4 file systems are successors of the original ext
-- 
2.19.1

