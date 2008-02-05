From: Jim Meyering <jim@meyering.net>
Subject: [PATCH] Handle unusual results from find_tempdir.
Date: Tue, 05 Feb 2008 13:13:04 +0100
Message-ID: <87hcgna9f3.fsf@rho.meyering.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp3-g19.free.fr ([212.27.42.29]:39889 "EHLO smtp3-g19.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751716AbYBEMNF (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 5 Feb 2008 07:13:05 -0500
Received: from smtp3-g19.free.fr (localhost.localdomain [127.0.0.1])
	by smtp3-g19.free.fr (Postfix) with ESMTP id D45A717B5CC
	for <linux-ext4@vger.kernel.org>; Tue,  5 Feb 2008 13:13:04 +0100 (CET)
Received: from mx.meyering.net (mx.meyering.net [82.230.74.64])
	by smtp3-g19.free.fr (Postfix) with ESMTP id C855317B5CB
	for <linux-ext4@vger.kernel.org>; Tue,  5 Feb 2008 13:13:04 +0100 (CET)
Received: from rho.meyering.net (localhost.localdomain [127.0.0.1])
	by rho.meyering.net (Acme Bit-Twister) with ESMTP id 9CC3725334
	for <linux-ext4@vger.kernel.org>; Tue,  5 Feb 2008 13:13:04 +0100 (CET)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

An alternative: make find_tempdir set tempdir to default_tempdir
upon malloc failure.

* arch/um/os-Linux/mem.c (make_tempfile): Handle NULL tempdir.
Don't let a long tempdir (e.g., via TMPDIR) provoke heap corruption.

Signed-off-by: Jim Meyering <meyering@redhat.com>
---
 arch/um/os-Linux/mem.c |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/arch/um/os-Linux/mem.c b/arch/um/os-Linux/mem.c
index e114d09..1458385 100644
--- a/arch/um/os-Linux/mem.c
+++ b/arch/um/os-Linux/mem.c
@@ -176,6 +176,9 @@ int __init make_tempfile(const char *template, char **out_tempname,
 	  return -1;

 	find_tempdir();
+	if (tempdir == NULL || strlen(tempdir) >= MAXPATHLEN)
+	  return -1;
+
 	if (template[0] != '/')
 		strcpy(tempname, tempdir);
 	else
--
1.5.4.19.gd3dfd
