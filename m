From: Tomas Racek <tracek@redhat.com>
Subject: [PATCH 2/3] e2image: man: fix typo
Date: Sat, 16 Mar 2013 10:13:24 +0100
Message-ID: <1363425205-10970-2-git-send-email-tracek@redhat.com>
References: <1363425205-10970-1-git-send-email-tracek@redhat.com>
Cc: Tomas Racek <tracek@redhat.com>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:14442 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753029Ab3CPJNh (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sat, 16 Mar 2013 05:13:37 -0400
Received: from int-mx10.intmail.prod.int.phx2.redhat.com (int-mx10.intmail.prod.int.phx2.redhat.com [10.5.11.23])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id r2G9DbH4026409
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-ext4@vger.kernel.org>; Sat, 16 Mar 2013 05:13:37 -0400
In-Reply-To: <1363425205-10970-1-git-send-email-tracek@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


Signed-off-by: Tomas Racek <tracek@redhat.com>
---
 misc/e2image.8.in | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/misc/e2image.8.in b/misc/e2image.8.in
index 0972826..84b9729 100644
--- a/misc/e2image.8.in
+++ b/misc/e2image.8.in
@@ -187,7 +187,7 @@ Normally
 only includes fs metadata, not regular file data.  The
 .B \-a
 option can be specified to include all data.  This will
-give an image that is suitible to use to clone the entire FS or
+give an image that is suitable to use to clone the entire FS or
 for backup purposes.  Note that this option only works with the
 raw or QCOW2 formats.
 .PP
-- 
1.7.11.7

