From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: [PATCH] Rearrange i_flags to be consistent with FS_IOC_GETFLAGS
Date: Mon, 05 Jul 2010 10:54:07 -0500
Message-ID: <4C32001F.8060906@redhat.com>
References: <20100705154319.31193.56706.stgit@warthog.procyon.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Cc: viro@ZenIV.linux.org.uk, linux-fsdevel@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-ext4@vger.kernel.org
To: David Howells <dhowells@redhat.com>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <20100705154319.31193.56706.stgit@warthog.procyon.org.uk>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

David Howells wrote:
> Rearrange the constituent bits of i_flags to be consistent with the flag values
> returned by the FS_IOC_GETFLAGS ioctl where flags with common meanings occur.
> Otherwise pack the bits of i_flags as low as possible so that RISC CPUs can
> use small instructions.
> 
> This allows those filesystems that use i_flags (Ext2/3/4) to simplify their
> get/set flags routines.
> 
> Signed-off-by: David Howells <dhowells@redhat.com>

Seems like a good idea to me, although:

> diff --git a/fs/ext2/inode.c b/fs/ext2/inode.c
> index 3675088..da5fd2d 100644
> --- a/fs/ext2/inode.c
> +++ b/fs/ext2/inode.c
> @@ -1259,38 +1259,17 @@ Egdp:
>  
>  void ext2_set_inode_flags(struct inode *inode)
>  {
> -	unsigned int flags = EXT2_I(inode)->i_flags;
> -
> -	inode->i_flags &= ~(S_SYNC|S_APPEND|S_IMMUTABLE|S_NOATIME|S_DIRSYNC);
> -	if (flags & EXT2_SYNC_FL)
> -		inode->i_flags |= S_SYNC;
> -	if (flags & EXT2_APPEND_FL)
> -		inode->i_flags |= S_APPEND;
> -	if (flags & EXT2_IMMUTABLE_FL)
> -		inode->i_flags |= S_IMMUTABLE;
> -	if (flags & EXT2_NOATIME_FL)
> -		inode->i_flags |= S_NOATIME;
> -	if (flags & EXT2_DIRSYNC_FL)
> -		inode->i_flags |= S_DIRSYNC;

Maybe a stern comment should be here about the relationship between
this and the flag definitions...

> +	unsigned int flags = EXT2_I(inode)->i_flags & S_FS_IOC_FLAGS;
> +
> +	inode->i_flags = (inode->i_flags & ~S_FS_IOC_FLAGS) | flags;
>  }
>  

...

> diff --git a/include/linux/fs.h b/include/linux/fs.h
> index 48616db..5808b9b 100644
> --- a/include/linux/fs.h
> +++ b/include/linux/fs.h

...

> +/*
> + * Inode flags - they have no relation to superblock flags now
> + *
> + * Where applicable, flags that are also in FS_IOC_GETFLAGS have the same bit
> + * position
> + */

... a stern comment here about not re-ordering since other fs/*/* code depends
strongly on this order?

"where applicable" sounds like a wish, but now these can't be changed, right?

If somebody rearranges these bad things will happen.

-Eric

> +#define S_DEAD		0x00000001	/* removed, but still open directory */
> +#define S_NOQUOTA	0x00000002	/* Inode is not counted to quota */
> +#define S_NOCMTIME	0x00000004	/* Do not update file c/mtime */
> +#define S_SYNC		0x00000008	/* [FS_SYNC_FL] Writes are synced at once */
> +#define S_IMMUTABLE	0x00000010	/* [FS_IMMUTABLE_FL] Immutable file */
> +#define S_APPEND	0x00000020	/* [FS_APPEND_FL] Append-only file */
> +#define S_SWAPFILE	0x00000040	/* Do not truncate: swapon got its bmaps */
> +#define S_NOATIME	0x00000080	/* [FS_NOATIME_FL] Do not update access times */
> +#define S_PRIVATE	0x00000100	/* Inode is fs-internal */
> +#define S_DIRSYNC	0x00010000	/* [FS_DIRSYNC_FL] Directory mods are synchronous */
> +
> +#define S_FS_IOC_FLAGS	0x000100B8	/* the S_xxx flags that are also FS_xxx_FL flags */
