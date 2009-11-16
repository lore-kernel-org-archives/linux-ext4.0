From: Eric Sandeen <sandeen@redhat.com>
Subject: [PATCH] ext3: make "norecovery" an alias for "noload"
Date: Mon, 16 Nov 2009 16:50:49 -0600
Message-ID: <4B01D749.3030601@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Jan Kara <jack@suse.cz>
To: ext4 development <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:38345 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752121AbZKPWut (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 16 Nov 2009 17:50:49 -0500
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Users on the list recently complained about differences across
filesystems w.r.t. how to mount without a journal replay.

In the discussion it was noted that xfs's "norecovery" option is
perhaps more descriptively accurate than "noload," so let's make
that an alias for ext3.

Also show this status in /proc/mounts

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---

diff --git a/Documentation/filesystems/ext3.txt b/Documentation/filesystems/ext3.txt
index 05d5cf1..8b8d973 100644
--- a/Documentation/filesystems/ext3.txt
+++ b/Documentation/filesystems/ext3.txt
@@ -33,7 +33,7 @@ journal_dev=devnum	When the external journal device's major/minor numbers
 			in devnum.
 
 noload			Don't load the journal on mounting. Note that this forces
-			mount of inconsistent filesystem, which can lead to
+norecovery		mount of inconsistent filesystem, which can lead to
 			various problems.
 
 data=journal		All data are committed into the journal prior to being
diff --git a/fs/ext3/super.c b/fs/ext3/super.c
index 427496c..c14fb95 100644
--- a/fs/ext3/super.c
+++ b/fs/ext3/super.c
@@ -636,6 +636,9 @@ static int ext3_show_options(struct seq_file *seq, struct vfsmount *vfs)
 	if (test_opt(sb, DATA_ERR_ABORT))
 		seq_puts(seq, ",data_err=abort");
 
+	if (test_opt(sb, NOLOAD))
+		seq_puts(seq, ",norecovery");
+
 	ext3_show_quota_options(seq, sb);
 
 	return 0;
@@ -818,6 +821,7 @@ static const match_table_t tokens = {
 	{Opt_reservation, "reservation"},
 	{Opt_noreservation, "noreservation"},
 	{Opt_noload, "noload"},
+	{Opt_noload, "norecovery"},
 	{Opt_nobh, "nobh"},
 	{Opt_bh, "bh"},
 	{Opt_commit, "commit=%u"},

