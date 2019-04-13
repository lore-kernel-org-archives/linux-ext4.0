Return-Path: <SRS0=R85w=SP=vger.kernel.org=linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,UNPARSEABLE_RELAY,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C3E50C10F14
	for <linux-ext4@archiver.kernel.org>; Sat, 13 Apr 2019 19:26:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 96624208E3
	for <linux-ext4@archiver.kernel.org>; Sat, 13 Apr 2019 19:26:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727171AbfDMT0T (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Sat, 13 Apr 2019 15:26:19 -0400
Received: from bhuna.collabora.co.uk ([46.235.227.227]:39224 "EHLO
        bhuna.collabora.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727166AbfDMT0T (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Sat, 13 Apr 2019 15:26:19 -0400
Received: from [127.0.0.1] (localhost [127.0.0.1])
        (Authenticated sender: krisman)
        with ESMTPSA id 697A3282140
From:   Gabriel Krisman Bertazi <krisman@collabora.com>
To:     tytso@mit.edu
Cc:     linux-ext4@vger.kernel.org,
        Gabriel Krisman Bertazi <krisman@collabora.co.uk>
Subject: [PATCH v7 10/10] docs: ext4.rst: Document case-insensitive directories
Date:   Sat, 13 Apr 2019 15:25:33 -0400
Message-Id: <20190413192533.2549-11-krisman@collabora.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190413192533.2549-1-krisman@collabora.com>
References: <20190413192533.2549-1-krisman@collabora.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-ext4-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org

From: Gabriel Krisman Bertazi <krisman@collabora.co.uk>

Introduces the case-insensitive features on ext4 for system
administrators.  Explain the minimum of design decisions that are
important for sysadmins wanting to enable this feature.

Signed-off-by: Gabriel Krisman Bertazi <krisman@collabora.co.uk>
---
 Documentation/admin-guide/ext4.rst | 38 ++++++++++++++++++++++++++++++
 1 file changed, 38 insertions(+)

diff --git a/Documentation/admin-guide/ext4.rst b/Documentation/admin-guide/ext4.rst
index e506d3dae510..9e8b35ed7cd9 100644
--- a/Documentation/admin-guide/ext4.rst
+++ b/Documentation/admin-guide/ext4.rst
@@ -91,10 +91,48 @@ Currently Available
 * large block (up to pagesize) support
 * efficient new ordered mode in JBD2 and ext4 (avoid using buffer head to force
   the ordering)
+* Case-insensitive file name lookups
 
 [1] Filesystems with a block size of 1k may see a limit imposed by the
 directory hash tree having a maximum depth of two.
 
+case-insensitive file name lookups
+======================================================
+
+The case-insensitive file name lookup feature is supported on a
+per-directory basis, allowing the user to mix case-insensitive and
+case-sensitive directories in the same filesystem.  It is enabled by
+flipping the +F inode attribute of an empty directory.  The
+case-insensitive string match operation is only defined when we know how
+text in encoded in a byte sequence.  For that reason, in order to enable
+case-insensitive directories, the filesystem must have the
+fname_encoding feature, which stores the filesystem-wide encoding
+model used.  By default, the charset adopted is the latest version of
+Unicode (12.0.0, by the time of this writing), encoded in the UTF-8
+form.  The comparison algorithm is implemented by normalizing the
+strings to the Canonical decomposition form, as defined by Unicode,
+followed by a byte per byte comparison.
+
+The case-awareness is name-preserving on the disk, meaning that the file
+name provided by userspace is a byte-per-byte match to what is actually
+written in the disk.  The Unicode normalization format used by the
+kernel is thus an internal representation, and not exposed to the
+userspace nor to the disk, with the important exception of disk hashes,
+used on large case-insensitive directories with DX feature.  On DX
+directories, the hash must be calculated using the casefolded version of
+the filename, meaning that the normalization format used actually has an
+impact on where the directory entry is stored.
+
+When we change from viewing filenames as opaque byte sequences to seeing
+them as encoded strings we need to address what happens when a program
+tries to create a file with an invalid name.  The Unicode subsystem
+within the kernel leaves the decision of what to do in this case to the
+filesystem, which select its preferred behavior by enabling/disabling
+the strict mode.  When Ext4 encounters one of those strings and the
+filesystem did not require strict mode, it falls back to considering the
+entire string as an opaque byte sequence, which still allows the user to
+operate on that file, but the case-insensitive lookups won't work.
+
 Options
 =======
 
-- 
2.20.1

