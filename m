Return-Path: <SRS0=48F3=M5=vger.kernel.org=linux-ext4-owner@kernel.org>
Received: from bhuna.collabora.co.uk ([46.235.227.227]:50198 "EHLO
        bhuna.collabora.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727132AbeJREyY (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Thu, 18 Oct 2018 00:54:24 -0400
From: Gabriel Krisman Bertazi <krisman@collabora.co.uk>
To: tytso@mit.edu
Cc: linux-ext4@vger.kernel.org,
        Gabriel Krisman Bertazi <krisman@collabora.co.uk>
Subject: [PATCH v3 23/23] docs: ext4.rst: Document encoding and case-insensitive
Date: Wed, 17 Oct 2018 16:55:24 -0400
Message-Id: <20181017205524.23360-24-krisman@collabora.co.uk>
In-Reply-To: <20181017205524.23360-1-krisman@collabora.co.uk>
References: <20181017205524.23360-1-krisman@collabora.co.uk>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Introduces the encoding-awareness and case-insensitive features on ext4
for system administrators.  Explain the minimum of design decisions that
are important for sysadmins enabling this feature.

Signed-off-by: Gabriel Krisman Bertazi <krisman@collabora.co.uk>
---
 Documentation/admin-guide/ext4.rst | 29 +++++++++++++++++++++++++++++
 1 file changed, 29 insertions(+)

diff --git a/Documentation/admin-guide/ext4.rst b/Documentation/admin-guide/ext4.rst
index e506d3dae510..f42c682acecc 100644
--- a/Documentation/admin-guide/ext4.rst
+++ b/Documentation/admin-guide/ext4.rst
@@ -91,10 +91,39 @@ Currently Available
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
+When we change from filenames as opaque byte sequences to seeing them as
+encoded strings we need to address what happens when a program tries to
+create a file with an invalid name.  The Natural Language System within
+the kernel leaves the decision of what to do in this case to the
+filesystem, which select its preferred behavior by enabling/disabling
+the strict mode in NLS.  When Ext4 encounters one of those strings, it
+falls back to considering the entire string as an opaque byte sequence,
+which still allows the user to operate on that file but the
+case-insensitive and equivalent sequence lookups won't work.
+
 Options
 =======
 
-- 
2.19.1
