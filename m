From: Jim Meyering <jim@meyering.net>
Subject: [PATCH] Handle failed malloc.
Date: Tue, 05 Feb 2008 13:06:22 +0100
Message-ID: <87myqfa9q9.fsf@rho.meyering.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp3-g19.free.fr ([212.27.42.29]:50745 "EHLO smtp3-g19.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751182AbYBEMGY (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 5 Feb 2008 07:06:24 -0500
Received: from smtp3-g19.free.fr (localhost.localdomain [127.0.0.1])
	by smtp3-g19.free.fr (Postfix) with ESMTP id ED9B117B55E
	for <linux-ext4@vger.kernel.org>; Tue,  5 Feb 2008 13:06:22 +0100 (CET)
Received: from mx.meyering.net (mx.meyering.net [82.230.74.64])
	by smtp3-g19.free.fr (Postfix) with ESMTP id DA06217B558
	for <linux-ext4@vger.kernel.org>; Tue,  5 Feb 2008 13:06:22 +0100 (CET)
Received: from rho.meyering.net (localhost.localdomain [127.0.0.1])
	by rho.meyering.net (Acme Bit-Twister) with ESMTP id 7B5C394C
	for <linux-ext4@vger.kernel.org>; Tue,  5 Feb 2008 13:06:22 +0100 (CET)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


* lib/inflate.c (inflate_dynamic): Don't deref NULL upon failed malloc.
* arch/um/os-Linux/mem.c (make_tempfile): Likewise.

Signed-off-by: Jim Meyering <meyering@redhat.com>
---
 arch/um/os-Linux/mem.c |    2 ++
 lib/inflate.c          |    3 +++
 2 files changed, 5 insertions(+), 0 deletions(-)

diff --git a/arch/um/os-Linux/mem.c b/arch/um/os-Linux/mem.c
index 436f8d2..e114d09 100644
--- a/arch/um/os-Linux/mem.c
+++ b/arch/um/os-Linux/mem.c
@@ -172,6 +172,8 @@ int __init make_tempfile(const char *template, char **out_tempname,

 	which_tmpdir();
 	tempname = malloc(MAXPATHLEN);
+	if (tempname == NULL)
+	  return -1;

 	find_tempdir();
 	if (template[0] != '/')
diff --git a/lib/inflate.c b/lib/inflate.c
index 845f91d..9762294 100644
--- a/lib/inflate.c
+++ b/lib/inflate.c
@@ -811,6 +811,9 @@ DEBG("<dyn");
   ll = malloc(sizeof(*ll) * (286+30));  /* literal/length and distance code lengths */
 #endif

+  if (ll == NULL)
+    return 1;
+
   /* make local bit buffer */
   b = bb;
   k = bk;
--
1.5.4.19.gd3dfd
