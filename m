From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH RFC] ext4: use __GFP_NOFAIL in ext4_free_blocks()
Date: Sun, 13 Mar 2016 17:30:06 -0400
Message-ID: <20160313213006.GG29218@thunk.org>
References: <20160224170912.2195.8153.stgit@buzz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Michal Hocko <mhocko@suse.com>, linux-kernel@vger.kernel.org,
	linux-mm@kvack.org, Dmitry Monakhov <dmonakhov@virtuozzo.com>,
	Johannes Weiner <hannes@cmpxchg.org>, linux-fsdevel@vger.kernel.org,
	linux-ext4@vger.kernel.org
To: Konstantin Khlebnikov <khlebnikov@yandex-team.ru>
Return-path: <owner-linux-mm@kvack.org>
Content-Disposition: inline
In-Reply-To: <20160224170912.2195.8153.stgit@buzz>
Sender: owner-linux-mm@kvack.org
List-Id: linux-ext4.vger.kernel.org

On Wed, Feb 24, 2016 at 08:09:12PM +0300, Konstantin Khlebnikov wrote:
> This might be unexpected but pages allocated for sbi->s_buddy_cache are
> charged to current memory cgroup. So, GFP_NOFS allocation could fail if
> current task has been killed by OOM or if current memory cgroup has no
> free memory left. Block allocator cannot handle such failures here yet.
> 
> Signed-off-by: Konstantin Khlebnikov <khlebnikov@yandex-team.ru>

Thanks, applied.

					- Ted

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
