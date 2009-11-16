From: Eric Sandeen <sandeen@redhat.com>
Subject: [PATCH 2/2] ext4: make "norecovery" an alias for "noload"
Date: Mon, 16 Nov 2009 16:47:09 -0600
Message-ID: <4B01D66D.4050001@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
To: ext4 development <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:33238 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754421AbZKPWrH (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 16 Nov 2009 17:47:07 -0500
Received: from int-mx03.intmail.prod.int.phx2.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.16])
	by mx1.redhat.com (8.13.8/8.13.8) with ESMTP id nAGMlDUJ009195
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-ext4@vger.kernel.org>; Mon, 16 Nov 2009 17:47:13 -0500
Received: from Liberator.local (ovpn01.gateway.prod.ext.phx2.redhat.com [10.5.9.1])
	by int-mx03.intmail.prod.int.phx2.redhat.com (8.13.8/8.13.8) with ESMTP id nAGMl97E028455
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-ext4@vger.kernel.org>; Mon, 16 Nov 2009 17:47:12 -0500
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Users on the list recently complained about differences across
filesystems w.r.t. how to mount without a journal replay.

In the discussion it was noted that xfs's "norecovery" option is
perhaps more descriptively accurate than "noload," so let's make
that an alias for ext4.

Also show this status in /proc/mounts

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---


diff --git a/Documentation/filesystems/ext4.txt b/Documentation/filesystems/ext4.txt
index 87036af..e5d47a7 100644
--- a/Documentation/filesystems/ext4.txt
+++ b/Documentation/filesystems/ext4.txt
@@ -154,7 +154,7 @@ journal_dev=devnum	When the external journal device's major/minor numbers
 			in devnum.
 
 noload			Don't load the journal on mounting.  Note that
-                     	if the filesystem was not unmounted cleanly,
+norecovery              if the filesystem was not unmounted cleanly,
                      	skipping the journal replay will lead to the
                      	filesystem containing inconsistencies that can
                      	lead to any number of problems.
diff --git a/fs/ext4/super.c b/fs/ext4/super.c
index fc4a8d8..ea3148b 100644
--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -902,6 +902,9 @@ static int ext4_show_options(struct seq_file *seq, struct vfsmount *vfs)
 	if (test_opt(sb, TRIM))
 		seq_puts(seq, ",trim");
 
+	if (test_opt(sb, NOLOAD))
+		seq_puts(seq, ",norecovery");
+
 	ext4_show_quota_options(seq, sb);
 
 	return 0;
@@ -1108,6 +1111,7 @@ static const match_table_t tokens = {
 	{Opt_acl, "acl"},
 	{Opt_noacl, "noacl"},
 	{Opt_noload, "noload"},
+	{Opt_noload, "norecovery"},
 	{Opt_nobh, "nobh"},
 	{Opt_bh, "bh"},
 	{Opt_commit, "commit=%u"},

