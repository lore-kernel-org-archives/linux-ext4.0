From: Andrew Clayton <andrew@digital-domain.net>
Subject: [PATCH] Documentation/filesystems/ext3.txt
Date: Mon, 18 May 2009 21:22:09 +0100
Message-ID: <20090518212209.17c46cee@digital-domain.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from c.painless.aaisp.net.uk ([81.187.30.53]:48432 "EHLO
	c.painless.aaisp.net.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755863AbZERUxy (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 18 May 2009 16:53:54 -0400
Received: from alpha.digital-domain.net ([217.169.2.51] helo=localhost.localdomain)
	by c.painless.aaisp.net.uk with esmtp (Exim 4.69)
	(envelope-from <andrew@digital-domain.net>)
	id 1M69Le-0001Fq-0c
	for linux-ext4@vger.kernel.org; Mon, 18 May 2009 21:22:10 +0100
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Update the ext3 document with the fact that data=writeback is now the
default journaling mode.


Signed-off-by: Andrew Clayton <andrew@digital-domain.net>

--- linux-2.6/Documentation/filesystems/ext3.txt.orig	2009-05-18 20:48:27.084220753 +0100
+++ linux-2.6/Documentation/filesystems/ext3.txt	2009-05-18 20:49:01.023225288 +0100
@@ -39,11 +39,11 @@
 data=journal		All data are committed into the journal prior to being
 			written into the main file system.
 
-data=ordered	(*)	All data are forced directly out to the main file
+data=ordered		All data are forced directly out to the main file
 			system prior to its metadata being committed to the
 			journal.
 
-data=writeback		Data ordering is not preserved, data may be written
+data=writeback	(*)	Data ordering is not preserved, data may be written
 			into the main file system after its metadata has been
 			committed to the journal.
 
