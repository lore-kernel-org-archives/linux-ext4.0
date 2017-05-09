From: Jan Kara <jack-AlSwsSmVLrQ@public.gmane.org>
Subject: Re: [PATCH v2] block, dax: move "select DAX" from BLOCK to FS_DAX
Date: Tue, 9 May 2017 16:52:52 +0200
Message-ID: <20170509145252.GF21467@quack2.suse.cz>
References: <149433927812.2049.3430917601443895174.stgit@dwillia2-desk3.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: Jens Axboe <axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org>, Theodore Ts'o <tytso-3s7WtUTddSA@public.gmane.org>,
 "Darrick J. Wong" <darrick.wong-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>,
 Matthew Wilcox <mawilcox-0li6OtcxBFHby3iVrkZq2A@public.gmane.org>, linux-xfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
 linux-nvdimm-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org, Geert Uytterhoeven <geert-Td1EMuHUCqxL1ZNQvxDV9g@public.gmane.org>,
 Alexander Viro <viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org>, Jan Kara <jack-IBi9RG/b67k@public.gmane.org>,
 linux-ext4-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Dan Williams <dan.j.williams-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Return-path: <linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <149433927812.2049.3430917601443895174.stgit-p8uTFz9XbKj2zm6wflaqv1nYeNYlB/vhral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Unsubscribe: <https://lists.01.org/mailman/options/linux-nvdimm>,
 <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=unsubscribe>
List-Archive: <http://lists.01.org/pipermail/linux-nvdimm/>
List-Post: <mailto:linux-nvdimm-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
List-Help: <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=help>
List-Subscribe: <https://lists.01.org/mailman/listinfo/linux-nvdimm>,
 <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=subscribe>
Errors-To: linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org
Sender: "Linux-nvdimm" <linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
List-Id: linux-ext4.vger.kernel.org

On Tue 09-05-17 07:17:04, Dan Williams wrote:
> For configurations that do not enable DAX filesystems or drivers, do not
> require the DAX core to be built.
> 
> Given that the 'direct_access' method has been removed from
> 'block_device_operations', we can also go ahead and remove the
> block-related dax helper functions from fs/block_dev.c to
> drivers/dax/super.c. This keeps dax details out of the block layer and
> lets the DAX core be built as a module in the FS_DAX=n case.
> 
> Filesystems need to include dax.h to call bdev_dax_supported().
> 
> Cc: Jan Kara <jack-IBi9RG/b67k@public.gmane.org>
> Cc: linux-xfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> Cc: Jens Axboe <axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org>
> Cc: "Theodore Ts'o" <tytso-3s7WtUTddSA@public.gmane.org>
> Cc: Matthew Wilcox <mawilcox-0li6OtcxBFHby3iVrkZq2A@public.gmane.org>
> Cc: Alexander Viro <viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org>
> Cc: "Darrick J. Wong" <darrick.wong-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
> Cc: Ross Zwisler <ross.zwisler-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
> Reported-by: Geert Uytterhoeven <geert-Td1EMuHUCqxL1ZNQvxDV9g@public.gmane.org>
> Signed-off-by: Dan Williams <dan.j.williams-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

Looks good to me. You can add:

Reviewed-by: Jan Kara <jack-AlSwsSmVLrQ@public.gmane.org>

								Honza

