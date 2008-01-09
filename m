From: Eric Sandeen <sandeen@redhat.com>
Subject: [PATCH] Fix up uuidd man page
Date: Wed, 09 Jan 2008 10:06:08 -0600
Message-ID: <4784F0F0.9090303@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
To: Theodore Tso <tytso@mit.edu>,
	ext4 development <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:39970 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751218AbYAIQGb (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 9 Jan 2008 11:06:31 -0500
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

uuidd(8) man page had a typo, and a couple of stale defaults
documented.

Signed-off-by: Eric Sandeen <sandeen@redhat.com>

---

Index: e2fsprogs-1.40.4/misc/uuidd.8.in
===================================================================
--- e2fsprogs-1.40.4.orig/misc/uuidd.8.in
+++ e2fsprogs-1.40.4/misc/uuidd.8.in
@@ -64,11 +64,11 @@ UUID's.
 .TP
 .BI \-p  " pidfile"
 Specify the pathname where the pid file should be written.  By default,
-the pid file is written to /var/run/uuidd.pid.
+the pid file is written to /var/lib/libuuid/uuidd.pid.
 .TP
 .BI \-s " socketpath"
 Specify the pathname used for the unix-domain socket used by uuidd.  By
-qdefault, the pathname used is /var/run/uuidd.sock.  This is primarily
+default, the pathname used is /var/lib/libuuid/request.  This is primarily
 for debugging purposes, since the pathname is hard-coded in the libuuid
 library.
 .TP
