From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH 09/32] ext4: extended attribute value size limit is
 enforced by vfs
Date: Thu, 22 Jun 2017 11:02:43 -0700
Message-ID: <20170622180243.GC4728@birch.djwong.org>
References: <20170621212142.16581-1-tahsin@google.com>
 <20170621212142.16581-9-tahsin@google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Andreas Dilger <adilger@dilger.ca>, Jan Kara <jack@suse.cz>,
        "Theodore Ts'o" <tytso@mit.edu>, linux-ext4@vger.kernel.org,
        linux-kernel@vger.kernel.org
To: Tahsin Erdogan <tahsin@google.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20170621212142.16581-9-tahsin@google.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Wed, Jun 21, 2017 at 02:21:19PM -0700, Tahsin Erdogan wrote:
> EXT4_XATTR_MAX_LARGE_EA_SIZE definition in ext4 is currently unused.
> Besides, vfs enforces its own 64k limit which makes the 1MB limit in
> ext4 redundant. Remove it.

Just FYI I believe the 64k VFS limit exists because XFS is the only fs
to allow large xattr values, and its maximum is 64k (on-disk field size
limitation).

I don't know if anyone actually wants larger values?  Now could be a
time to have such a conversation, if anyone is so interested.

--D

> 
> Signed-off-by: Tahsin Erdogan <tahsin@google.com>
> ---
>  fs/ext4/ext4.h | 6 ------
>  1 file changed, 6 deletions(-)
> 
> diff --git a/fs/ext4/ext4.h b/fs/ext4/ext4.h
> index 5d5fc0d0e2bc..2cdd6070e348 100644
> --- a/fs/ext4/ext4.h
> +++ b/fs/ext4/ext4.h
> @@ -2220,12 +2220,6 @@ struct mmpd_data {
>   */
>  #define EXT4_MMP_MAX_CHECK_INTERVAL	300UL
>  
> -/*
> - * Maximum size of xattr attributes for FEATURE_INCOMPAT_EA_INODE 1Mb
> - * This limit is arbitrary, but is reasonable for the xattr API.
> - */
> -#define EXT4_XATTR_MAX_LARGE_EA_SIZE    (1024 * 1024)
> -
>  /*
>   * Function prototypes
>   */
> -- 
> 2.13.1.611.g7e3b11ae1-goog
> 
