From: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH v2] fs/mbcache: make sure mb_cache_count() not return
 negative value.
Date: Mon, 8 Jan 2018 16:13:04 -0800
Message-ID: <20180108161304.f4be912fb6e20cdf56ae78ef@linux-foundation.org>
References: <1515454691-69220-1-git-send-email-jiang.biao2@zte.com.cn>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org,
        tytso@mit.edu, ebiggers@google.com, jack@suse.cz,
        zhong.weidong@zte.com.cn
To: Jiang Biao <jiang.biao2@zte.com.cn>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:40354 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1758595AbeAIANF (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Mon, 8 Jan 2018 19:13:05 -0500
In-Reply-To: <1515454691-69220-1-git-send-email-jiang.biao2@zte.com.cn>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, 9 Jan 2018 07:38:11 +0800 Jiang Biao <jiang.biao2@zte.com.cn> wrote:

> When running ltp stress test for 7*24 hours, vmscan occasionally emits the
> following warning continuously:
> 
> mb_cache_scan+0x0/0x3f0 negative objects to delete
> nr=-9232265467809300450
> ....
> 
> Trace info shows the freeable(mb_cache_count returns) is -1, which causes
> the continuous accumulation and overflow of total_scan.
> 
> This patch makes sure that mb_cache_count() not return a negative value,
> which makes the mbcache shrinker more robust.
> 
> ...
>
> --- a/fs/mbcache.c
> +++ b/fs/mbcache.c
> @@ -238,7 +238,11 @@ void mb_cache_entry_delete(struct mb_cache *cache, u32 key, u64 value)
>  			spin_lock(&cache->c_list_lock);
>  			if (!list_empty(&entry->e_list)) {
>  				list_del_init(&entry->e_list);
> -				cache->c_entry_count--;
> +				if (cache->c_entry_count > 0)
> +					cache->c_entry_count--;
> +				else
> +					WARN_ONCE(1, "mbcache: Entry count "
> +                          "going negative!\n");
>  				atomic_dec(&entry->e_refcnt);
>  			}
>  			spin_unlock(&cache->c_list_lock);

I agree with Jan's comment.  We need to figure out how ->c_entry_count
went negative.  mb_cache_count() says this state is "Unlikely, but not
impossible", but from a quick read I can't see how this happens - it
appears that coherency between ->c_list and ->c_entry_count is always
maintained under ->c_list_lock?
