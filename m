From: Eric Sandeen <sandeen@redhat.com>
Subject: [PATCH] properly show journal checksum/async options
Date: Sun, 14 Sep 2008 14:18:59 -0700
Message-ID: <48CD7FC3.4050807@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
To: ext4 development <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx2.redhat.com ([66.187.237.31]:55927 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754305AbYINVT5 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sun, 14 Sep 2008 17:19:57 -0400
Received: from int-mx2.corp.redhat.com (int-mx2.corp.redhat.com [172.16.27.26])
	by mx2.redhat.com (8.13.8/8.13.8) with ESMTP id m8ELJBUv001109
	for <linux-ext4@vger.kernel.org>; Sun, 14 Sep 2008 17:19:32 -0400
Received: from ns3.rdu.redhat.com (ns3.rdu.redhat.com [10.11.255.199])
	by int-mx2.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m8ELJ0mN013720
	for <linux-ext4@vger.kernel.org>; Sun, 14 Sep 2008 17:19:01 -0400
Received: from Liberator.local (sebastian-int.corp.redhat.com [172.16.52.221])
	by ns3.rdu.redhat.com (8.13.8/8.13.8) with ESMTP id m8ELIxib001389
	for <linux-ext4@vger.kernel.org>; Sun, 14 Sep 2008 17:18:59 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

The journal_checksum option is not being displayed in
/proc/mounts ... add this to the show_options() output, but
only if journal_async_commit is not specified, as that enables
journal_checksum internally.

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---

(Aside: this reminds me that we only show non-default options
in show_options; has there been any discussion of whether
these should be defaults?)

Index: linux-2.6/fs/ext4/super.c
===================================================================
--- linux-2.6.orig/fs/ext4/super.c	2008-09-14 16:12:54.898077064 -0500
+++ linux-2.6/fs/ext4/super.c	2008-09-14 16:13:22.878077407 -0500
@@ -746,8 +746,12 @@ static int ext4_show_options(struct seq_
 	 */
 	seq_puts(seq, ",barrier=");
 	seq_puts(seq, test_opt(sb, BARRIER) ? "1" : "0");
+	/* journal_async_commit enables journal_checksum internally */
 	if (test_opt(sb, JOURNAL_ASYNC_COMMIT))
 		seq_puts(seq, ",journal_async_commit");
+	else if (test_opt(sb, JOURNAL_CHECKSUM))
+		seq_puts(seq, ",journal_checksum");
+
 	if (test_opt(sb, NOBH))
 		seq_puts(seq, ",nobh");
 	if (!test_opt(sb, EXTENTS))