> ---
> Changes in v2:
> * kill off the remainder of the dax specific routines in the block layer
>   and move it to the drivers/dax core.
> 
>  block/Kconfig          |    1 -
>  drivers/dax/super.c    |   70 ++++++++++++++++++++++++++++++++++++++++++++++++
>  fs/Kconfig             |    1 +
>  fs/block_dev.c         |   66 ---------------------------------------------
>  fs/ext2/super.c        |    1 +
>  fs/ext4/super.c        |    1 +
>  fs/xfs/xfs_super.c     |    1 +
>  include/linux/blkdev.h |    2 -
>  include/linux/dax.h    |   30 +++++++++++++++++++--
>  9 files changed, 102 insertions(+), 71 deletions(-)
> 
> diff --git a/block/Kconfig b/block/Kconfig
> index 93da7fc3f254..e9f780f815f5 100644
> --- a/block/Kconfig
> +++ b/block/Kconfig
> @@ -6,7 +6,6 @@ menuconfig BLOCK
>         default y
>         select SBITMAP
>         select SRCU
> -       select DAX
>         help
>  	 Provide block layer support for the kernel.
>  
> diff --git a/drivers/dax/super.c b/drivers/dax/super.c
> index 465dcd7317d5..e8998d15f3cd 100644
> --- a/drivers/dax/super.c
> +++ b/drivers/dax/super.c
> @@ -14,6 +14,7 @@
>  #include <linux/module.h>
>  #include <linux/mount.h>
>  #include <linux/magic.h>
> +#include <linux/genhd.h>
>  #include <linux/cdev.h>
>  #include <linux/hash.h>
>  #include <linux/slab.h>
> @@ -47,6 +48,75 @@ void dax_read_unlock(int id)
>  }
>  EXPORT_SYMBOL_GPL(dax_read_unlock);
>  
> +int bdev_dax_pgoff(struct block_device *bdev, sector_t sector, size_t size,
> +		pgoff_t *pgoff)
> +{
> +	phys_addr_t phys_off = (get_start_sect(bdev) + sector) * 512;
> +
> +	if (pgoff)
> +		*pgoff = PHYS_PFN(phys_off);
> +	if (phys_off % PAGE_SIZE || size % PAGE_SIZE)
> +		return -EINVAL;
> +	return 0;
> +}
> +EXPORT_SYMBOL(bdev_dax_pgoff);
> +
> +/**
> + * __bdev_dax_supported() - Check if the device supports dax for filesystem
> + * @sb: The superblock of the device
> + * @blocksize: The block size of the device
> + *
> + * This is a library function for filesystems to check if the block device
> + * can be mounted with dax option.
> + *
> + * Return: negative errno if unsupported, 0 if supported.
> + */
> +int __bdev_dax_supported(struct super_block *sb, int blocksize)
> +{
> +	struct block_device *bdev = sb->s_bdev;
> +	struct dax_device *dax_dev;
> +	pgoff_t pgoff;
> +	int err, id;
> +	void *kaddr;
> +	pfn_t pfn;
> +	long len;
> +
> +	if (blocksize != PAGE_SIZE) {
> +		pr_err("VFS (%s): error: unsupported blocksize for dax\n",
> +				sb->s_id);
> +		return -EINVAL;
> +	}
> +
> +	err = bdev_dax_pgoff(bdev, 0, PAGE_SIZE, &pgoff);
> +	if (err) {
> +		pr_err("VFS (%s): error: unaligned partition for dax\n",
> +				sb->s_id);
> +		return err;
> +	}
> +
> +	dax_dev = dax_get_by_host(bdev->bd_disk->disk_name);
> +	if (!dax_dev) {
> +		pr_err("VFS (%s): error: device does not support dax\n",
> +				sb->s_id);
> +		return -EOPNOTSUPP;
> +	}
> +
> +	id = dax_read_lock();
> +	len = dax_direct_access(dax_dev, pgoff, 1, &kaddr, &pfn);
> +	dax_read_unlock(id);
> +
> +	put_dax(dax_dev);
> +
> +	if (len < 1) {
> +		pr_err("VFS (%s): error: dax access failed (%ld)",
> +				sb->s_id, len);
> +		return len < 0 ? len : -EIO;
> +	}
> +
> +	return 0;
> +}
> +EXPORT_SYMBOL_GPL(__bdev_dax_supported);
> +
>  /**
>   * struct dax_device - anchor object for dax services
>   * @inode: core vfs
> diff --git a/fs/Kconfig b/fs/Kconfig
> index 83eab52fb3f6..b0e42b6a96b9 100644
> --- a/fs/Kconfig
> +++ b/fs/Kconfig
> @@ -39,6 +39,7 @@ config FS_DAX
>  	depends on MMU
>  	depends on !(ARM || MIPS || SPARC)
>  	select FS_IOMAP
> +	select DAX
>  	help
>  	  Direct Access (DAX) can be used on memory-backed block devices.
>  	  If the block device supports DAX and the filesystem supports DAX,
> diff --git a/fs/block_dev.c b/fs/block_dev.c
> index 666367e13711..3096ecd48304 100644
> --- a/fs/block_dev.c
> +++ b/fs/block_dev.c
> @@ -718,72 +718,6 @@ int bdev_write_page(struct block_device *bdev, sector_t sector,
>  }
>  EXPORT_SYMBOL_GPL(bdev_write_page);
>  
> -int bdev_dax_pgoff(struct block_device *bdev, sector_t sector, size_t size,
> -		pgoff_t *pgoff)
> -{
> -	phys_addr_t phys_off = (get_start_sect(bdev) + sector) * 512;
> -
> -	if (pgoff)
> -		*pgoff = PHYS_PFN(phys_off);
> -	if (phys_off % PAGE_SIZE || size % PAGE_SIZE)
> -		return -EINVAL;
> -	return 0;
> -}
> -EXPORT_SYMBOL(bdev_dax_pgoff);
> -
> -/**
> - * bdev_dax_supported() - Check if the device supports dax for filesystem
> - * @sb: The superblock of the device
> - * @blocksize: The block size of the device
> - *
> - * This is a library function for filesystems to check if the block device
> - * can be mounted with dax option.
> - *
> - * Return: negative errno if unsupported, 0 if supported.
> - */
> -int bdev_dax_supported(struct super_block *sb, int blocksize)
> -{
> -	struct block_device *bdev = sb->s_bdev;
> -	struct dax_device *dax_dev;
> -	pgoff_t pgoff;
> -	int err, id;
> -	void *kaddr;
> -	pfn_t pfn;
> -	long len;
> -
> -	if (blocksize != PAGE_SIZE) {
> -		vfs_msg(sb, KERN_ERR, "error: unsupported blocksize for dax");
> -		return -EINVAL;
> -	}
> -
> -	err = bdev_dax_pgoff(bdev, 0, PAGE_SIZE, &pgoff);
> -	if (err) {
> -		vfs_msg(sb, KERN_ERR, "error: unaligned partition for dax");
> -		return err;
> -	}
> -
> -	dax_dev = dax_get_by_host(bdev->bd_disk->disk_name);
> -	if (!dax_dev) {
> -		vfs_msg(sb, KERN_ERR, "error: device does not support dax");
> -		return -EOPNOTSUPP;
> -	}
> -
> -	id = dax_read_lock();
> -	len = dax_direct_access(dax_dev, pgoff, 1, &kaddr, &pfn);
> -	dax_read_unlock(id);
> -
> -	put_dax(dax_dev);
> -
> -	if (len < 1) {
> -		vfs_msg(sb, KERN_ERR,
> -				"error: dax access failed (%ld)", len);
> -		return len < 0 ? len : -EIO;
> -	}
> -
> -	return 0;
> -}
> -EXPORT_SYMBOL_GPL(bdev_dax_supported);
> -
>  /*
>   * pseudo-fs
>   */
> diff --git a/fs/ext2/super.c b/fs/ext2/super.c
> index 9e25a71fe1a2..d07773b81da9 100644
> --- a/fs/ext2/super.c
> +++ b/fs/ext2/super.c
> @@ -32,6 +32,7 @@
>  #include <linux/log2.h>
>  #include <linux/quotaops.h>
>  #include <linux/uaccess.h>
> +#include <linux/dax.h>
>  #include "ext2.h"
>  #include "xattr.h"
>  #include "acl.h"
> diff --git a/fs/ext4/super.c b/fs/ext4/super.c
> index a9448db1cf7e..bf6bb8997124 100644
> --- a/fs/ext4/super.c
> +++ b/fs/ext4/super.c
> @@ -37,6 +37,7 @@
>  #include <linux/ctype.h>
>  #include <linux/log2.h>
>  #include <linux/crc16.h>
> +#include <linux/dax.h>
>  #include <linux/cleancache.h>
>  #include <linux/uaccess.h>
>  
> diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
> index 685c042a120f..f5c58d6dcafb 100644
> --- a/fs/xfs/xfs_super.c
> +++ b/fs/xfs/xfs_super.c
> @@ -52,6 +52,7 @@
>  #include "xfs_reflink.h"
>  
>  #include <linux/namei.h>
> +#include <linux/dax.h>
>  #include <linux/init.h>
>  #include <linux/slab.h>
>  #include <linux/mount.h>
> diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
> index 848f87eb1905..e4d9899755a7 100644
> --- a/include/linux/blkdev.h
> +++ b/include/linux/blkdev.h
> @@ -1940,8 +1940,6 @@ extern int __blkdev_driver_ioctl(struct block_device *, fmode_t, unsigned int,
>  extern int bdev_read_page(struct block_device *, sector_t, struct page *);
>  extern int bdev_write_page(struct block_device *, sector_t, struct page *,
>  						struct writeback_control *);
> -extern int bdev_dax_supported(struct super_block *, int);
> -int bdev_dax_pgoff(struct block_device *, sector_t, size_t, pgoff_t *pgoff);
>  #else /* CONFIG_BLOCK */
>  
>  struct block_device;
> diff --git a/include/linux/dax.h b/include/linux/dax.h
> index d3158e74a59e..7fdf1d710042 100644
> --- a/include/linux/dax.h
> +++ b/include/linux/dax.h
> @@ -18,12 +18,38 @@ struct dax_operations {
>  			void **, pfn_t *);
>  };
>  
> +int bdev_dax_pgoff(struct block_device *, sector_t, size_t, pgoff_t *pgoff);
> +#if IS_ENABLED(CONFIG_FS_DAX)
> +int __bdev_dax_supported(struct super_block *sb, int blocksize);
> +static inline int bdev_dax_supported(struct super_block *sb, int blocksize)
> +{
> +	return __bdev_dax_supported(sb, blocksize);
> +}
> +#else
> +static inline int bdev_dax_supported(struct super_block *sb, int blocksize)
> +{
> +	return -EOPNOTSUPP;
> +}
> +#endif
> +
> +#if IS_ENABLED(CONFIG_DAX)
> +struct dax_device *dax_get_by_host(const char *host);
> +void put_dax(struct dax_device *dax_dev);
> +#else
> +static inline struct dax_device *dax_get_by_host(const char *host)
> +{
> +	return NULL;
> +}
> +
> +static inline void put_dax(struct dax_device *dax_dev)
> +{
> +}
> +#endif
> +
>  int dax_read_lock(void);
>  void dax_read_unlock(int id);
> -struct dax_device *dax_get_by_host(const char *host);
>  struct dax_device *alloc_dax(void *private, const char *host,
>  		const struct dax_operations *ops);
> -void put_dax(struct dax_device *dax_dev);
>  bool dax_alive(struct dax_device *dax_dev);
>  void kill_dax(struct dax_device *dax_dev);
>  void *dax_get_private(struct dax_device *dax_dev);
> 
> 
-- 
Jan Kara <jack-IBi9RG/b67k@public.gmane.org>
SUSE Labs, CR
