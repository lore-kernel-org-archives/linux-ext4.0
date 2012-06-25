From: Fredrick <fjohnber@zoho.com>
Subject: Re: ext4_fallocate
Date: Mon, 25 Jun 2012 12:04:08 -0700
Message-ID: <4FE8B628.3090407@zoho.com>
References: <4FE8086F.4070506@zoho.com> <20120625085159.GA18931@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org, adilger@dilger.ca
To: Zheng Liu <gnehzuil.liu@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from sender1.zohomail.com ([72.5.230.103]:54696 "EHLO
	sender1.zohomail.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751088Ab2FYTES (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 25 Jun 2012 15:04:18 -0400
In-Reply-To: <20120625085159.GA18931@gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 06/25/2012 01:51 AM, Zheng Liu wrote:
> On Sun, Jun 24, 2012 at 11:42:55PM -0700, Fredrick wrote:
>> Hello Ext4 developers,
>>
>> When calling fallocate on ext4 fs, ext4_fallocate does not initialize
>> the extents. The extents are allocated only when they are actually
>> written. This is causing a problem for us. Our programs create many
>> "write only once" files as large as 1G on ext4 very rapidly at times.
>> We thought fallocate would solve the problem. But it didnt.
>> If I change the EXT4_GET_BLOCKS_CREATE_UNINIT_EXT to
>> just EXT4_GET_BLOCKS_CREATE in the ext4_map_blocks in the
>> ext4_fallocate call,
>> the extents get created in fallocate call itself. This is helping us.
>> Now the write throughtput to the disk was close to 98%. When extents
>> were not
>> initialized, our disk throughput were only 70%.
>>
>> Can this change be made to ext4_fallocate?
>
> Hi Fredrick,
>
> I think that this patch maybe can help you. :-)
>
> Actually I want to send a url for you from linux mailing list archive but
> I cannot find it.  After applying this patch, you can call ioctl(2) to
> enable expose_stale_data flag, and then when you call fallocate(2), ext4
> create initialized extents for you.  This patch cannot be merged into
> upstream kernel because it brings a huge security hole.
>
> Regards,
> Zheng
>
> From: Zheng Liu <wenqing.lz@taobao.com>
> Date: Wed, 6 Jun 2012 11:10:57 +0800
> Subject: [RFC][PATCH v2] ext4: add expose_stale_data flag in fallocate
>
> Here is the v2 of FALLOC_FL_NO_HIDE_STALE in fallocate.  Now no new flag is
> added into vfs in order to reduce the impacts and avoid a huge security hole.
> The application cannot call fallocate with a new flag to create an unwritten
> extent.  It needs to call ioctl to enable/disable this feature.  Meanwhile, in
> ioctl, filesystem will check CAP_SYS_RAWIO to ensure that the user has a
> privilege to switch on/off it.  Currently, I only implement it in ext4.
>
> Even though I try to reduce its impact, this feature still brings a security
> hole.  So the application must ensure that it initializes an unwritten extent
> by itself before reading it, and it is used in a limited environment.
>
> v1 -> v2:
> * remove FALLOC_FL_NO_HIDE_STALE flag in vfs
> * add 'i_expose_stale_data' in ext4 to enable/disable it
>
> Signed-off-by: Zheng Liu <wenqing.lz@taobao.com>
> ---
>   fs/ext4/ext4.h    |    5 +++++
>   fs/ext4/extents.c |    6 +++++-
>   fs/ext4/ioctl.c   |   43 +++++++++++++++++++++++++++++++++++++++++++
>   fs/ext4/super.c   |    1 +
>   4 files changed, 54 insertions(+), 1 deletions(-)
>
> diff --git a/fs/ext4/ext4.h b/fs/ext4/ext4.h
> index cfc4e01..61da070 100644
> --- a/fs/ext4/ext4.h
> +++ b/fs/ext4/ext4.h
> @@ -606,6 +606,8 @@ enum {
>   #define EXT4_IOC_ALLOC_DA_BLKS		_IO('f', 12)
>   #define EXT4_IOC_MOVE_EXT		_IOWR('f', 15, struct move_extent)
>   #define EXT4_IOC_RESIZE_FS		_IOW('f', 16, __u64)
> +#define EXT4_IOC_GET_EXPOSE_STALE	_IOR('f', 17, int)
> +#define EXT4_IOC_SET_EXPOSE_STALE	_IOW('f', 18, int)
>
>   #if defined(__KERNEL__) && defined(CONFIG_COMPAT)
>   /*
> @@ -925,6 +927,9 @@ struct ext4_inode_info {
>
>   	/* Precomputed uuid+inum+igen checksum for seeding inode checksums */
>   	__u32 i_csum_seed;
> +
> +	/* expose stale data in creating a new extent */
> +	int i_expose_stale_data;
>   };
>
>   /*
> diff --git a/fs/ext4/extents.c b/fs/ext4/extents.c
> index 91341ec..9ef883c 100644
> --- a/fs/ext4/extents.c
> +++ b/fs/ext4/extents.c
> @@ -4336,6 +4336,7 @@ static void ext4_falloc_update_inode(struct inode *inode,
>   long ext4_fallocate(struct file *file, int mode, loff_t offset, loff_t len)
>   {
>   	struct inode *inode = file->f_path.dentry->d_inode;
> +	struct ext4_inode_info *ei = EXT4_I(inode);
>   	handle_t *handle;
>   	loff_t new_size;
>   	unsigned int max_blocks;
> @@ -4379,7 +4380,10 @@ long ext4_fallocate(struct file *file, int mode, loff_t offset, loff_t len)
>   		trace_ext4_fallocate_exit(inode, offset, max_blocks, ret);
>   		return ret;
>   	}
> -	flags = EXT4_GET_BLOCKS_CREATE_UNINIT_EXT;
> +	if (ei->i_expose_stale_data)
> +		flags = EXT4_GET_BLOCKS_CREATE;
> +	else
> +		flags = EXT4_GET_BLOCKS_CREATE_UNINIT_EXT;
>   	if (mode & FALLOC_FL_KEEP_SIZE)
>   		flags |= EXT4_GET_BLOCKS_KEEP_SIZE;
>   	/*
> diff --git a/fs/ext4/ioctl.c b/fs/ext4/ioctl.c
> index 8ad112a..fffb3eb 100644
> --- a/fs/ext4/ioctl.c
> +++ b/fs/ext4/ioctl.c
> @@ -445,6 +445,47 @@ resizefs_out:
>   		return 0;
>   	}
>
> +	case EXT4_IOC_GET_EXPOSE_STALE: {
> +		int enable;
> +
> +		/* security check */
> +		if (!capable(CAP_SYS_RAWIO))
> +			return -EPERM;
> +
> +		/*
> +		 * currently only extent-based files support (pre)allocate with
> +		 * EXPOSE_STALE_DATA flag
> +		 */
> +		if (!(ext4_test_inode_flag(inode, EXT4_INODE_EXTENTS)))
> +			return -EOPNOTSUPP;
> +
> +		enable = ei->i_expose_stale_data;
> +
> +		return put_user(enable, (int __user *) arg);
> +	}
> +
> +	case EXT4_IOC_SET_EXPOSE_STALE: {
> +		int enable;
> +
> +		/* security check */
> +		if (!capable(CAP_SYS_RAWIO))
> +			return -EPERM;
> +
> +		/*
> +		 * currently only extent-based files support (pre)allocate with
> +		 * EXPOSE_STALE_DATA flag
> +		 */
> +		if (!(ext4_test_inode_flag(inode, EXT4_INODE_EXTENTS)))
> +			return -EOPNOTSUPP;
> +
> +		if (get_user(enable, (int __user *) arg))
> +			return -EFAULT;
> +
> +		ei->i_expose_stale_data = enable;
> +
> +		return 0;
> +	}
> +
>   	default:
>   		return -ENOTTY;
>   	}
> @@ -508,6 +549,8 @@ long ext4_compat_ioctl(struct file *file, unsigned int cmd, unsigned long arg)
>   	case EXT4_IOC_MOVE_EXT:
>   	case FITRIM:
>   	case EXT4_IOC_RESIZE_FS:
> +	case EXT4_IOC_GET_EXPOSE_STALE:
> +	case EXT4_IOC_SET_EXPOSE_STALE:
>   		break;
>   	default:
>   		return -ENOIOCTLCMD;
> diff --git a/fs/ext4/super.c b/fs/ext4/super.c
> index eb7aa3e..3654bb8 100644
> --- a/fs/ext4/super.c
> +++ b/fs/ext4/super.c
> @@ -988,6 +988,7 @@ static struct inode *ext4_alloc_inode(struct super_block *sb)
>   	ei->i_datasync_tid = 0;
>   	atomic_set(&ei->i_ioend_count, 0);
>   	atomic_set(&ei->i_aiodio_unwritten, 0);
> +	ei->i_expose_stale_data = 0;
>
>   	return &ei->vfs_inode;
>   }
>


