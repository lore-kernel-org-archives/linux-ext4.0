From: Andreas Dilger <adilger@whamcloud.com>
Subject: [PATCH] tune2fs: add dir_index feature to tune2fs man page
Date: Thu,  9 Jun 2011 23:24:33 -0600
Message-ID: <1307683473-4746-1-git-send-email-adilger@whamcloud.com>
Cc: Andreas Dilger <adilger@whamcloud.com>
To: tytso@mit.edu, linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from idcmail-mo2no.shaw.ca ([64.59.134.9]:58373 "EHLO
	idcmail-mo2no.shaw.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750864Ab1FJFYf (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 10 Jun 2011 01:24:35 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Add description of missing dir_index feature to tune2fs(8) man page.

Signed-off-by: Andreas Dilger <adilger@whamcloud.com>
---
 misc/tune2fs.8.in |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/misc/tune2fs.8.in b/misc/tune2fs.8.in
index 2f9db81..233f85a 100644
--- a/misc/tune2fs.8.in
+++ b/misc/tune2fs.8.in
@@ -491,6 +491,9 @@ The following filesystem features can be set or cleared using
 .B dir_index
 Use hashed b-trees to speed up lookups in large directories.
 .TP
+.B dir_nlink
+Allow more than 65000 subdirectories per directory.
+.TP
 .B filetype
 Store file type information in directory entries.
 .TP
-- 
1.7.3.4

