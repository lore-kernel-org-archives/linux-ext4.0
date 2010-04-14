From: Jan Blunck <jblunck@suse.de>
Subject: Re: [PATCH 5/5] ext2: Add ext2_sb_info s_lock spinlock
Date: Wed, 14 Apr 2010 10:00:19 +0200
Message-ID: <20100414080019.GQ10776@bolzano.suse.de>
References: <1271104905-8804-1-git-send-email-jblunck@suse.de> <1271104905-8804-6-git-send-email-jblunck@suse.de> <o2r3f9a31f41004140010t7c553e39ib51e69fa9022a75f@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Jan Kara <jack@suse.cz>, tytso@mit.edu,
	Linux-Kernel Mailinglist <linux-kernel@vger.kernel.org>,
	linux-ext4@vger.kernel.org,
	Frederic Weisbecker <fweisbec@gmail.com>,
	Arnd Bergmann <arnd@arndb.de>,
	Andi Kleen <andi@firstfloor.org>,
	OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
To: Jaswinder Singh Rajput <jaswinderlinux@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cantor.suse.de ([195.135.220.2]:37891 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753134Ab0DNIAX (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 14 Apr 2010 04:00:23 -0400
Content-Disposition: inline
In-Reply-To: <o2r3f9a31f41004140010t7c553e39ib51e69fa9022a75f@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, Apr 14, Jaswinder Singh Rajput wrote:

> Hello,
>=20
> On Tue, Apr 13, 2010 at 2:11 AM, Jan Blunck <jblunck@suse.de> wrote:
> > Add a spinlock that protects against concurrent modifications of
> > s_mount_state, s_blocks_last, s_overhead_last and the content of th=
e
> > superblock's buffer pointed to by sbi->s_es. This is a preparation =
patch
> > for removing the BKL from ext2 in the next patch.
> >
> > Signed-off-by: Jan Blunck <jblunck@suse.de>
> > Cc: Andi Kleen <andi@firstfloor.org>
> > Cc: Jan Kara <jack@suse.cz>
> > Cc: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
> > ---
> > =A0fs/ext2/inode.c =A0 =A0 =A0 =A0 =A0 =A0| =A0 =A02 ++
> > =A0fs/ext2/super.c =A0 =A0 =A0 =A0 =A0 =A0| =A0 31 ++++++++++++++++=
+++++++++++++--
> > =A0include/linux/ext2_fs_sb.h | =A0 =A06 ++++++
> > =A03 files changed, 37 insertions(+), 2 deletions(-)
> >
> > diff --git a/fs/ext2/inode.c b/fs/ext2/inode.c
> > index fc13cc1..5d15442 100644
> > --- a/fs/ext2/inode.c
> > +++ b/fs/ext2/inode.c
> > @@ -1407,9 +1407,11 @@ static int __ext2_write_inode(struct inode *=
inode, int do_sync)
> > =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0* cr=
eated, add a flag to the superblock.
> > =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0*/
> > =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0lock=
_kernel();
> > + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 spin_=
lock(&EXT2_SB(sb)->s_lock);
> > =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0ext2=
_update_dynamic_rev(sb);
> > =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0EXT2=
_SET_RO_COMPAT_FEATURE(sb,
> > =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0EXT2_FEATURE_RO_COMPAT_LARGE_FILE);
> > + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 spin_=
unlock(&EXT2_SB(sb)->s_lock);
> > =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0unlo=
ck_kernel();
> > =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0ext2=
_write_super(sb);
>=20
> Do we need both locks (kernel lock and spin lock)
>=20

The BKL is removed in a separate patch. First I though it should get me=
rged
through Frederic's tree but since the removal does not depend on the pu=
shdown
from do_new_mount() I guess it is safe to add here.

Thanks,
Jan
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
