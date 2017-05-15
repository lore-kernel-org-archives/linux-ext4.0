From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [xfstests PATCH v2 2/3] ext4: allow ext4 to use
	$SCRATCH_LOGDEV
Date: Mon, 15 May 2017 10:42:51 -0700
Message-ID: <20170515174251.GD4514@birch.djwong.org>
References: <20170509161245.29908-1-jlayton@redhat.com>
	<20170509161245.29908-3-jlayton@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: jfs-discussion@lists.sourceforge.net, hch@infradead.org,
	dhowells@redhat.com, linux-mm@kvack.org, hubcap@omnibond.com,
	linux-cifs@vger.kernel.org, linux-nilfs@vger.kernel.org,
	mawilcox@microsoft.com, cluster-devel@redhat.com,
	bo.li.liu@oracle.com, v9fs-developer@lists.sourceforge.net,
	ross.zwisler@linux.intel.com, linux-ext4@vger.kernel.org,
	josef@toxicpanda.com, linux-block@vger.kernel.org,
	rpeterso@redhat.com, viro@zeniv.linux.org.uk, axboe@kernel.dk,
	linux-nfs@vger.kernel.org, tytso@mit.edu, clm@fb.com,
	corbet@lwn.net, linux-kernel@vger.kernel.org,
	fstests@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net,
	linux-xfs@vger.kernel.org, jack@suse.com,
	linux-fsdevel@vger.kernel.org, akpm@linux-foundation.org,
	linux-btrfs@vger.kernel.org
To: Jeff Layton <jlayton@redhat.com>
Return-path: <linux-f2fs-devel-bounces@lists.sourceforge.net>
Content-Disposition: inline
In-Reply-To: <20170509161245.29908-3-jlayton@redhat.com>
List-Unsubscribe: <https://lists.sourceforge.net/lists/listinfo/linux-f2fs-devel>,
	<mailto:linux-f2fs-devel-request@lists.sourceforge.net?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum_name=linux-f2fs-devel>
List-Post: <mailto:linux-f2fs-devel@lists.sourceforge.net>
List-Help: <mailto:linux-f2fs-devel-request@lists.sourceforge.net?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/linux-f2fs-devel>,
	<mailto:linux-f2fs-devel-request@lists.sourceforge.net?subject=subscribe>
Errors-To: linux-f2fs-devel-bounces@lists.sourceforge.net
List-Id: linux-ext4.vger.kernel.org

On Tue, May 09, 2017 at 12:12:44PM -0400, Jeff Layton wrote:
> The writeback error handling test requires that you put the journal on a
> separate device. This allows us to use dmerror to simulate data
> writeback failure, without affecting the journal.
> 
> xfs already has infrastructure for this (a'la $SCRATCH_LOGDEV), so wire
> up the ext4 code so that it can do the same thing when _scratch_mkfs is
> called.
> 
> Signed-off-by: Jeff Layton <jlayton@redhat.com>

Looks ok,
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>

--D

> ---
>  common/rc | 3 +++
>  1 file changed, 3 insertions(+)
> 
> diff --git a/common/rc b/common/rc
> index 257b1903359d..8b815d9c8c33 100644
> --- a/common/rc
> +++ b/common/rc
> @@ -675,6 +675,9 @@ _scratch_mkfs_ext4()
>  	local tmp=`mktemp`
>  	local mkfs_status
>  
> +	[ "$USE_EXTERNAL" = yes -a ! -z "$SCRATCH_LOGDEV" ] && \
> +	    $mkfs_cmd -O journal_dev $SCRATCH_LOGDEV && \
> +	    mkfs_cmd="$mkfs_cmd -J device=$SCRATCH_LOGDEV"
>  
>  	_scratch_do_mkfs "$mkfs_cmd" "$mkfs_filter" $* 2>$tmp.mkfserr 1>$tmp.mkfsstd
>  	mkfs_status=$?
> -- 
> 2.9.3
> 
> --
> To unsubscribe from this list: send the line "unsubscribe fstests" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

------------------------------------------------------------------------------
Check out the vibrant tech community on one of the world's most
engaging tech sites, Slashdot.org! http://sdm.link/slashdot
