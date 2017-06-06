From: Eryu Guan <eguan@redhat.com>
Subject: Re: [xfstests PATCH v3 4/5] ext3: allow it to put journal on a
 separate device when doing scratch_mkfs
Date: Tue, 6 Jun 2017 17:06:22 +0800
Message-ID: <20170606090622.GQ19952@eguan.usersys.redhat.com>
References: <20170531130820.17634-1-jlayton@redhat.com>
 <20170531130820.17634-5-jlayton@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: fstests@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        Al Viro <viro@ZenIV.linux.org.uk>, Jan Kara <jack@suse.cz>,
        tytso@mit.edu, axboe@kernel.dk, mawilcox@microsoft.com,
        ross.zwisler@linux.intel.com, corbet@lwn.net, dhowells@redhat.com,
        linux-ext4@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-block@vger.kernel.org,
        linux-doc@vger.kernel.org
To: Jeff Layton <jlayton@redhat.com>
Return-path: <linux-doc-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20170531130820.17634-5-jlayton@redhat.com>
Sender: linux-doc-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Wed, May 31, 2017 at 09:08:19AM -0400, Jeff Layton wrote:
> Signed-off-by: Jeff Layton <jlayton@redhat.com>
> ---
>  common/rc | 11 ++++++++++-
>  1 file changed, 10 insertions(+), 1 deletion(-)
> 
> diff --git a/common/rc b/common/rc
> index 391d36f373cd..83765aacfb06 100644
> --- a/common/rc
> +++ b/common/rc
> @@ -832,7 +832,16 @@ _scratch_mkfs()
>  		mkfs_cmd="$MKFS_BTRFS_PROG"
>  		mkfs_filter="cat"
>  		;;
> -	ext2|ext3)
> +	ext3)
> +		mkfs_cmd="$MKFS_PROG -t $FSTYP -- -F"
> +		mkfs_filter="grep -v -e ^Warning: -e \"^mke2fs \""
> +
> +		# put journal on separate device?
> +		[ "$USE_EXTERNAL" = yes -a ! -z "$SCRATCH_LOGDEV" ] && \
> +		$mkfs_cmd -O journal_dev $SCRATCH_LOGDEV && \
> +		mkfs_cmd="$mkfs_cmd -J device=$SCRATCH_LOGDEV"

Similar to that ext4 patch, need $MKFS_OPTIONS when creating journal
device.

Thanks,
Eryu

> +		;;
> +	ext2)
>  		mkfs_cmd="$MKFS_PROG -t $FSTYP -- -F"
>  		mkfs_filter="grep -v -e ^Warning: -e \"^mke2fs \""
>  		;;
> -- 
> 2.9.4
> 
> --
> To unsubscribe from this list: send the line "unsubscribe fstests" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
