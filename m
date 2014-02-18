From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 4/6] fs: Introduce FALLOC_FL_ZERO_RANGE flag for fallocate
Date: Tue, 18 Feb 2014 13:51:12 +1100
Message-ID: <20140218025112.GH13997@dastard>
References: <1392649703-10772-1-git-send-email-lczerner@redhat.com>
	<1392649703-10772-5-git-send-email-lczerner@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org, tytso@mit.edu,
	xfs@oss.sgi.com
To: Lukas Czerner <lczerner@redhat.com>
Return-path: <xfs-bounces@oss.sgi.com>
Content-Disposition: inline
In-Reply-To: <1392649703-10772-5-git-send-email-lczerner@redhat.com>
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

On Mon, Feb 17, 2014 at 04:08:21PM +0100, Lukas Czerner wrote:
> Introduce new FALLOC_FL_ZERO_RANGE flag for fallocate. This has the same
> functionality as xfs ioctl XFS_IOC_ZERO_RANGE.
> 
> It can be used to convert a range of file to zeros preferably without
> issuing data IO. Blocks should be preallocated for the regions that span
> holes in the file, and the entire range is preferable converted to
> unwritten extents - even though file system may choose to zero out the
> extent or do whatever which will result in reading zeros from the range
> while the range remains allocated for the file.
> 
> This can be also used to preallocate blocks past EOF in the same way as
> with fallocate. Flag FALLOC_FL_KEEP_SIZE which should cause the inode
> size to remain the same.
> 
> Signed-off-by: Lukas Czerner <lczerner@redhat.com>
> ---
>  fs/open.c                   | 7 ++++++-
>  include/uapi/linux/falloc.h | 1 +
>  2 files changed, 7 insertions(+), 1 deletion(-)
> 
> diff --git a/fs/open.c b/fs/open.c
> index 4b3e1ed..6dc46c1 100644
> --- a/fs/open.c
> +++ b/fs/open.c
> @@ -231,7 +231,12 @@ int do_fallocate(struct file *file, int mode, loff_t offset, loff_t len)
>  		return -EINVAL;
>  
>  	/* Return error if mode is not supported */
> -	if (mode & ~(FALLOC_FL_KEEP_SIZE | FALLOC_FL_PUNCH_HOLE))
> +	if (mode & ~(FALLOC_FL_KEEP_SIZE | FALLOC_FL_PUNCH_HOLE |
> +		     FALLOC_FL_ZERO_RANGE))
> +		return -EOPNOTSUPP;
> +
> +	/* Punch hole and zero range are mutually exclusive */
> +	if (mode & FALLOC_FL_PUNCH_HOLE && mode & FALLOC_FL_ZERO_RANGE)

I would have expected gcc to throw a warning on this. Even if it
doesn't, it's so easy to mix up & an && and & it needs parenthesis
around it to make it obvious what you actually meant and it doesn't
have a && where an & should be or vice versa.  Better, IMO, is this:

	/* Punch hole and zero range are mutually exclusive */
	if ((mode & (FALLOC_FL_PUNCH_HOLE | FALLOC_FL_ZERO_RANGE)) ==
		    (FALLOC_FL_PUNCH_HOLE | FALLOC_FL_ZERO_RANGE))
		return -EOPNOTSUPP;

because it's obvious what the intent is and easy to spot typos.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
