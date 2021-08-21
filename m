Return-Path: <linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1FF69C4338F
	for <linux-ext4@archiver.kernel.org>; Sat, 21 Aug 2021 03:55:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id ED212611C4
	for <linux-ext4@archiver.kernel.org>; Sat, 21 Aug 2021 03:55:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232752AbhHUD4G (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Fri, 20 Aug 2021 23:56:06 -0400
Received: from outgoing-auth-1.mit.edu ([18.9.28.11]:56301 "EHLO
        outgoing.mit.edu" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S229610AbhHUD4G (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Fri, 20 Aug 2021 23:56:06 -0400
Received: from cwcc.thunk.org (pool-72-74-133-215.bstnma.fios.verizon.net [72.74.133.215])
        (authenticated bits=0)
        (User authenticated as tytso@ATHENA.MIT.EDU)
        by outgoing.mit.edu (8.14.7/8.12.4) with ESMTP id 17L3tKnl020231
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 20 Aug 2021 23:55:21 -0400
Received: by cwcc.thunk.org (Postfix, from userid 15806)
        id C78B415C3DBB; Fri, 20 Aug 2021 23:55:20 -0400 (EDT)
From:   "Theodore Ts'o" <tytso@mit.edu>
To:     Ext4 Developers List <linux-ext4@vger.kernel.org>
Cc:     syzkaller-bugs@googlegroups.com, "Theodore Ts'o" <tytso@mit.edu>,
        stable@kernel.org,
        syzbot+13146364637c7363a7de@syzkaller.appspotmail.com
Subject: [PATCH] ext4: fix race writing to an inline_data file while its xattrs are changing
Date:   Fri, 20 Aug 2021 23:54:27 -0400
Message-Id: <20210821035427.1471851-1-tytso@mit.edu>
X-Mailer: git-send-email 2.31.0
In-Reply-To: <000000000000e5080305c9e51453@google.com>
References: <000000000000e5080305c9e51453@google.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org

The location of the system.data extended attribute can change whenever
xattr_sem is not taken.  So we need to recalculate the i_inline_off
field since it mgiht have changed between ext4_write_begin() and
ext4_write_end().

This means that caching i_inline_off is probably not helpful, so in
the long run we should probably get rid of it and shrink the in-memory
ext4 inode slightly, but let's fix the race the simple way for now.

Cc: stable@kernel.org
Fixes: f19d5870cbf72 ("ext4: add normal write support for inline data")
Reported-by: syzbot+13146364637c7363a7de@syzkaller.appspotmail.com
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
---
 fs/ext4/inline.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/fs/ext4/inline.c b/fs/ext4/inline.c
index 70cb64db33f7..24e994e75f5c 100644
--- a/fs/ext4/inline.c
+++ b/fs/ext4/inline.c
@@ -750,6 +750,12 @@ int ext4_write_inline_data_end(struct inode *inode, loff_t pos, unsigned len,
 	ext4_write_lock_xattr(inode, &no_expand);
 	BUG_ON(!ext4_has_inline_data(inode));
 
+	/*
+	 * ei->i_inline_off may have changed since ext4_write_begin()
+	 * called ext4_try_to_write_inline_data()
+	 */
+	(void) ext4_find_inline_data_nolock(inode);
+
 	kaddr = kmap_atomic(page);
 	ext4_write_inline_data(inode, &iloc, kaddr, pos, len);
 	kunmap_atomic(kaddr);
-- 
2.31.0

