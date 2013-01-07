From: Jan Kara <jack@suse.cz>
Subject: Re: [Suggestion] fs/ext3: memory leak by calling set_qf_name or
 clear_qf_name, many times.
Date: Mon, 7 Jan 2013 20:54:25 +0100
Message-ID: <20130107195425.GE13659@quack.suse.cz>
References: <50DA857B.1050808@asianux.com>
 <20121231120621.GD7564@quack.suse.cz>
 <50E66B19.5060907@asianux.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="45Z9DzgjV8m4Oswq"
Content-Transfer-Encoding: 8bit
Cc: Jan Kara <jack@suse.cz>, Theodore Ts'o <tytso@mit.edu>,
	akpm@linux-foundation.org, linux-ext4@vger.kernel.org
To: Chen Gang <gang.chen@asianux.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:50756 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753812Ab3AGTy2 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 7 Jan 2013 14:54:28 -0500
Content-Disposition: inline
In-Reply-To: <50E66B19.5060907@asianux.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


--45Z9DzgjV8m4Oswq
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit

On Fri 04-01-13 13:39:37, Chen Gang wrote:
> 于 2012年12月31日 20:06, Jan Kara 写道:
> >   Thanks for report. Yes, memory leak seems to be possible. Attached patch
> > should fix it, I have added it to my tree.
> > 
> > 									Honza
> > 
> 
>   after read your patch, today (although I am not a reviewer).
>   is it a possible situation like this (just my imagination):
>     1st let it call clear_qf_name successfully.
>     2nd let it call set_qf_name successfully.
>     3rd call clear_qf_name again ?
  Although this is not likely in practice, if you specify mount options
like usrjquota=aquota.user,usrjquota=,usrjquota=aquota.user it can happen.
Thanks for spotting this.

>     ...
>   if this situation is possible.
>     I guess the memory still leak, after apply your patch.
> 
>   if what I guess is true
>     it seems we have to duplicate memory for old_opts in ext3_remount.
>     and for clear_qf_name, set_qf_name, ext3_remount:
>       use normal memory allocation and free ways instead of current using.
  Yes. Updated patch attached.

									Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR

--45Z9DzgjV8m4Oswq
Content-Type: text/x-patch; charset=us-ascii
Content-Disposition: attachment; filename="0001-ext3-Fix-memory-leak-when-quota-options-are-specifie.patch"

>From c36504046b93419fba7ec0029a43afd2bbdd6c48 Mon Sep 17 00:00:00 2001
From: Jan Kara <jack@suse.cz>
Date: Mon, 31 Dec 2012 12:38:36 +0100
Subject: [PATCH] ext3: Fix memory leak when quota options are specified multiple times

When usrjquota or grpjquota mount options are specified several times,
we leak memory storing the names. Free the memory correctly.

Reported-by: Chen Gang <gang.chen@asianux.com>
Signed-off-by: Jan Kara <jack@suse.cz>
---
 fs/ext3/super.c |   51 ++++++++++++++++++++++++++++++---------------------
 1 files changed, 30 insertions(+), 21 deletions(-)

diff --git a/fs/ext3/super.c b/fs/ext3/super.c
index 6e50223..0926fe4 100644
--- a/fs/ext3/super.c
+++ b/fs/ext3/super.c
@@ -916,21 +916,24 @@ static int set_qf_name(struct super_block *sb, int qtype, substring_t *args)
 			"Not enough memory for storing quotafile name");
 		return 0;
 	}
-	if (sbi->s_qf_names[qtype] &&
-		strcmp(sbi->s_qf_names[qtype], qname)) {
-		ext3_msg(sb, KERN_ERR,
-			"%s quota file already specified", QTYPE2NAME(qtype));
+	if (sbi->s_qf_names[qtype]) {
+		int same = !strcmp(sbi->s_qf_names[qtype], qname);
+
 		kfree(qname);
-		return 0;
+		if (!same) {
+			ext3_msg(sb, KERN_ERR,
+				 "%s quota file already specified",
+				 QTYPE2NAME(qtype));
+		}
+		return same;
 	}
-	sbi->s_qf_names[qtype] = qname;
-	if (strchr(sbi->s_qf_names[qtype], '/')) {
+	if (strchr(qname, '/')) {
 		ext3_msg(sb, KERN_ERR,
 			"quotafile must be on filesystem root");
-		kfree(sbi->s_qf_names[qtype]);
-		sbi->s_qf_names[qtype] = NULL;
+		kfree(qname);
 		return 0;
 	}
+	sbi->s_qf_names[qtype] = qname;
 	set_opt(sbi->s_mount_opt, QUOTA);
 	return 1;
 }
@@ -945,11 +948,10 @@ static int clear_qf_name(struct super_block *sb, int qtype) {
 			" when quota turned on");
 		return 0;
 	}
-	/*
-	 * The space will be released later when all options are confirmed
-	 * to be correct
-	 */
-	sbi->s_qf_names[qtype] = NULL;
+	if (sbi->s_qf_names[qtype]) {
+		kfree(sbi->s_qf_names[qtype]);
+		sbi->s_qf_names[qtype] = NULL;
+	}
 	return 1;
 }
 #endif
@@ -2605,7 +2607,18 @@ static int ext3_remount (struct super_block * sb, int * flags, char * data)
 #ifdef CONFIG_QUOTA
 	old_opts.s_jquota_fmt = sbi->s_jquota_fmt;
 	for (i = 0; i < MAXQUOTAS; i++)
-		old_opts.s_qf_names[i] = sbi->s_qf_names[i];
+		if (sbi->s_qf_names[i]) {
+			old_opts.s_qf_names[i] = kstrdup(sbi->s_qf_names[i],
+							 GFP_KERNEL);
+			if (!old_opts.s_qf_names[i]) {
+				int j;
+
+				for (j = 0; j < i; j++)
+					kfree(old_opts.s_qf_names[j]);
+				return -ENOMEM;
+			}
+		} else
+			old_opts.s_qf_names[i] = NULL;
 #endif
 
 	/*
@@ -2698,9 +2711,7 @@ static int ext3_remount (struct super_block * sb, int * flags, char * data)
 #ifdef CONFIG_QUOTA
 	/* Release old quota file names */
 	for (i = 0; i < MAXQUOTAS; i++)
-		if (old_opts.s_qf_names[i] &&
-		    old_opts.s_qf_names[i] != sbi->s_qf_names[i])
-			kfree(old_opts.s_qf_names[i]);
+		kfree(old_opts.s_qf_names[i]);
 #endif
 	if (enable_quota)
 		dquot_resume(sb, -1);
@@ -2714,9 +2725,7 @@ restore_opts:
 #ifdef CONFIG_QUOTA
 	sbi->s_jquota_fmt = old_opts.s_jquota_fmt;
 	for (i = 0; i < MAXQUOTAS; i++) {
-		if (sbi->s_qf_names[i] &&
-		    old_opts.s_qf_names[i] != sbi->s_qf_names[i])
-			kfree(sbi->s_qf_names[i]);
+		kfree(sbi->s_qf_names[i]);
 		sbi->s_qf_names[i] = old_opts.s_qf_names[i];
 	}
 #endif
-- 
1.7.1


--45Z9DzgjV8m4Oswq--
