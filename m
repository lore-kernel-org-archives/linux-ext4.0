From: Al Viro <viro-3bDd1+5oDREiFSDQTTA3OLVCufUGDwFn@public.gmane.org>
Subject: Re: [PATCH 2/4] fsfreeze: manage kill signal when sb_start_write is
 called
Date: Sat, 6 Apr 2013 22:50:33 +0100
Message-ID: <20130406215033.GM4068@ZenIV.linux.org.uk>
References: <515FF344.8040705@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Linux FS Devel <linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>,
	Chris Mason <chris.mason-5c4llco8/ftWk0Htik3J/w@public.gmane.org>,
	Steve French <sfrench-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>,
	Theodore Ts'o <tytso-3s7WtUTddSA@public.gmane.org>,
	Andreas Dilger <adilger.kernel-m1MBpc4rdrD3fQ9qLvQP4Q@public.gmane.org>,
	Miklos Szeredi <miklos-sUDqSbJrdHQHWmgEVkV9KA@public.gmane.org>,
	Anton Altaparmakov <anton-yrGDUoBaLx3QT0dZR+AlfA@public.gmane.org>,
	Mark Fasheh <mfasheh-IBi9RG/b67k@public.gmane.org>,
	Joel Becker <jlbec-aKy9MeLSZ9dg9hUCZPvPmw@public.gmane.org>, Ben Myers <bpm-sJ/iWh9BUns@public.gmane.org>,
	Alex Elder <elder-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, xfs-VZNHf3L845pBDgjK7y7TUQ@public.gmane.org,
	Matthew Wilcox <matthew-Ztpu424NOJ8@public.gmane.org>,
	Mike Snitzer <snitzer-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>,
	Alasdair G Kergon <agk-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>,
	linux-btrfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
	linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, samba-technical-w/Ol4Ecudpl8XjKLYN78aQ@public.gmane.org,
	linux-ext4-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, fuse-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org,
	linux-ntfs-dev-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org, ocfs2-devel-N0ozoZBvEnrZJqsBc5GL+g@public.gmane.org,
	linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, Jan Kara <jack-AlSwsSmVLrQ@public.gmane.org>
To: Marco Stornelli <marco.stornelli-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <515FF344.8040705-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-ext4.vger.kernel.org

On Sat, Apr 06, 2013 at 12:04:52PM +0200, Marco Stornelli wrote:
> In every place where sb_start_write was called now we must manage
> the error code and return -EINTR.

Now go and look for callers of mnt_want_write() ;-/  The really
painful one is in do_last(), but kern_path_create() is not much
better; mq_open() would be bad too, had it not been about something
you are not going to freeze anyway...
