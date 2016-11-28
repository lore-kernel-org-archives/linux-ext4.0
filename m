From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH 5/5] mbcache: document that "find" functions only return
 reusable entries
Date: Mon, 28 Nov 2016 14:19:17 +0100
Message-ID: <20161128131917.GL2590@quack2.suse.cz>
References: <1480227481-98535-1-git-send-email-ebiggers@google.com>
 <1480227481-98535-5-git-send-email-ebiggers@google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, Jan Kara <jack@suse.cz>,
        Andreas Gruenbacher <agruenba@redhat.com>
To: Eric Biggers <ebiggers@google.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:35736 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1754420AbcK1NTU (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Mon, 28 Nov 2016 08:19:20 -0500
Content-Disposition: inline
In-Reply-To: <1480227481-98535-5-git-send-email-ebiggers@google.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sat 26-11-16 22:18:01, Eric Biggers wrote:
> mb_cache_entry_find_first() and mb_cache_entry_find_next() only return
> cache entries with the 'e_reusable' bit set.  This should be documented.
> 
> Signed-off-by: Eric Biggers <ebiggers@google.com>

Looks good. You can add:

Reviewed-by: Jan Kara <jack@suse.cz>

								Honza

> ---
>  fs/mbcache.c | 16 ++++++++--------
>  1 file changed, 8 insertions(+), 8 deletions(-)
> 
> diff --git a/fs/mbcache.c b/fs/mbcache.c
> index bf65906..b19be42 100644
> --- a/fs/mbcache.c
> +++ b/fs/mbcache.c
> @@ -155,12 +155,12 @@ static struct mb_cache_entry *__entry_find(struct mb_cache *cache,
>  }
>  
>  /*
> - * mb_cache_entry_find_first - find the first entry in cache with given key
> + * mb_cache_entry_find_first - find the first reusable entry with the given key
>   * @cache: cache where we should search
>   * @key: key to look for
>   *
> - * Search in @cache for entry with key @key. Grabs reference to the first
> - * entry found and returns the entry.
> + * Search in @cache for a reusable entry with key @key. Grabs reference to the
> + * first reusable entry found and returns the entry.
>   */
>  struct mb_cache_entry *mb_cache_entry_find_first(struct mb_cache *cache,
>  						 u32 key)
> @@ -170,14 +170,14 @@ struct mb_cache_entry *mb_cache_entry_find_first(struct mb_cache *cache,
>  EXPORT_SYMBOL(mb_cache_entry_find_first);
>  
>  /*
> - * mb_cache_entry_find_next - find next entry in cache with the same
> + * mb_cache_entry_find_next - find next reusable entry with the same key
>   * @cache: cache where we should search
>   * @entry: entry to start search from
>   *
> - * Finds next entry in the hash chain which has the same key as @entry.
> - * If @entry is unhashed (which can happen when deletion of entry races
> - * with the search), finds the first entry in the hash chain. The function
> - * drops reference to @entry and returns with a reference to the found entry.
> + * Finds next reusable entry in the hash chain which has the same key as @entry.
> + * If @entry is unhashed (which can happen when deletion of entry races with the
> + * search), finds the first reusable entry in the hash chain. The function drops
> + * reference to @entry and returns with a reference to the found entry.
>   */
>  struct mb_cache_entry *mb_cache_entry_find_next(struct mb_cache *cache,
>  						struct mb_cache_entry *entry)
> -- 
> 2.8.0.rc3.226.g39d4020
> 
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
