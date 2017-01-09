From: Michal Hocko <mhocko@kernel.org>
Subject: Re: [PATCH 3/8] mm: introduce memalloc_nofs_{save,restore} API
Date: Mon, 9 Jan 2017 14:59:01 +0100
Message-ID: <20170109135901.GJ7495@dhcp22.suse.cz>
References: <20170106141107.23953-1-mhocko@kernel.org>
 <20170106141107.23953-4-mhocko@kernel.org>
 <86dbce74-a532-2f98-6a63-4dbad77b2aa1@suse.cz>
 <20170109134210.GI7495@dhcp22.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-mm@kvack.org, linux-fsdevel@vger.kernel.org,
	Andrew Morton <akpm@linux-foundation.org>,
	Dave Chinner <david@fromorbit.com>, djwong@kernel.org,
	Theodore Ts'o <tytso@mit.edu>, Chris Mason <clm@fb.com>,
	David Sterba <dsterba@suse.cz>, Jan Kara <jack@suse.cz>,
	ceph-devel@vger.kernel.org, cluster-devel@redhat.com,
	linux-nfs@vger.kernel.org, logfs@logfs.org,
	linux-xfs@vger.kernel.org, linux-ext4@vger.kernel.org,
	linux-btrfs@vger.kernel.org, linux-mtd@lists.infradead.org,
	reiserfs-devel@vger.kernel.org,
	linux-ntfs-dev@lists.sourceforge.net,
	linux-f2fs-devel@lists.sourceforge.net,
	linux-afs@lists.infradead.org, LKML <linux-kernel@vger.kernel.org>
To: Vlastimil Babka <vbabka@suse.cz>
Return-path: <owner-linux-mm@kvack.org>
Content-Disposition: inline
In-Reply-To: <20170109134210.GI7495@dhcp22.suse.cz>
Sender: owner-linux-mm@kvack.org
List-Id: linux-ext4.vger.kernel.org

On Mon 09-01-17 14:42:10, Michal Hocko wrote:
> On Mon 09-01-17 14:04:21, Vlastimil Babka wrote:
[...]
> Now that you have opened this I have noticed that the code is wrong
> here because GFP_HIGHUSER_MOVABLE & ~GFP_RECLAIM_MASK would overwrite
> the removed GFP_FS.

Blee, it wouldn't because ~GFP_RECLAIM_MASK will not contain neither
GFP_FS nor GFP_IO. So all is good here.

> I guess it would be better and less error prone
> to move the current_gfp_context part into the direct reclaim entry -
> do_try_to_free_pages - and put the comment like this

well, after more thinking about we, should probably keep it where it is.
If for nothing else try_to_free_mem_cgroup_pages has a tracepoint which
prints the gfp mask so we should use the filtered one. So let's just
scratch this follow up fix.

> ---
> diff --git a/mm/vmscan.c b/mm/vmscan.c
> index 4ea6b610f20e..df7975185f11 100644
> --- a/mm/vmscan.c
> +++ b/mm/vmscan.c
> @@ -2756,6 +2756,13 @@ static unsigned long do_try_to_free_pages(struct zonelist *zonelist,
>  	int initial_priority = sc->priority;
>  	unsigned long total_scanned = 0;
>  	unsigned long writeback_threshold;
> +
> +	/*
> +	 * Make sure that the gfp context properly handles scope gfp mask.
> +	 * This might weaken the reclaim context (e.g. make it GFP_NOFS or
> +	 * GFP_NOIO).
> +	 */
> +	sc->gfp_mask = current_gfp_context(sc->gfp_mask);
>  retry:
>  	delayacct_freepages_start();
>  
> @@ -2949,7 +2956,7 @@ unsigned long try_to_free_pages(struct zonelist *zonelist, int order,
>  	unsigned long nr_reclaimed;
>  	struct scan_control sc = {
>  		.nr_to_reclaim = SWAP_CLUSTER_MAX,
> -		.gfp_mask = (gfp_mask = current_gfp_context(gfp_mask)),
> +		.gfp_mask = gfp_mask,
>  		.reclaim_idx = gfp_zone(gfp_mask),
>  		.order = order,
>  		.nodemask = nodemask,
> @@ -3029,8 +3036,7 @@ unsigned long try_to_free_mem_cgroup_pages(struct mem_cgroup *memcg,
>  	int nid;
>  	struct scan_control sc = {
>  		.nr_to_reclaim = max(nr_pages, SWAP_CLUSTER_MAX),
> -		.gfp_mask = (current_gfp_context(gfp_mask) & GFP_RECLAIM_MASK) |
> -				(GFP_HIGHUSER_MOVABLE & ~GFP_RECLAIM_MASK),
> +		.gfp_mask = GFP_HIGHUSER_MOVABLE & ~GFP_RECLAIM_MASK,
>  		.reclaim_idx = MAX_NR_ZONES - 1,
>  		.target_mem_cgroup = memcg,
>  		.priority = DEF_PRIORITY,
> @@ -3723,7 +3729,7 @@ static int __node_reclaim(struct pglist_data *pgdat, gfp_t gfp_mask, unsigned in
>  	int classzone_idx = gfp_zone(gfp_mask);
>  	struct scan_control sc = {
>  		.nr_to_reclaim = max(nr_pages, SWAP_CLUSTER_MAX),
> -		.gfp_mask = (gfp_mask = current_gfp_context(gfp_mask)),
> +		.gfp_mask = gfp_mask,
>  		.order = order,
>  		.priority = NODE_RECLAIM_PRIORITY,
>  		.may_writepage = !!(node_reclaim_mode & RECLAIM_WRITE),
> -- 
> Michal Hocko
> SUSE Labs

-- 
Michal Hocko
SUSE Labs

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
