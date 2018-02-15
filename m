From: Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Subject: Re: [PATCH v4 1/3] fs: allow per-device dax status checking for
 filesystems
Date: Thu, 15 Feb 2018 09:52:41 -0800
Message-ID: <20180215175241.GA25223@infradead.org>
References: <151871644696.27617.4390718895806529377.stgit@djiang5-desk3.ch.intel.com>
 <151871655228.27617.3514495396592472682.stgit@djiang5-desk3.ch.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: linux-nvdimm-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org, darrick.wong-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org, david-FqsqvQoI3Ljby3iVrkZq2A@public.gmane.org,
 linux-xfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-ext4-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Dave Jiang <dave.jiang-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Return-path: <linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <151871655228.27617.3514495396592472682.stgit-Cxk7aZI4ujnJARH06PadV2t3HXsI98Cx0E9HWUfgJXw@public.gmane.org>
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

>  /**
> - * __bdev_dax_supported() - Check if the device supports dax for filesystem
> + * bdev_dax_supported() - Check if the device supports dax for filesystem
>   * @sb: The superblock of the device
> + * @bdev: block device to check
>   * @blocksize: The block size of the device
>   *
>   * This is a library function for filesystems to check if the block device
> @@ -82,9 +83,9 @@ EXPORT_SYMBOL_GPL(fs_dax_get_by_bdev);
>   *
>   * Return: negative errno if unsupported, 0 if supported.
>   */
> -int __bdev_dax_supported(struct super_block *sb, int blocksize)
> +int bdev_dax_supported(struct super_block *sb, struct block_device *bdev,
> +		       int blocksize)
>  {
> -	struct block_device *bdev = sb->s_bdev;
>  	struct dax_device *dax_dev;
>  	pgoff_t pgoff;
>  	int err, id;

This now only uses sb for sb->s_id.  It might be better to use bdevname
to print the device name and don't bother passing a sb at all.
