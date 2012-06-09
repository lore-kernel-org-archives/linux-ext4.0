From: Al Viro <viro-3bDd1+5oDREiFSDQTTA3OLVCufUGDwFn@public.gmane.org>
Subject: Re: [PATCH 00/27 v6] Fix filesystem freezing deadlocks
Date: Sat, 9 Jun 2012 07:29:52 +0100
Message-ID: <20120609062952.GY30000@ZenIV.linux.org.uk>
References: <1338589841-9568-1-git-send-email-jack@suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, dchinner-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org,
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
To: Jan Kara <jack-AlSwsSmVLrQ@public.gmane.org>
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1338589841-9568-1-git-send-email-jack-AlSwsSmVLrQ@public.gmane.org>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-ext4.vger.kernel.org

On Sat, Jun 02, 2012 at 12:30:14AM +0200, Jan Kara wrote:
>   Hello,
> 
>   here is the sixth iteration of my patches to improve filesystem freezing.
> The change since last iteration is that filesystem can be frozen with open but
> unlinked files. After some thinking, I've decided that the best way to handle
> this is to block removal inside ->evict_inode() of each filesystem and use
> fs-internal level of freeze protection for that (usually I've instrumented
> filesystem's transaction system to use freeze protection). Handling
> inside VFS would be less work but the only level of freeze protection that
> has a chance of not causing deadlocks is the one used for page faults and even
> there it's not clear lock ordering would be correct wrt some fs-specific locks.
> I've converted ext2, ext4, btrfs, xfs, nilfs2, ocfs2, gfs2 and also checked
> that ext3, reiserfs, jfs should work as well (they have their internal freeze
> protection mechanisms, possibly they could be replaced by a generic one but
> given these are mostly aging filesystems, it's not a real priority IHMO).
> So finally I'm not aware of any pending issue with this patch set so if you
> have some concern, please speak up!

Could you rebase on top of e.g. -rc2 and repost?
--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
