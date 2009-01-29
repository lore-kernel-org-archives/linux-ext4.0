From: Eric Sandeen <sandeen@redhat.com>
Subject: [PATCH] debugfs - fix segfault on "stat" command with no open fs
Date: Thu, 29 Jan 2009 17:46:28 -0500
Message-ID: <498231C4.6090203@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: Andrew Hecox <ahecox@redhat.com>
To: ext4 development <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx2.redhat.com ([66.187.237.31]:41192 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751850AbZA2Wqb (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 29 Jan 2009 17:46:31 -0500
Received: from int-mx2.corp.redhat.com (int-mx2.corp.redhat.com [172.16.27.26])
	by mx2.redhat.com (8.13.8/8.13.8) with ESMTP id n0TMkUvH014003
	for <linux-ext4@vger.kernel.org>; Thu, 29 Jan 2009 17:46:30 -0500
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

This is a regression from commit 
8fdf29117f922419bd5b3f741e5d554b1d5b8893, which attempts to access
current_fs via a feature check before we check that it's open.

Just moving the feature check below the open check should fix it.

Reported-by: Andrew Hecox <ahecox@redhat.com>
Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---

Index: e2fsprogs/debugfs/debugfs.c
===================================================================
--- e2fsprogs.orig/debugfs/debugfs.c	2008-09-12 10:37:52.000000000 -0500
+++ e2fsprogs/debugfs/debugfs.c	2009-01-29 16:36:04.748574864 -0600
@@ -291,9 +291,6 @@ void do_show_super_stats(int argc, char 
 	int	c, header_only = 0;
 	int	numdirs = 0, first, gdt_csum;
 
-	gdt_csum = EXT2_HAS_RO_COMPAT_FEATURE(current_fs->super,
-					      EXT4_FEATURE_RO_COMPAT_GDT_CSUM);
