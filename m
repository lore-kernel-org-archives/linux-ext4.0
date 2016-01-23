From: Matthew Wilcox <willy@linux.intel.com>
Subject: Re: [RFC PATCH] dax, ext2, ext4, XFS: fix data corruption race
Date: Fri, 22 Jan 2016 21:01:02 -0500
Message-ID: <20160123020102.GG2948@linux.intel.com>
References: <1453503971-5319-1-git-send-email-ross.zwisler@linux.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: Theodore Ts'o <tytso@mit.edu>, linux-nvdimm@lists.01.org,
	linux-kernel@vger.kernel.org, xfs@oss.sgi.com,
	Andreas Dilger <adilger.kernel@dilger.ca>,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	Jan Kara <jack@suse.com>, linux-fsdevel@vger.kernel.org,
	Andrew Morton <akpm@linux-foundation.org>, linux-ext4@vger.kernel.org,
	Dan Williams <dan.j.williams@intel.com>
To: Ross Zwisler <ross.zwisler@linux.intel.com>
Return-path: <xfs-bounces@oss.sgi.com>
Content-Disposition: inline
In-Reply-To: <1453503971-5319-1-git-send-email-ross.zwisler@linux.intel.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
List-Id: linux-ext4.vger.kernel.org

On Fri, Jan 22, 2016 at 04:06:11PM -0700, Ross Zwisler wrote:
> +++ b/fs/block_dev.c
> @@ -1733,13 +1733,28 @@ static const struct address_space_operations def_blk_aops = {
>   */
>  static int blkdev_dax_fault(struct vm_area_struct *vma, struct vm_fault *vmf)
>  {
> -	return __dax_fault(vma, vmf, blkdev_get_block, NULL);
> +	int ret;
> +
> +	ret = __dax_fault(vma, vmf, blkdev_get_block, NULL, false);
> +
> +	if (WARN_ON_ONCE(ret == -EAGAIN))
> +		ret = VM_FAULT_SIGBUS;
> +
> +	return ret;
>  }

Let's not mix up -E returns and VM_FAULT returns.  We already have a
perfectly good VM_FAULT return value -- VM_FAULT_RETRY.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
