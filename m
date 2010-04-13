From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH 5/5] ext2: Add ext2_sb_info s_lock spinlock
Date: Tue, 13 Apr 2010 21:09:49 +0200
Message-ID: <20100413190948.GC3250@quack.wifi.zluty.cz>
References: <1271104905-8804-1-git-send-email-jblunck@suse.de>
 <1271104905-8804-6-git-send-email-jblunck@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Jan Kara <jack@suse.cz>, tytso@mit.edu,
	Linux-Kernel Mailinglist <linux-kernel@vger.kernel.org>,
	linux-ext4@vger.kernel.org,
	Frederic Weisbecker <fweisbec@gmail.com>,
	Arnd Bergmann <arnd@arndb.de>,
	Andi Kleen <andi@firstfloor.org>,
	OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
To: Jan Blunck <jblunck@suse.de>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cantor.suse.de ([195.135.220.2]:35813 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753553Ab0DNG5T (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 14 Apr 2010 02:57:19 -0400
Content-Disposition: inline
In-Reply-To: <1271104905-8804-6-git-send-email-jblunck@suse.de>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon 12-04-10 22:41:45, Jan Blunck wrote:
> Add a spinlock that protects against concurrent modifications of
> s_mount_state, s_blocks_last, s_overhead_last and the content of the
> superblock's buffer pointed to by sbi->s_es. This is a preparation patch
> for removing the BKL from ext2 in the next patch.
> 
> Signed-off-by: Jan Blunck <jblunck@suse.de>
> Cc: Andi Kleen <andi@firstfloor.org>
> Cc: Jan Kara <jack@suse.cz>
> Cc: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
> ---
>  fs/ext2/inode.c            |    2 ++
>  fs/ext2/super.c            |   31 +++++++++++++++++++++++++++++--
>  include/linux/ext2_fs_sb.h |    6 ++++++
>  3 files changed, 37 insertions(+), 2 deletions(-)
> 
>diff --git a/fs/ext2/inode.c b/fs/ext2/inode.c
>index fc13cc1..5d15442 100644
>--- a/fs/ext2/inode.c
>+++ b/fs/ext2/inode.c
>@@ -1407,9 +1407,11 @@ static int __ext2_write_inode(struct inode *inode, int do_sync)
>                               * created, add a flag to the superblock.
>                               */
>                               lock_kernel();
>+                              spin_lock(&EXT2_SB(sb)->s_lock);
>                               ext2_update_dynamic_rev(sb);
>                               EXT2_SET_RO_COMPAT_FEATURE(sb,
>                                       EXT2_FEATURE_RO_COMPAT_LARGE_FILE);
>+                              spin_unlock(&EXT2_SB(sb)->s_lock);
>                               unlock_kernel();
>                               ext2_write_super(sb);
>                       }
  Looking at this - probably we should protect by this lock also setting of
a feature in ext2_xattr_update_super_block(). It's an unrelated bugfix but
when we are already doing the bugfixing & cleanups in this area...

> diff --git a/fs/ext2/super.c b/fs/ext2/super.c
> index b01c491..34d7a62 100644
> --- a/fs/ext2/super.c
> +++ b/fs/ext2/super.c
> @@ -209,6 +216,7 @@ static int ext2_show_options(struct seq_file *seq, struct vfsmount *vfs)
>  	struct ext2_super_block *es = sbi->s_es;
>  	unsigned long def_mount_opts;
>  
> +	spin_lock(&sbi->s_lock);
>  	def_mount_opts = le32_to_cpu(es->s_default_mount_opts);
>  
>  	if (sbi->s_sb_block != 1)
> @@ -281,6 +289,7 @@ static int ext2_show_options(struct seq_file *seq, struct vfsmount *vfs)
>  	if (!test_opt(sb, RESERVATION))
>  		seq_puts(seq, ",noreservation");
>  
> +	spin_unlock(&sbi->s_lock);
>  	return 0;
>  }
  Why exactly do you have in the above? Probably because of consistent
view of mount options? You should comment about that in the changelo and
especially at the lock declaration in ext2_fs.h.

> @@ -1158,19 +1173,22 @@ static void ext2_sync_super(struct super_block *sb, struct ext2_super_block *es)
>   * may have been checked while mounted and e2fsck may have
>   * set s_state to EXT2_VALID_FS after some corrections.
>   */
> -
>  static int ext2_sync_fs(struct super_block *sb, int wait)
>  {
> +	struct ext2_sb_info *sbi = EXT2_SB(sb);
>  	struct ext2_super_block *es = EXT2_SB(sb)->s_es;
>  	struct buffer_head *sbh = EXT2_SB(sb)->s_sbh;
>  
>  	lock_kernel();
> +	spin_lock(&sbi->s_lock);
>  	if (es->s_state & cpu_to_le16(EXT2_VALID_FS)) {
>  		ext2_debug("setting valid to 0\n");
>  		es->s_state &= cpu_to_le16(~EXT2_VALID_FS);
> +		spin_unlock(&sbi->s_lock);
>  		ext2_sync_super(sb, es);
>  	} else {
>  		ext2_commit_super(sb, es);
> +		spin_unlock(&sbi->s_lock);
  Could you please fold in ext2_commit_super? It's used only here and it's
name looks a bit scary to be called under the spinlock...

									Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
