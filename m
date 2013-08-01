From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 1/3] fs: Introduce new flag FALLOC_FL_COLLAPSE_RANGE
Date: Thu, 1 Aug 2013 10:22:41 +1000
Message-ID: <20130801002241.GH7118@dastard>
References: <1375281721-15840-1-git-send-email-linkinjeon@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: elder@kernel.org, tytso@mit.edu, Namjae Jeon <namjae.jeon@samsung.com>,
	linux-kernel@vger.kernel.org, xfs@oss.sgi.com, hch@infradead.org,
	bpm@sgi.com, adilger.kernel@dilger.ca, a.sangwan@samsung.com,
	linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org
To: Namjae Jeon <linkinjeon@gmail.com>
Return-path: <xfs-bounces@oss.sgi.com>
Content-Disposition: inline
In-Reply-To: <1375281721-15840-1-git-send-email-linkinjeon@gmail.com>
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

On Wed, Jul 31, 2013 at 11:42:00PM +0900, Namjae Jeon wrote:
> From: Namjae Jeon <namjae.jeon@samsung.com>
> 
> Fallocate now supports new FALLOC_FL_COLLAPSE_RANGE flag.
> The semantics of this flag are following:
> 1) It collapses the range lying between offset and length by removing any data
>    blocks which are present in this range and than updates all the logical
>    offsets of extents beyond "offset + len" to nullify the hole created by
>    removing blocks. In short, it does not leave a hole.
> 1) It should be used exclusively. No other fallocate flag in combination.
> 2) Offset and length supplied to fallocate should be fs block size aligned.

Given that the rest of fallocate() interfaces are byte based, this
is going to cause some confusion if it's not well documented. i.e.
this restriction needs to be documented in the header file that is
exposed to userspace, as well as in the fallocate(2) man page.

> 3) It wokrs beyond "EOF", so the extents which are pre-allocated beyond "EOF"
>    are also updated.

I don't think that's valid for this operation. If the range is
beyond EOF, you are not modifying anything visible to userspace, and
that makes it the same as a hole punch operation. So, I'd get rid of
thisnasty implementation complexity altogether.

> 4) It reduces the i_size of inode by the amount of collapse range which lies
>    within i_size. So, if offset >= i_size, i_size won't be changed at all.

Similarly, I don't think that asking for a range that overlaps EOF
is valid, either. The moment you overlap or go beyond EOF, you are
effectively truncating the file as there is no data to collapse into
the range

As it is, I don't see these EOF rules enforced by this patch, nor
are they documented at all in the patch.

Regardless of what semantics we decide on, this needs xfs_io
support and extensive corner case tests added to xfstests so that we
can confirm the implementation in every filesystem is correct and we
don't introduce regressions in future. it also needs documentation
in the fallocate(2) man page.

> diff --git a/include/uapi/linux/falloc.h b/include/uapi/linux/falloc.h
> index 990c4cc..7567c8c 100644
> --- a/include/uapi/linux/falloc.h
> +++ b/include/uapi/linux/falloc.h
> @@ -1,9 +1,10 @@
>  #ifndef _UAPI_FALLOC_H_
>  #define _UAPI_FALLOC_H_
>  
> -#define FALLOC_FL_KEEP_SIZE	0x01 /* default is extend size */
> -#define FALLOC_FL_PUNCH_HOLE	0x02 /* de-allocates range */
> +#define FALLOC_FL_KEEP_SIZE		0x01 /* default is extend size */
> +#define FALLOC_FL_PUNCH_HOLE		0x02 /* de-allocates range */
>  #define FALLOC_FL_NO_HIDE_STALE	0x04 /* reserved codepoint */
> +#define FALLOC_FL_COLLAPSE_RANGE	0x08 /* it does not leave a hole */

I'd suggest that you need to explain what FALLOC_FL_COLLAPSE_RANGE
does in great detail right here.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
