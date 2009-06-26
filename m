From: Eric Sandeen <sandeen@redhat.com>
Subject: [PATCH] debugfs: don't try to fclose NULL
Date: Fri, 26 Jun 2009 13:57:39 -0500
Message-ID: <4A451A23.20307@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
To: ext4 development <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx2.redhat.com ([66.187.237.31]:51532 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752175AbZFZS5i (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 26 Jun 2009 14:57:38 -0400
Received: from int-mx2.corp.redhat.com (int-mx2.corp.redhat.com [172.16.27.26])
	by mx2.redhat.com (8.13.8/8.13.8) with ESMTP id n5QIvf1L021187
	for <linux-ext4@vger.kernel.org>; Fri, 26 Jun 2009 14:57:41 -0400
Received: from ns3.rdu.redhat.com (ns3.rdu.redhat.com [10.11.255.199])
	by int-mx2.corp.redhat.com (8.13.1/8.13.1) with ESMTP id n5QIvf1o003831
	for <linux-ext4@vger.kernel.org>; Fri, 26 Jun 2009 14:57:41 -0400
Received: from liberator.sandeen.net (sebastian-int.corp.redhat.com [172.16.52.221])
	by ns3.rdu.redhat.com (8.13.8/8.13.8) with ESMTP id n5QIve8j030260
	for <linux-ext4@vger.kernel.org>; Fri, 26 Jun 2009 14:57:40 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

do_logdump may jump to errout if fopen(out_file) fails, 
but in that case out_file is NULL, and fclose will segfault.

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---

diff --git a/debugfs/logdump.c b/debugfs/logdump.c
index 4818bc6..9a7108a 100644
--- a/debugfs/logdump.c
+++ b/debugfs/logdump.c
@@ -259,7 +259,7 @@ void do_logdump(int argc, char **argv)
 		close(journal_fd);
 
 errout:
-	if (out_file != stdout)
+	if (out_file && (out_file != stdout))
 		fclose(out_file);
 
 	return;

