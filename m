From: Jan Kara <jack@suse.cz>
Subject: Re: [Suggestion] fs/ext3: memory leak by calling set_qf_name or
 clear_qf_name, many times.
Date: Mon, 31 Dec 2012 13:06:21 +0100
Message-ID: <20121231120621.GD7564@quack.suse.cz>
References: <50DA857B.1050808@asianux.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="AhhlLboLdkugWU4S"
Cc: Theodore Ts'o <tytso@mit.edu>, jack@suse.cz,
	akpm@linux-foundation.org, linux-ext4@vger.kernel.org
To: Chen Gang <gang.chen@asianux.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:55559 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750951Ab2LaMG0 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 31 Dec 2012 07:06:26 -0500
Content-Disposition: inline
In-Reply-To: <50DA857B.1050808@asianux.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


--AhhlLboLdkugWU4S
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed 26-12-12 13:04:59, Chen Gang wrote:
> Hello Theodore Ts'o
> 
> in fs/ext3/supper.c
>   for function set_qf_name:
>     sbi->s_qf_names[qtype] may already have owned a memory (line 919..925)
>     we set sbi->s_qf_names[qtype] = qname directly without checking (line 926)
> 
>   for function clear_qf_name:
>     we set sbi->s_qf_names[qtype] = NULL (line 942..952)
> 
> 
>   for function parse_options:
>     we can call set_qf_name or clear_qf_name with USR or GRP many times.
>       we find parameters not mind whether they are repeated. (line 975..985) 
>       so we may call set_qf_name or clear_qf_name several times.
>         also may first call set_qf_name, then call clear_qf_name.
> 
>   in this situation, we will get memory leak.
> 
>   please help check this suggestion whether valid (I find it by code review).
  Thanks for report. Yes, memory leak seems to be possible. Attached patch
should fix it, I have added it to my tree.

									Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR

--AhhlLboLdkugWU4S
Content-Type: text/x-patch; charset=us-ascii
Content-Disposition: attachment; filename="0001-ext3-Fix-memory-leak-when-quota-options-are-specifie.patch"

>From 59cefce80eb3e081d0dbef335843340512aff79e Mon Sep 17 00:00:00 2001
From: Jan Kara <jack@suse.cz>
Date: Mon, 31 Dec 2012 12:38:36 +0100
Subject: [PATCH] ext3: Fix memory leak when quota options are specified multiple times

When usrjquota or grpjquota mount options are specified several times
with the same file name, we leak memory storing the names. Free the
memory correctly.

Reported-by: Chen Gang <gang.chen@asianux.com>
Signed-off-by: Jan Kara <jack@suse.cz>
---
 fs/ext3/super.c |   14 +++++++++-----
 1 files changed, 9 insertions(+), 5 deletions(-)

diff --git a/fs/ext3/super.c b/fs/ext3/super.c
index 6e50223..b36cea9 100644
--- a/fs/ext3/super.c
+++ b/fs/ext3/super.c
@@ -916,12 +916,16 @@ static int set_qf_name(struct super_block *sb, int qtype, substring_t *args)
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
 	sbi->s_qf_names[qtype] = qname;
 	if (strchr(sbi->s_qf_names[qtype], '/')) {
-- 
1.7.1


--AhhlLboLdkugWU4S--
