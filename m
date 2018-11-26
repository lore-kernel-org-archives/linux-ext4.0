Return-Path: <SRS0=7vaa=OF=vger.kernel.org=linux-ext4-owner@kernel.org>
Received: from bhuna.collabora.co.uk ([46.235.227.227]:44570 "EHLO
        bhuna.collabora.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727291AbeK0JQJ (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Tue, 27 Nov 2018 04:16:09 -0500
From: Gabriel Krisman Bertazi <krisman@collabora.com>
To: tytso@mit.edu
Cc: kernel@collabora.com, linux-ext4@vger.kernel.org,
        Gabriel Krisman Bertazi <krisman@collabora.com>
Subject: [PATCH v3 11/12] mke2fs.conf.5: Document fname_encoding configuration option
Date: Mon, 26 Nov 2018 17:19:48 -0500
Message-Id: <20181126221949.12172-12-krisman@collabora.com>
In-Reply-To: <20181126221949.12172-1-krisman@collabora.com>
References: <20181126221949.12172-1-krisman@collabora.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Signed-off-by: Gabriel Krisman Bertazi <krisman@collabora.com>
---
 misc/mke2fs.conf.5.in | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/misc/mke2fs.conf.5.in b/misc/mke2fs.conf.5.in
index c086b4113b50..ab93c7761a16 100644
--- a/misc/mke2fs.conf.5.in
+++ b/misc/mke2fs.conf.5.in
@@ -97,6 +97,10 @@ The following relations are defined in the
 .I [options]
 stanza.
 .TP
+.I fname_encoding
+This relation defines the file name encoding to be used by mke2fs, in
+case the user doesn't specify an encoding in the command line.
+.TP
 .I proceed_delay
 If this relation is set to a positive integer, then mke2fs will
 wait
-- 
2.19.2
