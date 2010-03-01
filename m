From: Eric Sandeen <sandeen@redhat.com>
Subject: [PATCH] mke2fs: skip alignment questioning if -F specified
Date: Mon, 01 Mar 2010 13:53:09 -0600
Message-ID: <4B8C1B25.5050006@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
To: ext4 development <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:16024 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751459Ab0CATxM (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 1 Mar 2010 14:53:12 -0500
Received: from int-mx04.intmail.prod.int.phx2.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.17])
	by mx1.redhat.com (8.13.8/8.13.8) with ESMTP id o21JrBLO030974
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-ext4@vger.kernel.org>; Mon, 1 Mar 2010 14:53:12 -0500
Received: from liberator.sandeen.net (ovpn01.gateway.prod.ext.phx2.redhat.com [10.5.9.1])
	by int-mx04.intmail.prod.int.phx2.redhat.com (8.13.8/8.13.8) with ESMTP id o21Jr9Ae027751
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-ext4@vger.kernel.org>; Mon, 1 Mar 2010 14:53:11 -0500
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

RH bug 569021 - mke2fs insists on user interaction even if stdin is not a tty and -F is passed

This is just a warning, -F should easily override it.

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---

diff --git a/misc/mke2fs.c b/misc/mke2fs.c
index 4b13367..2a23bf7 100644
--- a/misc/mke2fs.c
+++ b/misc/mke2fs.c
@@ -1643,7 +1643,8 @@ got_size:
 		       device_name, retval);
 		printf(_("This may result in very poor performance, "
 			  "(re)-partitioning suggested.\n"));
-		proceed_question();
+		if (!force)
+			proceed_question();
 	}
 #endif
 

