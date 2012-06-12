From: Jan Kara <jack-AlSwsSmVLrQ@public.gmane.org>
Subject: [PATCH 00/27 v7] Fix filesystem freezing deadlocks
Date: Tue, 12 Jun 2012 16:20:21 +0200
Message-ID: <1339510848-16992-1-git-send-email-jack@suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: Jan Kara <jack-AlSwsSmVLrQ@public.gmane.org>, "J. Bruce Fields" <bfields-uC3wQj2KruNg9hUCZPvPmw@public.gmane.org>,
	KONISHI Ryusuke <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>,
	linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Miklos Szeredi <miklos-sUDqSbJrdHQHWmgEVkV9KA@public.gmane.org>,
	cluster-devel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, Chris Mason <chris.mason-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>,
	linux-ext4-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, fuse-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org,
	Mark Fasheh <mfasheh-IBi9RG/b67k@public.gmane.org>, linux-fsdevel-AlSwsSmVLrQ@public.gmane.org,
	xfs-VZNHf3L845pBDgjK7y7TUQ@public.gmane.org, Ben Myers <bpm-sJ/iWh9BUns@public.gmane.org>, Joel Becker <jlbec-aKy9MeLSZ9dg9hUCZPvPmw@public.gmane.org>,
	Anton Altaparmakov <anton-yrGDUoBaLx3QT0dZR+AlfA@public.gmane.org>,
	Steven Whitehouse <swhiteho-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>,
	OGAWA Hirofumi <hirofumi-UIVanBePwB70ZhReMnHkpc8NsWr+9BEh@public.gmane.org>,
	linux-nfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Alex Elder <elder-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>,
	Theodore Ts'o <tytso-3s7WtUTddSA@public.gmane.org>, linux-ntfs-dev-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org,
	LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, ocfs2-devel-N0ozoZBvEnrZJqsBc5GL+g@public.gmane.org,
	"David S. Miller" <davem-fT/PcQaiUtIeIZ0/mPfg9Q@public.gmane.org>, linux-btrfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Al Viro <viro-3bDd1+5oDREiFSDQTTA3OLVCufUGDwFn@public.gmane.org>
Return-path: <fuse-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
List-Unsubscribe: <https://lists.sourceforge.net/lists/listinfo/fuse-devel>,
	<mailto:fuse-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum_name=fuse-devel>
List-Post: <mailto:fuse-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
List-Help: <mailto:fuse-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/fuse-devel>,
	<mailto:fuse-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=subscribe>
Errors-To: fuse-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
List-Id: linux-ext4.vger.kernel.org

  Hello,

  here is the seventh iteration of my patches to improve filesystem freezing.
I've rebased patches on top of 3.5-rc2 as Al requested. Otherwise I've just
fixed some outdated text in the introduction below and added one ack.

Introductory text to first time readers:

Filesystem freezing is currently racy and thus we can end up with dirty data on
frozen filesystem (see changelog patch 13 for detailed race description). This
patch series aims at fixing this.

To be able to block all places where inodes get dirtied, I've moved filesystem
file_update_time() call to ->page_mkwrite callback (patches 01-07) and put
freeze handling in mnt_want_write() / mnt_drop_write(). That however required
some code shuffling and changes to kern_path_create() (see patches 09-12). I
think the result is OK but opinions may differ ;). The advantage of this change
also is that all filesystems get freeze protection almost for free - even ext2
can handle freezing well now.

I'm not able to hit any deadlocks, lockdep warnings, or dirty data on frozen
filesystem despite beating it with fsstress, bash-shared-mapping, and
aio-stress while freezing and unfreezing for several hours (using ext4 and xfs)
so I'm reasonably confident this could finally be the right solution.

Changes since v6:
  * rebased on 3.5-rc2
  * added ack

Changes since v5:
  * handle unlinked & open files on frozen filesystem
  * lockdep keys for freeze protection are now per filesystem type
  * taught lockdep that freeze protection at lower level does not create
    dependency when we already hold freeze protection at higher level 
  * rebased on 3.5-rc1-ish

Changes since v4:
  * added a couple of Acked-by's
  * added some comments & doc update
  * added patches from series "Push file_update_time() into .page_mkwrite"
    since it doesn't make much sense to keep them separate anymore
  * rebased on top of 3.4-rc2

Changes since v3:
  * added third level of freezing for fs internal purposes - hooked some
    filesystems to use it (XFS, nilfs2)
  * removed racy i_size check from filemap_mkwrite()

Changes since v2:
  * completely rewritten
  * freezing is now blocked at VFS entry points
  * two stage freezing to handle both mmapped writes and other IO

The biggest changes since v1:
  * have two counters to provide safe state transitions for SB_FREEZE_WRITE
    and SB_FREEZE_TRANS states
  * use percpu counters instead of own percpu structure
  * added documentation fixes from the old fs freezing series
  * converted XFS to use SB_FREEZE_TRANS counter instead of its private
    m_active_trans counter

								Honza

CC: Alex Elder <elder-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
CC: Anton Altaparmakov <anton-yrGDUoBaLx3QT0dZR+AlfA@public.gmane.org>
CC: Ben Myers <bpm-sJ/iWh9BUns@public.gmane.org>
CC: Chris Mason <chris.mason-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
CC: cluster-devel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
CC: "David S. Miller" <davem-fT/PcQaiUtIeIZ0/mPfg9Q@public.gmane.org>
CC: fuse-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
CC: "J. Bruce Fields" <bfields-uC3wQj2KruNg9hUCZPvPmw@public.gmane.org>
CC: Joel Becker <jlbec-aKy9MeLSZ9dg9hUCZPvPmw@public.gmane.org>
CC: KONISHI Ryusuke <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
CC: linux-btrfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
CC: linux-ext4-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
CC: linux-nfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
CC: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
CC: linux-ntfs-dev-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
CC: Mark Fasheh <mfasheh-IBi9RG/b67k@public.gmane.org>
CC: Miklos Szeredi <miklos-sUDqSbJrdHQHWmgEVkV9KA@public.gmane.org>
CC: ocfs2-devel-N0ozoZBvEnrZJqsBc5GL+g@public.gmane.org
CC: OGAWA Hirofumi <hirofumi-UIVanBePwB70ZhReMnHkpc8NsWr+9BEh@public.gmane.org>
CC: Steven Whitehouse <swhiteho-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
CC: "Theodore Ts'o" <tytso-3s7WtUTddSA@public.gmane.org>
CC: xfs-VZNHf3L845pBDgjK7y7TUQ@public.gmane.org

------------------------------------------------------------------------------
Live Security Virtual Conference
Exclusive live event will cover all the ways today's security and 
threat landscape has changed and how IT managers can respond. Discussions 
will include endpoint security, mobile security and the latest in malware 
threats. http://www.accelacomm.com/jaw/sfrnl04242012/114/50122263/
