From: Jan Kara <jack-AlSwsSmVLrQ@public.gmane.org>
Subject: Re: [PATCH 00/19 v5] Fix filesystem freezing deadlocks
Date: Mon, 16 Apr 2012 18:16:20 +0200
Message-ID: <20120416161620.GC6852@quack.suse.cz>
References: <1334592845-22862-1-git-send-email-jack@suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: dchinner-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>,
	linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Jan Kara <jack-AlSwsSmVLrQ@public.gmane.org>,
	Alex Elder <elder-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>,
	Anton Altaparmakov <anton-yrGDUoBaLx3QT0dZR+AlfA@public.gmane.org>, Ben Myers <bpm-sJ/iWh9BUns@public.gmane.org>,
	Chris Mason <chris.mason-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, cluster-devel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org,
	"David S. Miller" <davem-fT/PcQaiUtIeIZ0/mPfg9Q@public.gmane.org>,
	fuse-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org,
	"J. Bruce Fields" <bfields-uC3wQj2KruNg9hUCZPvPmw@public.gmane.org>,
	Joel Becker <jlbec-aKy9MeLSZ9dg9hUCZPvPmw@public.gmane.org>,
	KONISHI Ryusuke <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>,
	linux-btrfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-ext4-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
	linux-nfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
	linux-ntfs-dev-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org,
	Mark Fasheh <mfasheh-IBi9RG/b67k@public.gmane.org>,
	Miklos Szeredi <miklos-sUDqSbJrdHQHWmgEVkV9KA@public.gmane.org>, ocfs2-devel-N0ozoZBvEnrZJqsBc5GL+g@public.gmane.org,
	OGAWA Hirofumi <hirofumi-UIVanBePwB70ZhReMnHkpc8NsWr+9BEh@public.gmane.org>,
	Steven Whitehouse <swhiteho-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>,
	Theodore Ts'o <tytso-3s7WtUTddSA@public.gmane.org>, xfs-VZNHf3L845pBDgjK7y7TUQ@public.gmane.org
To: Al Viro <viro-3bDd1+5oDREiFSDQTTA3OLVCufUGDwFn@public.gmane.org>
Return-path: <linux-nfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1334592845-22862-1-git-send-email-jack-AlSwsSmVLrQ@public.gmane.org>
Sender: linux-nfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-ext4.vger.kernel.org

  The subject should have been [PATCH 00/27]... Sorry for the mistake.

								Honza

On Mon 16-04-12 18:13:38, Jan Kara wrote:
>   Hello,
> 
>   here is the fifth iteration of my patches to improve filesystem freezing.
> No serious changes since last time. Mostly I rebased patches and merged this
> series with series moving file_update_time() to ->page_mkwrite() to simplify
> testing and merging.
> 
> Filesystem freezing is currently racy and thus we can end up with dirty data on
> frozen filesystem (see changelog patch 13 for detailed race description). This
> patch series aims at fixing this.
> 
> To be able to block all places where inodes get dirtied, I've moved filesystem
> file_update_time() call to ->page_mkwrite callback (patches 01-07) and put
> freeze handling in mnt_want_write() / mnt_drop_write(). That however required
> some code shuffling and changes to kern_path_create() (see patches 09-12). I
> think the result is OK but opinions may differ ;). The advantage of this change
> also is that all filesystems get freeze protection almost for free - even ext2
> can handle freezing well now.
> 
> Another potential contention point might be patch 19. In that patch we make
> freeze_super() refuse to freeze the filesystem when there are open but unlinked
> files which may be impractical in some cases. The main reason for this is the
> problem with handling of file deletion from fput() called with mmap_sem held
> (e.g. from munmap(2)), and then there's the fact that we cannot really force
> such filesystem into a consistent state... But if people think that freezing
> with open but unlinked files should happen, then I have some possible
> solutions in mind (maybe as a separate patchset since this is large enough).
> 
> I'm not able to hit any deadlocks, lockdep warnings, or dirty data on frozen
> filesystem despite beating it with fsstress and bash-shared-mapping while
> freezing and unfreezing for several hours (using ext4 and xfs) so I'm
> reasonably confident this could finally be the right solution.
> 
> Changes since v4:
>   * added a couple of Acked-by's
>   * added some comments & doc update
>   * added patches from series "Push file_update_time() into .page_mkwrite"
>     since it doesn't make much sense to keep them separate anymore
>   * rebased on top of 3.4-rc2
> 
> Changes since v3:
>   * added third level of freezing for fs internal purposes - hooked some
>     filesystems to use it (XFS, nilfs2)
>   * removed racy i_size check from filemap_mkwrite()
> 
> Changes since v2:
>   * completely rewritten
>   * freezing is now blocked at VFS entry points
>   * two stage freezing to handle both mmapped writes and other IO
> 
> The biggest changes since v1:
>   * have two counters to provide safe state transitions for SB_FREEZE_WRITE
>     and SB_FREEZE_TRANS states
>   * use percpu counters instead of own percpu structure
>   * added documentation fixes from the old fs freezing series
>   * converted XFS to use SB_FREEZE_TRANS counter instead of its private
>     m_active_trans counter
> 
> 								Honza
> 
> CC: Alex Elder <elder-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
> CC: Anton Altaparmakov <anton-yrGDUoBaLx3QT0dZR+AlfA@public.gmane.org>
> CC: Ben Myers <bpm-sJ/iWh9BUns@public.gmane.org>
> CC: Chris Mason <chris.mason-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
> CC: cluster-devel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
> CC: "David S. Miller" <davem-fT/PcQaiUtIeIZ0/mPfg9Q@public.gmane.org>
> CC: fuse-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
> CC: "J. Bruce Fields" <bfields-uC3wQj2KruNg9hUCZPvPmw@public.gmane.org>
> CC: Joel Becker <jlbec-aKy9MeLSZ9dg9hUCZPvPmw@public.gmane.org>
> CC: KONISHI Ryusuke <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
> CC: linux-btrfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> CC: linux-ext4-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> CC: linux-nfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> CC: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> CC: linux-ntfs-dev-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
> CC: Mark Fasheh <mfasheh-IBi9RG/b67k@public.gmane.org>
> CC: Miklos Szeredi <miklos-sUDqSbJrdHQHWmgEVkV9KA@public.gmane.org>
> CC: ocfs2-devel-N0ozoZBvEnrZJqsBc5GL+g@public.gmane.org
> CC: OGAWA Hirofumi <hirofumi-UIVanBePwB70ZhReMnHkpc8NsWr+9BEh@public.gmane.org>
> CC: Steven Whitehouse <swhiteho-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> CC: "Theodore Ts'o" <tytso-3s7WtUTddSA@public.gmane.org>
> CC: xfs-VZNHf3L845pBDgjK7y7TUQ@public.gmane.org
-- 
Jan Kara <jack-AlSwsSmVLrQ@public.gmane.org>
SUSE Labs, CR
--
To unsubscribe from this list: send the line "unsubscribe linux-nfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
