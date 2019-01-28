Return-Path: <SRS0=NyoO=QE=vger.kernel.org=linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,UNPARSEABLE_RELAY,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 997DBC282C8
	for <linux-ext4@archiver.kernel.org>; Mon, 28 Jan 2019 21:33:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7698E21738
	for <linux-ext4@archiver.kernel.org>; Mon, 28 Jan 2019 21:33:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728295AbfA1VdF (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Mon, 28 Jan 2019 16:33:05 -0500
Received: from bhuna.collabora.co.uk ([46.235.227.227]:58304 "EHLO
        bhuna.collabora.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727156AbfA1VdF (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Mon, 28 Jan 2019 16:33:05 -0500
Received: from [127.0.0.1] (localhost [127.0.0.1])
        (Authenticated sender: krisman)
        with ESMTPSA id 68A1527FB87
From:   Gabriel Krisman Bertazi <krisman@collabora.com>
To:     tytso@mit.edu
Cc:     linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org,
        sfrench@samba.org, darrick.wong@oracle.com,
        samba-technical@lists.samba.org, jlayton@kernel.org,
        bfields@fieldses.org, paulus@samba.org,
        Gabriel Krisman Bertazi <krisman@collabora.co.uk>
Subject: [PATCH RFC v5 11/11] docs: ext4.rst: Document encoding and case-insensitive
Date:   Mon, 28 Jan 2019 16:32:23 -0500
Message-Id: <20190128213223.31512-12-krisman@collabora.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190128213223.31512-1-krisman@collabora.com>
References: <20190128213223.31512-1-krisman@collabora.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-ext4-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org

From: Gabriel Krisman Bertazi <krisman@collabora.co.uk>

Introduces the encoding-awareness and case-insensitive features on ext4
for system administrators.  Explain the minimum of design decisions that
are important for sysadmins wanting to enable this feature.

Signed-off-by: Gabriel Krisman Bertazi <krisman@collabora.co.uk>
---
 Documentation/admin-guide/ext4.rst | 41 ++++++++++++++++++++++++++++++
 1 file changed, 41 insertions(+)

diff --git a/Documentation/admin-guide/ext4.rst b/Documentation/admin-guide/ext4.rst
index e506d3dae510..4e08d0309f1e 100644
--- a/Documentation/admin-guide/ext4.rst
+++ b/Documentation/admin-guide/ext4.rst
@@ -91,10 +91,51 @@ Currently Available
 * large block (up to pagesize) support
 * efficient new ordered mode in JBD2 and ext4 (avoid using buffer head to force
   the ordering)
+* Encoding aware file names
+* Case insensitive file name lookups
 
 [1] Filesystems with a block size of 1k may see a limit imposed by the
 directory hash tree having a maximum depth of two.
 
+Encoding-aware file names and case-insensitive lookups
+======================================================
+
+Ext4 optionally supports filesystem-wide charset knowledge when handling
+file names, which allows the user to perform file system lookups using
+charset equivalent versions of the same file name, and optionally ensure
+that no invalid names are held by the filesystem.  charset encoding
+awareness is also essential for performing case-insensitive lookups,
+because it is what defines the casefold operation.
+
+The case-insensitive file name lookup feature is supported in a smaller
+granularity, on a per-directory basis, allowing the user to mix
+case-insensitive and case-sensitive directories in the same filesystem.
+It is enabled by flipping a file attribute on an empty directory.  For
+the reason stated above, the filesystem must have encoding enabled to
+use this feature.
+
+Both encoding-awareness and case-awareness are name-preserving on the
+disk, meaning that the file name provided by userspace is a
+byte-per-byte match to what is actually written in the disk.  The
+Unicode normalization format used by the kernel is thus an internal
+representation, and not exposed to the userspace nor to the disk, with
+the important exception of disk hashes, used on large directories with
+DX feature.  On DX directories, the hash must be calculated using the
+normalized version of the filename, meaning that the normalization
+format used actually has an impact on where the directory entry is
+stored.
+
+When we change from viewing filenames as opaque byte sequences to seeing
+them as encoded strings we need to address what happens when a program
+tries to create a file with an invalid name.  The Unicode subsystem
+within the kernel leaves the decision of what to do in this case to the
+filesystem, which select its preferred behavior by enabling/disabling
+the strict mode.  When Ext4 encounters one of those strings and the
+filesystem did not require strict mode, it falls back to considering the
+entire string as an opaque byte sequence, which still allows the user to
+operate on that file but the case-insensitive and equivalent sequence
+lookups won't work.
+
 Options
 =======
 
-- 
2.20.1

