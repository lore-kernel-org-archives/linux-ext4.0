From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH] fs, jbd: use a more generic hash function
Date: Wed, 22 Oct 2014 10:02:18 +0200
Message-ID: <20141022080218.GA26827@quack.suse.cz>
References: <1413924235-26276-1-git-send-email-sasha.levin@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: akpm@linux-foundation.org, jack@suse.cz,
	linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org,
	a.ryabinin@samsung.com
To: Sasha Levin <sasha.levin@oracle.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1413924235-26276-1-git-send-email-sasha.levin@oracle.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Tue 21-10-14 16:43:55, Sasha Levin wrote:
> While the hash function used by the revoke hashtable is good somewhere else,
> it's not really good here.
> 
> The default hash shift (8) means that one third of the hashing function
> gets lost (and is undefined anyways (8 - 12 = negative shift)):
> 
> 	"(block << (hash_shift - 12))) & (table->hash_size - 1)"
> 
> Instead, just use the kernel's generic hash function that gets used everywhere
> else.
  Thanks. Merged to my tree.

								Honza
> 
> Signed-off-by: Sasha Levin <sasha.levin@oracle.com>
> ---
>  fs/jbd/revoke.c |    7 ++-----
>  1 file changed, 2 insertions(+), 5 deletions(-)
> 
> diff --git a/fs/jbd/revoke.c b/fs/jbd/revoke.c
> index 8898bbd..dcead63 100644
> --- a/fs/jbd/revoke.c
> +++ b/fs/jbd/revoke.c
> @@ -93,6 +93,7 @@
>  #include <linux/bio.h>
>  #endif
>  #include <linux/log2.h>
> +#include <linux/hash.h>
>  
>  static struct kmem_cache *revoke_record_cache;
>  static struct kmem_cache *revoke_table_cache;
> @@ -129,15 +130,11 @@ static void flush_descriptor(journal_t *, struct journal_head *, int, int);
>  
>  /* Utility functions to maintain the revoke table */
>  
> -/* Borrowed from buffer.c: this is a tried and tested block hash function */
>  static inline int hash(journal_t *journal, unsigned int block)
>  {
>  	struct jbd_revoke_table_s *table = journal->j_revoke;
> -	int hash_shift = table->hash_shift;
>  
> -	return ((block << (hash_shift - 6)) ^
> -		(block >> 13) ^
> -		(block << (hash_shift - 12))) & (table->hash_size - 1);
> +	return hash_32(block, table->hash_shift);
>  }
>  
>  static int insert_revoke_hash(journal_t *journal, unsigned int blocknr,
> -- 
> 1.7.10.4
> 
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
