From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH v2 7/7] Documentation: Correct s_umount state for
 freeze_fs/unfreeze_fs
Date: Fri, 6 Jan 2012 01:36:45 +0100
Message-ID: <20120106003645.GE3790@quack.suse.cz>
References: <1323367477-21685-1-git-send-email-kamal@canonical.com>
 <1323367477-21685-8-git-send-email-kamal@canonical.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Jan Kara <jack@suse.cz>, Alexander Viro <viro@zeniv.linux.org.uk>,
	Andreas Dilger <adilger.kernel@dilger.ca>,
	Matthew Wilcox <matthew@wil.cx>,
	Randy Dunlap <rdunlap@xenotime.net>,
	Theodore Tso <tytso@mit.edu>, linux-doc@vger.kernel.org,
	linux-ext4@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	linux-kernel@vger.kernel.org, Surbhi Palande <csurbhi@gmail.com>,
	Valerie Aurora <val@vaaconsulting.com>,
	Christopher Chaltain <christopher.chaltain@canonical.com>,
	"Peter M. Petrakis" <peter.petrakis@canonical.com>,
	Mikulas Patocka <mpatocka@redhat.com>
To: Kamal Mostafa <kamal@canonical.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1323367477-21685-8-git-send-email-kamal@canonical.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Thu 08-12-11 10:04:37, Kamal Mostafa wrote:
> From: Valerie Aurora <val@vaaconsulting.com>
> 
> freeze_fs/unfreeze_fs ops are called with s_umount held for write, not read.
  Looks good. You can add:
Acked-by: Jan Kara <jack@suse.cz>

								Honza
> 
> BugLink: https://bugs.launchpad.net/bugs/897421
> Signed-off-by: Valerie Aurora <val@vaaconsulting.com>
> Cc: Kamal Mostafa <kamal@canonical.com>
> Tested-by: Peter M. Petrakis <peter.petrakis@canonical.com>
> Signed-off-by: Kamal Mostafa <kamal@canonical.com>
> Reviewed-by: Christoph Hellwig <hch@lst.de>
> ---
>  Documentation/filesystems/Locking |    4 ++--
>  1 files changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/Documentation/filesystems/Locking b/Documentation/filesystems/Locking
> index d819ba1..7e46a94 100644
> --- a/Documentation/filesystems/Locking
> +++ b/Documentation/filesystems/Locking
> @@ -134,8 +134,8 @@ evict_inode:
>  put_super:		write
>  write_super:		read
>  sync_fs:		read
> -freeze_fs:		read
> -unfreeze_fs:		read
> +freeze_fs:		write
> +unfreeze_fs:		write
>  statfs:			maybe(read)	(see below)
>  remount_fs:		write
>  umount_begin:		no
> -- 
> 1.7.5.4
> 
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
