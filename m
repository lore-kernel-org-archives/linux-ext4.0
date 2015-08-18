From: Michal Hocko <mhocko@kernel.org>
Subject: Re: [RFC -v2 5/8] ext4: Do not fail journal due to block allocator
Date: Tue, 18 Aug 2015 12:55:46 +0200
Message-ID: <20150818105545.GH5033@dhcp22.suse.cz>
References: <1438768284-30927-1-git-send-email-mhocko@kernel.org>
 <1438768284-30927-6-git-send-email-mhocko@kernel.org>
 <20150818103903.GD5033@dhcp22.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-mm@kvack.org, linux-fsdevel@vger.kernel.org,
	Andrew Morton <akpm@linux-foundation.org>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>,
	Dave Chinner <david@fromorbit.com>,
	Theodore Ts'o <tytso@mit.edu>, linux-btrfs@vger.kernel.org,
	linux-ext4@vger.kernel.org, Jan Kara <jack@suse.cz>
To: LKML <linux-kernel@vger.kernel.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20150818103903.GD5033@dhcp22.suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Tue 18-08-15 12:39:03, Michal Hocko wrote:
[...]
> @@ -992,9 +992,8 @@ static int ext4_mb_get_buddy_page_lock(struct super_block *sb,
>  	block = group * 2;
>  	pnum = block / blocks_per_page;
>  	poff = block % blocks_per_page;
> -	page = find_or_create_page(inode->i_mapping, pnum, GFP_NOFS);
> -	if (!page)
> -		return -ENOMEM;
> +	page = find_or_create_page(inode->i_mapping, pnum,
> +				   GFP_NOFS|__GFP_NOFAIL);

Scratch this one. find_or_create_page is allowed to return NULL. The
patch is bogus. I was overly eager to turn all places to not check the
return value.

-- 
Michal Hocko
SUSE Labs
