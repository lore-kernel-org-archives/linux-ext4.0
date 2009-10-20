From: Kazuya Mio <k-mio@sx.jp.nec.com>
Subject: [RFC][PATCH v2 4/4] e4defrag: update man page about -c option
Date: Tue, 20 Oct 2009 17:16:26 +0900
Message-ID: <4ADD71DA.7080801@sx.jp.nec.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
To: ext4 <linux-ext4@vger.kernel.org>, Theodore Tso <tytso@mit.edu>,
	Greg Freemyer <greg.freemyer@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from TYO202.gate.nec.co.jp ([202.32.8.206]:59717 "EHLO
	tyo202.gate.nec.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751233AbZJTIWR (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 20 Oct 2009 04:22:17 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Add the description of the size per one extent and the maximum extent size
in ext4 into e4defrag man page.

Signed-off-by: Kazuya Mio <k-mio@sx.jp.nec.com>
---

 e4defrag.8.in |   14 +++++++++-----
 1 file changed, 9 insertions(+), 5 deletions(-)
diff --git a/misc/e4defrag.8.in b/misc/e4defrag.8.in
index 3ba8570..75e1bc9 100644
--- a/misc/e4defrag.8.in
+++ b/misc/e4defrag.8.in
@@ -35,16 +35,20 @@ point.
 .SH OPTIONS
 .TP
 .B \-c
-Get the fragmentation count and calculate fragmentation score based on it
-before and after defrag. By seeing this score, we can determine whether we
-should execute
+Get a current fragmentation count and an ideal fragmentation count, and
+calculate fragmentation score based on them. By seeing this score, we can
+determine whether we should execute
 .B e4defrag
 to
 .IR target .
 When used with
 .B \-v
-option, the fragmentation count before and after defrag is printed for each
-file.
+option, the current fragmentation count and the ideal fragmentation count are
+printed for each file.
+.IP
+Also this option outputs the average data size in one extent. If you see it,
+you'll find the file has ideal extents or not. Note that the maximum extent
+size is 131072KB in ext4 filesystem (if block size is 4KB).
 .IP
 If this option is specified,
 .I target

