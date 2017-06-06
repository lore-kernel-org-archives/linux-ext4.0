From: Eryu Guan <eguan@redhat.com>
Subject: Re: [xfstests PATCH v3 2/5] ext4: allow ext4 to use $SCRATCH_LOGDEV
Date: Tue, 6 Jun 2017 17:01:07 +0800
Message-ID: <20170606090107.GO19952@eguan.usersys.redhat.com>
References: <20170531130820.17634-1-jlayton@redhat.com>
 <20170531130820.17634-3-jlayton@redhat.com>
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
Return-path: <linux-block-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20170531130820.17634-3-jlayton@redhat.com>
Sender: linux-block-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Wed, May 31, 2017 at 09:08:17AM -0400, Jeff Layton wrote:
> The writeback error handling test requires that you put the journal on a
> separate device. This allows us to use dmerror to simulate data
> writeback failure, without affecting the journal.
> 
> xfs already has infrastructure for this (a'la $SCRATCH_LOGDEV), so wire
> up the ext4 code so that it can do the same thing when _scratch_mkfs is
> called.
> 
> Signed-off-by: Jeff Layton <jlayton@redhat.com>
> Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>
> ---
>  common/rc | 3 +++
>  1 file changed, 3 insertions(+)
> 
> diff --git a/common/rc b/common/rc
> index 743df427c047..391d36f373cd 100644
> --- a/common/rc
> +++ b/common/rc
> @@ -676,6 +676,9 @@ _scratch_mkfs_ext4()
>  	local tmp=`mktemp`
>  	local mkfs_status
>  
> +	[ "$USE_EXTERNAL" = yes -a ! -z "$SCRATCH_LOGDEV" ] && \
> +	    $mkfs_cmd -O journal_dev $SCRATCH_LOGDEV && \
> +	    mkfs_cmd="$mkfs_cmd -J device=$SCRATCH_LOGDEV"

Need $MKFS_OPTIONS too when creating journal device, otherwise mkfs will
fail when making non-default block size ext4, i.e. journal device has 4k
block size, but ext4 has 1k block size if we have MKFS_OPTIONS="-b 1024"

Thanks,
Eryu

>  
>  	_scratch_do_mkfs "$mkfs_cmd" "$mkfs_filter" $* 2>$tmp.mkfserr 1>$tmp.mkfsstd
>  	mkfs_status=$?
> -- 
> 2.9.4
> 
> --
> To unsubscribe from this list: send the line "unsubscribe fstests" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
