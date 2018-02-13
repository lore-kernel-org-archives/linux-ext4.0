From: Ross Zwisler <ross.zwisler-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Subject: Re: [PATCH v3 2/3] dax: change bdev_dax_supported() to support
 boolean returns
Date: Tue, 13 Feb 2018 13:31:48 -0700
Message-ID: <20180213203148.GB13682@linux.intel.com>
References: <151813659955.15926.8922476613392258086.stgit@djiang5-desk3.ch.intel.com>
 <151813669915.15926.5489252461577531.stgit@djiang5-desk3.ch.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: linux-nvdimm-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org, darrick.wong-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org, david-FqsqvQoI3Ljby3iVrkZq2A@public.gmane.org,
 linux-xfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-ext4-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Dave Jiang <dave.jiang-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Return-path: <linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <151813669915.15926.5489252461577531.stgit-Cxk7aZI4ujnJARH06PadV2t3HXsI98Cx0E9HWUfgJXw@public.gmane.org>
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

On Thu, Feb 08, 2018 at 05:38:19PM -0700, Dave Jiang wrote:
> The function return values are confusing with the way the function is
> named. We expect a true or false return value but it actually returns
> 0/-errno.  This makes the code very confusing. Changing the return values
> to return a bool where if DAX is supported then return true and no DAX
> support returns false.
> 
> Signed-off-by: Dave Jiang <dave.jiang-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> ---

> diff --git a/fs/ext2/super.c b/fs/ext2/super.c
> index 655699321c45..636b9c5e1bff 100644
> --- a/fs/ext2/super.c
> +++ b/fs/ext2/super.c
> @@ -958,9 +958,10 @@ static int ext2_fill_super(struct super_block *sb, void *data, int silent)
>  	blocksize = BLOCK_SIZE << le32_to_cpu(sbi->s_es->s_log_block_size);
>  
>  	if (sbi->s_mount_opt & EXT2_MOUNT_DAX) {
> -		err = sb_dax_supported(sb, blocksize);
> -		if (err)
> +		if(!sb_dax_supported(sb, blocksize)) {
> +			err = -EIO;

No need to set 'err' here.  This is just a temporary variable used for some
local checks later in the function.  'ret' is the value that will be returned,
and that is already initialized to -EINVAL which should be fine.

>  			goto failed_mount;
> +		}
>  	}
>  
>  	/* If the blocksize doesn't match, re-read the thing.. */
> diff --git a/fs/ext4/super.c b/fs/ext4/super.c
> index 804a2d6729af..7b7650ac9c53 100644
> --- a/fs/ext4/super.c
> +++ b/fs/ext4/super.c
> @@ -3712,9 +3712,10 @@ static int ext4_fill_super(struct super_block *sb, void *data, int silent)
>  					" that may contain inline data");
>  			goto failed_mount;
>  		}
> -		err = sb_dax_supported(sb, blocksize);
> -		if (err)
> +		if (!sb_dax_supported(sb, blocksize)) {
> +			err = -EIO;

Same comment as with the ext2 case - no need to set 'err', 'ret' is -EINVAL
and has you covered.