Thanks Zheng for this nice patch.
Thanks Andreas for the comments.
I had the following patch to do the same.

-Fredrick

diff --git a/fs/ext4/ext4.h b/fs/ext4/ext4.h
index 1a34c1c..7fe835c 100644
--- a/fs/ext4/ext4.h
+++ b/fs/ext4/ext4.h
@@ -549,6 +549,7 @@ struct ext4_new_group_data {
   /* note ioctl 11 reserved for filesystem-independent FIEMAP ioctl */
  #define EXT4_IOC_ALLOC_DA_BLKS		_IO('f', 12)
  #define EXT4_IOC_MOVE_EXT		_IOWR('f', 15, struct move_extent)
+#define EXT4_IOC_INIT_EXT		_IOWR('f', 20, unsigned long)

  #if defined(__KERNEL__) && defined(CONFIG_COMPAT)
  /*
diff --git a/fs/ext4/ioctl.c b/fs/ext4/ioctl.c
index 4cbe1c2..c66555e 100644
--- a/fs/ext4/ioctl.c
+++ b/fs/ext4/ioctl.c
@@ -335,6 +335,57 @@ mext_out:
  		mnt_drop_write(filp->f_path.mnt);
  		return err;
  	}
+	
+	case EXT4_IOC_INIT_EXT:
+	{
+
+		handle_t *handle;
+		unsigned int max_blocks;
+		unsigned int credits;
+		struct ext4_map_blocks map;
+		unsigned int blkbits = inode->i_blkbits;	
+		unsigned long offset = filp->f_pos;
+		unsigned long len = arg;
+		int ret = 0, ret2 = 0;
+
+		if (!(ext4_test_inode_flag(inode, EXT4_INODE_EXTENTS)))
+			return -EOPNOTSUPP;
+
+		mutex_lock(&inode->i_mutex);
+		if ((offset + len)> i_size_read(inode)) {
+			mutex_unlock(&inode->i_mutex);
+			return -EINVAL;
+		}
+		map.m_lblk = offset >> blkbits;
+		max_blocks = ((EXT4_BLOCK_ALIGN(len + offset, blkbits) >> blkbits) -
+			      map.m_lblk);
+
+		credits = ext4_chunk_trans_blocks(inode, max_blocks);
+		while (ret >= 0 && ret < max_blocks) {
+			map.m_lblk += ret;
+			map.m_len = (max_blocks -= ret);
+			handle = ext4_journal_start(inode, credits);
+			if (IS_ERR(handle)) {
+				ret = PTR_ERR(handle);
+				break;
+			}
+			ret = ext4_map_blocks(handle, inode, &map,
+					      EXT4_GET_BLOCKS_CREATE);
+			if (ret <= 0) {
+				WARN_ON(ret <= 0);
+				printk(KERN_ERR "%s: ext4_map_blocks "
+					    "returned error inode#%lu, block=%u, "
+					    "max_blocks=%u", __func__,
+					    inode->i_ino, map.m_lblk, map.m_len);
+			}
+			ext4_mark_inode_dirty(handle, inode);
+			ret2 = ext4_journal_stop(handle);
+			if (ret <= 0 || ret2 )
+				break;
+		}
+		mutex_unlock(&inode->i_mutex);
+		return ret > 0 ? ret2 : ret;
+	}

  	case FITRIM:
  	{
@@ -432,6 +483,7 @@ long ext4_compat_ioctl(struct file *file, unsigned 
int cmd, unsigned long arg)
  		return err;
  	}
  	case EXT4_IOC_MOVE_EXT:
+	case EXT4_IOC_INIT_EXT:
  	case FITRIM:
  		break;
  	default:





