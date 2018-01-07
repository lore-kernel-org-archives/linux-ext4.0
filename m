From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH] Revert "fs/mbcache.c: make count_objects() more robust"
Date: Sun, 7 Jan 2018 16:04:46 -0500
Message-ID: <20180107210446.GB17380@thunk.org>
References: <20180106180654.7373-1-ebiggers3@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        Eric Biggers <ebiggers@google.com>, Jan Kara <jack@suse.cz>,
        Jiang Biao <jiang.biao2@zte.com.cn>
To: Eric Biggers <ebiggers3@gmail.com>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20180106180654.7373-1-ebiggers3@gmail.com>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Sat, Jan 06, 2018 at 10:06:54AM -0800, Eric Biggers wrote:
> From: Eric Biggers <ebiggers@google.com>
> 
> This reverts commit d5dabd633922ac5ee5bcc67748f7defb8b211469.
> 
> This patch did absolutely nothing, because ->c_entry_count is unsigned.
> 
> In addition if there is a bug in how mbcache maintains its entry count,
> it needs to be fixed, not just hacked around.  (There is no obvious bug,
> though.)

Right, if we're going to add a check, we should be checking to make
sure cache->c_entry_count is not zero before we decrement it in
mb_cache_entry_delete().

I will note that it's quite possible the error is in do_shrink_slab()
--- it's already dodgy that it assigns an unsigned long from
shrinker->count_objects to a signed long.  Then it multiplies it by (4
* nr_scanned) / shrinker->seeks.  So there are plenty of opportunities
to get the "negative objects to delete" message that has nothing to do
with value returned from mb_cache_count().

Regards,

					- Ted
