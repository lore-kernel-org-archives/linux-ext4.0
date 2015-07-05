From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH] ext4: replace open coded nofail allocation
Date: Sun, 5 Jul 2015 17:06:00 -0400
Message-ID: <20150705210600.GD8628@thunk.org>
References: <1435053037-1451-1-git-send-email-mhocko@suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	linux-mm@kvack.org, LKML <linux-kernel@vger.kernel.org>
To: Michal Hocko <mhocko@suse.cz>
Return-path: <owner-linux-mm@kvack.org>
Content-Disposition: inline
In-Reply-To: <1435053037-1451-1-git-send-email-mhocko@suse.cz>
Sender: owner-linux-mm@kvack.org
List-Id: linux-ext4.vger.kernel.org

On Tue, Jun 23, 2015 at 11:50:37AM +0200, Michal Hocko wrote:
> ext4_free_blocks is looping around the allocation request and mimics
> __GFP_NOFAIL behavior without any allocation fallback strategy. Let's
> remove the open coded loop and replace it with __GFP_NOFAIL. Without
> the flag the allocator has no way to find out never-fail requirement
> and cannot help in any way.
> 
> Signed-off-by: Michal Hocko <mhocko@suse.cz>

Thanks, applied.

					- Ted

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
