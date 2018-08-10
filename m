From: Eric Sandeen <esandeen-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v2 2/2] [PATCH] xfs: Close race between direct IO and
 xfs_break_layouts()
Date: Fri, 10 Aug 2018 13:31:57 -0500
Message-ID: <be8603ab-ccb2-3f0d-4dbf-7935fc3ed357@redhat.com>
References: <153374942137.42241.10539674028265137668.stgit@djiang5-desk3.ch.intel.com>
Reply-To: sandeen-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: linux-nvdimm-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org, david-FqsqvQoI3Ljby3iVrkZq2A@public.gmane.org, linux-xfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
 linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, lczerner-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-ext4-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
 hch-jcswGhMUV9g@public.gmane.org
To: Dave Jiang <dave.jiang-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, tytso-3s7WtUTddSA@public.gmane.org,
 darrick.wong-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org, jack-AlSwsSmVLrQ@public.gmane.org, zwisler-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
Return-path: <linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
In-Reply-To: <153374942137.42241.10539674028265137668.stgit-Cxk7aZI4ujnJARH06PadV2t3HXsI98Cx0E9HWUfgJXw@public.gmane.org>
Content-Language: en-US
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

On 8/8/18 12:31 PM, Dave Jiang wrote:
> This patch is the duplicate of ross's fix for ext4 for xfs.
> 
> If the refcount of a page is lowered between the time that it is returned
> by dax_busy_page() and when the refcount is again checked in
> xfs_break_layouts() => ___wait_var_event(), the waiting function
> xfs_wait_dax_page() will never be called.  This means that
> xfs_break_layouts() will still have 'retry' set to false, so we'll stop
> looping and never check the refcount of other pages in this inode.
> 
> Instead, always continue looping as long as dax_layout_busy_page() gives us
> a page which it found with an elevated refcount.

Hi Dave, does this have a testcase?  Have you seen the issue using Ross's
xfstest generic/503 or is there some other test?  Apologies if I missed
prior discussion on a testcase or race frequency...

Thanks,
-Eric

> Signed-off-by: Dave Jiang <dave.jiang-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> Reviewed-by: Jan Kara <jack-AlSwsSmVLrQ@public.gmane.org>
> ---
> 
> Sorry resend, forgot to add Jan's reviewed-by.
> 
> v2:
> - Rename parameter from did_unlock to retry (Jan)
> 
>  fs/xfs/xfs_file.c |    9 ++++-----
>  1 file changed, 4 insertions(+), 5 deletions(-)
> 
> diff --git a/fs/xfs/xfs_file.c b/fs/xfs/xfs_file.c
> index a3e7767a5715..cd6f0d8c4922 100644
> --- a/fs/xfs/xfs_file.c
> +++ b/fs/xfs/xfs_file.c
> @@ -721,12 +721,10 @@ xfs_file_write_iter(
>  
>  static void
>  xfs_wait_dax_page(
> -	struct inode		*inode,
> -	bool			*did_unlock)
> +	struct inode		*inode)
>  {
>  	struct xfs_inode        *ip = XFS_I(inode);
>  
> -	*did_unlock = true;
>  	xfs_iunlock(ip, XFS_MMAPLOCK_EXCL);
>  	schedule();
>  	xfs_ilock(ip, XFS_MMAPLOCK_EXCL);
> @@ -736,7 +734,7 @@ static int
>  xfs_break_dax_layouts(
>  	struct inode		*inode,
>  	uint			iolock,
> -	bool			*did_unlock)
> +	bool			*retry)
>  {
>  	struct page		*page;
>  
> @@ -746,9 +744,10 @@ xfs_break_dax_layouts(
>  	if (!page)
>  		return 0;
>  
> +	*retry = true;
>  	return ___wait_var_event(&page->_refcount,
>  			atomic_read(&page->_refcount) == 1, TASK_INTERRUPTIBLE,
> -			0, 0, xfs_wait_dax_page(inode, did_unlock));
> +			0, 0, xfs_wait_dax_page(inode));
>  }
>  
>  int
> 
