From: Eric Sandeen <sandeen@redhat.com>
Subject: [PATCH e2fsprogs] add e2undo files to the specfile template
Date: Wed, 18 Jun 2008 16:16:35 -0500
Message-ID: <48597B33.4030809@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: Theodore Tso <tytso@mit.edu>
To: ext4 development <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:46827 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754443AbYFRVQh (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 18 Jun 2008 17:16:37 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Add e2undo files to the specfile template.

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---

Index: e2fsprogs-1.41/e2fsprogs.spec.in
===================================================================
--- e2fsprogs-1.41.orig/e2fsprogs.spec.in	2008-06-17 06:31:35.000000000 -0500
+++ e2fsprogs-1.41/e2fsprogs.spec.in	2008-06-18 16:15:18.703822498 -0500
@@ -115,6 +115,7 @@ exit 0
 %{_root_sbindir}/e2fsck
 %{_root_sbindir}/e2image
 %{_root_sbindir}/e2label
+%{_root_sbindir}/e2undo
 %{_root_sbindir}/findfs
 %{_root_sbindir}/fsck
 %{_root_sbindir}/fsck.ext2
@@ -164,6 +165,7 @@ exit 0
 %{_mandir}/man8/fsck.ext4dev.8*
 %{_mandir}/man8/e2image.8*
 %{_mandir}/man8/e2label.8*
+%{_mandir}/man8/e2undo.8*
 %{_mandir}/man8/fsck.8*
 %{_mandir}/man8/logsave.8*
 %{_mandir}/man8/mke2fs.8*

