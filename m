Return-Path: <SRS0=qwWH=3O=vger.kernel.org=linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EF466C2D0CE
	for <linux-ext4@archiver.kernel.org>; Sat, 25 Jan 2020 02:23:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id CD6152075D
	for <linux-ext4@archiver.kernel.org>; Sat, 25 Jan 2020 02:23:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387687AbgAYCXE (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Fri, 24 Jan 2020 21:23:04 -0500
Received: from outgoing-auth-1.mit.edu ([18.9.28.11]:50707 "EHLO
        outgoing.mit.edu" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S2387542AbgAYCXE (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Fri, 24 Jan 2020 21:23:04 -0500
Received: from callcc.thunk.org (rrcs-67-53-201-206.west.biz.rr.com [67.53.201.206])
        (authenticated bits=0)
        (User authenticated as tytso@ATHENA.MIT.EDU)
        by outgoing.mit.edu (8.14.7/8.12.4) with ESMTP id 00P2Mwex030322
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 24 Jan 2020 21:23:00 -0500
Received: by callcc.thunk.org (Postfix, from userid 15806)
        id 98B3F42014A; Fri, 24 Jan 2020 21:22:57 -0500 (EST)
From:   "Theodore Ts'o" <tytso@mit.edu>
To:     Ext4 Developers List <linux-ext4@vger.kernel.org>
Cc:     "Theodore Ts'o" <tytso@mit.edu>
Subject: [PATCH] ext4: make dioread_nolock the default
Date:   Fri, 24 Jan 2020 21:22:54 -0500
Message-Id: <20200125022254.1101588-1-tytso@mit.edu>
X-Mailer: git-send-email 2.24.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-ext4-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org

This fixes the direct I/O versus writeback race which can reveal stale
data, and it improves the tail latency of commits on slow devices.

Signed-off-by: Theodore Ts'o <tytso@mit.edu>
---
 fs/ext4/super.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/fs/ext4/super.c b/fs/ext4/super.c
index ecf36a23e0c4..c6fe742db798 100644
--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -1592,6 +1592,7 @@ static const match_table_t tokens = {
 	{Opt_auto_da_alloc, "auto_da_alloc"},
 	{Opt_noauto_da_alloc, "noauto_da_alloc"},
 	{Opt_dioread_nolock, "dioread_nolock"},
+	{Opt_dioread_lock, "nodioread_nolock"},
 	{Opt_dioread_lock, "dioread_lock"},
 	{Opt_discard, "discard"},
 	{Opt_nodiscard, "nodiscard"},
@@ -3764,6 +3765,7 @@ static int ext4_fill_super(struct super_block *sb, void *data, int silent)
 		set_opt(sb, NO_UID32);
 	/* xattr user namespace & acls are now defaulted on */
 	set_opt(sb, XATTR_USER);
+	set_opt(sb, DIOREAD_NOLOCK);
 #ifdef CONFIG_EXT4_FS_POSIX_ACL
 	set_opt(sb, POSIX_ACL);
 #endif
@@ -3931,9 +3933,8 @@ static int ext4_fill_super(struct super_block *sb, void *data, int silent)
 #endif
 
 	if (test_opt(sb, DATA_FLAGS) == EXT4_MOUNT_JOURNAL_DATA) {
-		printk_once(KERN_WARNING "EXT4-fs: Warning: mounting "
-			    "with data=journal disables delayed "
-			    "allocation and O_DIRECT support!\n");
+		printk_once(KERN_WARNING "EXT4-fs: Warning: mounting with data=journal disables delayed allocation, dioread_nolock, and O_DIRECT support!\n");
+		clear_opt(sb, DIOREAD_NOLOCK);
 		if (test_opt2(sb, EXPLICIT_DELALLOC)) {
 			ext4_msg(sb, KERN_ERR, "can't mount with "
 				 "both data=journal and delalloc");
-- 
2.24.1

