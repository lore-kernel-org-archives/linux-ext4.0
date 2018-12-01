Return-Path: <SRS0=IALa=OK=vger.kernel.org=linux-ext4-owner@kernel.org>
Received: from bhuna.collabora.co.uk ([46.235.227.227]:32992 "EHLO
        bhuna.collabora.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726014AbeLALx4 (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Sat, 1 Dec 2018 06:53:56 -0500
From: Gabriel Krisman Bertazi <krisman@collabora.com>
To: tytso@mit.edu
Cc: kernel@collabora.com, linux-ext4@vger.kernel.org,
        Gabriel Krisman Bertazi <krisman@collabora.com>
Subject: [PATCH v4 9/9] ext4.5: Add fname_encoding feature to ext4 man page
Date: Fri, 30 Nov 2018 19:42:23 -0500
Message-Id: <20181201004223.25539-2-krisman@collabora.com>
In-Reply-To: <20181201004223.25539-1-krisman@collabora.com>
References: <20181201003910.18982-1-krisman@collabora.com>
 <20181201004223.25539-1-krisman@collabora.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Signed-off-by: Gabriel Krisman Bertazi <krisman@collabora.com>
---
 misc/ext4.5.in | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/misc/ext4.5.in b/misc/ext4.5.in
index 8f4c4f51ea85..d65598428a35 100644
--- a/misc/ext4.5.in
+++ b/misc/ext4.5.in
@@ -151,6 +151,16 @@ can be specified using the
 .B \-G
 option.
 .TP
+.B fname_encoding
+.br
+This ext4 feature provides file system level character encoding support
+for files and directories name.  This feature is name-preserving on the
+disk, but it allows applications to lookup for a file in the file system
+using any encoding equivalent version of the file name.
+
+This feature is required to perform in-kernel case-insensitive file
+name lookups.
+.TP
 .B has_journal
 .br
 Create a journal to ensure filesystem consistency even across unclean
-- 
2.20.0.rc1
