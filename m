From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Subject: Re: [PATCH 4/4] mm: vmscan: If kswapd has been running too long,
 allow it to sleep
Date: Sun, 15 May 2011 19:27:12 +0900
Message-ID: <4DCFAA80.7040109@jp.fujitsu.com>
References: <1305295404-12129-1-git-send-email-mgorman@suse.de> <1305295404-12129-5-git-send-email-mgorman@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Cc: akpm@linux-foundation.org, James.Bottomley@HansenPartnership.com,
	colin.king@canonical.com, raghu.prabhu13@gmail.com, jack@suse.cz,
	chris.mason@oracle.com, cl@linux.com, penberg@kernel.org,
	riel@redhat.com, hannes@cmpxchg.org, linux-fsdevel@vger.kernel.org,
	linux-mm@kvack.org, linux-kernel@vger.kernel.org,
	linux-ext4@vger.kernel.org
To: mgorman@suse.de
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:56322 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754491Ab1EOK0E (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sun, 15 May 2011 06:26:04 -0400
In-Reply-To: <1305295404-12129-5-git-send-email-mgorman@suse.de>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

(2011/05/13 23:03), Mel Gorman wrote:
> Under constant allocation pressure, kswapd can be in the situation where
> sleeping_prematurely() will always return true even if kswapd has been
> running a long time. Check if kswapd needs to be scheduled.
> 
> Signed-off-by: Mel Gorman<mgorman@suse.de>
> ---
>   mm/vmscan.c |    4 ++++
>   1 files changed, 4 insertions(+), 0 deletions(-)
> 
> diff --git a/mm/vmscan.c b/mm/vmscan.c
> index af24d1e..4d24828 100644
> --- a/mm/vmscan.c
> +++ b/mm/vmscan.c
> @@ -2251,6 +2251,10 @@ static bool sleeping_prematurely(pg_data_t *pgdat, int order, long remaining,
>   	unsigned long balanced = 0;
>   	bool all_zones_ok = true;
> 
> +	/* If kswapd has been running too long, just sleep */
> +	if (need_resched())
> +		return false;
> +

Hmm... I don't like this patch so much. because this code does

- don't sleep if kswapd got context switch at shrink_inactive_list
- sleep if kswapd didn't

It seems to be semi random behavior.



