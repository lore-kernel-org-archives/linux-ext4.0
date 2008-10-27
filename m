From: Hidehiro Kawai <hidehiro.kawai.ez@hitachi.com>
Subject: [PATCH 1/2] ext3: fix a bug accessing freed memory in ext3_abort
Date: Mon, 27 Oct 2008 16:31:31 +0900
Message-ID: <49056E53.9050601@hitachi.com>
References: <19f34abd0810250422t17990222x78fcf0fad2e6f04b@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: Theodore Tso <tytso@mit.edu>, Jan Kara <jack@ucw.cz>,
	Stephen Rothwell <sfr@canb.auug.org.au>,
	Al Viro <viro@zeniv.linux.org.uk>, linux-ext4@vger.kernel.org,
	Andrew Morton <akpm@linux-foundation.org>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	"Rafael J. Wysocki" <rjw@sisk.pl>, Ingo Molnar <mingo@elte.hu>,
	Pekka Enberg <penberg@cs.helsinki.fi>,
	linux-kernel@vger.kernel.org,
	sugita <yumiko.sugita.yf@hitachi.com>,
	Satoshi OSHIMA <satoshi.oshima.fk@hitachi.com>
To: Vegard Nossum <vegard.nossum@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail9.hitachi.co.jp ([133.145.228.44]:33974 "EHLO
	mail9.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751591AbYJ0Hbs (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 27 Oct 2008 03:31:48 -0400
In-Reply-To: <19f34abd0810250422t17990222x78fcf0fad2e6f04b@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi Vegard,

Vegard Nossum wrote:

> commit 2d7c820e56ce83b23daee9eb5343730fb309418e
> Author: Hidehiro Kawai <hidehiro.kawai.ez@hitachi.com>
> Date:   Wed Oct 22 14:15:01 2008 -0700
> 
>     ext3: add checks for errors from jbd
> 
> introduces a regression which was discovered by kmemcheck:

Thank you for reporting this regression.  It's my fault.
I send patches to fix.

Regards,


Subject: [PATCH 1/2] ext3: fix a bug accessing freed memory in ext3_abort

Vegard Nossum reported a bug which accesses freed memory.  When
journal has been aborted, ext3_put_super() calls ext3_abort() after
freeing the journal_t object, and then ext3_abort() accesses it.
This patch fix it.

Signed-off-by: Hidehiro Kawai <hidehiro.kawai.ez@hitachi.com>
---
 fs/ext3/super.c |   10 +++++++---
 1 file changed, 7 insertions(+), 3 deletions(-)

Index: linux-2.6.28-rc2/fs/ext3/super.c
===================================================================
--- linux-2.6.28-rc2.orig/fs/ext3/super.c
+++ linux-2.6.28-rc2/fs/ext3/super.c
@@ -281,7 +281,8 @@ void ext3_abort (struct super_block * sb
 	EXT3_SB(sb)->s_mount_state |= EXT3_ERROR_FS;
 	sb->s_flags |= MS_RDONLY;
 	EXT3_SB(sb)->s_mount_opt |= EXT3_MOUNT_ABORT;
-	journal_abort(EXT3_SB(sb)->s_journal, -EIO);
+	if (EXT3_SB(sb)->s_journal)
+		journal_abort(EXT3_SB(sb)->s_journal, -EIO);
 }
 
 void ext3_warning (struct super_block * sb, const char * function,
@@ -390,11 +391,14 @@ static void ext3_put_super (struct super
 {
 	struct ext3_sb_info *sbi = EXT3_SB(sb);
 	struct ext3_super_block *es = sbi->s_es;
-	int i;
+	int i, err;
 
 	ext3_xattr_put_super(sb);
-	if (journal_destroy(sbi->s_journal) < 0)
+	err = journal_destroy(sbi->s_journal);
+	sbi->s_journal = NULL;
+	if (err < 0)
 		ext3_abort(sb, __func__, "Couldn't clean up the journal");
+
 	if (!(sb->s_flags & MS_RDONLY)) {
 		EXT3_CLEAR_INCOMPAT_FEATURE(sb, EXT3_FEATURE_INCOMPAT_RECOVER);
 		es->s_state = cpu_to_le16(sbi->s_mount_state);




