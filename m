From: Hidehiro Kawai <hidehiro.kawai.ez@hitachi.com>
Subject: [PATCH 1/2 take 2] ext3: fix a bug accessing freed memory in
    ext3_abort
Date: Mon, 27 Oct 2008 20:44:31 +0900
Message-ID: <4905A99F.8000605@hitachi.com>
References: <19f34abd0810250422t17990222x78fcf0fad2e6f04b@mail.gmail.com>
    <49056D29.2010700@hitachi.com> <49056FA5.7070202@hitachi.com>
    <20081027104325.GA13641@elte.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: Theodore Tso <tytso@mit.edu>,
	Vegard Nossum <vegard.nossum@gmail.com>,
	Jan Kara <jack@ucw.cz>,
	Stephen Rothwell <sfr@canb.auug.org.au>,
	Al Viro <viro@zeniv.linux.org.uk>, linux-ext4@vger.kernel.org,
	"Rafael J. Wysocki" <rjw@sisk.pl>,
	Pekka Enberg <penberg@cs.helsinki.fi>,
	linux-kernel@vger.kernel.org,
	sugita <yumiko.sugita.yf@hitachi.com>,
	Satoshi OSHIMA <satoshi.oshima.fk@hitachi.com>
To: Ingo Molnar <mingo@elte.hu>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Andrew Morton <akpm@linux-foundation.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail7.hitachi.co.jp ([133.145.228.42]:34955 "EHLO
	mail7.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752371AbYJ0Lop (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 27 Oct 2008 07:44:45 -0400
In-Reply-To: <20081027104325.GA13641@elte.hu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Ingo Molnar wrote:

> * Hidehiro Kawai <hidehiro.kawai.ez@hitachi.com> wrote:
> 
>>Vegard Nossum reported a bug which accesses freed memory.  When
>>journal has been aborted, ext4_put_super() calls ext4_abort() after
>>freeing the journal_t object, and then ext4_abort() accesses it.
>>This patch fix it.
>>
>>Signed-off-by: Hidehiro Kawai <hidehiro.kawai.ez@hitachi.com>
> 
> could you please put the word "kmemcheck" into the commit log? ("found 
> via kmemcheck" or so) We want to have an easily git-greppable track 
> record of upstream kernel bugs that were found via kmemcheck. (and 
> there's already a long list)

Ah, OK.  I fixed the commit log.

Thanks,


Subject: [PATCH 1/2] ext3: fix a bug accessing freed memory in ext3_abort

Vegard Nossum reported a bug which accesses freed memory (found via
kmemcheck).  When journal has been aborted, ext3_put_super() calls
ext3_abort() after freeing the journal_t object, and then ext3_abort()
accesses it.  This patch fix it.

Signed-off-by: Hidehiro Kawai <hidehiro.kawai.ez@hitachi.com>
Acked-by: Jan Kara <jack@suse.cz>
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


