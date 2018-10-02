Return-Path: <SRS0=f65u=MO=vger.kernel.org=linux-ext4-owner@kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:37134 "EHLO imap.thunk.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726552AbeJBVdY (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Tue, 2 Oct 2018 17:33:24 -0400
Date: Tue, 2 Oct 2018 10:49:33 -0400
From: "Theodore Y. Ts'o" <tytso@mit.edu>
To: syzbot <syzbot+a2872d6feea6918008a9@syzkaller.appspotmail.com>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        syzkaller-bugs@googlegroups.com, viro@zeniv.linux.org.uk,
        linux-ext4@vger.kernel.org
Subject: Re: KASAN: use-after-free Read in seq_escape
Message-ID: <20181002144933.GC17537@thunk.org>
References: <000000000000902cb10577255369@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <000000000000902cb10577255369@google.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sun, Sep 30, 2018 at 11:58:02PM -0700, syzbot wrote:
> Hello,
> 
> syzbot found the following crash on:
> 
> HEAD commit:    17b57b1883c1 Linux 4.19-rc6
> git tree:       upstream
> console output: https://syzkaller.appspot.com/x/log.txt?x=1672d711400000
> kernel config:  https://syzkaller.appspot.com/x/.config?x=c0af03fe452b65fb
> dashboard link: https://syzkaller.appspot.com/bug?extid=a2872d6feea6918008a9
> compiler:       gcc (GCC) 8.0.1 20180413 (experimental)

This should be fixed with the following patch.

     	       	     	      		- Ted

>From 89cc85e761c5b905b1a61cb85440bf9b5e841c80 Mon Sep 17 00:00:00 2001
From: Theodore Ts'o <tytso@mit.edu>
Date: Tue, 2 Oct 2018 10:40:57 -0400
Subject: [PATCH] ext4: fix use-after-free race in ext4_remount()'s error path

It's possible for ext4_show_quota_options() to try reading
s_qf_names[i] while it is being modified by ext4_remount() --- most
notably, in ext4_remount's error path when the original values of the
quota file name gets restored.

Reported-by: syzbot+a2872d6feea6918008a9@syzkaller.appspotmail.com
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
Cc: stable@kernel.org
---
 fs/ext4/super.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/fs/ext4/super.c b/fs/ext4/super.c
index faf293ed8060..11a1bfae0937 100644
--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -2048,11 +2048,13 @@ static inline void ext4_show_quota_options(struct seq_file *seq,
 		seq_printf(seq, ",jqfmt=%s", fmtname);
 	}
 
+	down_read(&sb->s_umount);
 	if (sbi->s_qf_names[USRQUOTA])
 		seq_show_option(seq, "usrjquota", sbi->s_qf_names[USRQUOTA]);
 
 	if (sbi->s_qf_names[GRPQUOTA])
 		seq_show_option(seq, "grpjquota", sbi->s_qf_names[GRPQUOTA]);
+	up_read(&sb->s_umount);
 #endif
 }
 
-- 
2.18.0.rc0
