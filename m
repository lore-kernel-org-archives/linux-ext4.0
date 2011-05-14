From: Minchan Kim <minchan.kim@gmail.com>
Subject: Re: [PATCH 1/4] mm: vmscan: Correct use of pgdat_balanced in sleeping_prematurely
Date: Sun, 15 May 2011 01:30:57 +0900
Message-ID: <BANLkTik7+9TcA0HMgKeMZy-L0R+1RN2_rQ@mail.gmail.com>
References: <1305295404-12129-1-git-send-email-mgorman@suse.de>
	<1305295404-12129-2-git-send-email-mgorman@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: Andrew Morton <akpm@linux-foundation.org>,
	James Bottomley <James.Bottomley@hansenpartnership.com>,
	Colin King <colin.king@canonical.com>, Raghavendra D Prabhu <raghu.prabhu13@gmail.com>,
	Jan Kara <jack@suse.cz>, Chris Mason <chris.mason@oracle.com>, Christoph Lameter <cl@linux.com>,
	Pekka Enberg <penberg@kernel.org>, Rik van Riel <riel@redhat.com>,
	Johannes Weiner <hannes@cmpxchg.org>, linux-fsdevel <linux-fsdevel@vger.kernel.org>,
	linux-mm <linux-mm@kvack.org>, linux-kernel <linux-kernel@vger.kernel.org>,
	linux-ext4 <linux-ext4@vger.kernel.org>
To: Mel Gorman <mgorman@suse.de>
Return-path: <owner-linux-mm@kvack.org>
In-Reply-To: <1305295404-12129-2-git-send-email-mgorman@suse.de>
Sender: owner-linux-mm@kvack.org
List-Id: linux-ext4.vger.kernel.org

On Fri, May 13, 2011 at 11:03 PM, Mel Gorman <mgorman@suse.de> wrote:
> Johannes Weiner poined out that the logic in commit [1741c877: mm:
> kswapd: keep kswapd awake for high-order allocations until a percentage
> of the node is balanced] is backwards. Instead of allowing kswapd to go
> to sleep when balancing for high order allocations, it keeps it kswapd
> running uselessly.
>
> From-but-was-not-signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
> Will-sign-off-after-Johannes: Mel Gorman <mgorman@suse.de>
Reviewed-by: Minchan Kim <minchan.kim@gmail.com>

Nice catch! Hannes.

-- 
Kind regards,
Minchan Kim

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Fight unfair telecom internet charges in Canada: sign http://stopthemeter.ca/
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
