From: Carlos Maiolino <cmaiolino@redhat.com>
Subject: [PATCH] e2image: Add image consistency information and -f option to manpage
Date: Mon, 30 Sep 2013 18:19:25 -0300
Message-ID: <1380575965-9668-1-git-send-email-cmaiolino@redhat.com>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:23743 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755171Ab3I3VTb (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 30 Sep 2013 17:19:31 -0400
Received: from int-mx12.intmail.prod.int.phx2.redhat.com (int-mx12.intmail.prod.int.phx2.redhat.com [10.5.11.25])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id r8ULJUUD026051
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-ext4@vger.kernel.org>; Mon, 30 Sep 2013 17:19:30 -0400
Received: from orion.redhat.com (ovpn-113-131.phx2.redhat.com [10.3.113.131])
	by int-mx12.intmail.prod.int.phx2.redhat.com (8.14.4/8.14.4) with ESMTP id r8ULJSkm007995
	for <linux-ext4@vger.kernel.org>; Mon, 30 Sep 2013 17:19:29 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Adds information regarding image consistency when using e2image on a read-write
filesystem and about -f option used now to force the image creation of a
read-write filesystem

Signed-off-by: Carlos Maiolino <cmaiolino@redhat.com>
---
 misc/e2image.8.in | 12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/misc/e2image.8.in b/misc/e2image.8.in
index 84b9729..eb22f42 100644
--- a/misc/e2image.8.in
+++ b/misc/e2image.8.in
@@ -30,6 +30,18 @@ recovering catastrophically corrupted filesystems.  In the future,
 e2fsck will be enhanced to be able to use the image file to help
 recover a badly damaged filesystem.
 .PP
+When getting an image to be used for debugging purposes, is necessary that the
+filesystem be unmounted or in a Read-Only state, to ensure the image-file will
+be in a consistent state. Although, it's possible to force an image-file
+creation using the 
+.B -f
+option. For images saved for metadata backup purposes (to be restored with
+.B -I
+option),
+.B e2image
+will be backing up only statically located metadata blocks, so, images taken
+from a read-write filesystem are not completely useless, and, although recommended, there is no real need to run it on a Read-Only or unmounted filesystem.
+.PP
 If
 .I image-file
 is \-, then the output of
-- 
1.8.1.4

