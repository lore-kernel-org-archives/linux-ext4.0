Return-Path: <SRS0=7vaa=OF=vger.kernel.org=linux-ext4-owner@kernel.org>
Received: from bhuna.collabora.co.uk ([46.235.227.227]:44566 "EHLO
        bhuna.collabora.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727291AbeK0JQG (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Tue, 27 Nov 2018 04:16:06 -0500
From: Gabriel Krisman Bertazi <krisman@collabora.com>
To: tytso@mit.edu
Cc: kernel@collabora.com, linux-ext4@vger.kernel.org,
        Gabriel Krisman Bertazi <krisman@collabora.com>
Subject: [PATCH v3 10/12] mke2fs.8: Document fname_encoding options
Date: Mon, 26 Nov 2018 17:19:47 -0500
Message-Id: <20181126221949.12172-11-krisman@collabora.com>
In-Reply-To: <20181126221949.12172-1-krisman@collabora.com>
References: <20181126221949.12172-1-krisman@collabora.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Signed-off-by: Gabriel Krisman Bertazi <krisman@collabora.com>
---
 misc/mke2fs.8.in | 25 +++++++++++++++++++++++++
 1 file changed, 25 insertions(+)

diff --git a/misc/mke2fs.8.in b/misc/mke2fs.8.in
index 603e37e54a78..4a2aa8fd9672 100644
--- a/misc/mke2fs.8.in
+++ b/misc/mke2fs.8.in
@@ -280,6 +280,31 @@ option is still accepted for backwards compatibility, but is deprecated.
 The following extended options are supported:
 .RS 1.2i
 .TP
+.BI fname_encoding= encoding-name
+Enable the
+.I fname_encoding
+feature in the super block and set
+.I encoding-name
+as the encoding to be used.  If
+.I encoding-name
+is not specified, the encoding defined in
+.BR mke2fs.conf (5)
+is used.
+.TP
+.BI fname_encoding_flags= encoding-flags
+Define parameters for file name character encoding operations.  If a
+flag is not changed using this parameter, its default value is used.
+.I encoding-flags
+should be a comma-separated lists of flags to be enabled.  To disable a
+flag, add it to the list with the prefix "no".
+
+The only flag that can be set right now is
+.I strict
+which means that invalid strings should be rejected by the file system.
+In the default configuration, the
+.I strict
+flag is disabled.
+.TP
 .BI mmp_update_interval= interval
 Adjust the initial MMP update interval to
 .I interval
-- 
2.19.2
