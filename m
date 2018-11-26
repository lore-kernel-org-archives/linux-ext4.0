Return-Path: <SRS0=7vaa=OF=vger.kernel.org=linux-ext4-owner@kernel.org>
Received: from bhuna.collabora.co.uk ([46.235.227.227]:44574 "EHLO
        bhuna.collabora.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727291AbeK0JQN (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Tue, 27 Nov 2018 04:16:13 -0500
From: Gabriel Krisman Bertazi <krisman@collabora.com>
To: tytso@mit.edu
Cc: kernel@collabora.com, linux-ext4@vger.kernel.org,
        Gabriel Krisman Bertazi <krisman@collabora.com>
Subject: [PATCH v3 12/12] chattr.1: Document the casefold attribute
Date: Mon, 26 Nov 2018 17:19:49 -0500
Message-Id: <20181126221949.12172-13-krisman@collabora.com>
In-Reply-To: <20181126221949.12172-1-krisman@collabora.com>
References: <20181126221949.12172-1-krisman@collabora.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Signed-off-by: Gabriel Krisman Bertazi <krisman@collabora.com>
---
 misc/chattr.1.in | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/misc/chattr.1.in b/misc/chattr.1.in
index 028ae9e7ca4c..5949d096687b 100644
--- a/misc/chattr.1.in
+++ b/misc/chattr.1.in
@@ -29,7 +29,7 @@ The operator '+' causes the selected attributes to be added to the
 existing attributes of the files; '-' causes them to be removed; and '='
 causes them to be the only attributes that the files have.
 .PP
-The letters 'aAcCdDeijPsStTu' select the new attributes for the files:
+The letters 'aAcCdDeFijPsStTu' select the new attributes for the files:
 append only (a),
 no atime updates (A),
 compressed (c),
@@ -37,6 +37,7 @@ no copy on write (C),
 no dump (d),
 synchronous directory updates (D),
 extent format (e),
+case-insensitive directory lookups (F),
 immutable (i),
 data journalling (j),
 project hierarchy (P),
@@ -119,6 +120,11 @@ set or reset using
 although it can be displayed by
 .BR lsattr (1).
 .PP
+A directory with the 'F' attribute set indicates that all the path
+lookups inside that directory are made in a case-insensitive fashion.
+This attribute can only be changed in empty directories on file systems
+with the fname_encoding feature enabled.
+.PP
 A file with the 'i' attribute cannot be modified: it cannot be deleted or
 renamed, no link can be created to this file, most of the file's
 metadata can not be modified, and the file can not be opened in write mode.
-- 
2.19.2
