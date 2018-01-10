From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH v2] fs/mbcache: make sure mb_cache_count() not return
 negative value.
Date: Wed, 10 Jan 2018 15:11:37 -0500
Message-ID: <20180110201137.GB6499@thunk.org>
References: <1515454691-69220-1-git-send-email-jiang.biao2@zte.com.cn>
 <20180108161304.f4be912fb6e20cdf56ae78ef@linux-foundation.org>
 <20180110042600.GC5809@thunk.org>
 <20180110150223.axkqucrhzef2n64u@quack2.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Jiang Biao <jiang.biao2@zte.com.cn>,
        linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org,
        ebiggers@google.com, zhong.weidong@zte.com.cn
To: Jan Kara <jack@suse.cz>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20180110150223.axkqucrhzef2n64u@quack2.suse.cz>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Wed, Jan 10, 2018 at 04:02:23PM +0100, Jan Kara wrote:
> So I don't think this can be a problem. Look, mb_cache_shrink() holds
> c_list_lock. It will take first entry from cache->c_list - this list is
> using list_head entry->e_list and so we are guaranteed entry->e_list is
> non-empty.
> 
> The other place deleting entry - mb_cache_entry_delete() - which is using
> different list to grab the entry is properly checking for
> !list_empty(entry->e_list) after acquiring c_list_lock.

Hmm... you're right.  How we handle the hlist_bl_lock and c_list_lock
still creeps me out a bit, but it's not going to cause the potential
problem.  I think there is a problem if mb_cache_entry_create() races
with mb_cache_delete(), but that will result in an entry being on the
c_list while not being on the hash list, and it doesn't cause the
c_entry_count to get out of sync with reality.

Drat....

						- Ted
