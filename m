From: David Sterba <dsterba@suse.com>
Subject: Re: [RFC 7/8] btrfs: Prevent from early transaction abort
Date: Wed, 5 Aug 2015 18:31:54 +0200
Message-ID: <20150805163154.GA31669@twin.jikos.cz>
References: <1438768284-30927-1-git-send-email-mhocko@kernel.org>
 <1438768284-30927-8-git-send-email-mhocko@kernel.org>
Reply-To: dsterba@suse.com
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: LKML <linux-kernel@vger.kernel.org>, linux-mm@kvack.org,
	linux-fsdevel@vger.kernel.org,
	Andrew Morton <akpm@linux-foundation.org>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>,
	Dave Chinner <david@fromorbit.com>, Theodore Ts'o <tytso@mit.edu>,
	linux-btrfs@vger.kernel.org, linux-ext4@vger.kernel.org,
	Jan Kara <jack@suse.cz>, Michal Hocko <mhocko@suse.com>
To: mhocko@kernel.org
Return-path: <owner-linux-mm@kvack.org>
Content-Disposition: inline
In-Reply-To: <1438768284-30927-8-git-send-email-mhocko@kernel.org>
Sender: owner-linux-mm@kvack.org
List-Id: linux-ext4.vger.kernel.org

On Wed, Aug 05, 2015 at 11:51:23AM +0200, mhocko@kernel.org wrote:
> From: Michal Hocko <mhocko@suse.com>
... 
> Fix this by reintroducing the no-fail behavior of this allocation path
> with the explicit __GFP_NOFAIL.
> 
> Signed-off-by: Michal Hocko <mhocko@suse.com>

Reviewed-by: David Sterba <dsterba@suse.com>

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
