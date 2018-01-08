From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH] fs/mbcache: make sure mb_cache_count() not return
 negative value.
Date: Mon, 8 Jan 2018 11:44:49 +0100
Message-ID: <20180108104449.q6paee4u7zraqqiw@quack2.suse.cz>
References: <1515376842-66291-1-git-send-email-jiang.biao2@zte.com.cn>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org,
        tytso@mit.edu, ebiggers@google.com, akpm@linux-foundation.org,
        jack@suse.cz, zhong.weidong@zte.com.cn
To: Jiang Biao <jiang.biao2@zte.com.cn>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1515376842-66291-1-git-send-email-jiang.biao2@zte.com.cn>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Mon 08-01-18 10:00:42, Jiang Biao wrote:
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

Thanks for the patch. Couple of comments below.
 
> Signed-off-by: Jiang Biao <jiang.biao2@zte.com.cn>
> CC: "Theodore Ts'o" <tytso@mit.edu>
> CC: Eric Biggers <ebiggers@google.com>
> CC: Andrew Morton <akpm@linux-foundation.org>
> CC: Jan Kara <jack@suse.cz>
> ---
>  fs/mbcache.c | 4 +++-
>  1 file changed, 3 insertions(+), 1 deletion(-)
> 
> diff --git a/fs/mbcache.c b/fs/mbcache.c
> index b8b8b9c..c758458 100644
> --- a/fs/mbcache.c
> +++ b/fs/mbcache.c
> @@ -238,7 +238,9 @@ void mb_cache_entry_delete(struct mb_cache *cache, u32 key, u64 value)
>  			spin_lock(&cache->c_list_lock);
>  			if (!list_empty(&entry->e_list)) {
>  				list_del_init(&entry->e_list);
> -				cache->c_entry_count--;
> +				/*Make sure c_entry_count is not zero before dec*/

The comment is useless, just delete it.

> +				if (cache->c_entry_count != 0)

cache->c_entry_count > 0 would be more logical...

> +					cache->c_entry_count--;

OK, but please also add:
				else
					WARN_ONCE(1, "mbcache: Entry count "
						  "going negative!");

Also as I said in another email I'd be actually more interested in
debugging how can entry count go to such huge value rather than trying to
paper over it...


								Honza
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
