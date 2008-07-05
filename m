From: "Stoyan Gaydarov" <stoyboyker@gmail.com>
Subject: Ext4 Compile warning 2.6.26-rc8
Date: Fri, 4 Jul 2008 19:57:42 -0500
Message-ID: <6d291e080807041757o6f1e379cof267c7e5ea37d3aa@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org
To: sct@redhat.com, akpm@linux-foundation.org, adilger@clusterfs.com
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from nf-out-0910.google.com ([64.233.182.185]:56564 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750721AbYGEA5p (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 4 Jul 2008 20:57:45 -0400
Received: by nf-out-0910.google.com with SMTP id d3so424712nfc.21
        for <linux-ext4@vger.kernel.org>; Fri, 04 Jul 2008 17:57:43 -0700 (PDT)
Content-Disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

I found a warning while compiling the 2.6.26-rc8 I though I would
point it out and see if I could help.

fs/ext4/super.c: In function 'ext4_show_options':
fs/ext4/super.c:674: warning: unused variable 'journal'

This is a patch to get rid of the variable causing the warning. I
compiled the kernel again after applying this patch and it got rid of
the warning. If you intend to use this variable in later versions and
it was just left there as a setup then ignore this.


diff -uprN linux-2.6.26-rc8/fs/ext4/super.c devel/fs/ext4/super.c
--- linux-2.6.26-rc8/fs/ext4/super.c    2008-06-24 20:58:20.000000000 -0500
+++ devel/fs/ext4/super.c       2008-07-04 19:37:42.000000000 -0500
@@ -671,7 +671,6 @@ static int ext4_show_options(struct seq_
        unsigned long def_mount_opts;
        struct super_block *sb = vfs->mnt_sb;
        struct ext4_sb_info *sbi = EXT4_SB(sb);
-       journal_t *journal = sbi->s_journal;
        struct ext4_super_block *es = sbi->s_es;

        def_mount_opts = le32_to_cpu(es->s_default_mount_opts);

Signed-off-by: Stoyan Gaydarov <stoyboyker@gmail.com>
