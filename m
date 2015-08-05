From: David Sterba <dsterba@suse.com>
Subject: Re: [RFC 8/8] btrfs: use __GFP_NOFAIL in alloc_btrfs_bio
Date: Wed, 5 Aug 2015 18:32:12 +0200
Message-ID: <20150805163211.GB31669@twin.jikos.cz>
References: <1438768284-30927-1-git-send-email-mhocko@kernel.org>
 <1438768284-30927-9-git-send-email-mhocko@kernel.org>
Reply-To: dsterba@suse.com
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: LKML <linux-kernel@vger.kernel.org>, linux-mm@kvack.org,
	linux-fsdevel@vger.kernel.org,
	Andrew Morton <akpm@linux-foundation.org>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>,
	Dave Chinner <david@fromorbit.com>,
	Theodore Ts'o <tytso@mit.edu>, linux-btrfs@vger.kernel.org,
	linux-ext4@vger.kernel.org, Jan Kara <jack@suse.cz>,
	Michal Hocko <mhocko@suse.com>
To: mhocko@kernel.org
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1438768284-30927-9-git-send-email-mhocko@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Wed, Aug 05, 2015 at 11:51:24AM +0200, mhocko@kernel.org wrote:
> From: Michal Hocko <mhocko@suse.com>
> 
> alloc_btrfs_bio is relying on GFP_NOFS to allocate a bio but since "mm:
> page_alloc: do not lock up GFP_NOFS allocations upon OOM" this is
> allowed to fail which can lead to
> [   37.928625] kernel BUG at fs/btrfs/extent_io.c:4045
> 
> This is clearly undesirable and the nofail behavior should be explicit
> if the allocation failure cannot be tolerated.
> 
> Signed-off-by: Michal Hocko <mhocko@suse.com>

Reviewed-by: David Sterba <dsterba@suse.com>
