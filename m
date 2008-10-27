From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH 2/2] ext4: fix a bug accessing freed memory in ext4_abort
Date: Mon, 27 Oct 2008 09:11:54 +0100
Message-ID: <20081027081154.GC23804@atrey.karlin.mff.cuni.cz>
References: <19f34abd0810250422t17990222x78fcf0fad2e6f04b@mail.gmail.com> <49056D29.2010700@hitachi.com> <49056FA5.7070202@hitachi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Theodore Tso <tytso@mit.edu>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Vegard Nossum <vegard.nossum@gmail.com>,
	Jan Kara <jack@ucw.cz>,
	Stephen Rothwell <sfr@canb.auug.org.au>,
	Al Viro <viro@zeniv.linux.org.uk>, linux-ext4@vger.kernel.org,
	Andrew Morton <akpm@linux-foundation.org>,
	"Rafael J. Wysocki" <rjw@sisk.pl>, Ingo Molnar <mingo@elte.hu>,
	Pekka Enberg <penberg@cs.helsinki.fi>,
	linux-kernel@vger.kernel.org,
	sugita <yumiko.sugita.yf@hitachi.com>,
	Satoshi OSHIMA <satoshi.oshima.fk@hitachi.com>
To: Hidehiro Kawai <hidehiro.kawai.ez@hitachi.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:33775 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751901AbYJ0ILz (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 27 Oct 2008 04:11:55 -0400
Content-Disposition: inline
In-Reply-To: <49056FA5.7070202@hitachi.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

> Vegard Nossum reported a bug which accesses freed memory.  When
> journal has been aborted, ext4_put_super() calls ext4_abort() after
> freeing the journal_t object, and then ext4_abort() accesses it.
> This patch fix it.
> 
> Signed-off-by: Hidehiro Kawai <hidehiro.kawai.ez@hitachi.com>
  And this one as well. Acked-by: Jan Kara <jack@suse.cz>
> ---
>  fs/ext4/super.c |   11 +++++++----
>  1 file changed, 7 insertions(+), 4 deletions(-)
> 
> Index: linux-2.6.28-rc2/fs/ext4/super.c
> ===================================================================
> --- linux-2.6.28-rc2.orig/fs/ext4/super.c
> +++ linux-2.6.28-rc2/fs/ext4/super.c
> @@ -333,7 +333,8 @@ void ext4_abort(struct super_block *sb, 
>  	EXT4_SB(sb)->s_mount_state |= EXT4_ERROR_FS;
>  	sb->s_flags |= MS_RDONLY;
>  	EXT4_SB(sb)->s_mount_opt |= EXT4_MOUNT_ABORT;
> -	jbd2_journal_abort(EXT4_SB(sb)->s_journal, -EIO);
> +	if (EXT4_SB(sb)->s_journal)
> +		jbd2_journal_abort(EXT4_SB(sb)->s_journal, -EIO);
>  }
>  
>  void ext4_warning(struct super_block *sb, const char *function,
> @@ -442,14 +443,16 @@ static void ext4_put_super(struct super_
>  {
>  	struct ext4_sb_info *sbi = EXT4_SB(sb);
>  	struct ext4_super_block *es = sbi->s_es;
> -	int i;
> +	int i, err;
>  
>  	ext4_mb_release(sb);
>  	ext4_ext_release(sb);
>  	ext4_xattr_put_super(sb);
> -	if (jbd2_journal_destroy(sbi->s_journal) < 0)
> -		ext4_abort(sb, __func__, "Couldn't clean up the journal");
> +	err = jbd2_journal_destroy(sbi->s_journal);
>  	sbi->s_journal = NULL;
> +	if (err < 0)
> +		ext4_abort(sb, __func__, "Couldn't clean up the journal");
> +
>  	if (!(sb->s_flags & MS_RDONLY)) {
>  		EXT4_CLEAR_INCOMPAT_FEATURE(sb, EXT4_FEATURE_INCOMPAT_RECOVER);
>  		es->s_state = cpu_to_le16(sbi->s_mount_state);
> 
-- 
Jan Kara <jack@suse.cz>
SuSE CR Labs
