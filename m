From: Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH v2 1/2] mbcache: decoupling the locking of local from
 global data
Date: Thu, 22 Aug 2013 09:53:45 -0700
Message-ID: <CA+55aFze8ZC0YP+TdwDFRPpa=BqUhY25RhEJb6c9pkCk2CZfVA@mail.gmail.com>
References: <1374108934-50550-1-git-send-email-tmac@hp.com>
	<1377186876-57291-1-git-send-email-tmac@hp.com>
	<1377186876-57291-2-git-send-email-tmac@hp.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: "Theodore Ts'o" <tytso@mit.edu>,
	"adilger.kernel@dilger.ca" <adilger.kernel@dilger.ca>,
	Al Viro <viro@zeniv.linux.org.uk>,
	"linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	linux-fsdevel <linux-fsdevel@vger.kernel.org>,
	"Chandramouleeswaran, Aswin" <aswin@hp.com>
To: T Makphaibulchoke <tmac@hp.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1377186876-57291-2-git-send-email-tmac@hp.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Thu, Aug 22, 2013 at 8:54 AM, T Makphaibulchoke <tmac@hp.com> wrote:
>
> +#define        MB_LOCK_HASH_CHAIN(hash_head)   hlist_bl_lock(hash_head)
> +#define        MB_UNLOCK_HASH_CHAIN(hash_head) hlist_bl_unlock(hash_head)
> +#ifdef MB_CACHE_DEBUG
> +#define        MB_LOCK_BLOCK_HASH(ce) do {

Please don't do these ugly and pointless preprocessor macro expanders
that hide what the actual operation is.

The DEBUG case seems to be just for your own testing anyway, so even
that shouldn't exist in the merged version.

> +#define        MAX_LOCK_RETRY  1024
> +
> +static inline int __mb_cache_lock_entry_block_hash(struct mb_cache_entry *ce)
> +{
> +       int nretry = 0;
> +       struct hlist_bl_head *block_hash_p = ce->e_block_hash_p;
> +
> +       do {
> +               MB_LOCK_HASH_CHAIN(block_hash_p);
> +               if (ce->e_block_hash_p == block_hash_p)
> +                       return 0;
> +               MB_UNLOCK_HASH_CHAIN(block_hash_p);
> +               block_hash_p = ce->e_block_hash_p;
> +       } while (++nretry < MAX_LOCK_RETRY);
> +       return -1;
> +}

And this is really ugly. Again it's also then hidden behind the ugly macro.

First off, the thousand-time retry seems completely excessive. Does it
actually need any retry AT ALL? If the hash entry changes, either you
should retry forever, or if you feel that can result in livelocks
(fair enough) and you need a fallback case to a bigger lock, then why
not just do the fallback immediately?

More importantly, regardless of that retry issue, this seems to be
abstracted at the wrong level, resulting in every single user of this
repeating the same complex and hard-to-understand incantation:

> +               if (MB_LOCK_ENTRY_BLOCK_HASH(ce)) {
> +                       spin_lock(&mb_cache_spinlock);
> +                       list_add_tail(&ce->e_lru_list, &mb_cache_lru_list);
> +                       spin_unlock(&mb_cache_spinlock);
> +                       continue;
> +               }
..
> +               if (MB_LOCK_ENTRY_BLOCK_HASH(ce)) {
> +                       spin_lock(&mb_cache_spinlock);
> +                       list_add_tail(&ce->e_lru_list, &mb_cache_lru_list);
> +                       spin_unlock(&mb_cache_spinlock);
> +                       continue;
> +               }
..
> +                               if (MB_LOCK_ENTRY_BLOCK_HASH(ce)) {
> +                                       spin_lock(&mb_cache_spinlock);
> +                                       list_add_tail(&ce->e_lru_list,
> +                                               &mb_cache_lru_list);
> +                                       continue;
> +                               }

where the only difference is that the last one doesn't unlock
afterwards because it runs in a loop with that LRU list lock held.
Ugh.

The locking logic also isn't explained anywhere, making the
hard-to-read code even harder to read.

             Linus
