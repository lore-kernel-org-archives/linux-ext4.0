Return-Path: <SRS0=VTDm=MG=vger.kernel.org=linux-ext4-owner@kernel.org>
Received: from bhuna.collabora.co.uk ([46.235.227.227]:45608 "EHLO
        bhuna.collabora.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725986AbeIYEC6 (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Tue, 25 Sep 2018 00:02:58 -0400
From: Gabriel Krisman Bertazi <krisman@collabora.co.uk>
To: tytso@mit.edu
Cc: linux-ext4@vger.kernel.org,
        Gabriel Krisman Bertazi <krisman@collabora.co.uk>
Subject: [PATCH RESEND v2 25/25] docs: ext4.rst: Document encoding and case-insensitive lookups
Date: Mon, 24 Sep 2018 17:56:55 -0400
Message-Id: <20180924215655.3676-26-krisman@collabora.co.uk>
In-Reply-To: <20180924215655.3676-1-krisman@collabora.co.uk>
References: <20180924215655.3676-1-krisman@collabora.co.uk>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Introduces the encoding-awareness and case-insensitive features on ext4,
explains some of the design decisions and the mount options to enabled
it.

Signed-off-by: Gabriel Krisman Bertazi <krisman@collabora.co.uk>
---
 Documentation/filesystems/ext4/ext4.rst | 38 +++++++++++++++++++++++++
 1 file changed, 38 insertions(+)

diff --git a/Documentation/filesystems/ext4/ext4.rst b/Documentation/filesystems/ext4/ext4.rst
index 9d4368d591fa..e57c181e40e9 100644
--- a/Documentation/filesystems/ext4/ext4.rst
+++ b/Documentation/filesystems/ext4/ext4.rst
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
 
@@ -363,6 +392,15 @@ i_version		Enable 64-bit inode version support. This option is
 dax			Use direct access (no page cache).  See
 			Documentation/filesystems/dax.txt.  Note that
 			this option is incompatible with data=journal.
+
+encoding		Enable a specific encoding for file name lookups.
+			This cannot be used with per-directory encryption and
+			will fail on filesystems that have that flag enabled.
+
+encoding_flags		A bitmask to configure how the encoding aware mechanism
+			should function. It specifies whether to refuse invalid
+			sequences and the specific normalization and casefold
+			operations to use.
 ======================= =======================================================
 
 Data Mode
-- 
2.19.0
