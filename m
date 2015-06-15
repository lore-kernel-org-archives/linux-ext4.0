From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH] jbd2: get rid of open coded allocation retry loop
Date: Mon, 15 Jun 2015 15:47:04 -0400
Message-ID: <20150615194704.GF5003@thunk.org>
References: <1434377854-17959-1-git-send-email-mhocko@suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	linux-mm@kvack.org, LKML <linux-kernel@vger.kernel.org>
To: Michal Hocko <mhocko@suse.cz>
Return-path: <owner-linux-mm@kvack.org>
Content-Disposition: inline
In-Reply-To: <1434377854-17959-1-git-send-email-mhocko@suse.cz>
Sender: owner-linux-mm@kvack.org
List-Id: linux-ext4.vger.kernel.org

On Mon, Jun 15, 2015 at 04:17:34PM +0200, Michal Hocko wrote:
> insert_revoke_hash does an open coded endless allocation loop if
> journal_oom_retry is true. It doesn't implement any allocation fallback
> strategy between the retries, though. The memory allocator doesn't know
> about the never fail requirement so it cannot potentially help to move
> on with the allocation (e.g. use memory reserves).
> 
> Get rid of the retry loop and use __GFP_NOFAIL instead. We will lose the
> debugging message but I am not sure it is anyhow helpful.
> 
> Do the same for journal_alloc_journal_head which is doing a similar
> thing.
> 
> Signed-off-by: Michal Hocko <mhocko@suse.cz>

Thanks, applied.

					- Ted

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
