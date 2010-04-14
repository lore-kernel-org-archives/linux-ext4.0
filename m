From: Jaswinder Singh Rajput <jaswinderlinux@gmail.com>
Subject: Re: [PATCH 5/5] ext2: Add ext2_sb_info s_lock spinlock
Date: Wed, 14 Apr 2010 12:40:28 +0530
Message-ID: <o2r3f9a31f41004140010t7c553e39ib51e69fa9022a75f@mail.gmail.com>
References: <1271104905-8804-1-git-send-email-jblunck@suse.de>
	 <1271104905-8804-6-git-send-email-jblunck@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Jan Kara <jack@suse.cz>, tytso@mit.edu,
	Linux-Kernel Mailinglist <linux-kernel@vger.kernel.org>,
	linux-ext4@vger.kernel.org,
	Frederic Weisbecker <fweisbec@gmail.com>,
	Arnd Bergmann <arnd@arndb.de>,
	Andi Kleen <andi@firstfloor.org>,
	OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
To: Jan Blunck <jblunck@suse.de>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-yw0-f198.google.com ([209.85.211.198]:35459 "EHLO
	mail-yw0-f198.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750939Ab0DNHK3 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 14 Apr 2010 03:10:29 -0400
In-Reply-To: <1271104905-8804-6-git-send-email-jblunck@suse.de>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hello,

On Tue, Apr 13, 2010 at 2:11 AM, Jan Blunck <jblunck@suse.de> wrote:
> Add a spinlock that protects against concurrent modifications of
> s_mount_state, s_blocks_last, s_overhead_last and the content of the
> superblock's buffer pointed to by sbi->s_es. This is a preparation pa=
tch
> for removing the BKL from ext2 in the next patch.
>
> Signed-off-by: Jan Blunck <jblunck@suse.de>
> Cc: Andi Kleen <andi@firstfloor.org>
> Cc: Jan Kara <jack@suse.cz>
> Cc: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
> ---
> =A0fs/ext2/inode.c =A0 =A0 =A0 =A0 =A0 =A0| =A0 =A02 ++
> =A0fs/ext2/super.c =A0 =A0 =A0 =A0 =A0 =A0| =A0 31 ++++++++++++++++++=
+++++++++++--
> =A0include/linux/ext2_fs_sb.h | =A0 =A06 ++++++
> =A03 files changed, 37 insertions(+), 2 deletions(-)
>
> diff --git a/fs/ext2/inode.c b/fs/ext2/inode.c
> index fc13cc1..5d15442 100644
> --- a/fs/ext2/inode.c
> +++ b/fs/ext2/inode.c
> @@ -1407,9 +1407,11 @@ static int __ext2_write_inode(struct inode *in=
ode, int do_sync)
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0* crea=
ted, add a flag to the superblock.
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0*/
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0lock_k=
ernel();
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 spin_lo=
ck(&EXT2_SB(sb)->s_lock);
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0ext2_u=
pdate_dynamic_rev(sb);
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0EXT2_S=
ET_RO_COMPAT_FEATURE(sb,
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0EXT2_FEATURE_RO_COMPAT_LARGE_FILE);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 spin_un=
lock(&EXT2_SB(sb)->s_lock);
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0unlock=
_kernel();
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0ext2_w=
rite_super(sb);

Do we need both locks (kernel lock and spin lock)

Thanks,
--
JSR
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
