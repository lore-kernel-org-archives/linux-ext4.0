From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH v5 2/10] xfs: Add support FALLOC_FL_COLLAPSE_RANGE for
	fallocate
Date: Mon, 24 Feb 2014 08:22:31 +1100
Message-ID: <20140223212231.GD4317@dastard>
References: <1392741475-20063-1-git-send-email-linkinjeon@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: tytso@mit.edu, Namjae Jeon <namjae.jeon@samsung.com>,
	linux-kernel@vger.kernel.org, xfs@oss.sgi.com, bpm@sgi.com,
	adilger.kernel@dilger.ca, mtk.manpages@gmail.com,
	Ashish Sangwan <a.sangwan@samsung.com>, lczerner@redhat.com,
	linux-fsdevel@vger.kernel.org, jack@suse.cz,
	linux-ext4@vger.kernel.org, viro@zeniv.linux.org.uk
To: Namjae Jeon <linkinjeon@gmail.com>
Return-path: <xfs-bounces@oss.sgi.com>
Content-Disposition: inline
In-Reply-To: <1392741475-20063-1-git-send-email-linkinjeon@gmail.com>
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

On Wed, Feb 19, 2014 at 01:37:55AM +0900, Namjae Jeon wrote:
> From: Namjae Jeon <namjae.jeon@samsung.com>
> 
> This patch implements fallocate's FALLOC_FL_COLLAPSE_RANGE for XFS.
> 
> The semantics of this flag are following:
> 1) It collapses the range lying between offset and length by removing any data
>    blocks which are present in this range and than updates all the logical
>    offsets of extents beyond "offset + len" to nullify the hole created by
>    removing blocks. In short, it does not leave a hole.
> 2) It should be used exclusively. No other fallocate flag in combination.
> 3) Offset and length supplied to fallocate should be fs block size aligned
>    in case of xfs and ext4.
> 4) Collaspe range does not work beyond i_size.
> 
> Signed-off-by: Namjae Jeon <namjae.jeon@samsung.com>
> Signed-off-by: Ashish Sangwan <a.sangwan@samsung.com>
.....
> +	while (!error && !done) {
> +		tp = xfs_trans_alloc(mp, XFS_TRANS_DIOSTRAT);
> +		tp->t_flags |= XFS_TRANS_RESERVE;

This probably shouldn't use XFS_TRANS_RESERVE. If we are at ENOSPC,
then the operation simply fails. Yes, we've already punched the
hole, so we shouldn't get ENOSPC here, but I don't think it's worth
dipping into the reserve pool as it has much more important uses...

You don' tneed to resent the entire patch for this - I can remove it
directly myself....

Otherwise it looks good, so consider it

Reviewed-by: Dave Chinner <dchinner@redhat.com>

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
